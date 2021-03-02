Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BDA32B5BB
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449276AbhCCHTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839813AbhCBToq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 14:44:46 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F89EC06178A;
        Tue,  2 Mar 2021 11:44:04 -0800 (PST)
Received: from zn.tnic (p200300ec2f068c00543f0f7c5f9166fd.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:8c00:543f:f7c:5f91:66fd])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ECE371EC0105;
        Tue,  2 Mar 2021 20:44:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614714243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IGZC7Oux/tWM6r4nS+D/ePQALQcIumclBu+U+Em2dKA=;
        b=Wcd4qA06f5nAkiingAG8IrYXipICsS/XvfYqmVrZkPDFn2sEV5O7ST8t5NsPiSjCaDUjMc
        YY+FuX/ZuNsWOfLopeDESjsUnV7D+InJiNlBicdfHH4UXsqHmgYCd43tNE8QDZQDOAYKmA
        eHa+Dufd7Ne+31WcIrKP6tHo40RI2Yk=
Date:   Tue, 2 Mar 2021 20:43:53 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 6/7] x86/boot/compressed/64: Check SEV encryption in
 32-bit boot-path
Message-ID: <20210302194353.GH15469@zn.tnic>
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210102135.30667-7-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210210102135.30667-7-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 11:21:34AM +0100, Joerg Roedel wrote:
> +	/*
> +	 * Store the sme_me_mask as an indicator that SEV is active. It will be
> +	 * set again in startup_64().

So why bother? Or does something needs it before that?

...

> +SYM_FUNC_START(sev_startup32_cbit_check)

s/sev_startup32_cbit_check/startup32_check_sev_cbit/

I guess.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
