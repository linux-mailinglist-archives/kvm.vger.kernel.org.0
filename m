Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB510357DE9
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 10:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhDHIRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 04:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhDHIRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 04:17:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDBFC061760;
        Thu,  8 Apr 2021 01:17:41 -0700 (PDT)
Received: from zn.tnic (p200300ec2f095000d1c5cef8b4104033.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5000:d1c5:cef8:b410:4033])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F17F71EC027D;
        Thu,  8 Apr 2021 10:17:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617869860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hFlLhXCwCKYT4yY3v85LDEYvANk/g2ETWMLwyVoq7x8=;
        b=L7EMzURMHopNG1JZ4WjphuwjMHQdEiMYD1AflIaSEWIieJC564aYKAzgqqPMy3r67ZzPe5
        Uz/GHbkNazFEitPiP0BZEBb/tNiTvKsZK4O+STaH7NkDscBi/KlDXVZlsg5ah5YJhNg2f7
        Q094Ghb+7vEdoW0zKDGeTToe1PFdeYc=
Date:   Thu, 8 Apr 2021 10:17:40 +0200
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
Subject: Re: [RFC Part1 PATCH 07/13] x86/compressed: register GHCB memory
 when SNP is active
Message-ID: <20210408081740.GA10192@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-8-brijesh.singh@amd.com>
 <20210407115959.GC25319@zn.tnic>
 <2453bacb-dce3-a9c2-f506-7dae7796ab7e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2453bacb-dce3-a9c2-f506-7dae7796ab7e@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 12:34:59PM -0500, Brijesh Singh wrote:
> The feature is part of the GHCB version 2 and is enforced by the
> hypervisor. I guess it can be extended for the ES. Since this feature
> was not available in GHCB version 1 (base ES) so it should be presented
> as an optional for the ES ?

Yeah, it probably is not worth the effort. If an attacker controls the
guest kernel, then it can re-register a new GHCB so it doesn't really
matter.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
