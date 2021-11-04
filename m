Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A674444DFC
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 05:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhKDEms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 00:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhKDEmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 00:42:42 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BD6C06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 21:40:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id f9so5459382ioo.11
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 21:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/oGGVsH6I+hmezpdEDegUETDQ+R1R/jvng1+rGxahVU=;
        b=UfBtRo2UAkdmuwv88wWtWcGtlY4DwPnt2gDrF+jpR6H3t4HA7BidOVoSkqM2OP0kHQ
         m0ZtyxSE90dUFHCkTY5AfZ+s1ClccHSZWdY8R4ehbu8zvXwlSdbOwqjmp5bKGMRwPgsr
         y+2y+4ZUIufgxYFEZYstF99lf8ECwIlHB0fwSndJlV9KvTWolJw5Bd90AQKFonzXt8qi
         jdx5u9Ho1ZkPw/9EDZEaaGAq/zGm8t+T4jJzsBer1kULU/RN22Os5Agg7AUgIfgGMsIp
         xqLeEYPaxeQC9ldtO+B/AI8W7ondlEqHQKJj1kNpFLNbBMnHgROepWanUw3Iy3saqB8/
         htuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/oGGVsH6I+hmezpdEDegUETDQ+R1R/jvng1+rGxahVU=;
        b=csMeA1tBUbejcaOIwu+QEVWv90EZmS0SGaCCkOwqRu9Jr4AlgAvvNh33ZoqgDDjeZa
         HkyR1rCiOXr3CgkgKQwxXc9xtCcrdqU5nJM3evl2tM5kgLEpohd8341mmFz9UzCxKaBF
         6a23sGNBlmupiSGW/1WaOqGzqY6wd5GezQgC+Zid7gpMiKpYzfCIsSTiRH9N6QpTwLJj
         UG/6k3Utw88inFMt8czd34Z7O+IOim8XfJLVpFm3PMvc6gjpZN3KNNJT0cpbUBEn6330
         Ij9oejEaunWb+BD6UbMSFxrYUIoZGNlqsK1tX+VKhzDhrYSj5JR7SOoxHCt8ieZgaRcO
         x7Tw==
X-Gm-Message-State: AOAM532LSUtqpkM4p2VgVBINoGSAerwqCgXu4cQEQE2p2dVw69BtUsjh
        aA8wNHnmgUaMA6ZJWKDElGR1rg==
X-Google-Smtp-Source: ABdhPJxtlH2O9yzm/lh52rnKHYjjgSm8POcEdPjDV8Q5ZoEaT3pwpKKWrr9lu0ghY3vBz8oNOYqgNQ==
X-Received: by 2002:a05:6602:2b89:: with SMTP id r9mr34527695iov.32.1636000804317;
        Wed, 03 Nov 2021 21:40:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id r14sm2513810iov.14.2021.11.03.21.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 21:40:03 -0700 (PDT)
Date:   Thu, 4 Nov 2021 04:40:00 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: Allow guest to set the OSLK bit
Message-ID: <YYNkIFx5jhnIYaxA@google.com>
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-4-oupton@google.com>
 <CAAeT=FxdXX77kkANAgLX-xbsvjdeRtCZQ25dZQ1Rqw+-jU=_dg@mail.gmail.com>
 <YYNX3t3yOL9LKKdP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYNX3t3yOL9LKKdP@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021 at 08:47:42PM -0700, Ricardo Koller wrote:
