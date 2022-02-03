Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C604A8A3D
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352916AbiBCRiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiBCRiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:38:01 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1870EC061714
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:38:01 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id u7so3398934lji.2
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6t1NMzP4e8n3FBQ7Ilq4G/oflmuQi4zeKyZmWebLgWI=;
        b=hda7WI8uFTics5pmFrHWD1sVsLUEkG5a0ilo+bECArSPgaAQHFDVKPblloMUejv90E
         hahtFEpw1bvYpIbBbDGPE1TFLHWQALzW9cCU++8eL+eVIB05b8wFlPprTh/WDDiJ1jRC
         HHeMr/iZYmL95DDyzJ9mWtu9+nw1U1k841MEt3vthKfAROrToVmh4B50qco28SiVYejc
         3zC1W6a3Fq39M6kW9CHohpFG0rjYENzWe1zHw+e93KuE2VX1A0adL1r3uYiAwdn7LXty
         IT9Xdqt7y/pkYdt4q5FiAKefaTnOajvxQjjRLavffOE+2W0/jEHcTwZUOmgS5GGJcmTp
         emjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6t1NMzP4e8n3FBQ7Ilq4G/oflmuQi4zeKyZmWebLgWI=;
        b=IVJ2uEoon4dw/LF0uZ0gHTAg5ygecVH+tuHRuN3AlNaMND3/kkULLGja91XSudb7+h
         sSRavv5BLLj3BdDTPC+hai3SKTSCErlfFFmUY25MjIOBLNGluCY7lTFCU01w8ZFwVN/B
         4j6Lt2DlUaH4kmsHSmrzXNldvqGWyHT2v8puXYijBJLnH/GShvS3pm2CDl8CKZE2xumr
         JHhc+HSWrnr2qV+DHac0FwGeCVwnt3lHI8pB7w8oc4so6GZS3YvtkCJS6Is1uvCZdokx
         BxRFKZG/QD1frSgzts73TB44084Oobv2yTU+dYB56DUflt4vkxTkKVVQr3xKmkWXDyk8
         GdTw==
X-Gm-Message-State: AOAM532EtZeaJLSe2PVB7XqAtBM/2n3+Af7C3G0YN4ftLkDoaEWXlzVg
        2Nap1pj4pjjWSCCEF8KBKoqJu1Gsh4i5xg5fPTIqZQ==
X-Google-Smtp-Source: ABdhPJx0I/4I6/U1UG73AltPWLQkpDwtns8xeurO6OUxlLlusAin2rvTO+b1teWE6T2TXJWIO3Fg/uP2LzH/HiTDSgg=
X-Received: by 2002:a2e:b449:: with SMTP id o9mr22832976ljm.140.1643909879114;
 Thu, 03 Feb 2022 09:37:59 -0800 (PST)
MIME-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com> <20211214172812.2894560-4-oupton@google.com>
 <YbncTRH4TnVvRVxB@FVFF77S0Q05N>
In-Reply-To: <YbncTRH4TnVvRVxB@FVFF77S0Q05N>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 3 Feb 2022 09:37:48 -0800
Message-ID: <CAOQ_QsjppDFzy8-kN_wkGXB6fn0j4svfx=K265v-bit5uPeJTQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Allow guest to set the OSLK bit
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

Sorry for the delay on my end..

On Wed, Dec 15, 2021 at 4:15 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > +static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
> > +                        struct sys_reg_params *p,
> > +                        const struct sys_reg_desc *r)
> > +{
> > +     u64 oslsr;
> > +
> > +     if (!p->is_write)
> > +             return read_from_write_only(vcpu, p, r);
> > +
> > +     /* Forward the OSLK bit to OSLSR */
> > +     oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> > +     if (p->regval & SYS_OSLAR_OSLK)
> > +             oslsr |= SYS_OSLSR_OSLK;
> > +
> > +     __vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
> > +     return true;
> > +}
>
> Does changing this affect existing userspace? Previosuly it could read
> OSLAR_EL1 as 0, whereas now that should be rejected.
>
> That might be fine, and if so, it would be good to call that out in the commit
> message.

I do not believe we expose OSLAR_EL1 to userspace. Attempts to read it
return -ENOENT. The access will go through get_invariant_sys_reg(),
which cannot find a corresponding entry in the invariant_sys_regs
array.

[...]

> > @@ -309,9 +331,14 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >       if (err)
> >               return err;
> >
> > -     if (val != rd->val)
> > +     /*
> > +      * The only modifiable bit is the OSLK bit. Refuse the write if
> > +      * userspace attempts to change any other bit in the register.
> > +      */
> > +     if ((val & ~SYS_OSLSR_OSLK) != SYS_OSLSR_OSLM)
> >               return -EINVAL;
>
> How about:
>
>         if ((val ^ rd->val) & ~SYS_OSLSR_OSLK)
>                 return -EINVAL;
>
> ... so that we don't need to hard-code the expected value here, and can more
> easily change it in future?

Nice and clean. Thanks!

--
Best,
Oliver
