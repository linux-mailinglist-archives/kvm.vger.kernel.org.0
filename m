Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AEBF98D8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 19:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKLSgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 13:36:09 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:46329 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfKLSgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 13:36:08 -0500
Received: by mail-il1-f193.google.com with SMTP id q1so15782469ile.13
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 10:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pt+Eiiq/E3aycrVMhn1krJyuGOpfFcyGAVCaAM8khkU=;
        b=f6K0GT66CzhSK/ru9GwCp5nsZpF/byuB2/tBzi+H5ZVbqtqipkO4CYxbvjXBMBXUvK
         YLcl8i2AB/HlfTzxiOYLksHji6gKTh5t7UTqCWFEIyXMI1wPzqm31OhXptGE+imOKxHm
         +5HOOpK1JsITDHjr6Y4XktnW5KqAoM267ax3nr4dwAHPkn/eDHgkMBhzrf2VMeHBcdWI
         FVa2i0UwMTOiZz7oS06zZxkPjv/c6YEwVDuV95ckL2jf8h86P+mC/gOVkhlccR8wUIiA
         b+2c4Dq9zX2nMhXQcDN6GNf/8CMGzC+lVincUyYI62Hhkfvsya1bzQ6iKUYz1DdmOy7P
         32JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pt+Eiiq/E3aycrVMhn1krJyuGOpfFcyGAVCaAM8khkU=;
        b=YZxoi/vEc2Cuump5xw8+IAF22a0i5wyPPn1pOvLiGzuljozwMlmdumt/bJhr0cfHOa
         0ZebSIlZUAAUURBBXGXjHapYyqO5bOrl03axePThjMrJBwmzyzyhfgtDsuMu9xXBTWH+
         lDH+l8jDpa2yVTZIzBBam/SmEJvn3i3o2MtFtIcZ8CfPAoUlrsxJgD7+AtrQS3/N05To
         9kvNgHIHocSQ/Z15EKbvfYjqMhuQnJHr1Z5RJEIRxzrJOfoVvGdhlrb9kj8FLG2KlnvA
         o0zIZCmSsxqlmmKw2G466ju+639fSXrxfQnxftheZtO81Vy0zwHrw85FyjMcY7e3qMSJ
         I7jQ==
X-Gm-Message-State: APjAAAV2FdFWwfXNn99LUjVCQYec2VtZZ7g2FzjWxMx0cz2jPzuudvfp
        tAVfoffcM3wrsvIb9DONA+AiuZdJpj2t6S87S32SZA==
X-Google-Smtp-Source: APXvYqz5+MDxQicmVyuoGMe0YErdTWD+n8Ty2EHjM180dTfeNxqN/ppUeFXbr5EJxvOXKr1iys9Y0EKGkhTHzsoVq3U=
X-Received: by 2002:a92:9adb:: with SMTP id c88mr37066861ill.193.1573583767237;
 Tue, 12 Nov 2019 10:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20190710201244.25195-1-brijesh.singh@amd.com> <20190710201244.25195-2-brijesh.singh@amd.com>
In-Reply-To: <20190710201244.25195-2-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 12 Nov 2019 10:35:55 -0800
Message-ID: <CAMkAt6pzXrZw1TZgcX-G0wDNZBjf=1bQdErAJTxfzYQ2MJDZvw@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] KVM: SVM: Add KVM_SEV SEND_START command
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 1:13 PM Singh, Brijesh <brijesh.singh@amd.com> wrote:
>
> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       void *amd_cert = NULL, *session_data = NULL;
> +       void *pdh_cert = NULL, *plat_cert = NULL;
> +       struct sev_data_send_start *data = NULL;
> +       struct kvm_sev_send_start params;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +                               sizeof(struct kvm_sev_send_start)))
> +               return -EFAULT;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       /* userspace wants to query the session length */
> +       if (!params.session_len)
> +               goto cmd;
> +
> +       if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> +           !params.session_uaddr)
> +               return -EINVAL;

I think pdh_cert is only required if the guest policy SEV bit is set.
Can pdh_cert be optional?

> +
> +       /* copy the certificate blobs from userspace */
> +       pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr, params.pdh_cert_len);
> +       if (IS_ERR(pdh_cert)) {
> +               ret = PTR_ERR(pdh_cert);
> +               goto e_free;
> +       }
> +
> +       data->pdh_cert_address = __psp_pa(pdh_cert);
> +       data->pdh_cert_len = params.pdh_cert_len;
> +
> +       plat_cert = psp_copy_user_blob(params.plat_cert_uaddr, params.plat_cert_len);
> +       if (IS_ERR(plat_cert)) {
> +               ret = PTR_ERR(plat_cert);
> +               goto e_free_pdh;
> +       }

I think plat_cert is also only required if the guest policy SEV bit is
set. Can plat_cert also be optional?

> +
> +       data->plat_cert_address = __psp_pa(plat_cert);
> +       data->plat_cert_len = params.plat_cert_len;
> +
> +       amd_cert = psp_copy_user_blob(params.amd_cert_uaddr, params.amd_cert_len);
> +       if (IS_ERR(amd_cert)) {
> +               ret = PTR_ERR(amd_cert);
> +               goto e_free_plat_cert;
> +       }

I think amd_cert is also only required if the guest policy SEV bit is
set. Can amd_cert also be optional?

> +
> +       data->amd_cert_address = __psp_pa(amd_cert);
> +       data->amd_cert_len = params.amd_cert_len;
> +
> +       ret = -EINVAL;
> +       if (params.session_len > SEV_FW_BLOB_MAX_SIZE)
> +               goto e_free_amd_cert;
> +
> +       ret = -ENOMEM;
> +       session_data = kmalloc(params.session_len, GFP_KERNEL);
> +       if (!session_data)
> +               goto e_free_amd_cert;

This pattern of returning -EINVAL if a length is greater than
SEV_FW_BLOB_MAX_SIZE and -ENOMEM if kmalloc fails is used at
sev_launch_measure. And I think in your later patches you do similar,
did you consider factoring this out into a helper function similar to
psp_copy_user_blob?
