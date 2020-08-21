Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA31124E1C3
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 22:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgHUUC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 16:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgHUUC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 16:02:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29943C061573;
        Fri, 21 Aug 2020 13:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qf+C/vALCJLHCuDIud0TGurzvmff61svtox7fx2n034=; b=IvMN3CmydmyLRnC/Z64Dfsiu5o
        Q6GrLp8CRovAv+EfD4cQOgWuIrvZGCSZmArYdin9VECt28XzksU5sf3mX4ctw2y3YAJYBdvuT1MqI
        Qe1l0UhtRjPM7YwELz0VY+Nr2kuoBQ6iUBYypjWS1RClKleXxkqTP3vQnoUEsVZsXcDOz9kYDAGyL
        JG/Tzps5K2flaBON/nE/XMDp48GqqKWbkEZsEtJ7nwddb3xtqkpDXVvE5Vve0tCmQIeQPyQh9wEH3
        pKM0fHTIQmt3Mv0m58pQZBs59mjqmvni7tU/bUx56GAJ52pDkXoL8bhZ9L8V+V6TVpKpBTTrVgYDV
        jWtC57AQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9DEm-0007AP-Bb; Fri, 21 Aug 2020 20:02:08 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id F3962980DF7; Fri, 21 Aug 2020 22:02:07 +0200 (CEST)
Date:   Fri, 21 Aug 2020 22:02:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     hpa@zytor.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
Message-ID: <20200821200207.GW3982@worktop.programming.kicks-ass.net>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821074743.GB12181@zn.tnic>
 <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
 <87r1s0gxfj.fsf@nanos.tec.linutronix.de>
 <5120CF63-12EB-4701-B303-C0A96201F5A2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5120CF63-12EB-4701-B303-C0A96201F5A2@zytor.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 12:55:53PM -0700, hpa@zytor.com wrote:

> It is hardly going to be a performance difference for paranoid entry,
> which is hopefully rare enough that it falls into the noise.

Try perf some day ;-)

But yeah, given the utter trainwreck that NMIs are anyway, this is all
not going to matter much.
