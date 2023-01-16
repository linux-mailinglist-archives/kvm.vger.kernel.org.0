Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F7266D0E6
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 22:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbjAPVW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 16:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbjAPVWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 16:22:53 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFBE23645;
        Mon, 16 Jan 2023 13:22:52 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D995F1EC0441;
        Mon, 16 Jan 2023 22:22:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673904170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SvTq3QUKO/fSH18fq9ZAd93e/ucCBpnJFHBpsteItuU=;
        b=PUd8SkGifBQ8ZKXzqdEtcmE5Uf9eNwLtrb8cAkH8OzQEERiCXcf43p8STIqE+0ExQkgAyI
        GHkul9tFi6j0VazAKkiOk3IbvSYp2nJDZ5qa95AdXfZYtW9hiJyRh+u6EQb6FMxja827Ha
        wGHJMOX4LukUqlfAcd+Buw2KsbBnKnI=
Date:   Mon, 16 Jan 2023 22:22:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
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
Subject: Re: [PATCH v6 3/7] x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE
 always serializing feature
Message-ID: <Y8XAKvXSHuKF/uma@zn.tnic>
References: <20230110224643.452273-1-kim.phillips@amd.com>
 <20230110224643.452273-5-kim.phillips@amd.com>
 <Y8WTnx/ukvdAEeoe@zn.tnic>
 <cc344449-5f0b-51c7-bae8-6deb9be83702@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cc344449-5f0b-51c7-bae8-6deb9be83702@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 01:15:29PM -0800, Dave Hansen wrote:
> I don't think so.
> 
> I'd be surprised if we don't have a _few_ other cases like this around,
> but nothing is coming to mind.  Either way, it doesn't seem problematic.

Yeah, probably. The cases I remember are the other way around - we map
vendor-specific flags to synthetic ones...

Anyway, thanks for checking!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
