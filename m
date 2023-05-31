Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8063A718DFA
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjEaWCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjEaWCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:02:32 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2F511D
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:02:29 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2566a1a11d0so8534a91.3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685570549; x=1688162549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KixHZBMA+6FI7Pfjf38bXK5H1vgh9ysGY6HKye84LxA=;
        b=cKjCxybKIBlY6BvZhjgsMAJYJjgYSoSIDbguxswRODUBqYxXlbMS6zTlr3jKf2WWLO
         a0iV7g8hPFwM/0DjIwrgyToe1Oy1xRVNqCNVKG86o9VWxLj6q/eTUzbwPINkD1J50LfQ
         EUKiJxrXUqr5ZTX67Joo1YZleIP0mOgwAJ92X16sB0054X+V+llNUgvrezWbmKSmwBXL
         z9FPpSEOtEuHpw5hhTjXww4kLrz/fYX7BCkJHueqgA2jlIaAer2rU/CYkg9HkAe3rUE3
         Woqu7PjMGTA0e16oFwQtPeNmzYnY2QqY1SE9zzNOiFPaG5F0I3XQaEZWDcmwFPRw8ar4
         BoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685570549; x=1688162549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KixHZBMA+6FI7Pfjf38bXK5H1vgh9ysGY6HKye84LxA=;
        b=MeE5NujK3va2jSRWsb5Xa/Ar6qVFo+v6i8DNEFxFkmOhwcW6nn5muPUmUAMgdjAa8V
         UfhaUbb3TcU6HgRMAQ3HcaUIARPuXErEkN68crPXCMaOJdkhclWjxHkuXOWFmnUWdIlh
         fHnfX6i9SHRE+pP6emd91XAbn5gg4bqRfYc0T3R6EDcgZC6EPJFjIOowq/EoOMdIfSzn
         bAo7bJ5bQPqzFOjmHRfh9jGVKCrmrhoBwHZmlCzAPlbGUVFs8OuxTj3t0gQlUyCBGx7K
         lNP75tUeOe2OFKcjBe+RYv+AY3RCmSI3jJOy0Cwpf8ElZj/yyhqvasvZENZY5sroZ+ez
         OPmw==
X-Gm-Message-State: AC+VfDyqPnH/A/ve9xYmDz0SChLFNmHKO+R39bMqWyFgKrRnBOUTePAg
        OrTYv4l9nf9Vx7odV4cqmEreEYXuP/w=
X-Google-Smtp-Source: ACHHUZ6cPlRqjV7aURtrMNwlQNXtnj/y5NeekyPOAoESHt3+Na81kZydArmpyXvAJRO2BfdmGDl6AlroJsM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:943:b0:253:38f0:eff0 with SMTP id
 dw3-20020a17090b094300b0025338f0eff0mr1461277pjb.0.1685570548974; Wed, 31 May
 2023 15:02:28 -0700 (PDT)
Date:   Wed, 31 May 2023 15:02:27 -0700
In-Reply-To: <20230531212907.GHZHe8I/DZUyzIXI2Q@fat_crate.local>
Mime-Version: 1.0
References: <20230530200152.18961-1-jon@nutanix.com> <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com> <ZHd2P6D142rCByrm@google.com>
 <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com> <ZHermsSGQBcDD07R@google.com>
 <20230531212907.GHZHe8I/DZUyzIXI2Q@fat_crate.local>
Message-ID: <ZHfD88N3PhqReu2z@google.com>
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jon Kohler <jon@nutanix.com>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>,
        "neelnatu@google.com" <neelnatu@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023, Borislav Petkov wrote:
> On Wed, May 31, 2023 at 08:18:34PM +0000, Sean Christopherson wrote:
> > Assert that the to-be-checked bit passed to cpu_feature_enabled() is a
> > compile-time constant instead of applying the DISABLED_MASK_BIT_SET()
> > logic if and only if the bit is a constant.  Conditioning the check on
> > the bit being constant instead of requiring the bit to be constant could
> > result in compiler specific kernel behavior, e.g. running on hardware that
> > supports a disabled feature would return %false if the compiler resolved
> > the bit to a constant, but %true if not.
> 
> Uff, more mirroring CPUID inconsistencies.
> 
> So *actually*, we should clear all those build-time disabled bits from
> x86_capability so that this doesn't happen.

Heh, I almost suggested that, but there is a non-zero amount of code that wants
to ignore the disabled bits and query the "raw" CPUID information.  In quotes
because the kernel still massages x86_capability.  Changing that behavior will
require auditing a lot of code, because in most cases any breakage will be mostly
silent, e.g. loss of features/performance and not explosions.

E.g. KVM emulates UMIP when it's not supported in hardware, and so advertises UMIP
support irrespective of hardware/host support.  But emulating UMIP is imperfect
and suboptimal (requires intercepting L*DT instructions), so KVM intercepts L*DT
instructions iff UMIP is not supported in hardware, as detected by
boot_cpu_has(X86_FEATURE_UMIP).

The comment for cpu_feature_enabled() even calls out this type of use case:

  Use the cpu_has() family if you want true runtime testing of CPU features, like
  in hypervisor code where you are supporting a possible guest feature where host
  support for it is not relevant.

That said, the behavior of cpu_has() is wildly inconsistent, e.g. LA57 is
indirectly cleared in x86_capability if it's a disabled bit because of this code
in early_identify_cpu().

	if (!pgtable_l5_enabled())
		setup_clear_cpu_cap(X86_FEATURE_LA57);

KVM works around that by manually doing CPUID to query hardware directly:

	/* Set LA57 based on hardware capability. */
	if (cpuid_ecx(7) & F(LA57))
		kvm_cpu_cap_set(X86_FEATURE_LA57);

So yeah, I 100% agree the current state is messy and would love to have
cpu_feature_enabled() be a pure optimization with respect to boot_cpu_has(), but
it's not as trivial at it looks.