> On Wed, Nov 03, 2021 at 08:31:35PM -0700, Reiji Watanabe wrote:
> > On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Allow writes to OSLAR and forward the OSLK bit to OSLSR. Change the
> > > reset value of the OSLK bit to 1. Allow the value to be migrated by
> > > making OSLSR_EL1.OSLK writable from userspace.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  arch/arm64/include/asm/sysreg.h |  6 ++++++
> > >  arch/arm64/kvm/sys_regs.c       | 35 +++++++++++++++++++++++++--------
> > >  2 files changed, 33 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > index b268082d67ed..6ba4dc97b69d 100644
> > > --- a/arch/arm64/include/asm/sysreg.h
> > > +++ b/arch/arm64/include/asm/sysreg.h
> > > @@ -127,7 +127,13 @@
> > >  #define SYS_DBGWCRn_EL1(n)             sys_reg(2, 0, 0, n, 7)
> > >  #define SYS_MDRAR_EL1                  sys_reg(2, 0, 1, 0, 0)
> > >  #define SYS_OSLAR_EL1                  sys_reg(2, 0, 1, 0, 4)
> > > +
> > > +#define SYS_OSLAR_OSLK                 BIT(0)
> > > +
> > >  #define SYS_OSLSR_EL1                  sys_reg(2, 0, 1, 1, 4)
> > > +
> > > +#define SYS_OSLSR_OSLK                 BIT(1)
> > > +
> > >  #define SYS_OSDLR_EL1                  sys_reg(2, 0, 1, 3, 4)
> > >  #define SYS_DBGPRCR_EL1                        sys_reg(2, 0, 1, 4, 4)
> > >  #define SYS_DBGCLAIMSET_EL1            sys_reg(2, 0, 7, 8, 6)
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 0326b3df0736..acd8aa2e5a44 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -44,6 +44,10 @@
> > >   * 64bit interface.
> > >   */
> > >
> > > +static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> > > +static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> > > +static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > > +
> > >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> > >                                  struct sys_reg_params *params,
> > >                                  const struct sys_reg_desc *r)
> > > @@ -287,6 +291,24 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> > >         return trap_raz_wi(vcpu, p, r);
> > >  }
> > >
> > > +static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
> > > +                          struct sys_reg_params *p,
> > > +                          const struct sys_reg_desc *r)
> > > +{
> > > +       u64 oslsr;
> > > +
> > > +       if (!p->is_write)
> > > +               return read_from_write_only(vcpu, p, r);
> > > +
> > > +       /* Forward the OSLK bit to OSLSR */
> > > +       oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> > > +       if (p->regval & SYS_OSLAR_OSLK)
> > > +               oslsr |= SYS_OSLSR_OSLK;
> > > +
> > > +       __vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
> > > +       return true;
> > > +}
> > > +
> > >  static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
> > >                            struct sys_reg_params *p,
> > >                            const struct sys_reg_desc *r)
> > > @@ -309,9 +331,10 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >         if (err)
> > >                 return err;
> > >
> > > -       if (val != rd->val)
> > > +       if ((val | SYS_OSLSR_OSLK) != rd->val)
> > >                 return -EINVAL;
> > >
> > > +       __vcpu_sys_reg(vcpu, rd->reg) = val;
> > >         return 0;
> > >  }
> > >
> > > @@ -1176,10 +1199,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> > >         return __access_id_reg(vcpu, p, r, true);
> > >  }
> > >
> > > -static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> > > -static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> > > -static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > > -
> > >  /* Visibility overrides for SVE-specific control registers */
> > >  static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> > >                                    const struct sys_reg_desc *rd)
> > > @@ -1456,8 +1475,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> > >         DBG_BCR_BVR_WCR_WVR_EL1(15),
> > >
> > >         { SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
> > > -       { SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
> > > -       { SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
> > > +       { SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
> > > +       { SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x0000000A,
> > >                 .set_user = set_oslsr_el1, },
> > 
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > 
> > I assume the reason why you changed the reset value for the
> > register is because Arm ARM says "the On a Cold reset,
> > this field resets to 1".
> > 
> > "4.82 KVM_ARM_VCPU_INIT" in Documentation/virt/kvm/api.rst says:
> > -------------------------------------------------------------
> >   - System registers: Reset to their architecturally defined
> >     values as for a warm reset to EL1 (resp. SVC)
> > -------------------------------------------------------------
> > 
> > Since Arm ARM doesn't say anything about a warm reset for the field,
> > I would guess the bit doesn't necessarily need to be set.
> 
> That would be great, because it would avoid the migration issue that
> Oliver described in [PATCH v2 4/6]:

Yeah, awesome! Means I can be even lazier and things will "Just Work"
:-)

--
Oliver
