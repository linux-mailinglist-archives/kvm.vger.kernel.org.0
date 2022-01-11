Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA4D48A6D3
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 05:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347876AbiAKEeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 23:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiAKEeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 23:34:06 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C537C061748
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 20:34:05 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id l15so15287085pls.7
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 20:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMyFE4hG9HNVlJfPf9YKH//FQ4xNSq0cqHXKoYVzLtY=;
        b=IoUVuvrgWKhoC6sytqSfwIJI7gkn4fO0B8ADTV3aEgX+knQcJsv0VAQaj1kuLBeNoI
         O6xnzUblcUsaWiU/Z4wBCsMYs8FnGy+kKltX5jlY/Z5bpv7VT+iDEIl4N5HphnVSPoKc
         yCPnpKrZyKuNI9FN/+bAZAeyLqf69A96/TysbBvFonI3FqDvEBEBbYX9wpHhrFv1ZrqM
         dqOYgpXY9ky0C/oAQHLMOCPUXteUxxndCpdzANKI3hQUQxZVPAGAUyi4rSwXbtDp2ABn
         L+DKYW4o2UtYL9YEHda31pyHov40Rr1EwQ8mQ9Prkrr6+CDQjQO0rFzakHfnfcSZSS1V
         UWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMyFE4hG9HNVlJfPf9YKH//FQ4xNSq0cqHXKoYVzLtY=;
        b=hGc34dvjGlM4hCUfutLqfBeXSjysiAUAwg0TGa+JE0MpnNZyDLAxYsWZJLJL7PxpBF
         GL6OccNlYCWN0YFVIArnIL/MVCJ5hqEZDcbMQ2FCLAM+0XziXd5wsB0i/vGCDtoSFrnr
         jjPZPxvZkRVNjJ08NujHPFq6tpwP9jcCV0x5fBDsn76+Nqbs9cZJF32075krSFfGjGd7
         BrrEqzF2tEfohhMCWiBDyIkeqhoyoDwn8stToyFUIIQkL1YH5Kog1AucBcVwsbElWmJP
         ovKEQohSdU9fCGzmcHZUJF1bA8IYZqFG9yupN8Y7lLhRIsxVe0kAb3xBopsCDBDwJ/dk
         V6Qg==
X-Gm-Message-State: AOAM531WVRmf+yNMHtJoPToPvFOBoCAxm+MSEm1StZrDTD+jQypO8BsZ
        gzei4sNdjn6lGUKLpqMCM+AD5C9oYcslkF/H6URBZg==
X-Google-Smtp-Source: ABdhPJxDACYVZNSOXRWjP5GTJ3EFQevPl911BeBWcnIlhN78MJFunWDZRUfpIPX1foVzWaUHnTgRqvlXUGm4SWZ6HUg=
X-Received: by 2002:a63:6c85:: with SMTP id h127mr2530846pgc.491.1641875644641;
 Mon, 10 Jan 2022 20:34:04 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-4-rananta@google.com>
 <CAAeT=FxCCD+H1z8+gfyBZNeibfAUqUenZZe56Vj_3fCghJjy=Q@mail.gmail.com> <CAJHc60yY9qH5_r09Tz2fhWr+tT+i7RnKhchBuEePCKnos52kwA@mail.gmail.com>
In-Reply-To: <CAJHc60yY9qH5_r09Tz2fhWr+tT+i7RnKhchBuEePCKnos52kwA@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 Jan 2022 20:33:48 -0800
Message-ID: <CAAeT=FyJcUKP4ZGuMQh-AFExj9X=cXKUf0RueqqqhRwUHL2+sw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/11] KVM: Introduce KVM_CAP_ARM_HVC_FW_REG_BMAP
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 3:40 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Fri, Jan 7, 2022 at 9:40 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Raghu,
> >
> > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > Introduce the KVM ARM64 capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
> > > to indicate the support for psuedo-firmware bitmap extension.
> > > Each of these registers holds a feature-set exposed to the guest
> > > in the form of a bitmap. If supported, a simple 'read' of the
> > > capability should return the number of psuedo-firmware registers
> > > supported. User-space can utilize this to discover the registers.
> > > It can further explore or modify the features using the classical
> > > GET/SET_ONE_REG interface.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++++
> > >  include/uapi/linux/kvm.h       |  1 +
> > >  2 files changed, 22 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index aeeb071c7688..646176537f2c 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -6925,6 +6925,27 @@ indicated by the fd to the VM this is called on.
> > >  This is intended to support intra-host migration of VMs between userspace VMMs,
> > >  upgrading the VMM process without interrupting the guest.
> > >
> > > +7.30 KVM_CAP_ARM_HVC_FW_REG_BMAP
> >
> > IMHO, instead of including its format of the register in the name,
> > including its purpose/function in the name might be better.
> > e.g. KVM_CAP_ARM_HVC_FEATURE_REG ?
> > (Feature fields don't necessarily have to be in a bitmap format
> >  if they don't fit well although I'm not sure if we have such fields.)
> >
> Well we do have registers, KVM_REG_ARM_PSCI_VERSION for instance,
> that's not covered by this CAP. But sure, I can explicitly add
> 'FEATURES' to the name. I also wanted to explicitly convey that we are
> covering the *bitmapped* firmware registers here. But not sure if
> appending 'BMAP' might give an impression that the CAP itself is
> bitmapped.
> Do you think KVM_CAP_ARM_HVC_BMAP_FEAT_REG is better?

Thank you for the explanation! That sounds better to me.

Regards,
Reiji


> > > +
> > > +:Architectures: arm64
> > > +:Parameters: None
> > > +:Returns: Number of psuedo-firmware registers supported
> >
> > Looking at patch-4, the return value of this would be the number of
> > pseudo-firmware *bitmap* registers supported.
> > BTW, "4.68 KVM_SET_ONE_REG" in the doc uses the word "arm64 firmware
> > pseudo-registers".  It would be nicer to use the same term.
> >
> Nice catch. I'll fix it here in apr.rst.
> > > +
> > > +This capability indicates that KVM for arm64 supports the psuedo-firmware
> > > +register bitmap extension. Each of these registers represent the features
> > > +supported by a particular type in the form of a bitmap. By default, these
> > > +registers are set with the upper limit of the features that are supported.
> > > +
> > > +The registers can be accessed via the standard SET_ONE_REG and KVM_GET_ONE_REG
> > > +interfaces. The user-space is expected to read the number of these registers
> > > +available by reading KVM_CAP_ARM_HVC_FW_REG_BMAP, read the current bitmap
> > > +configuration via GET_ONE_REG for each register, and then write back the
> > > +desired bitmap of features that it wishes the guest to see via SET_ONE_REG.
> > > +
> > > +Note that KVM doesn't allow the user-space to modify these registers after
> > > +the VM (any of the vCPUs) has started running.
> >
> > Since even if KVM_RUN fails, and the VM hasn't started yet,
> > it will get immutable. So, "after any of the vCPUs run KVM_RUN."
> > might be more clear ?
> >
> Sure, that's probably more clear. I'll fix it.
>
> Regards,
> Raghavendra
>
> > Thanks,
> > Reiji
> >
> >
> >
> > > +
> > >  8. Other capabilities.
> > >  ======================
> > >
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index 1daa45268de2..209b43dbbc3c 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
> > >  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
> > >  #define KVM_CAP_ARM_MTE 205
> > >  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> > > +#define KVM_CAP_ARM_HVC_FW_REG_BMAP 207
> > >
> > >  #ifdef KVM_CAP_IRQ_ROUTING
> > >
> > > --
> > > 2.34.1.448.ga2b2bfdf31-goog
> > >
