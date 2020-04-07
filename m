Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570291A03E8
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 02:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDGA6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 20:58:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35287 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgDGA6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 20:58:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id k21so1818743ljh.2
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 17:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TDz9BFmZ8zQpqNsWCTptx0CrsbNAsUuC7AsThVhGJVY=;
        b=bmS1u9FMz/4hyaxFYbha1NI2AnffokqKUEnhj0wBpgyduvbsFD1n+97WD4U75p+1ob
         EnZaumrGvgNO5ochV/LIMm/bYhgMXfD4ViALib44ySCVTBIE7hRrGzgfnQGFvJKVH4Tm
         9wJXGyAAVbsTUiaPiPJaKA0QtBuvojNec0BT6DUp1VwTYUWUUQPiLXHTxTZTIuRs2j9g
         AVAZhVv0QaVNJCJVzLbPNrJQaeInwCs5j5lWTCGIcBd0kX09NR+NmU0MY16u07v/p4K9
         bMzmb9zMEWyWTREvKXMA4vbsKfTw3q6vuHRRVFerVwNjGiwI+fU7frloTaX1suC7w10o
         nhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TDz9BFmZ8zQpqNsWCTptx0CrsbNAsUuC7AsThVhGJVY=;
        b=D5EMOQrrw61ggJ6LutHOQA0t1YFsMJuqyXdlaGJa48qX+VcO2pI+b6YtPFGwJgQ+0b
         M1GiZNEiDTBj/0uOlqhWyuvFXWCv6BuK258co2ornZ274snALHqoXRFWNHD1dfYe+SCD
         +0RZQaOLbJE4w4Oyd/ixKGh/HvmWHCeKep1mmb+VcW6bVn6yvY1BuEWcbafx6QgiAm83
         pON6hgLpvh6yAe9WZ6loQFIxEb0RYg2Hl9PPo26Lv5BUGtbW0o8fWoIHTS9R8w73gcxI
         lTI+z8R5xlEtwe+dMDTYfYeRr4r+rHwExQ3tz7D4k5ZwatdGZAnuvpXyxoIg+kJtBE0E
         JPBg==
X-Gm-Message-State: AGi0PuYN7wcADI0zqO9YjnaNgF19lmRD6LVFJyz8fvP6umijmlVYy1Lt
        7oR1RmpMW817wuxoavNzbYE4ugEnmWu2rUdfFxe6FQ==
X-Google-Smtp-Source: APiQypJPjEm7jIn9z+xThhRqVGjzF4hWCD7RLXMMIVBq9BZWIjtWy7Q+lJWVYtgK52U74tJQzmDlc9Ni7zpWkWW3eWA=
X-Received: by 2002:a2e:894e:: with SMTP id b14mr3817ljk.103.1586221111082;
 Mon, 06 Apr 2020 17:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <0f8a2125c7acb7b38fc51a044a8088e8baa45e3d.1585548051.git.ashish.kalra@amd.com>
 <8694381f-2083-e477-bea1-04fb572519d0@oracle.com>
In-Reply-To: <8694381f-2083-e477-bea1-04fb572519d0@oracle.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 6 Apr 2020 17:57:54 -0700
Message-ID: <CABayD+dvb7iYOJrrBRwKw2qp1MDLWucp3yds_YG+vLTzaV6DTA@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
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

On Thu, Apr 2, 2020 at 3:27 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 3/29/20 11:21 PM, Ashish Kalra wrote:
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> >
> > The command finalize the guest receiving process and make the SEV guest
> > ready for the execution.
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
> > ---
> >   .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
> >   arch/x86/kvm/svm.c                            | 23 ++++++++++++++++++=
+
> >   2 files changed, 31 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/amd-memory-encryption.rst
> > index 554aa33a99cc..93cd95d9a6c0 100644
> > --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> > @@ -375,6 +375,14 @@ Returns: 0 on success, -negative on error
> >                   __u32 trans_len;
> >           };
> >
> > +15. KVM_SEV_RECEIVE_FINISH
> > +------------------------
> > +
> > +After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH com=
mand can be
> > +issued by the hypervisor to make the guest ready for execution.
> > +
> > +Returns: 0 on success, -negative on error
> > +
> >   References
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 5fc5355536d7..7c2721e18b06 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7573,6 +7573,26 @@ static int sev_receive_update_data(struct kvm *k=
vm, struct kvm_sev_cmd *argp)
> >       return ret;
> >   }
> >
> > +static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *arg=
p)
> > +{
> > +     struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> > +     struct sev_data_receive_finish *data;
> > +     int ret;
> > +
> > +     if (!sev_guest(kvm))
> > +             return -ENOTTY;
> > +
> > +     data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> > +     if (!data)
> > +             return -ENOMEM;
> > +
> > +     data->handle =3D sev->handle;
> > +     ret =3D sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, data, &argp->e=
rror);
> > +
> > +     kfree(data);
> > +     return ret;
> > +}
> > +
> >   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >   {
> >       struct kvm_sev_cmd sev_cmd;
> > @@ -7632,6 +7652,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void _=
_user *argp)
> >       case KVM_SEV_RECEIVE_UPDATE_DATA:
> >               r =3D sev_receive_update_data(kvm, &sev_cmd);
> >               break;
> > +     case KVM_SEV_RECEIVE_FINISH:
> > +             r =3D sev_receive_finish(kvm, &sev_cmd);
> > +             break;
> >       default:
> >               r =3D -EINVAL;
> >               goto out;
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

As to ENOTTY, man page for ioctl translates it as "The specified
request does not apply to the kind of object that the file descriptor
fd references", which seems appropriate here.
Reviewed-by: Steve Rutherford <srutherford@google.com>
