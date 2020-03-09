Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEEC17EB2A
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCIV3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:29:24 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37518 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgCIV3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 17:29:23 -0400
Received: by mail-lj1-f193.google.com with SMTP id d12so11684476lji.4
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 14:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T8M3/jbbXEQHhkWJ8fWBj3BkKaZr3EQT9pwrSQhYf0g=;
        b=YtYemB+ouTty70S4QpIHG+myx29twDxqxnTZUJFvkofojfymPemyjqUNscIbOjQ1ud
         HvA43i9pcGvF1SoXF6dG8+52fciUDqwcqhHZ0qyU1455qudRKPwBvrIjXeHEmQgWXJwI
         7KYUGP18a1zI2UBYyYo4a0/DdMbiCgCZZurjom266NMXI8BreHiZZxpuF8L05uM/FEH1
         c0oS18K3GvSpG6eOcAuyOrMpQXiYeqBx6vkCYIPHvR8MJKiHLzLOvCN4b9yXfH+0/aVo
         dIMhU0Sjy+kgjVCHXDkr9AMC4WNtyaRzJtqDO1MLKD6zF3kzPTRCuhSqo8JbHm5KPuyk
         Ty3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T8M3/jbbXEQHhkWJ8fWBj3BkKaZr3EQT9pwrSQhYf0g=;
        b=NdiMkd1V3Ddu8ezhtOB8HsOn4pST0RrxKh2YVxyw2zYKNg70OIb/uI0DrdrQerZLRN
         xNVkFRog0O9RdCTvO0oqjZknMfnoDMlCAlv0VbYYJuKey/Z9xKnu1ERYeWIjrwAkQeCk
         7K4xC2r1yxMNuDIeem+/eqHiIrenqTAHbWnQCZjwXICVDx2AAdufVKkbBfYFjJYnapHh
         jii+dJHrGiX+VlrdeW4X7KT0LAyUdRqPU+UCt+wU8C/1931NjQPPby+nBy0pjPCCSan0
         rohcdpNuhs8pY530gFZQTqpwbDGCwfjc6QQyU0QvSlZQwOfX/o78w6mUt6NgoOwpC5A/
         A7VA==
X-Gm-Message-State: ANhLgQ0+1IwU0nG4r2t4rBab+3WR/L5tx/yRUnjnMJj2rT/CY79sNu0o
        BfgSFAb4Nnjv/xitbFnIJVibWwjSSanQJiSzHf50rQ==
X-Google-Smtp-Source: ADFU+vtug0RGpWjSmMn7rkWSctbfENbtHS5jZ40tTWcWx3iW7hWtZ7iTTQvrB3BM+Yy3IMEIEKH5EU5T8wlDC+4kcwM=
X-Received: by 2002:a2e:b008:: with SMTP id y8mr10897462ljk.35.1583789358675;
 Mon, 09 Mar 2020 14:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <59ca3ae4ac03c43751ce4af5119ede548bb9e8e4.1581555616.git.ashish.kalra@amd.com>
In-Reply-To: <59ca3ae4ac03c43751ce4af5119ede548bb9e8e4.1581555616.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 9 Mar 2020 14:28:42 -0700
Message-ID: <CABayD+f1Vk1YfpkZ7XXBpw5Z_kxzg1xb3zxtQGYaF4MbEQCT3w@mail.gmail.com>
Subject: Re: [PATCH 01/12] KVM: SVM: Add KVM_SEV SEND_START command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 5:15 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The command is used to create an outgoing SEV guest encryption context.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
>  arch/x86/kvm/svm.c                            | 125 ++++++++++++++++++
>  include/linux/psp-sev.h                       |   8 +-
>  include/uapi/linux/kvm.h                      |  12 ++
>  4 files changed, 168 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documenta=
tion/virt/kvm/amd-memory-encryption.rst
> index d18c97b4e140..826911f41f3b 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -238,6 +238,33 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>
> +10. KVM_SEV_SEND_START
> +----------------------
> +
> +The KVM_SEV_SEND_START command can be used by the hypervisor to create a=
n
> +outgoing guest encryption context.
> +
> +Parameters (in): struct kvm_sev_send_start
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_send_start {
> +                __u32 policy;                 /* guest policy */
> +
> +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman=
 certificate */
> +                __u32 pdh_cert_len;
> +
> +                __u64 plat_certs_uadr;        /* platform certificate ch=
ain */
> +                __u32 plat_certs_len;
> +
> +                __u64 amd_certs_uaddr;        /* AMD certificate */
> +                __u32 amd_cert_len;
> +
> +                __u64 session_uaddr;          /* Guest session informati=
on */
> +                __u32 session_len;
> +        };
> +
>  References
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index a3e32d61d60c..3a7e2cac51de 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7140,6 +7140,128 @@ static int sev_launch_secret(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +/* Userspace wants to query session length. */
> +static int
> +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cm=
d *argp,
> +                                     struct kvm_sev_send_start *params)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_send_start *data;
> +       int ret;
> +
> +       data =3D kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +       if (data =3D=3D NULL)
> +               return -ENOMEM;
> +
> +       data->handle =3D sev->handle;
> +       ret =3D sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error=
);
> +
> +       params->session_len =3D data->session_len;
> +       if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> +                               sizeof(struct kvm_sev_send_start)))
> +               ret =3D -EFAULT;
> +
> +       kfree(data);
> +       return ret;
> +}
> +
> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_send_start *data;
> +       struct kvm_sev_send_start params;
> +       void *amd_certs, *session_data;
> +       void *pdh_cert, *plat_certs;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +                               sizeof(struct kvm_sev_send_start)))
> +               return -EFAULT;
> +
> +       /* if session_len is zero, userspace wants t query the session le=
ngth */

