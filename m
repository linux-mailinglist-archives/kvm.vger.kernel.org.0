Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03F06734C8
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 10:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjASJvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 04:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjASJvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 04:51:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4710D6C547;
        Thu, 19 Jan 2023 01:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qo2nFY/QtUWYOj3LnHvvQl8GalJSX+nAh9zmpPfJrCY=; b=hTafTCOqaVD2KVdpbe1q+4sYWd
        ptKIzLgIOR74jA2zZXxnUUUA34HMH/u1EN5t1OzmPQvUYN+lo9xU3BLOOiKhA0JAzQLPMNfUFkC9y
        B/Z72/2KCj/hIpkRgaL2LtkOb60g7BL0cgBwrLYiSWbr0nJCtvdzrqeQY/9vUbiSd9AfulrpkppW7
        Eim6cVIY7VU8kh7acxj0e7JrplwA3Qv5VSGyyN0CrunPizCmflWCt3+SJUa3njTUMwbaW4RzeAtzt
        owvAkNgcdY9yliZkmSwTLcxmcaztd/UZZ++t8V1Ez0C0b/0nricsmYCbW12A3fUDrFYv3FZzO9dOj
        zQ2V/Tdg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIRZE-000qqx-Re; Thu, 19 Jan 2023 09:50:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CD51D30012F;
        Thu, 19 Jan 2023 10:50:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BD9D720758E52; Thu, 19 Jan 2023 10:50:44 +0100 (CET)
Date:   Thu, 19 Jan 2023 10:50:44 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Message-ID: <Y8kSdKnlgAAvB1tK@hirez.programming.kicks-ass.net>
References: <20221213060912.654668-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 06:09:05AM +0000, Sean Christopherson wrote:

> Sean Christopherson (7):
>   KVM: x86: Make vmx_get_exit_qual() and vmx_get_intr_info()
>     noinstr-friendly
>   KVM: VMX: Allow VM-Fail path of VMREAD helper to be instrumented
>   KVM: VMX: Always inline eVMCS read/write helpers
>   KVM: VMX: Always inline to_vmx() and to_kvm_vmx()
>   x86/entry: KVM: Use dedicated VMX NMI entry for 32-bit kernels too
>   KVM: VMX: Provide separate subroutines for invoking NMI vs. IRQ
>     handlers
>   KVM: VMX: Handle NMI VM-Exits in noinstr region

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
