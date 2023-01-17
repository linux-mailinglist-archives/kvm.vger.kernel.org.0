Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471CE66DC86
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 12:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbjAQLea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 06:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236507AbjAQLeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 06:34:04 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CD53864B;
        Tue, 17 Jan 2023 03:33:30 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D4B9D1EC052A;
        Tue, 17 Jan 2023 12:33:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673955208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6Itw1OHFz0br39PARy1fRPJ5MAUgeBmrd/8uIbIJqow=;
        b=RTiB0ts8PHjDtfhbv05gXpopg0WvHnZ1wBaQe8q/Yy5zDTlUHeM6iwVkd+LLo/drXpwr62
        9j5xWfh6mN9X/OB5oyx+3nCV7S6aaRCCgcH5st2q/5DHps7xKqXjeTHADI07HTAHEr4P6B
        GyVLY49jfo/H7BZ/bovHmarfqAxz+14=
Date:   Tue, 17 Jan 2023 12:33:24 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/7] x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE
 always serializing feature
Message-ID: <Y8aHhOfqnLUuZnmH@zn.tnic>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
 <20230116230159.1511393-4-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230116230159.1511393-4-kim.phillips@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 05:01:55PM -0600, Kim Phillips wrote:
> The LFENCE_RDTSC / LFENCE always serializing feature was a scattered bit
> and open-coded for KVM in __do_cpuid_func().  Add it to its newly added
> CPUID leaf 0x80000021 EAX proper, and propagate it in kvm_set_cpu_caps()
> instead.  Drop the bit description comments now it's more self-describing.
> 
> Also, in amd_init(), don't bother setting DE_CFG[1] any more if we already

For the future, please use passive voice in your commit message: no "we" or "I",
etc, and describe your changes in imperative mood. Personal pronouns are
ambiguous in text, especially with so many parties/companies/etc developing the
kernel so let's avoid them please.

I'll fix it up now.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
