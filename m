Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1A968531
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 10:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbfGOI2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 04:28:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46682 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbfGOI2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 04:28:30 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hmwLE-0005Ij-RB; Mon, 15 Jul 2019 10:28:12 +0200
Date:   Mon, 15 Jul 2019 10:28:11 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
In-Reply-To: <fd98f388-1080-ff9e-1f9a-b089272c0037@oracle.com>
Message-ID: <alpine.DEB.2.21.1907151026190.1669@nanos.tec.linutronix.de>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de> <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net> <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de> <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com> <alpine.DEB.2.21.1907122059430.1669@nanos.tec.linutronix.de>
 <fd98f388-1080-ff9e-1f9a-b089272c0037@oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexandre,

On Mon, 15 Jul 2019, Alexandre Chartre wrote:
> On 7/12/19 9:48 PM, Thomas Gleixner wrote:
> > As I said before, come up with a list of possible usage scenarios and
> > protection scopes first and please take all the ideas other people have
> > with this into account. This includes PTI of course.
> > 
> > Once we have that we need to figure out whether these things can actually
> > coexist and do not contradict each other at the semantical level and
> > whether the outcome justifies the resulting complexity.
> > 
> > After that we can talk about implementation details.
> 
> Right, that makes perfect sense. I think so far we have the following
> scenarios:
> 
>  - PTI
>  - KVM (i.e. VMExit handler isolation)
>  - maybe some syscall isolation?

Vs. the latter you want to talk to Paul Turner. He had some ideas there.

> I will look at them in more details, in particular what particular
> mappings they need and when they need to switch mappings.
> 
> And thanks for putting me back on the right track.

That's what maintainers are for :)

Thanks,

	tglx
