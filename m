Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C229F255
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 17:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgJ2Q4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgJ2Q4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 12:56:16 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8E8C0613CF;
        Thu, 29 Oct 2020 09:56:16 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q1so3750857ilt.6;
        Thu, 29 Oct 2020 09:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=46u7k16lmtR7tMf5v+7fbJj/BQNg8vF1V9HFBp6hYFg=;
        b=TO+GpLM6LycPQoMwryo9xUQRLiEvWYgbGjKPlPQ6JQhAIVJlLxzOsJaEhiiNlylpPU
         rGt9Uq2jE226wycKVWSpG3npnQmZoU8s5A0MHGd4XSgMb8BejsiG/VnzNhIPy8QMD2Z2
         F7IuQvFLeFbghxG3CEhpvXe2WzK8pXgSdiSab7Hx7KATccJNuio5nWAfuBEIbjKsp7Jl
         57A4/cWqICjr/T8wosnkqI/KIZt/A6xx/E5Z8Ir2VJXwueycsYLO4vaFWXcEsKYYZcWb
         Jn/3mLxoII+jzekPaOQFJui7oYC1wE6ekbWbnMCmXPVPkacWmJDSEidjIcgzxSpyLhaA
         1ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=46u7k16lmtR7tMf5v+7fbJj/BQNg8vF1V9HFBp6hYFg=;
        b=rmep6T8c4StuS+UMW2VO/6Z5LWgDYf6mX16G43yz8V40tOzV9swL3p/pxaSH53dF1s
         nJlMdj68HN+NDdnhM29CkJ7mHh50WJsy8oazI5FuYUPeFG9aMkG+4T75me0umIZO45H5
         QzP2632wcT4Kw2nD3g2v4LsLIMdyek9pOfac5Y81LYv3WQGHcZCgw11OcOD5MFirthTd
         lJCCe30qBUqLmFKdAlum59LISlNYb1qVi4Qk3TtJjq4H/SwIzfxeCSukJNy3GegN6QWG
         E6XFolqX7xe3TmakOFWxPmf4B9wGWlWah0q3+ke8wA1pbFwYJdusCls8I3nsmsqlg9s5
         5cCQ==
X-Gm-Message-State: AOAM532LLZUUSVJ1LH6sV7g0IEeqV3GlvlvEH+XRxp7T/cIIBPfT8oxe
        TTEPQGRb+q3BVLiyX1nJaZM=
X-Google-Smtp-Source: ABdhPJw9DVYgoIwqL5pROZm1JBXSItTI0Ey8t6jCLCnyLj0KmL714RaHercqOegkYMBCGEVvAtY/7g==
X-Received: by 2002:a05:6e02:2cc:: with SMTP id v12mr4099654ilr.115.1603990575376;
        Thu, 29 Oct 2020 09:56:15 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id r12sm2584639ilm.28.2020.10.29.09.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 09:56:14 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 29 Oct 2020 12:56:11 -0400
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Arnd Bergmann' <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Message-ID: <20201029165611.GA2557691@rani.riverdale.lan>
References: <20201028212417.3715575-1-arnd@kernel.org>
 <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 03:05:31PM +0000, David Laight wrote:
> From: Arnd Bergmann
> > Sent: 28 October 2020 21:21
> > 
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > There are hundreds of warnings in a W=2 build about a local
> > variable shadowing the global 'apic' definition:
> > 
> > arch/x86/kvm/lapic.h:149:65: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
> > 
> > Avoid this by renaming the global 'apic' variable to the more descriptive
> > 'x86_system_apic'. It was originally called 'genapic', but both that
> > and the current 'apic' seem to be a little overly generic for a global
> > variable.
> > 
> > Fixes: c48f14966cc4 ("KVM: inline kvm_apic_present() and kvm_lapic_enabled()")
> > Fixes: c8d46cf06dc2 ("x86: rename 'genapic' to 'apic'")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > v2: rename the global instead of the local variable in the header
> ...
> > diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> > index 284e73661a18..33e2dc78ca11 100644
> > --- a/arch/x86/hyperv/hv_apic.c
> > +++ b/arch/x86/hyperv/hv_apic.c
> > @@ -259,14 +259,14 @@ void __init hv_apic_init(void)
> >  		/*
> >  		 * Set the IPI entry points.
> >  		 */
> > -		orig_apic = *apic;
> > -
> > -		apic->send_IPI = hv_send_ipi;
> > -		apic->send_IPI_mask = hv_send_ipi_mask;
> > -		apic->send_IPI_mask_allbutself = hv_send_ipi_mask_allbutself;
> > -		apic->send_IPI_allbutself = hv_send_ipi_allbutself;
> > -		apic->send_IPI_all = hv_send_ipi_all;
> > -		apic->send_IPI_self = hv_send_ipi_self;
> > +		orig_apic = *x86_system_apic;
> > +
> > +		x86_system_apic->send_IPI = hv_send_ipi;
> > +		x86_system_apic->send_IPI_mask = hv_send_ipi_mask;
> > +		x86_system_apic->send_IPI_mask_allbutself = hv_send_ipi_mask_allbutself;
> > +		x86_system_apic->send_IPI_allbutself = hv_send_ipi_allbutself;
> > +		x86_system_apic->send_IPI_all = hv_send_ipi_all;
> > +		x86_system_apic->send_IPI_self = hv_send_ipi_self;
> >  	}
> > 
> >  	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
> > @@ -285,10 +285,10 @@ void __init hv_apic_init(void)
> >  		 */
> >  		apic_set_eoi_write(hv_apic_eoi_write);
> >  		if (!x2apic_enabled()) {
> > -			apic->read      = hv_apic_read;
> > -			apic->write     = hv_apic_write;
> > -			apic->icr_write = hv_apic_icr_write;
> > -			apic->icr_read  = hv_apic_icr_read;
> > +			x86_system_apic->read      = hv_apic_read;
> > +			x86_system_apic->write     = hv_apic_write;
> > +			x86_system_apic->icr_write = hv_apic_icr_write;
> > +			x86_system_apic->icr_read  = hv_apic_icr_read;
> >  		}
> 
> For those two just add:
> 	struct apic *apic = x86_system_apic;
> before all the assignments.
> Less churn and much better code.
> 

Why would it be better code?
