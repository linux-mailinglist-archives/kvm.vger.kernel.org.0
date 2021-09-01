Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F2E3FE5F3
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242175AbhIAXHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 19:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbhIAXHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 19:07:12 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187B5C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 16:06:15 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id j18so95707ioj.8
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 16:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KZ/5nel7V3JYltMvpEGkr0qAe2nUa6A5gCoohICIk1U=;
        b=ptTWVvIXnmKoEScR5wfbDVKBiHVdPwwVrptmuTuhJVbPYOxgcbRhxrfw8HKuPWeWxF
         nE1Jc0HnWlbabWnNwP7yZlr0GuVrHwf8F5YgUdJYMrBXg6sNRyfEO6goIAh36ZaNvDy9
         t8w2ap9acGNdJ3gPs8pZV8nWo5w7/w2FdyH+o7CuMi2JTCECj46yq+ycnYW0NY4fa7+d
         n17yv+xB5YCMuypPSsWfX8TYQC6LxhZfyCpuGd+EA5KNvVZpquWBkdZ1ClEnNw2gmfkF
         u/4KAtFf1oaq9WehcZSh1IFg9Jcgki6aPFOvI1zvoAzbZh0ZALQpNkkC+QhRh5j8Lu59
         r+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KZ/5nel7V3JYltMvpEGkr0qAe2nUa6A5gCoohICIk1U=;
        b=IMws7CO2VYwwDWs1es4Gcd6VZJWguPPUI/LbJC7RbNDDenrN9eoe6UuGkGufr29HFc
         HS/R3/xEGp9wat7R+Kxu6aAt5l8UOiNhQ0LTquVx16w32poQVQMAUpaE/HmaEfrRMlBo
         ckJ5pBKEY3k9tJXKskeBA61r2UDVXMklOjkvEbF5w3JfgKAAEePeVcWjOF9Je8/FGhlp
         muSZpUwME8a8gPkVh2f+3A8iATJrGShIUAgCX3iZhgA5mZXdxEcKiZSB83st9XrvlOBL
         xdrDMNkW2NMFxtXh3TerzkQzBRFK1Ud/MBvCM0C78CHuu1FBdmXJcEMssU09Olu9YWNR
         cuOA==
X-Gm-Message-State: AOAM532gf0MLybZjKgMTt0VF8BKJDZL38Hp3S31r6p5N0egGn7dnABKC
        1BWPWmk+aYtww9y07zH+1cEX2w==
X-Google-Smtp-Source: ABdhPJxEM4N294HdnpgByMmrM0QXbQJiuXDih9pT6LyofjozajJsW+u0iFTBg48WKw74Eb71BROBPQ==
X-Received: by 2002:a5e:db06:: with SMTP id q6mr230560iop.24.1630537574234;
        Wed, 01 Sep 2021 16:06:14 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id l15sm538950ilt.45.2021.09.01.16.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:06:13 -0700 (PDT)
Date:   Wed, 1 Sep 2021 23:06:10 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <YTAHYrQslkY12715@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com>
 <YS/53N7LdJOgdzNu@google.com>
 <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 03:48:40PM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Sep 1, 2021 at 3:08 PM Oliver Upton <oupton@google.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> > > On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > > > For register names that are unsupported by the assembler or the ones
> > > > without architectural names, add the macros write_sysreg_s and
> > > > read_sysreg_s to support them.
> > > >
> > > > The functionality is derived from kvm-unit-tests and kernel's
> > > > arch/arm64/include/asm/sysreg.h.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > >
> > > Would it be possible to just include <asm/sysreg.h>? See
> > > tools/arch/arm64/include/asm/sysreg.h
> >
> > Geez, sorry for the noise. I mistakenly searched from the root of my
> > repository, not the tools/ directory.
> >
> No worries :)
> 
> > In any case, you could perhaps just drop the kernel header there just to
> > use the exact same source for kernel and selftest.
> >
> You mean just copy/paste the entire header? There's a lot of stuff in
> there which we
> don't need it (yet).

Right. It's mostly register definitions, which I don't think is too high
of an overhead. Don't know where others stand, but I would prefer a
header that is equivalent between kernel & selftests over a concise
header.

--
Thanks,
Oliver

> > Thanks,
> > Oliver
> >
> > > > ---
> > > >  .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
> > > >  1 file changed, 61 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > index 3cbaf5c1e26b..082cc97ad8d3 100644
> > > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > @@ -118,6 +118,67 @@ void vm_install_exception_handler(struct kvm_vm *vm,
> > > >  void vm_install_sync_handler(struct kvm_vm *vm,
> > > >             int vector, int ec, handler_fn handler);
> > > >
> > > > +/*
> > > > + * ARMv8 ARM reserves the following encoding for system registers:
> > > > + * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
> > > > + *  C5.2, version:ARM DDI 0487A.f)
> > > > + * [20-19] : Op0
> > > > + * [18-16] : Op1
> > > > + * [15-12] : CRn
> > > > + * [11-8]  : CRm
> > > > + * [7-5]   : Op2
> > > > + */
> > > > +#define Op0_shift  19
> > > > +#define Op0_mask   0x3
> > > > +#define Op1_shift  16
> > > > +#define Op1_mask   0x7
> > > > +#define CRn_shift  12
> > > > +#define CRn_mask   0xf
> > > > +#define CRm_shift  8
> > > > +#define CRm_mask   0xf
> > > > +#define Op2_shift  5
> > > > +#define Op2_mask   0x7
> > > > +
> > > > +/*
> > > > + * When accessed from guests, the ARM64_SYS_REG() doesn't work since it
> > > > + * generates a different encoding for additional KVM processing, and is
> > > > + * only suitable for userspace to access the register via ioctls.
> > > > + * Hence, define a 'pure' sys_reg() here to generate the encodings as per spec.
> > > > + */
> > > > +#define sys_reg(op0, op1, crn, crm, op2) \
> > > > +   (((op0) << Op0_shift) | ((op1) << Op1_shift) | \
> > > > +    ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
> > > > +    ((op2) << Op2_shift))
> > > > +
> > > > +asm(
> > > > +"  .irp    num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
> > > > +"  .equ    .L__reg_num_x\\num, \\num\n"
> > > > +"  .endr\n"
> > > > +"  .equ    .L__reg_num_xzr, 31\n"
> > > > +"\n"
> > > > +"  .macro  mrs_s, rt, sreg\n"
> > > > +"  .inst   0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > > > +"  .endm\n"
> > > > +"\n"
> > > > +"  .macro  msr_s, sreg, rt\n"
> > > > +"  .inst   0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > > > +"  .endm\n"
> > > > +);
> > > > +
> > > > +/*
> > > > + * read_sysreg_s() and write_sysreg_s()'s 'reg' has to be encoded via sys_reg()
> > > > + */
> > > > +#define read_sysreg_s(reg) ({                                              \
> > > > +   u64 __val;                                                      \
> > > > +   asm volatile("mrs_s %0, "__stringify(reg) : "=r" (__val));      \
> > > > +   __val;                                                          \
> > > > +})
> > > > +
> > > > +#define write_sysreg_s(reg, val) do {                                      \
> > > > +   u64 __val = (u64)val;                                           \
> > > > +   asm volatile("msr_s "__stringify(reg) ", %x0" : : "rZ" (__val));\
> > > > +} while (0)
> > > > +
> > > >  #define write_sysreg(reg, val)                                               \
> > > >  ({                                                                   \
> > > >     u64 __val = (u64)(val);                                           \
> > > > --
> > > > 2.33.0.153.gba50c8fa24-goog
> > > >
