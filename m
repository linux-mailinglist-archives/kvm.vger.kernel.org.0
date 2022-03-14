Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EC34D7E74
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 10:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbiCNJ3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 05:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbiCNJ3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 05:29:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA1E17A8A
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 02:28:08 -0700 (PDT)
Date:   Mon, 14 Mar 2022 10:28:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647250086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGKKEjg04U137bK82J2TU5HjvwZgBtaxgm9x679m0Uo=;
        b=O9JtiqZCzl/N/+hl+Yf/eTF9H1AjpeMJgO6zx8MCaPLaUMWt7VSGalk2/9tqEAuGo7UZwB
        rqEdsW/A2+jCy7tbxTU6TvYdH+O0ZmrLkLCyWGIN9W4DlcumvMF5l8DbI6IT2BBfmdPyTP
        j8+j6SGoPLdGg+IFX7KYJZMjDWsAqJ9FV3Tiss2bnxG9E3xeZt84fXLRDfQn8yraKzQj/V
        NI8AucSPSaicQWjKM2WptJHZrqkWW/h/7SuUzRyLlBY3m1cdHHVIpMDWd3Hxb4caEz3Ko3
        +JzE1EhoyUkd+eEtz9VroOtRU2fJ9wSDPL2/gjbqHHGTOE5nToDutB+yV28+9g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647250086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGKKEjg04U137bK82J2TU5HjvwZgBtaxgm9x679m0Uo=;
        b=1qa1Bogx/Ff24ovwNcfy8k0wIC2nNKoO9h/hrSHDJttxkl1FX09rp7d6vEcfAEWHAkFwmk
        C9bXtwwcx31LdrBA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH] x86: kvm Require const tsc for RT
Message-ID: <Yi8KpReL9UfO0dEb@linutronix.de>
References: <Yh5eJSG19S2sjZfy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yh5eJSG19S2sjZfy@linutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-03-01 18:55:51 [+0100], To kvm@vger.kernel.org wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Sun, 6 Nov 2011 12:26:18 +0100
> 
> Non constant TSC is a nightmare on bare metal already, but with
> virtualization it becomes a complete disaster because the workarounds
> are horrible latency wise. That's also a preliminary for running RT in
> a guest on top of a RT host.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

ping.

> ---
>  arch/x86/kvm/x86.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 82a9dcd8c67fe..54d2090d04e7a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8826,6 +8826,12 @@ int kvm_arch_init(void *opaque)
>  		goto out;
>  	}
>  
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +		pr_err("RT requires X86_FEATURE_CONSTANT_TSC\n");
> +		r = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	r = -ENOMEM;
>  
>  	x86_emulator_cache = kvm_alloc_emulator_cache();
> -- 
> 2.35.1
> 
