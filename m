Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7144EDB4
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 21:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbhKLUKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 15:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbhKLUKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 15:10:07 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E9DC061766;
        Fri, 12 Nov 2021 12:07:16 -0800 (PST)
Received: from zn.tnic (p4fed33a9.dip0.t-ipconnect.de [79.237.51.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 54D4A1EC0529;
        Fri, 12 Nov 2021 21:07:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636747634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qZ7MOAyZyrJAApU6BzNgJfJjmgahzhT2ZevVF49HWuI=;
        b=KzejhEYkg/1Rt+3DbkuDxfysNCLXypiVrS/G19UU3kedCRz9v9OKaWWGOIYB9CIMLRuCr+
        7w2hVja2Idq8EWHosziSCsbgInOKXSoYTU5sm21jwLTFkJMh8rxxBRZ2hmrfTcZ7eiWESt
        hTKY0K8+5OhuvMXwayiEseuMYJ8XPN8=
Date:   Fri, 12 Nov 2021 21:04:58 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YY7I6sgqIPubTrtA@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YY7FAW5ti7YMeejj@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrote:
> Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.

What do you suggest instead?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
