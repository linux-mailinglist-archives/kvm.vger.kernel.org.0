Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EBF151800
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 10:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgBDJhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 04:37:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgBDJhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 04:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l8wLZvShLpGwIIo23/sbMyLLHi4SrrzV56FOntvn8cI=; b=Di9MDRXL6hCNrmrgU2T1UQxxtd
        QCgGDtQZz86r4eBxsvjQS+JGvuAKaXEk5mYR3xUAN2cOfRH3BVt0J/GteOAJFOubIqpX2nO58vr1h
        IDI9cpZX1dhx3wtklr1EkbM5UTLR6PZX7Yje9A7OncjQRWL4PYG/YzbVW1vADHltDp/xVr13IPR93
        uBbT9ml4OzR2KKs+ddvF9LClb2Y1G40Q8BMV+bSzq2ydgvZ69jQuXC0fMdN92lrrl+2PcQOfLUL1R
        +873A6dCC817+w5aQR74FTSuVlknaCXt5+L9bJ+zDZb8tmhEse8lscBB9qSHp/n7Ewe8yPbpFzEy3
        BjkCucoQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyue7-0005kv-D7; Tue, 04 Feb 2020 09:37:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D5E5A30257C;
        Tue,  4 Feb 2020 10:35:39 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4A4E620236A49; Tue,  4 Feb 2020 10:37:25 +0100 (CET)
Date:   Tue, 4 Feb 2020 10:37:25 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v2 5/6] kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
Message-ID: <20200204093725.GC14879@hirez.programming.kicks-ass.net>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-6-xiaoyao.li@intel.com>
 <20200203214300.GI19638@linux.intel.com>
 <829bd606-6852-121f-0d95-e9f1d35a3dde@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829bd606-6852-121f-0d95-e9f1d35a3dde@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 05:19:26PM +0800, Xiaoyao Li wrote:

> > > +	case MSR_IA32_CORE_CAPS:
> > > +		if (!msr_info->host_initiated)
> > 
> > Shouldn't @data be checked against kvm_get_core_capabilities()?
> 
> Maybe it's for the case that userspace might have the ability to emulate SLD
> feature? And we usually let userspace set whatever it wants, e.g.,
> ARCH_CAPABILITIES.

If the 'sq_misc.split_lock' event is sufficiently accurate, I suppose
the host could use that to emulate the feature at the cost of one
counter used.
