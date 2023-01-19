Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2E1673DF8
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjASPwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjASPwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:52:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D02983C3;
        Thu, 19 Jan 2023 07:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eVM0Z+UpV/jRJdEATz67ETbXZdCDjyEbZsm+lCFPUtA=; b=P0AEilJKMpJmDXeIo6zuQLJHNW
        mh2t/0Ioui6KKGso7FmteSrnVw6fpGSCGrLsyjPnKYHbOymAm6uuiaMU9KU8FXYnJ24rkJ4bm+usS
        Rtx2Y/ThH0eEc1ML+lci5b0IR2ZYnGwtBZVEw+g0LHyNJB6/HhK4QAAZe+Nkchoeadim6FB72x9F1
        tYymazORrnnJFzB3pwRW005wD4mGYM1fVxwn3IkdK8hpcWtVj5A0mro38JSPptMU1U50mgNlvF3d7
        XLz7KWtbzLqpaWqnvjm4zqkbsjYPPqBrglDnBA+UdbRHsqKVZU3I9VwEuXqfZbz2fYej9pbP8Rxi2
        t6y45gzw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIXCt-0016X7-BI; Thu, 19 Jan 2023 15:52:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A4D41300348;
        Thu, 19 Jan 2023 16:52:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 86B9320DBE09E; Thu, 19 Jan 2023 16:52:02 +0100 (CET)
Date:   Thu, 19 Jan 2023 16:52:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 7/7] KVM: VMX: Handle NMI VM-Exits in noinstr region
Message-ID: <Y8lnItUdFhuUh2p+@hirez.programming.kicks-ass.net>
References: <20221213060912.654668-1-seanjc@google.com>
 <20221213060912.654668-8-seanjc@google.com>
 <Y8kSLBwUuqzlcSEZ@hirez.programming.kicks-ass.net>
 <Y8lkS2XUBBrcjNku@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8lkS2XUBBrcjNku@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 03:39:55PM +0000, Sean Christopherson wrote:

> It's in this patch, just lurking at the bottom.

Ha!, so much for reading ..
