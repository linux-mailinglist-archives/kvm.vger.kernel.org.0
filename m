Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96D41A03E2
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 02:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgDGAui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 20:50:38 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37961 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgDGAuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 20:50:37 -0400
Received: by mail-lj1-f194.google.com with SMTP id v16so1783145ljg.5
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 17:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AeI0bz92VASTTXgirRn/wihciZnmL99qlKu0y6qTcUI=;
        b=KWAQ1tlKoJYnqZnOT87m5isrEm1nTgz//yOZEUhmdMGIubBy3AxPiYJpDjDHFojgL+
         wTlQWCRko5T/HQUatH4viOs27pC2T5TTu6upDYeZ5iGMhx8uI1eG9aZLEpMb9sVSx/pR
         wmdET62r9yhdR7C9NA4e28N5OfS92vm1Cd3kq56F719lVKWRFdUkTPYIaBNx0/KvvdwC
         0RPPKAIQLTdcN0TCtMf4EQajm5Udoc0MRhd4GS9cVyG54VwJManabuc1wZ83SQ1Zm2Ix
         o2V4BBu02YvkiyEduOUSEkx/xZV814p1khva74YtHeExVZfckl+DnbWJtmppdv7vD3Kc
         MSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AeI0bz92VASTTXgirRn/wihciZnmL99qlKu0y6qTcUI=;
        b=nrGDaJ0cr+FncRiVrodD8fP8cvPQPmo9Xe3AOJSuZ3+4qxtCQCn/yc8S8cWT9fxfcu
         fWg4sD29dHbNqYu2tYWQ544NXBXQhwQNhLrGvKrNp7Ly0lbVWm1yLGR1rKeXQoqzwVAz
         N5IdromWr+Dp2zt9dn4BYURzE6lvcWcTxW0fkoA407fjtzeoC9lOqSg0PyzwypHAlatv
         mBYLoV5r1GfNhtzwR6oGs+to3TA2z9FX8QiGhI+/1gpA1lRtpg/NQMygb1Z4yBXLoXlq
         K8C/PsNtjE37d3TgSfhyfSpEXk70ChOUFz0iFtJmo/bnf1/R/zLPAJ2kditPWMU+Bn+C
         bxEg==
X-Gm-Message-State: AGi0Pubu2xGEvVb/2vj1bCKhoU9dy5ju8HVrX8lk35sCxd7RMvcvv1tO
        8onLlK/c5rf2wd99DpF61rMRmEShxM7wcnjGHllbHw==
X-Google-Smtp-Source: APiQypLdwtnxEtY39wX4aDKPgVGo2KeRuvU7G5PQfWERi0o12eU73IuyStcx4lVtr9NhK2teQgpc4WDmhV1CbXZvFSs=
X-Received: by 2002:a2e:b0ee:: with SMTP id h14mr1109372ljl.35.1586220629933;
 Mon, 06 Apr 2020 17:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <871a1e89a4dff59f50d9c264c6d9a4cfd0eab50f.1585548051.git.ashish.kalra@amd.com>
 <20200402222943.GA659464@vbusired-dt>
In-Reply-To: <20200402222943.GA659464@vbusired-dt>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 6 Apr 2020 17:49:53 -0700
Message-ID: <CABayD+cEhbhaSpA1N90QRisfx85s3qJVtqyO-AtpULt5ED6tQg@mail.gmail.com>
Subject: Re: [PATCH v6 05/14] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 2, 2020 at 3:31 PM Venu Busireddy <venu.busireddy@oracle.com> w=
rote:
>
> On 2020-03-30 06:21:20 +0000, Ashish Kalra wrote:
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> >
> > The command is used for copying the incoming buffer into the
> > SEV guest memory space.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
>
> > ---
> >  .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
> >  arch/x86/kvm/svm.c                            | 79 +++++++++++++++++++
> >  include/uapi/linux/kvm.h                      |  9 +++
> >  3 files changed, 112 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/amd-memory-encryption.rst
> > index ef1f1f3a5b40..554aa33a99cc 100644
> > --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> > @@ -351,6 +351,30 @@ On success, the 'handle' field contains a new hand=
le and on error, a negative va
> >
> >  For more details, see SEV spec Section 6.12.
> >
> > +14. KVM_SEV_RECEIVE_UPDATE_DATA
> > +----------------------------
> > +
> > +The KVM_SEV_RECEIVE_UPDATE_DATA command can be used by the hypervisor =
to copy
> > +the incoming buffers into the guest memory region with encryption cont=
ext
> > +created during the KVM_SEV_RECEIVE_START.
> > +
> > +Parameters (in): struct kvm_sev_receive_update_data
> > +
> > +Returns: 0 on success, -negative on error
> > +
> > +::
> > +
> > +        struct kvm_sev_launch_receive_update_data {
> > +                __u64 hdr_uaddr;        /* userspace address containin=
g the packet header */
> > +                __u32 hdr_len;
> > +
> > +                __u64 guest_uaddr;      /* the destination guest memor=
y region */
> > +                __u32 guest_len;
> > +
> > +                __u64 trans_uaddr;      /* the incoming buffer memory =
region  */
> > +                __u32 trans_len;
> > +        };
> > +
> >  References
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 038b47685733..5fc5355536d7 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7497,6 +7497,82 @@ static int sev_receive_start(struct kvm *kvm, st=
ruct kvm_sev_cmd *argp)
> >       return ret;
> >  }
> >
> > +static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd=
 *argp)
