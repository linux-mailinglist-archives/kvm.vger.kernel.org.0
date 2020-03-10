Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0971617EE14
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 02:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgCJBlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 21:41:42 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32805 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgCJBll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 21:41:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id f13so12298696ljp.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 18:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N2AJ/0d2IKfifuARWS8QvzHkNJ1nk+dikFRpBjILSK4=;
        b=KEZBT/9NnnEjpG56gBgV0PPF1J1JoZlIAUVefLkZXQvenXZXfj1ctiAO1l0zQD/zfo
         84NZNJV8krAKaD/fVFrBCzktaDNfuHU4kZSL0VnbvjpgxzOVF0s8/R8RGMzK55U11ICc
         bM4ocsqJorqy6WujAKGw8ClwexWAISCUoe+ck3Wx6k3reWePoG+r9oggZQvtt6xRvcb/
         Tqb2unXwAuXWgNkjAFHgS7d2ad+HcyaHnYnax5cHDJLTB2k/TubG0uKjpD0GRmUpKqmp
         S4ECVmLEOhzihKNB6b/lJ1kaQXzJS7osccUAVCqOMQM/R1wCt91qwCms0knpthts4G7O
         YcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N2AJ/0d2IKfifuARWS8QvzHkNJ1nk+dikFRpBjILSK4=;
        b=bnpmuZ8SQsJoSbaNMaWWlrSp7NX/MuTJwEIWAvzBCMGh5PRKLw6gqSXtqnbudXs9mF
         6p2BgME9Iu2yf2nPPlH1p6GvF1uK1CltE2reeI10JZ+jJxXeTqguU2Vn+LiMlesH38EN
         rlQQlJUc8cEqjTLXmF+hE631tRpn7ypYfXdvbzdRgEPQzQXtn4Wwo9JAc1u9Kiryn6V5
         403i5kSwPkv1t5B/7FpmDIUlMMWR5nDU8U1QzLf8Kf37/8k9A7So0Uemcz2FpyFymzHe
         e1UhxxUYLvhhS2ygZmbpV22Ry8DBdkpsk17sAkzS5SzxZS37y6eyHWHWy1gwHQylDL9v
         AYsg==
X-Gm-Message-State: ANhLgQ3r2HETEVf1gWUqoHYW16WXZ9+lTJvZDQnj9eCa5kgjL9UTO+3F
        zAMQwRlIAHKt8zBaVTcRv29l1GE+j7AdKbPe+fqrsw==
X-Google-Smtp-Source: ADFU+vv3QyZStkk5ddo8jheHznhfCZKbTAULndf3FNlfQelBQQkxb7GWiC7eAgRKytBYYxwPL+R3A1p2yiAwVDPWYgE=
X-Received: by 2002:a05:651c:502:: with SMTP id o2mr11083568ljp.150.1583804498617;
 Mon, 09 Mar 2020 18:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <0a0b3815e03dcee47ca0fbf4813821877b4c2ea0.1581555616.git.ashish.kalra@amd.com>
In-Reply-To: <0a0b3815e03dcee47ca0fbf4813821877b4c2ea0.1581555616.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 9 Mar 2020 18:41:02 -0700
Message-ID: <CABayD+ciJiF8gf+s6d57vENcnSQPQGzTTwdo0TLBsNLdoy0tWw@mail.gmail.com>
Subject: Re: [PATCH 04/12] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
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

On Wed, Feb 12, 2020 at 5:16 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The command is used to create the encryption context for an incoming
> SEV guest. The encryption context can be later used by the hypervisor
> to import the incoming data into the SEV guest memory space.
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
>  .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
>  arch/x86/kvm/svm.c                            | 81 +++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  9 +++
>  3 files changed, 119 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documenta=
tion/virt/kvm/amd-memory-encryption.rst
> index f22f09ad72bd..4b882fb681fa 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -297,6 +297,35 @@ issued by the hypervisor to delete the encryption co=
ntext.
>
>  Returns: 0 on success, -negative on error
>
> +13. KVM_SEV_RECEIVE_START
> +------------------------
> +
> +The KVM_SEV_RECEIVE_START command is used for creating the memory encryp=
tion
> +context for an incoming SEV guest. To create the encryption context, the=
 user must
