Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CCC2B21C
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 12:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfE0KaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 06:30:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38400 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfE0KaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 06:30:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fO4yzkLNvwCdtEhg2+HPTX4Reyxk7SMjLIEFxFLV1qg=; b=pYKF21PBn82fa2rICGxiMtwQK
        t4RX9tPZfOsqVrIwLkSBvUDpxGCjSVECjEH9UDf1AM5h+k88M9da0PuEOcokdueJDRP1iQqcGfRL3
        yizWRzNx+zl992HJ7vu9Up9W4b6bRGoSlYUszHF34bfWSRLc5SEvrZYyUYUNCM0EJeonttC6IxHRs
        KBBpwT9Nbx2C5jetEzCAMldcFUDk+p4WwzVmvl31HKKvxvw9Uh4jV4M1o6rIlJM62xEJvuczATKCD
        139WQc112sejHLe5eAzrgqHzEgbxPMHKMorztt9WDdki8vrIW1RlAfDFZZi51r52ZUE1xbBVeqp3V
        eVwCt6+HA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hVCtI-0002IY-B8; Mon, 27 May 2019 10:30:05 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1B49D2027F766; Mon, 27 May 2019 12:30:03 +0200 (CEST)
Date:   Mon, 27 May 2019 12:30:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
Message-ID: <20190527103003.GX2623@hirez.programming.kicks-ass.net>
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524075637.29496-2-tao3.xu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 24, 2019 at 03:56:35PM +0800, Tao Xu wrote:
> This patch adds support for UMONITOR, UMWAIT and TPAUSE instructions
> in kvm, and by default dont't expose it to kvm and provide a capability
> to enable it.

I'm thinking this should be conditional on the guest being a 1:1 guest,
and I also seem to remember we have bits for that already -- they were
used to disable paravirt spinlocks for example.
