Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFEADC2FC
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 12:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbfJRKn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 06:43:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36014 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfJRKn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 06:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oxApsNYvw66RYq5moaNmeiPbSZysZVQPCrDxkISvsxg=; b=lj+/TILVPr4+8Wq0kbg6+i9q6
        +MNAtgBK5pj3tsWPMlgEh9gkCSGNHeH0/PjsFEVmBD3SWLGXlE6Qm+shwtvkTY+3zA6RIX3v/FI1x
        MnBsHcVL12ndv3QPVj66JqqLpzSeDaqJJrlBFGhXChMts3nyYJSnRXB/cQD8PhxpdSC27rPyoA8Ua
        Slf5mJ1ftQ4X8JWkavBHsdFmJAG0a+eJoa3XkBpAmI0pwO6o8WbXKdHnfczUQa1Cv21IdPpG14mtO
        qCKljUY/+KSBGPCTXLfL4ikRgkpQw0TahKphA5iHj1lQpSOqusq9i6Hxgy+mKXKtkxTF0bPHZbr/b
        U+lyQcIdA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLPix-0002Ib-3W; Fri, 18 Oct 2019 10:43:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9081A30018A;
        Fri, 18 Oct 2019 12:42:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 56C542B17810B; Fri, 18 Oct 2019 12:43:07 +0200 (CEST)
Date:   Fri, 18 Oct 2019 12:43:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [RFD] x86/split_lock: Request to Intel
Message-ID: <20191018104307.GG2328@hirez.programming.kicks-ass.net>
References: <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
 <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
 <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
 <5da90713-9a0d-6466-64f7-db435ba07dbe@intel.com>
 <alpine.DEB.2.21.1910181100000.1869@nanos.tec.linutronix.de>
 <763bb046-e016-9440-55c4-33438e35e436@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <763bb046-e016-9440-55c4-33438e35e436@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 18, 2019 at 06:20:44PM +0800, Xiaoyao Li wrote:

> We enable #AC on all cores/threads to detect split lock.
>  -If user space causes #AC, sending SIGBUS to it.
>  -If kernel causes #AC, we globally disable #AC on all cores/threads,
> letting kernel go on working and WARN. (only disabling #AC on the thread
> generates it just doesn't help, since the buggy kernel code is possible to
> run on any threads and thus disabling #AC on all of them)
> 
> As described above, either enabled globally or disabled globally, so whether
> it's per-core or per-thread really doesn't matter

Go back and read the friggin' thread already. A big clue: virt ruins it
(like it tends to do).