> > +{
> > +     struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> > +     struct kvm_sev_receive_update_data params;
> > +     struct sev_data_receive_update_data *data;
> > +     void *hdr =3D NULL, *trans =3D NULL;
> > +     struct page **guest_page;
> > +     unsigned long n;
> > +     int ret, offset;
> > +
> > +     if (!sev_guest(kvm))
> > +             return -EINVAL;
> > +
> > +     if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> > +                     sizeof(struct kvm_sev_receive_update_data)))
> > +             return -EFAULT;
> > +
> > +     if (!params.hdr_uaddr || !params.hdr_len ||
> > +         !params.guest_uaddr || !params.guest_len ||
> > +         !params.trans_uaddr || !params.trans_len)
> > +             return -EINVAL;
> > +
> > +     /* Check if we are crossing the page boundary */
> > +     offset =3D params.guest_uaddr & (PAGE_SIZE - 1);
> > +     if ((params.guest_len + offset > PAGE_SIZE))
> > +             return -EINVAL;

Check for overflow.
>
> > +
> > +     hdr =3D psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
> > +     if (IS_ERR(hdr))
> > +             return PTR_ERR(hdr);
> > +
> > +     trans =3D psp_copy_user_blob(params.trans_uaddr, params.trans_len=
);
> > +     if (IS_ERR(trans)) {
> > +             ret =3D PTR_ERR(trans);
> > +             goto e_free_hdr;
> > +     }
> > +
> > +     ret =3D -ENOMEM;
> > +     data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> > +     if (!data)
> > +             goto e_free_trans;
> > +
> > +     data->hdr_address =3D __psp_pa(hdr);
> > +     data->hdr_len =3D params.hdr_len;
> > +     data->trans_address =3D __psp_pa(trans);
> > +     data->trans_len =3D params.trans_len;
> > +
> > +     /* Pin guest memory */
> > +     ret =3D -EFAULT;
> > +     guest_page =3D sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK=
,
> > +                                 PAGE_SIZE, &n, 0);
> > +     if (!guest_page)
> > +             goto e_free;
> > +
> > +     /* The RECEIVE_UPDATE_DATA command requires C-bit to be always se=
t. */
> > +     data->guest_address =3D (page_to_pfn(guest_page[0]) << PAGE_SHIFT=
) +
> > +                             offset;
> > +     data->guest_address |=3D sev_me_mask;
> > +     data->guest_len =3D params.guest_len;
> > +     data->handle =3D sev->handle;
> > +
> > +     ret =3D sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, data,
> > +                             &argp->error);
> > +
> > +     sev_unpin_memory(kvm, guest_page, n);
> > +
> > +e_free:
> > +     kfree(data);
> > +e_free_trans:
> > +     kfree(trans);
> > +e_free_hdr:
> > +     kfree(hdr);
> > +
> > +     return ret;
> > +}
> > +
> >  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >       struct kvm_sev_cmd sev_cmd;
> > @@ -7553,6 +7629,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void _=
_user *argp)
> >       case KVM_SEV_RECEIVE_START:
> >               r =3D sev_receive_start(kvm, &sev_cmd);
> >               break;
> > +     case KVM_SEV_RECEIVE_UPDATE_DATA:
> > +             r =3D sev_receive_update_data(kvm, &sev_cmd);
> > +             break;
> >       default:
> >               r =3D -EINVAL;
> >               goto out;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 74764b9db5fa..4e80c57a3182 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1588,6 +1588,15 @@ struct kvm_sev_receive_start {
> >       __u32 session_len;
> >  };
> >
> > +struct kvm_sev_receive_update_data {
> > +     __u64 hdr_uaddr;
> > +     __u32 hdr_len;
> > +     __u64 guest_uaddr;
> > +     __u32 guest_len;
> > +     __u64 trans_uaddr;
> > +     __u32 trans_len;
> > +};
> > +
> >  #define KVM_DEV_ASSIGN_ENABLE_IOMMU  (1 << 0)
> >  #define KVM_DEV_ASSIGN_PCI_2_3               (1 << 1)
> >  #define KVM_DEV_ASSIGN_MASK_INTX     (1 << 2)
> > --
> > 2.17.1
> >
Otherwise looks fine to my eye.
Reviewed-by: Steve Rutherford <srutherford@google.com>
