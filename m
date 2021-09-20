Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1437C4118E8
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbhITQMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 12:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbhITQMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 12:12:15 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6894AC061760
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 09:10:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 17so17846451pgp.4
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 09:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RHPENS35TK70dwgRtuqMxqQYFvEywydxESq3g0YeWeY=;
        b=a+D32SSgnrOzLf2jTTB3XXObCufAjGVIs0SqMoiQUV7ljWXr4dz4YtA+HOcz+prtgm
         5s8aG0yU5rTM2wmxo1wlsWi2IjIAIOCC4wS5T7rT7gl1MLstD6X4zH3J3dUDcYaSScIi
         pU9yWEXihPjBpN0472qyPrL1LIwtZEzBsxcu7521ETNdy555l/L+OPfvWyDwtrHwq3KX
         5Yy5s2XogiXel6mGab+Mgl8BANm7UD4s9PtRVksaZ5w5DICYmKnWrTmAAXHR0ky9MUUx
         +O4cfzZADqj+nhpcUB8vMDH2T6+CjBTupY76CQsuFUD2muVBVp6hp+KUgJ2PISB3B/j8
         wrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RHPENS35TK70dwgRtuqMxqQYFvEywydxESq3g0YeWeY=;
        b=qiWB0bWvAQMFxegY538zOfcr+QF/KP3iW4zSvNN4/57OSU6fgsT/N5sSD9PUPjq6y+
         RVt12vtWasqeMdGDrA8hzyPrVIphnWioO4rGMphbcUrKR2h778QMaty2njXOrH54HM2q
         HGLER9J8VbGvS/O7JzW/Kib6QBNF2cW5ev5odNlp7Pa+0GMeIN+77pwL/pF5Ctz7v9Y7
         m3IVjCKB8bXV/6AOV8BaB3OhcyGMoTfYtzLmSOW01UCPIQh6G6U6VM+SXx+o1Aa5rLpL
         mDC0conF9Idp1o2YjuqwKPT67GYS8uB7DQ2O99du9EvvH83b+G54k/VwMgPRqhGQiUZ1
         gaVA==
X-Gm-Message-State: AOAM531aKVsAVH2uNFAUkoS3f7ZbZrv6NWWgXDEKFiI0P884QzXcQyVu
        uH5bx+xh4sNJ+1PdsAY+awddqA==
X-Google-Smtp-Source: ABdhPJx5qH4XRk3aI1atwoaavXlPJ3g+FMogcSusD/ahOJ1VHNmO+V2cxDDuhPlNlaQNjZaeRkUToQ==
X-Received: by 2002:a63:7402:: with SMTP id p2mr24070517pgc.472.1632154247688;
        Mon, 20 Sep 2021 09:10:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm15420414pgq.0.2021.09.20.09.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 09:10:47 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:10:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v2 1/4] KVM: SVM: Get rid of *ghcb_msr_bits() functions
Message-ID: <YUiyg1W1cDxVbgzs@google.com>
References: <20210722115245.16084-1-joro@8bytes.org>
 <20210722115245.16084-2-joro@8bytes.org>
 <YS/sqmgbS6ACRfSD@google.com>
 <YToM5akzNrlqHTJz@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YToM5akzNrlqHTJz@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021, Joerg Roedel wrote:
> On Wed, Sep 01, 2021 at 09:12:10PM +0000, Sean Christopherson wrote:
> > On Thu, Jul 22, 2021, Joerg Roedel wrote:
> > >  	case GHCB_MSR_TERM_REQ: {
> > >  		u64 reason_set, reason_code;
> > >  
> > > -		reason_set = get_ghcb_msr_bits(svm,
> > > -					       GHCB_MSR_TERM_REASON_SET_MASK,
> > > -					       GHCB_MSR_TERM_REASON_SET_POS);
> > > -		reason_code = get_ghcb_msr_bits(svm,
> > > -						GHCB_MSR_TERM_REASON_MASK,
> > > -						GHCB_MSR_TERM_REASON_POS);
> > > +		reason_set  = GHCB_MSR_TERM_REASON_SET(control->ghcb_gpa);
> > > +		reason_code = GHCB_MSR_TERM_REASON(control->ghcb_gpa);
> > > +
> > >  		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
> > >  			reason_set, reason_code);
> > > +
> > >  		fallthrough;
> > 
> > Not related to this patch, but why use fallthrough and more importantly, why is
> > this an -EINVAL return?  Why wouldn't KVM forward the request to userspace instead
> > of returning an opaque -EINVAL?
> 
> I guess it is to signal an error condition up the call-chain to get the
> guest terminated, like requested.

Yes, but it's odd bizarre/unfortunate that KVM doesn't take this opportunity to
forward the termination info to the VMM.  The above pr_info() should not exist.
If that information is relevant then it should be handed to the VMM directly, not
dumped to dmesg.
