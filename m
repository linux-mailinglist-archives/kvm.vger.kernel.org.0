Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F9E6A237B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 22:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjBXVIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 16:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjBXVIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 16:08:42 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9371BC6;
        Fri, 24 Feb 2023 13:08:38 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 483E41EC0606;
        Fri, 24 Feb 2023 22:08:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677272917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=gdrEC5cn/BkwP2ABobvH4JCzTJBWXd+39QfT+01x2qA=;
        b=dGu/rBZRPqehORnH26hXgUvSUbrSuoih0U4y48bK8/SyfOt2EyBg+MLf0419hADn95racV
        dTwQmlLCtaeb2Coln0c7d05u7kXbez9Xw62sldoBpI6I63ADmDcj+pnl1ICBsu4Y5LE14r
        Kl4z2gz0FDWHKWSrLk8EBoNG1036cxg=
Date:   Fri, 24 Feb 2023 22:08:32 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
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
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <Y/knUC0s+rg6ef2r@zn.tnic>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230224185257.o3mcmloei5zqu7wa@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 10:52:57AM -0800, Josh Poimboeuf wrote:
> Doesn't this only enable it on the boot CPU?

Whoops, you might be right.

Lemme fix it.

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
