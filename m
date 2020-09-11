Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA58F266A16
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 23:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgIKVeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 17:34:05 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58206 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgIKVeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 17:34:04 -0400
Received: from zn.tnic (p200300ec2f162200a8246000ea14139e.dip0.t-ipconnect.de [IPv6:2003:ec:2f16:2200:a824:6000:ea14:139e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3CCD71EC052C;
        Fri, 11 Sep 2020 23:34:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1599860042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zcRbcG6lU7+mJahNszBtN5sPZaojMVrjdXUyyVeewfY=;
        b=OiL5ixRoVfLlQ6tdZO7jYJxEvtd0b+iA34JYb3cQncDCmToqW2YtfHMFP7FQ8bzWJY8Cgh
        g+gtpmIhgB7n6IzZIkqkqMXI7gcXG/Q+pRqqmgdx7waA9Ij+qZUIViHBxuy2K/EoSOsn7D
        DmcZNogZpGQc1wlK5oteJmPqFQCBDCc=
Date:   Fri, 11 Sep 2020 23:33:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4 v3] x86: AMD: Add hardware-enforced cache coherency
 as a CPUID feature
Message-ID: <20200911213356.GC4110@zn.tnic>
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
 <20200911192601.9591-3-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200911192601.9591-3-krish.sadhukhan@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Tom.

On Fri, Sep 11, 2020 at 07:25:59PM +0000, Krish Sadhukhan wrote:
> +#define X86_FEATURE_HW_CACHE_COHERENCY (11*32+ 7) /* AMD hardware-enforced cache coherency */

so before you guys paint the bikeshed all kinds of colors :), Tom (CCed)
is digging out the official name. (If it is even uglier, we might keep
on bikeshedding...).

Once you have that, add the "" after the comment - like
X86_FEATURE_FENCE_SWAPGS_USER, for example, so that it doesn't show in
/proc/cpuinfo as luserspace doesn't care about hw coherency between enc
memory.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
