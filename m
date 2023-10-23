Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FCA7D3F9E
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjJWS4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjJWS4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:56:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1943E110;
        Mon, 23 Oct 2023 11:56:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CF3C433C8;
        Mon, 23 Oct 2023 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698087405;
        bh=RKQ1pbNtIiiIYv1ffY3rTP4iIBSITuSmtnVZMc7D0fA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l94/Yqjx0pS0ri8nG0RUzL16OruKvi8dMjYHWpDbZtbBjoRaONTmJH1o9kqKijb4G
         RGVM0arXQFOZ8fQH8q0aSuTWtbq/HnAgEgjEEBHol0EnvaBTCG9x37m9Oq9HLWhGBa
         kAe75jrQ/W4rMZyRJ6Bt//lkfj18Ou++/4cBHqeWE9DzYkjm+tISl63ya7seszPfyi
         zlFz+hnann6vD2dM3v7vxtvf8BIB1SbGRGEnE/+i6tGNnIB/Il8Qdipu/O+vE8A29d
         kqLJDb0oWum0AuGWjBnnEzV1OwWCV7jTNGNNqwhc7r4v+NVsmPsUQ/jHAByHIQ2GF3
         pdUhuOiRVCkYw==
Date:   Mon, 23 Oct 2023 11:56:43 -0700
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
Subject: Re: [PATCH  6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231023185643.oyd4irw43ztdqtps@treble>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-6-cff54096326d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231020-delay-verw-v1-6-cff54096326d@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 01:45:29PM -0700, Pawan Gupta wrote:
> @@ -31,6 +32,8 @@
>  #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
>  #endif
>  
> +#define GUEST_CLEAR_CPU_BUFFERS		USER_CLEAR_CPU_BUFFERS

I don't think the extra macro buys anything here.

-- 
Josh
