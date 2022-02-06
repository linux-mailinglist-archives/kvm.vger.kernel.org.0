Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8614AAFDF
	for <lists+kvm@lfdr.de>; Sun,  6 Feb 2022 15:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbiBFOKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Feb 2022 09:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbiBFOKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Feb 2022 09:10:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15D5C06173B;
        Sun,  6 Feb 2022 06:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mI67syAIUWTfJyg9FU9W87lE6c5yK7WTkN3mqQzAN9Y=; b=O4BQMPvZRrJIH4kASoGMJquIrP
        riojtP8gxpL8XWi0yxHkhbLGFMf2w5ZCosCclSbpg9Bln941ZmsmqpSY7t2chYHIl/yFaWIGG8Ljc
        iXbQTjJN4TROZ+tV7p1LJaS+rLhD750l774ftlz/XsUFZMpHAuHEAsuaEntcqWQIPupmFUNVaAfuv
        hfWxcma3LaVO9kY0XLYi32qaqXKw4aAsikUE1mQXM2s4QC2A4E4Y4gSkRDamYhAS/tlWNHTNt+bd6
        wD5Mx2LSCmDVX96LfypR4/1yDfM5B0wNQ1n3oolOnP/qjvV2X30sIbQUghjqxEsstLUHoKu94NYt8
        5L3b8ChA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nGiEw-00EKdv-SD; Sun, 06 Feb 2022 14:10:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2EEF8300470;
        Sun,  6 Feb 2022 15:10:06 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 154F02CA510BA; Sun,  6 Feb 2022 15:10:06 +0100 (CET)
Date:   Sun, 6 Feb 2022 15:10:06 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH 5/5] KVM: x86: allow defining return-0 static calls
Message-ID: <Yf/WvmqxzBDVTTSm@hirez.programming.kicks-ass.net>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
 <20220202181813.1103496-6-pbonzini@redhat.com>
 <745fc750-cd52-af1e-4e5e-0644ff3be007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <745fc750-cd52-af1e-4e5e-0644ff3be007@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 03, 2022 at 07:40:25PM +0100, Paolo Bonzini wrote:
> On 2/2/22 19:18, Paolo Bonzini wrote:
> > A few vendor callbacks are only used by VMX, but they return an integer
> > or bool value.  Introduce KVM_X86_OP_RET0 for them: a NULL value in
> > struct kvm_x86_ops will be changed to __static_call_return0.
> 
> This also needs EXPORT_SYMBOL_GPL(__static_call_ret0).  Peter, any
> objections?

__static_call_return0 I suppose, but no. Go ahead.
