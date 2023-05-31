Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032E5718EC6
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjEaWs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjEaWsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:48:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D704A124;
        Wed, 31 May 2023 15:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D6063950;
        Wed, 31 May 2023 22:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EEAC433EF;
        Wed, 31 May 2023 22:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685573325;
        bh=lOe8yoG1y43dXiHsu5UEqoPiBRsH7i4oe9x4GdaWzmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g7zP9/Ry0v7kXmOd7LSxIG+ciXvJb0op8gwKeV5l+eNvIN+Mq7fwL4EyMJq3cHTs+
         EopAO5gAxqixNSQSYrBKjCGU6J4hebLLo8CTr+dkWDraJfzoml/V1lPCL+XxIdt0P3
         8yCfmsxXhTaRilNtIaLIRe++QVFIb2Uks15DHcY67EOBs6BLbQhfquYniIWyWVHrTw
         jA4uCVcpfWzG9kWHLQY35GpwXu4PvxRwG+BPn2+2PIHerfJ8+AEIlR8SX4fKMN2OpF
         MygnmhYa2Rr3ZRnX+kMGdVsOVDetI1p1l1AusXsCIaEWHT5whvrVKJk0ABWj9saNEx
         lsQ9S2qAZ+2Cg==
Date:   Wed, 31 May 2023 15:48:43 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] KVM: VMX: restore vmx_vmexit alignment
Message-ID: <20230531224843.frnqfqyhvqcx27cs@treble>
References: <20230531155821.80590-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230531155821.80590-1-jon@nutanix.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 11:58:21AM -0400, Jon Kohler wrote:
> Commit 8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()") changed
> vmx_vmexit from SYM_FUNC_START to SYM_INNER_LABEL, accidentally
> removing 16 byte alignment as SYM_FUNC_START uses SYM_A_ALIGN and
> SYM_INNER_LABEL does not. Josh mentioned [1] this was unintentional.
> 
> Fix by changing to SYM_INNER_LABEL_ALIGN instead.
> 
> [1] https://lore.kernel.org/lkml/Y3adkSe%2FJ70PqUyt@p183
> 
> Fixes: 8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()")
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh
