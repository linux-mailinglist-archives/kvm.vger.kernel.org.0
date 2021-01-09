Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9622EFC3F
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbhAIAft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbhAIAfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:35:48 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406FC061573;
        Fri,  8 Jan 2021 16:35:08 -0800 (PST)
Received: from zn.tnic (p200300ec2f0a31002d28d593016b8c5a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:3100:2d28:d593:16b:8c5a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2A8251EC03C5;
        Sat,  9 Jan 2021 01:35:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610152504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9sIdhPYpEiND4wwlu2cZgkCZXl3hCMqf+nLV7kUSRBQ=;
        b=fPUlsfpQavNy80WuCzP5TkoW3Ewe+1FYyGs8v3T/zKXHtbJ5HYr8wQ0YJj08PflgevPdTO
        NMBYOxUWrIIk9BUn9hDLCLvKMUDvYVv7TNRncSZPvDANNucdFfQiUFNUzfI6EMbzn7oM8P
        aKjIgylkKe/1qJ0UkYFshYQSWdR8vNk=
Date:   Sat, 9 Jan 2021 01:35:02 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210109003502.GK4042@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/jxCOLG+HUO4QlZ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 08, 2021 at 03:55:52PM -0800, Sean Christopherson wrote:
> To be fair, this is the third time we've got conflicting, direct feedback on
> this exact issue.  I do agree that it doesn't make sense to burn a whole word
> for just two features, I guess I just feel like whining.
> 
> [*] https://lore.kernel.org/kvm/20180828102140.GA31102@nazgul.tnic/
> [*] https://lore.kernel.org/linux-sgx/20190924162520.GJ19317@zn.tnic/

Well, sorry that I confused you guys but in hindsight we probably should
have stopped you right then and there from imposing kvm requirements on
the machinery behind *_cpu_has() and kvm should have been a regular user
of those interfaces like the rest of the kernel code - nothing more.

And if you'd like to do your own X86_FEATURE_* querying but then extend
it with its own functionality, then that should have been decoupled.

And I will look at your patch later when brain is actually awake but
I strongly feel that in order to avoid such situations in the future,
*_cpu_has() internal functionality should be separate from kvm's
respective CPUID leafs representation. For obvious reasons.

And if there should be some partial sharing - if that makes sense at all
- then that should be first agreed upon.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
