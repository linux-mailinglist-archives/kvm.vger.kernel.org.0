Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA4346A2F5
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 18:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242707AbhLFRbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 12:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242650AbhLFRbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 12:31:39 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EB4C0698C0;
        Mon,  6 Dec 2021 09:27:53 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q3so23978850wru.5;
        Mon, 06 Dec 2021 09:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yjr0+LLOtRYKZIcmyJPSLxbVouLvWeiwMzFfrSoScsc=;
        b=mPxz2dugNRDvMULWeyAbLHMImMUBsVjTvSexDQ/t2hs9rH6TyliuHVPNBtqJJQwnkz
         16Uslu/T396k4INAJf3vRLO/6X7glSDv4oOtjSgUoHH9UZYMrnvXwiO74MhQn8C4l4Tn
         8qJYQDUzCPLowvvwHxFhBY2RnTAE0Shiyy3+DWUwjd4FIDqp+9cFZ/aEQ5Cru2tKZ3la
         ixo3yZBIA069Z2Rp0xo3nwTu3CAllfRKWXVODwTgsvx0qtkTc9pqzcczPFT9Nma15VH5
         tHXVqsZtG1gkTLqqCdukQhOUj8B1znJxPH1Sd2knkGmEtytStanURmvPflXNtgOJN2kc
         7E0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yjr0+LLOtRYKZIcmyJPSLxbVouLvWeiwMzFfrSoScsc=;
        b=OLi3TQKOlxG//QvBFqGJBLLLZ8OWYzU7lIm3uv6hwZGeWJq4VS7d/inPzEbCjEnFnh
         D11c5wtgT1YMRvb3ESglr+LVJW4MoOqHq55XVGuhShlw+RlPqa3hVDdlV9sYL/7+7vdF
         jDoJqIJhWlYG/ZL2UPRR5MYyMRr8S6lRjhJkJhrusBn57BU4v8/pdeba+g4uOHnkk/mD
         jsCDdG9i//kfBTMVYr/G8GxcsL71uJeF/dD+H2D2C5b7OXJE4NWfet49mVjPL07KI6tT
         IAZbQoQLz7xICJpIZBtfJxno6Gim6ebsPQVGr3dUGm1KsYLyYXuSzNBd5+uKCWinzDoC
         sFJw==
X-Gm-Message-State: AOAM530YP18K0sNyu4C0IW6jJygd+LjVfyvQCBNJeJ4nknFrT6nVn7MY
        RWsxp4zhxGkorfPR5X1Ye+g=
X-Google-Smtp-Source: ABdhPJxu9Q2wvB/5ZUFTAzRhvP09Nf7rnGzVLcifYypW8VvFBL4Cmjxp7zqxKUWVIwssO7e94Rn4GA==
X-Received: by 2002:a5d:6d86:: with SMTP id l6mr44159550wrs.304.1638811672539;
        Mon, 06 Dec 2021 09:27:52 -0800 (PST)
Received: from hamza-OptiPlex-7040 ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id u13sm4153wmq.14.2021.12.06.09.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:27:51 -0800 (PST)
Date:   Mon, 6 Dec 2021 22:27:46 +0500
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3] KVM: x86: fix for missing initialization of return
 status variable
Message-ID: <20211206172746.GA141396@hamza-OptiPlex-7040>
References: <20211206160813.GA37599@hamza-OptiPlex-7040>
 <20211206164503.135917-1-amhamza.mgc@gmail.com>
 <Ya5CCU0zf+MzMwcX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya5CCU0zf+MzMwcX@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 05:02:01PM +0000, Sean Christopherson wrote:
> On Mon, Dec 06, 2021, Ameer Hamza wrote:
> > If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
> > ioctl, we should trigger KVM_BUG_ON() and return with EIO to silent
> > coverity warning.
> > 
> > Addresses-Coverity: 1494124 ("Uninitialized scalar variable")
> > Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> > ---
> > Changes in v3:
> > Added KVM_BUG_ON() as default case and returned -EIO
> > ---
> >  arch/x86/kvm/x86.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e0aa4dd53c7f..b37068f847ff 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5019,6 +5019,9 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
> >  	case KVM_SET_DEVICE_ATTR:
> >  		r = kvm_arch_tsc_set_attr(vcpu, &attr);
> >  		break;
> > +	default:
> > +		KVM_BUG_ON(1, vcpu->kvm);
> > +		r = -EIO;
> 
> At least have a
> 
> 		break;
> 
> if we're going to be pedantic about things.
I just started as a contributer in this community and trying
to fix issues found by static analyzer tools. If you think that's
not necessary, its totally fine :)

> >  	}
> >  
> >  	return r;
> > -- 
> > 2.25.1
> > 
