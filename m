Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52599356B1E
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 13:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242988AbhDGL0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 07:26:03 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35856 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234598AbhDGL0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 07:26:02 -0400
Received: from zn.tnic (p200300ec2f08fb002f59ec04e5c6bba4.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:2f59:ec04:e5c6:bba4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A9ECD1EC027D;
        Wed,  7 Apr 2021 13:25:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617794751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=X16VaWChjl8MmKdShkWfeaVAAiA4jnoapC94RAmEKRM=;
        b=Roxw176gMH3NIQzB4XAV88p3i5EIDcEM7rUTimjRgUad23TNWW0lw/JmPMknSbakFUQU8B
        WUyUbdAsvWNeVwz94+2UiQdf86lp+c/UWBmUUdjjr+KJ5gIw01VoJAa/X4anH8CqHUs5BZ
        3EppUkgojBUlnyAoDOOWepE/0SM40sQ=
Date:   Wed, 7 Apr 2021 13:25:55 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate
 the memory used for the GHCB
Message-ID: <20210407112555.GB25319@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
 <67f92f5c-780c-a4c6-241a-6771558e81a3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <67f92f5c-780c-a4c6-241a-6771558e81a3@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 02:42:43PM -0500, Tom Lendacky wrote:
> The GHCB spec only defines the "0" reason code set. We could provide Linux
> it's own reason code set with some more specific reason codes for
> failures, if that is needed.

Why Linux only?

Don't we want to have a generalized set of error codes which say what
has happened so that people can debug?

Let's take the above case Brijesh explains: guest tries a page state
change, HV cannot manage for whatever reason and guest terminates with a
"general request".

Wouldn't you want to at least have a *hint* as to why the guest
terminated instead of just "guest terminated"?

I.e., none of those:

https://duckduckgo.com/?q=dumb+error+messages&iax=images&ia=images

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
