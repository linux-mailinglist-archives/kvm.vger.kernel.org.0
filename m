Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6AD7C4AA4
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 08:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344505AbjJKGcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 02:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343606AbjJKGcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 02:32:42 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99E093
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 23:32:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-58e119bb28eso505900a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 23:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697005960; x=1697610760; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlCvzn9D9MWfXzyAjQXrd2l33CVlRWaoX+EsCqMd6ps=;
        b=kWTWVPK7N9NCNf2HZ3Fyp42qChTUEHUHU97/4FONyjQgtNtbeeDXBEMNrp4zfUlB2x
         vX8T9j9s5s/ARkEB/UTWO0sisG0aSIWSqSzC4PvABUFj0ZSX7YtcnAA3sPm/ccNFz1dn
         Cch+OPNt05lppQURTmvKrfRsnNHKAK2a9/lZzh5RKgkp58iWhKD9slxYcvPXpEznkydo
         BwuPnbCUXdYJEG6R1oOGbPVpXS9PA9eEBdiFUoU2yfd7jwNOnoF1L81rbqLlouQUA/kc
         fAi5QEBKkuyqfXDx0cyrFI2nxm61QRBAgtxwQ49npw0Oq4dWd2GyhXTcSgYJ8R4USj+D
         Vd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697005960; x=1697610760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlCvzn9D9MWfXzyAjQXrd2l33CVlRWaoX+EsCqMd6ps=;
        b=inUpyjKGpZj2fEAKl8IZ7poCwH8SjppyJsMx6G0JObDI3YJa5b64ErSgCNQ6QaBTUG
         MZ5ZCuH73UeDZBC94OOO0+jYsqU7ZSeV3Xr6AfXfXKOZeMw55QaZd6tI2/UsCQnVvlci
         SupWDy1Ni4LBk3GJN3t0QEeT7/qf3Ag47NJRC/XD+f3+ibEHN88RveTasa2WYbUZy/9H
         crFBkJf/XcLKLgBxgDX5eaYHHPsFosbN1ib3o3ABMRDdhsJ+IpL7NpiycsA66AjCOe05
         WNCKnStMdK4FO1PflQSkoKoq3t/iveQVg2iSm5mQoz+aQd6eqG5BvO/cCyT/CYn2XfYE
         ckOA==
X-Gm-Message-State: AOJu0Yz0+wKadgkp/OY46Mi1pYaKBq4q640IJVXLqAnn2Gm4xmNlXhJG
        rDbMwESgUVo3uRBTcBDCfwbmJOHUB684xcKQxbhgCA==
X-Google-Smtp-Source: AGHT+IH0b9pvjz2wUtu97VMbjcxmgb/lTA+sWvTdIT6U1QGtyomZxkrbbJUyvfIkk70xvT4UTjANIh9gr7AwN1M7ntI=
X-Received: by 2002:a17:90b:4a02:b0:277:61d7:78be with SMTP id
 kk2-20020a17090b4a0200b0027761d778bemr24784754pjb.14.1697005960055; Tue, 10
 Oct 2023 23:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20231010170503.657189-1-apatel@ventanamicro.com>
 <20231010170503.657189-4-apatel@ventanamicro.com> <2023101048-attach-drift-d77b@gregkh>
In-Reply-To: <2023101048-attach-drift-d77b@gregkh>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Wed, 11 Oct 2023 12:02:30 +0530
Message-ID: <CAK9=C2UEcQpHg8WZM3XxLa5yCEZ6wtWJj=8g5_m_0_RkiNMkTA@mail.gmail.com>
Subject: Re: [PATCH 3/6] RISC-V: KVM: Forward SBI DBCN extension to user-space
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 10:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 10, 2023 at 10:35:00PM +0530, Anup Patel wrote:
> > The SBI DBCN extension needs to be emulated in user-space
>
> Why?

The SBI debug console is similar to a console port available to
KVM Guest so the KVM user space tool (i.e. QEMU-KVM or
KVMTOOL) can redirect the input/output of SBI debug console
wherever it wants (e.g.  telnet, file, stdio, etc).

We forward SBI DBCN calls to KVM user space so that the
in-kernel KVM does not need to be aware of the guest
console devices.

>
> > so let
> > us forward console_puts() call to user-space.
>
> What could go wrong!
>
> Why does userspace have to get involved in a console message?  Why is
> this needed at all?  The kernel can not handle userspace consoles as
> obviously they have to be re-entrant and irq safe.

As mentioned above, these are KVM guest console messages which
the VMM (i.e. KVM user-space) can choose to manage on its own.

This is more about providing flexibility to KVM user-space which
allows it to manage guest console devices.

>
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
> >  arch/riscv/include/uapi/asm/kvm.h     |  1 +
> >  arch/riscv/kvm/vcpu_sbi.c             |  4 ++++
> >  arch/riscv/kvm/vcpu_sbi_replace.c     | 31 +++++++++++++++++++++++++++
> >  4 files changed, 37 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include=
/asm/kvm_vcpu_sbi.h
> > index 8d6d4dce8a5e..a85f95eb6e85 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > @@ -69,6 +69,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_e=
xt_ipi;
> >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
> >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
> >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
> > +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
> >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
> >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 917d8cc2489e..60d3b21dead7 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -156,6 +156,7 @@ enum KVM_RISCV_SBI_EXT_ID {
> >       KVM_RISCV_SBI_EXT_PMU,
> >       KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> >       KVM_RISCV_SBI_EXT_VENDOR,
> > +     KVM_RISCV_SBI_EXT_DBCN,
> >       KVM_RISCV_SBI_EXT_MAX,
>
> You just broke a user/kernel ABI here, why?

The KVM_RISCV_SBI_EXT_MAX only represents the number
of entries in "enum KVM_RISCV_SBI_EXT_ID" so we are not
breaking "enum KVM_RISCV_SBI_EXT_ID" rather appending
new ID to existing enum.

>
> thanks,
>
> greg k-h

Thanks,
Anup