/t/to/
>
> +       if (!params.session_len)
> +               return __sev_send_start_query_session_length(kvm, argp,
> +                               &params);
Document this behavior with the command.

> +
> +       /* some sanity checks */
> +       if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> +           !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX=
_SIZE)
> +               return -EINVAL;
> +
> +       /* allocate the memory to hold the session data blob */
> +       session_data =3D kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
> +       if (!session_data)
> +               return -ENOMEM;
> +
> +       /* copy the certificate blobs from userspace */
> +       pdh_cert =3D psp_copy_user_blob(params.pdh_cert_uaddr,
> +                               params.pdh_cert_len);
> +       if (IS_ERR(pdh_cert)) {
> +               ret =3D PTR_ERR(pdh_cert);
> +               goto e_free_session;
> +       }
> +
> +       plat_certs =3D psp_copy_user_blob(params.plat_certs_uaddr,
> +                               params.plat_certs_len);
> +       if (IS_ERR(plat_certs)) {
> +               ret =3D PTR_ERR(plat_certs);
> +               goto e_free_pdh;
> +       }
> +
> +       amd_certs =3D psp_copy_user_blob(params.amd_certs_uaddr,
> +                               params.amd_certs_len);
> +       if (IS_ERR(amd_certs)) {
> +               ret =3D PTR_ERR(amd_certs);
> +               goto e_free_plat_cert;
> +       }
> +
> +       data =3D kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +       if (data =3D=3D NULL) {
> +               ret =3D -ENOMEM;
> +               goto e_free_amd_cert;
> +       }
> +
> +       /* populate the FW SEND_START field with system physical address =
*/
> +       data->pdh_cert_address =3D __psp_pa(pdh_cert);
> +       data->pdh_cert_len =3D params.pdh_cert_len;
> +       data->plat_certs_address =3D __psp_pa(plat_certs);
> +       data->plat_certs_len =3D params.plat_certs_len;
> +       data->amd_certs_address =3D __psp_pa(amd_certs);
> +       data->amd_certs_len =3D params.amd_certs_len;
> +       data->session_address =3D __psp_pa(session_data);
> +       data->session_len =3D params.session_len;
> +       data->handle =3D sev->handle;
> +
> +       ret =3D sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error=
);
sev_issue_cmd can fail. I think you want to handle those errors here
(e.g. it can return -ebadf or a number of others). Right now they
could get clobbered by a later copy_to_user error.

It's also worth documenting what the error argp->error is filled in
with. I didn't see anything in the docs mentioning the status codes
(may have missed it).

> +
> +       if (copy_to_user((void __user *)(uintptr_t) params.session_uaddr,
> +                       session_data, params.session_len)) {
> +               ret =3D -EFAULT;
> +               goto e_free;
> +       }
> +
> +       params.policy =3D data->policy;
> +       params.session_len =3D data->session_len;
> +       if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> +                               sizeof(struct kvm_sev_send_start)))
> +               ret =3D -EFAULT;
> +
> +e_free:
> +       kfree(data);
> +e_free_amd_cert:
> +       kfree(amd_certs);
> +e_free_plat_cert:
> +       kfree(plat_certs);
> +e_free_pdh:
> +       kfree(pdh_cert);
> +e_free_session:
> +       kfree(session_data);
> +       return ret;
> +}
> +
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -7181,6 +7303,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __u=
ser *argp)
>         case KVM_SEV_LAUNCH_SECRET:
>                 r =3D sev_launch_secret(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_SEND_START:
> +               r =3D sev_send_start(kvm, &sev_cmd);
> +               break;
>         default:
>                 r =3D -EINVAL;
>                 goto out;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 5167bf2bfc75..9f63b9d48b63 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -323,11 +323,11 @@ struct sev_data_send_start {
>         u64 pdh_cert_address;                   /* In */
>         u32 pdh_cert_len;                       /* In */
>         u32 reserved1;
> -       u64 plat_cert_address;                  /* In */
> -       u32 plat_cert_len;                      /* In */
> +       u64 plat_certs_address;                 /* In */
> +       u32 plat_certs_len;                     /* In */
>         u32 reserved2;
> -       u64 amd_cert_address;                   /* In */
> -       u32 amd_cert_len;                       /* In */
> +       u64 amd_certs_address;                  /* In */
> +       u32 amd_certs_len;                      /* In */
>         u32 reserved3;
>         u64 session_address;                    /* In */
>         u32 session_len;                        /* In/Out */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..17bef4c245e1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1558,6 +1558,18 @@ struct kvm_sev_dbg {
>         __u32 len;
>  };
>
> +struct kvm_sev_send_start {
> +       __u32 policy;
> +       __u64 pdh_cert_uaddr;
> +       __u32 pdh_cert_len;
> +       __u64 plat_certs_uaddr;
> +       __u32 plat_certs_len;
> +       __u64 amd_certs_uaddr;
> +       __u32 amd_certs_len;
> +       __u64 session_uaddr;
> +       __u32 session_len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.17.1
>

Looks pretty reasonable overall.
