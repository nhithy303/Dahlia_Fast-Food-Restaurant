﻿using BLL;
using DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Windows.Forms;

namespace GUI
{
    public partial class frmLogin : Form
    {
        public frmLogin()
        {
            InitializeComponent();
            this.Load += frmLogin_Load;
            btnLogIn.Click += btnLogIn_Click;
            picClose.Click += picClose_Click;
            this.FormClosing += frmLogin_FormClosing;
        }

        private void frmLogin_Load(object sender, EventArgs e)
        {
            txtUsername.Focus();
            rdoAdmin.Checked = true;
        }

        private void btnLogIn_Click(object sender, EventArgs e)
        {
            TaiKhoan tk = new TaiKhoan();
            tk.TenDangNhap = txtUsername.Text.Trim();
            tk.MatKhau = txtPassword.Text;
            tk.PhanQuyen = rdoAdmin.Checked ? 2 : 3;

            TaiKhoanBLL tk_bll = new TaiKhoanBLL();
            if (!tk_bll.IsValidated(tk))
            {
                ShowError("Thông tin đăng nhập còn trống!");
            }
            else
            {
                TaiKhoan[] tk_list = tk_bll.GetList(tk);
                if (tk_list != null)
                {
                    tk = tk_list[0];
                    if (rdoAdmin.Checked)
                    {
                        new frmAdmin(tk).ShowDialog();
                    }
                    else
                    {
                        new frmEmployee(tk).ShowDialog();
                    }
                    txtUsername.Clear();
                    txtPassword.Clear();
                    this.Show();
                }
                else
                {
                    ShowError("Tài khoản hoặc mật khẩu không chính xác!");
                }
            }
        }

        private void ShowError(string error)
        {
            MessageBox.Show(error, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private void picClose_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Bạn có chắc chắn muốn thoát không?", "Thoát",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void frmLogin_FormClosing(object sender, FormClosingEventArgs e)
        {
            Application.Exit();
        }
    }
}