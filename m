Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6B17A879A
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbjITOxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbjITOxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:53:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467A39F;
        Wed, 20 Sep 2023 07:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GyiHhTkxOm0E3nJZzmdSc55EE6M80FFoZ8Fg8eF69QI=; b=qal6/LGdy1+KLISPaYnZD8Qx03
        0sPsW4Hb98j/QISugyJf8X+fjehOvS9Ll09sNhQBGt4zYCqJLS05+5zcypr1lxzUUBMMzVD94e3dM
        WsEbCy3MXmjjSIbGTjummdcpDaTg/Q5P6+27Ache2MDt+PDg7wvaaYBxEqYwmH7IH6z3v4Nrab3kH
        jumgDPBEh8iwGY7QxhMaZVdU9o7YOZ+lp8opCiziKvMXLydIfARsPghjuMR+QFMMUTvGJiINVUWkL
        bzeShoJxnjyr3LqxNC1fTfMdieOivUFEv0jhy8CMnJm5sqI4skd6Rbs5aAGT9J8EfMFToJBwbaylz
        Z9nmpmCw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qiyZT-006Oz0-BC; Wed, 20 Sep 2023 14:52:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 04996300348; Wed, 20 Sep 2023 16:52:55 +0200 (CEST)
Date:   Wed, 20 Sep 2023 16:52:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH 1/3] x86/paravirt: move some functions and defines to
 alternative
Message-ID: <20230920145254.GC6687@noisy.programming.kicks-ass.net>
References: <20230608140333.4083-1-jgross@suse.com>
 <20230608140333.4083-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608140333.4083-2-jgross@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 04:03:31PM +0200, Juergen Gross wrote:
> As a preparation for replacing paravirt patching completely by
> alternative patching, move some backend functions and #defines to
> alternative code and header.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
