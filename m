Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FE3321C69
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhBVQIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbhBVQHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 11:07:55 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7C3C06178B
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 08:07:03 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t25so10497272pga.2
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 08:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mp7wIhLHWdhboT6kIoeZS80417khoNPc/CItzMbajCM=;
        b=GghBN+pJW634uiH0KTvYQM25/DQNpQPu4VEF3pllmDO/S+sXWWXvfEcPZD7QzQs9p2
         wK0aVSoTe3R/o1UKotnmlXWXlWMFWQpMfOHkxdrSr3K+i2TOjz5/oNfo+VXAplIz9O7Y
         m7DPjmLtPN09xoGaMg1HPRJwS84c0QxxavAABptUXuOocx4cfM30gvi+OS7sH5SHNMKu
         VTiebkIQROzGNQguER8Oo5Y+llKPvpVwvIOihvewwLxecWoFR5rilxSvmx8UoGi/SDlO
         4nY5QInyKBTSATXZax+wF/Xiaq55FURXrt0wCErG40INjLE41UPsXY+wgpvigM00HtLY
         81Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mp7wIhLHWdhboT6kIoeZS80417khoNPc/CItzMbajCM=;
        b=sV+Pa0lbPxByoUrTf8MA/rlMwfsgmYjBKLDWN2haqCgP1vxv1CttR1nG++chYbSqpg
         yl4q+KOvperaROr7n0rTmzZnPqL6YwXn8bmmIEBni5zaKz/Pe6hoiZhGSu05vwoVgiYw
         yBYNJ/WXO3mGGVEwxNnpbwVuc/lH1wls23pwcQaQrLoWPwjuSbogqHOBAqePFqkRJdiL
         U1x9+9cQs6xJh2vcWxzUyGFJMSEVxyltdHig6PIiY59Ipevj4BId2Ac4X3IexkDudd9J
         qPcYb6xH0rDthWUxjEKzCuPfSFRSd4wCzKpToyCKSMSteUiKF4GpA+VR4YgWZmtusFel
         7zlQ==
X-Gm-Message-State: AOAM533219ONlmNBFL/BcXBtn20XD0gyvoc5nJopN202HMPVRdf+VbyD
        wvO1WNpBJ9v4SGE2+gPLV/+lEg==
X-Google-Smtp-Source: ABdhPJwG9nn/7s/1PvvBnUYYLfgZNtt6cka/dQQtMqdxrWrWI6kD7up/F5zZXHkLMYSfoyhbP4JtMw==
X-Received: by 2002:a63:cf05:: with SMTP id j5mr4302479pgg.384.1614010023095;
        Mon, 22 Feb 2021 08:07:03 -0800 (PST)
Received: from google.com ([2620:15c:f:10:655e:415b:3b95:bd58])
        by smtp.gmail.com with ESMTPSA id k128sm20069508pfd.137.2021.02.22.08.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 08:07:02 -0800 (PST)
Date:   Mon, 22 Feb 2021 08:06:55 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] kvm: x86: Revise guest_fpu xcomp_bv field
Message-ID: <YDPWn70DTA64psQb@google.com>
References: <20210208161659.63020-1-jing2.liu@linux.intel.com>
 <4e4b37d1-e2f8-6757-003c-d19ae8184088@intel.com>
 <YCFzztFESzcnKRqQ@google.com>
 <c33335d3-abbe-04e0-2fa1-47f57ad154ac@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c33335d3-abbe-04e0-2fa1-47f57ad154ac@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021, Liu, Jing2 wrote:
> 
> On 2/9/2021 1:24 AM, Sean Christopherson wrote:
> > On Mon, Feb 08, 2021, Dave Hansen wrote:
> > > On 2/8/21 8:16 AM, Jing Liu wrote:
> > > > -#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
> > > > -
> > > >   static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
> > > >   {
> > > >   	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
> > > > @@ -4494,7 +4492,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
> > > >   	/* Set XSTATE_BV and possibly XCOMP_BV.  */
> > > >   	xsave->header.xfeatures = xstate_bv;
> > > >   	if (boot_cpu_has(X86_FEATURE_XSAVES))
> > > > -		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
> > > > +		xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
> > > > +					 xfeatures_mask_all;
> > This is wrong, xfeatures_mask_all also tracks supervisor states.
> When looking at SDM Vol2 XSAVES instruction Operation part, it says as
> follows,
> 
> RFBM ← (XCR0 OR IA32_XSS) AND EDX:EAX;
> COMPMASK ← RFBM OR 80000000_00000000H;
> ...
> 
> XCOMP_BV field in XSAVE header ← COMPMASK;
> 
> 
> So it seems xcomp_bv also tracks supervisor states?

Yes, sorry, I got distracted by Dave's question and didn't read the changelog
closely.

Now that I have, I find "Since fpstate_init() has initialized xcomp_bv, let's
just use that." confusing.  I think what you intend to say is that we can use
the same _logic_ as fpstate_init_xstate() for calculating xcomp_bv.

That said, it would be helpful for the changelog to explain why it's correct to
use xfeatures_mask_all, e.g. just a short comment stating that the variable holds
all XCR0 and XSS bits enabled by the host kernel.  Justifying a change with
"because other code does it" is sketchy, becuse there's no guarantee that what
something else does is also correct for KVM, or that the existing code itself is
even correct.
