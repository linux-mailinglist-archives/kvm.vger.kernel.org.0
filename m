Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB596352CBD
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhDBPo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:44:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53360 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234968AbhDBPoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:44:55 -0400
Received: from zn.tnic (p200300ec2f0a2000fb5cecc74a705e14.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2000:fb5c:ecc7:4a70:5e14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 478001EC036C;
        Fri,  2 Apr 2021 17:44:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617378293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WsVWEB1QpwjlANMFlFl82TjGWWsWDseoOUY4h9xc4os=;
        b=SjxJMJZpcarL8XoqZ79XuREBk9vIVX6fO2jub/+DHurpUzbsq0q+HFH2udI9hVKNq+YmAU
        WuTLesw4QG7Y8dnh73rKLMJq1Hm6HRUhL23OQsZhm0paWtDg76CF1BmY4nUffprjktC6we
        qigGunoc1YVG8nyfQ7k6n+8l4Dh0czQ=
Date:   Fri, 2 Apr 2021 17:44:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 04/13] x86/sev-snp: define page state change
 VMGEXIT structure
Message-ID: <20210402154458.GI28499@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-5-brijesh.singh@amd.com>
 <20210401103208.GA28954@zn.tnic>
 <894e7732-8ed8-cc17-1cd1-769b7d2745d1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <894e7732-8ed8-cc17-1cd1-769b7d2745d1@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021 at 09:11:34AM -0500, Brijesh Singh wrote:
> I guess I was trying to keep it in consistent with sev-es.h macro
> definitions in which the command is used before the fields. In next
> version, I will use the msb to lsb ordering.

Yes pls. And then you could fix the sev-es.h macro too, in a prepatch
maybe or in the same one, to do the same so that when reading the GHCB
doc, it maps directly to the macros.

> IIRC, the spec structure has uint<width>_t, so I used it as-is. No
> strong reason for using it. I will switch to u64 type in the next version.

Yeah, the uint* things are in the C spec but we don't need this
definition outside the kernel, right?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
