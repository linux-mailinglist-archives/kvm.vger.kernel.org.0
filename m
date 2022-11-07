Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52261F7BD
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 16:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiKGPeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 10:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiKGPeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 10:34:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E55CF7;
        Mon,  7 Nov 2022 07:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9KSRsl8w+glcaYWqHx819lTnxG6pMMVmls0yZ98qoD0=; b=hhptl6/hX7c8Df8jhQC6EfBSRf
        PXW1JXHuRd7Le3XIl+58a0UBLitVa0+5sCR2f1ZFWJrWq45Uwy//C/c+85KONAAZAsURkFiaA9btX
        BF/4fewLdklYvuQNgzcBG1rdodDGD2tJAxWbc28JP57rORc6mPnfm7XomgRd9XPhJMk73eqfTXdxz
        TQQ3ter6XZoERwaDbhNKL6n/cjLbt4TTGKcJEXUi0v60OHQaIoDYobqtD3QoDXxKbzm+WvwIhXrJp
        3/6UD/Pu5WFoyrZBc7LpEpufIuNJV+4IgEoA/eegxjoN6jUm8yX9LntTMf21Zf94FAMYIl9G7zJD1
        IHWiAXbw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1os48E-009Swg-UO; Mon, 07 Nov 2022 15:33:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id ADA30300244;
        Mon,  7 Nov 2022 16:33:43 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 968F52B8046C8; Mon,  7 Nov 2022 16:33:43 +0100 (CET)
Date:   Mon, 7 Nov 2022 16:33:43 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, jmattson@google.com, seanjc@google.com
Subject: Re: [PATCH 0/8] KVM: SVM: fixes for vmentry code
Message-ID: <Y2klVygcNw4UduW2@hirez.programming.kicks-ass.net>
References: <20221107145436.276079-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107145436.276079-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 09:54:28AM -0500, Paolo Bonzini wrote:

> Paolo Bonzini (8):
>   KVM: SVM: extract VMCB accessors to a new file
>   KVM: SVM: replace regs argument of __svm_vcpu_run with vcpu_svm
>   KVM: SVM: adjust register allocation for __svm_vcpu_run
>   KVM: SVM: move guest vmsave/vmload to assembly
>   KVM: SVM: retrieve VMCB from assembly
>   KVM: SVM: restore host save area from assembly
>   KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
>   x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and
>     callers

Nice!

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
