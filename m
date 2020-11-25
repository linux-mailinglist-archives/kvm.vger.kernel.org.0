Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7927F2C4AA2
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 23:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733162AbgKYWJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 17:09:54 -0500
Received: from mail.skyhub.de ([5.9.137.197]:41256 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733213AbgKYWJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 17:09:53 -0500
Received: from zn.tnic (p200300ec2f0c9b00e207899b66220853.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:9b00:e207:899b:6622:853])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5EDE81EC04DB;
        Wed, 25 Nov 2020 23:09:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1606342192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mW2FlkEjQCKR1BPA5xH59OBazNeYChxwpNjdkolWwXw=;
        b=sLcVA309mm2mi+C2uR2bAJ2azv7NJYkAyuqQc6Wt2fHSweBxlUNGvzfh+x2CLYN4/zTlGT
        1tBzEO0LsHNndTqK9hUuMiSvrCcpLzlNzcUH8wzxI0eSNmarnkJeHLZHIetrL5a4Hc0+iO
        GlB4MFiW4NtEOAyjIw2mn4Meggfey/s=
Date:   Wed, 25 Nov 2020 23:09:47 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com, Zhang Chen <chen.zhang@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH 03/67] x86/cpu: Move get_builtin_firmware() common
 code (from microcode only)
Message-ID: <20201125220947.GA14656@zn.tnic>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
 <46d35ce06d84c55ff02a05610ca3fb6d51ee1a71.1605232743.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46d35ce06d84c55ff02a05610ca3fb6d51ee1a71.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 10:25:48AM -0800, isaku.yamahata@intel.com wrote:
> From: Zhang Chen <chen.zhang@intel.com>
> 
> Move get_builtin_firmware() to common.c so that it can be used to get
> non-ucode firmware, e.g. Intel's SEAM modules, even if MICROCODE=n.

What for?

This is used for microcode built in the kernel - a non-common use case.
Why is your thing built into the kernel and not a normal module object?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
