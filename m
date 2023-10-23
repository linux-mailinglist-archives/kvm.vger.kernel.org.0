Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4BF7D3F82
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjJWSst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjJWSss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:48:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3A0FD;
        Mon, 23 Oct 2023 11:48:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9937C433C8;
        Mon, 23 Oct 2023 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698086926;
        bh=cvYxySdgl+SSffKthUQYcmnzcQEhBW8ys75F8wjA2xU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VKZotqrzZy1mTRr7FWkB0d2qDIiiQGAJ9bDjq+VTRDfn+3mivoqDZayOVR4oTcnrN
         EAYAlAlDg/m724zZLBIEUI4oV4lX77WZFtmmX2bgkv8j3NiArP49fyYjmGLhdxOGrW
         YCSm13ZhYrH92UNA8Ws1R6a56mCdSOE9GcnaeSW1BCERRL8e+ONx5oGw3IBLQfwS9e
         vIfG/yJSzcVitPHnM+h7avJB/PLEzShMotgN/aCtSj9cTxE0Hqr//UA4X4AuC9yUYd
         j5NMZmYoJ52CPpQXFzEuCATDZnW72dFUjYgjNYixYXWYZ8qBBppAsbiLIRhNPrpkvh
         aqVl+oe4EcOzw==
Date:   Mon, 23 Oct 2023 11:48:44 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  4/6] x86/bugs: Use ALTERNATIVE() instead of
 mds_user_clear static key
Message-ID: <20231023184844.e2loaxlldm4zbko2@treble>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-4-cff54096326d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231020-delay-verw-v1-4-cff54096326d@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 01:45:15PM -0700, Pawan Gupta wrote:
> @@ -484,11 +484,11 @@ static void __init md_clear_update_mitigation(void)
>  	if (cpu_mitigations_off())
>  		return;
>  
> -	if (!static_key_enabled(&mds_user_clear))
> +	if (!boot_cpu_has(X86_FEATURE_USER_CLEAR_CPU_BUF))
>  		goto out;
>  
>  	/*
> -	 * mds_user_clear is now enabled. Update MDS, TAA and MMIO Stale Data
> +	 * X86_FEATURE_USER_CLEAR_CPU_BUF is now enabled. Update MDS, TAA and MMIO Stale Data
>  	 * mitigation, if necessary.
>  	 */

This comment line got long, the paragraph can be reformatted.

-- 
Josh
