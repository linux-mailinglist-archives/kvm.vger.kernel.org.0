Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758653610B0
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhDORDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 13:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbhDORDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 13:03:44 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53488C061574;
        Thu, 15 Apr 2021 10:03:21 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ace002a6aea191a6cda8f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:ce00:2a6a:ea19:1a6c:da8f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CF4521EC0518;
        Thu, 15 Apr 2021 19:03:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618506199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=85rANTp4s3hfSEAzqIke+mB4040PR0V7EE7so0qvb5s=;
        b=PeHE1Cw1jDqrpOm6BurHBGaSQPaWKl7OYwZwT1K0n3r56Bio4a2l+4coVRyAcWCRb0Mrs2
        m8MZN/xAbjUbGVU8ctTPItmgLhLpHE8TY7k3AqPw0nuasVMret3U3H0XJiHCXX+m6Aq6Rx
        dhsDFY7zXCzyGrczCPq5ZFfHEF7J2kU=
Date:   Thu, 15 Apr 2021 19:03:22 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 02/30] x86/sev-snp: add RMP entry lookup helpers
Message-ID: <20210415170322.GE6318@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324170436.31843-3-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 12:04:08PM -0500, Brijesh Singh wrote:
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c

Also, why is all this SNP stuff landing in this file instead of in sev.c
or so which is AMD-specific?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