> +provide a guest policy, the platform public Diffie-Hellman (PDH) key and=
 session
> +information.
> +
> +Parameters: struct  kvm_sev_receive_start (in/out)
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_receive_start {
> +                __u32 handle;           /* if zero then firmware creates=
 a new handle */
> +                __u32 policy;           /* guest's policy */
> +
> +                __u64 pdh_uaddr;         /* userspace address pointing t=
o the PDH key */
> +                __u32 dh_len;
> +
> +                __u64 session_addr;     /* userspace address which point=
s to the guest session information */
> +                __u32 session_len;
> +        };
> +
> +On success, the 'handle' field contains a new handle and on error, a neg=
ative value.
> +
> +For more details, see SEV spec Section 6.12.
> +
>  References
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c55c1865f9e0..3b766f386c84 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7407,6 +7407,84 @@ static int sev_send_finish(struct kvm *kvm, struct=
 kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_receive_start *start;
> +       struct kvm_sev_receive_start params;
> +       int *error =3D &argp->error;
> +       void *session_data;
> +       void *pdh_data;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       /* Get parameter from the userspace */
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +                       sizeof(struct kvm_sev_receive_start)))
> +               return -EFAULT;
> +
> +       /* some sanity checks */
> +       if (!params.pdh_uaddr || !params.pdh_len ||
> +           !params.session_uaddr || !params.session_len)
> +               return -EINVAL;
> +
> +       pdh_data =3D psp_copy_user_blob(params.pdh_uaddr, params.pdh_len)=
;
> +       if (IS_ERR(pdh_data))
> +               return PTR_ERR(pdh_data);
> +
> +       session_data =3D psp_copy_user_blob(params.session_uaddr,
> +                       params.session_len);
> +       if (IS_ERR(session_data)) {
> +               ret =3D PTR_ERR(session_data);
> +               goto e_free_pdh;
> +       }
> +
> +       ret =3D -ENOMEM;
> +       start =3D kzalloc(sizeof(*start), GFP_KERNEL);
> +       if (!start)
> +               goto e_free_session;
> +
> +       start->handle =3D params.handle;
> +       start->policy =3D params.policy;
> +       start->pdh_cert_address =3D __psp_pa(pdh_data);
> +       start->pdh_cert_len =3D params.pdh_len;
> +       start->session_address =3D __psp_pa(session_data);
> +       start->session_len =3D params.session_len;
> +
> +       /* create memory encryption context */

Set ret to a different value here, since otherwise this will look like -ENO=
MEM.

> +       ret =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, star=
t,
> +                               error);
> +       if (ret)
> +               goto e_free;
> +
> +       /* Bind ASID to this guest */

Ideally, set ret to another distinct value, since the error spaces for
these commands overlap, so you won't be sure which had the problem.
You also wouldn't be sure if one succeeded and the other failed vs
both failing.

> +       ret =3D sev_bind_asid(kvm, start->handle, error);
> +       if (ret)
> +               goto e_free;
> +
> +       params.handle =3D start->handle;
> +       if (copy_to_user((void __user *)(uintptr_t)argp->data,
> +                        &params, sizeof(struct kvm_sev_receive_start))) =
{
> +               ret =3D -EFAULT;
> +               sev_unbind_asid(kvm, start->handle);
> +               goto e_free;
> +       }
> +
> +       sev->handle =3D start->handle;
> +       sev->fd =3D argp->sev_fd;
> +
> +e_free:
> +       kfree(start);
> +e_free_session:
> +       kfree(session_data);
> +e_free_pdh:
> +       kfree(pdh_data);
> +
> +       return ret;
> +}
> +
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -7457,6 +7535,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __u=
ser *argp)
>         case KVM_SEV_SEND_FINISH:
>                 r =3D sev_send_finish(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_RECEIVE_START:
> +               r =3D sev_receive_start(kvm, &sev_cmd);
> +               break;
>         default:
>                 r =3D -EINVAL;
>                 goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d9dc81bb9c55..74764b9db5fa 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1579,6 +1579,15 @@ struct kvm_sev_send_update_data {
>         __u32 trans_len;
>  };
>
> +struct kvm_sev_receive_start {
> +       __u32 handle;
> +       __u32 policy;
> +       __u64 pdh_uaddr;
> +       __u32 pdh_len;
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
