Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003ED469268
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 10:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbhLFJgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 04:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240727AbhLFJgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 04:36:06 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22FFC061746;
        Mon,  6 Dec 2021 01:32:37 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id u1so20983160wru.13;
        Mon, 06 Dec 2021 01:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=McUfv8lB1YIEsBJpslKprT4L4p+qeHjUMFaBs/wJJzs=;
        b=JSxPuFsXD/9WwuS8bDzhC57ZezzYW4TwmTC7eAoBZL65JV1xOhlIb5Qn0v/ufJHOiS
         f3rhah26KgXBJ9zU+dSb3nEMVEzDQnnETj6Umi6aux2wNXncdL3bHWL/f+OXYlAB3Mz0
         0LfVmOwquQMCNWJOEAUas6P0ULnpjVi2OGXDL7N/R8+gTStnPYTNF8ULptQw07VGrItC
         6LFBactmLmFi2rAQE/ibjY+hWNmO1JNIZZGx/lQeIjAEy/HyCAdbLwbvEUVYynynFdGw
         fvvHPJGh/zBs6x+IwGADhUkWmCJ1VNef3xQ7tJCfdtBA49o3Ix5pD7VEK1BnHi3dNb/A
         lPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=McUfv8lB1YIEsBJpslKprT4L4p+qeHjUMFaBs/wJJzs=;
        b=vdTS5omNyQR6y7VWtX81FgC3RRhaLJb7Fsj+lDZ7YBwlmI7aPM1Cc6e9C9LRu3Af86
         SiUOzeH3cUukzaRpRwWaM87VdrCZUIY1Mia5gSJH5rQPF8H60F1XkEo1UdjFpsfxcmLP
         xsi5aPQZCHVN91ugBkygjIivc9H6H0Fwqqs1J0SKKEEls2XfTxgx1LUV9D7oY7HCnp9b
         3MSrDf2BV4IESMvcMOVYtqnYG6jdmZkHAM1m0npzJoRLs5AceExiY1JBNZspgxIbzTEA
         CDMijUOpjQzh9hmIqxI3Tani1Ie4v010FyFbO5IFpNvwSZ27M5Mycn/g76145+30vv6Q
         +8hg==
X-Gm-Message-State: AOAM531AYcZJRQDAQk/PJvUp5YBMQZmhjDzFWzC7OXPr7ykurY6gjz11
        Zh3rGvvmrnE27exxNGfMCE0=
X-Google-Smtp-Source: ABdhPJwf0qJdUr6vFm9bfOXKkqk7Ern+T83YH3b3/nyJN2O9NiEjYReVfrwpcfLEaJEV5VCr2vXbRg==
X-Received: by 2002:adf:f00a:: with SMTP id j10mr42916082wro.339.1638783156582;
        Mon, 06 Dec 2021 01:32:36 -0800 (PST)
Received: from hamza-OptiPlex-7040 ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id g4sm10684904wro.12.2021.12.06.01.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 01:32:36 -0800 (PST)
Date:   Mon, 6 Dec 2021 14:32:31 +0500
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86: fix for missing initialization of return
 status variable
Message-ID: <20211206093231.GB5609@hamza-OptiPlex-7040>
References: <20211205194719.16987-1-amhamza.mgc@gmail.com>
 <87ee6q6r1p.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee6q6r1p.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 10:06:26AM +0100, Vitaly Kuznetsov wrote:
> Ameer Hamza <amhamza.mgc@gmail.com> writes:
> 
> > If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
> > function, it should return with error status.
> >
> > Addresses-Coverity: 1494124 ("Uninitialized scalar variable")
> >
> > Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> > ---
> >  arch/x86/kvm/x86.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e0aa4dd53c7f..55b90c185717 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5001,7 +5001,7 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
> >  				      void __user *argp)
> >  {
> >  	struct kvm_device_attr attr;
> > -	int r;
> > +	int r = -EINVAL;
> >  
> >  	if (copy_from_user(&attr, argp, sizeof(attr)))
> >  		return -EFAULT;
> 
> The reported issue is not real, kvm_vcpu_ioctl_device_attr() is never
> called with anything but [KVM_HAS_DEVICE_ATTR, KVM_GET_DEVICE_ATTR,
> KVM_SET_DEVICE_ATTR] as 'ioctl' and the switch below covers all
> three. Instead of initializing 'r' we could've added a 'default' case to
> the switch, either returning something like EINVAL or just BUG(). Hope
> it'll silence coverity.
Thank you for your kind response. I agree with you and I think its
logical to add default case here. Let me update the patch.

Best Regards,
Hamza

