Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85EC1C3C3
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 09:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfENHVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 03:21:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfENHVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 03:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5gY/FrzuJKQ2FR01A0lkoDKVYEffpMYlDw1IyGNKjYo=; b=dMyL7yFyBotXpf1bhUBEB/ekM
        rQHrC1RIyHATgW4sGM/lBtPM6Q/ir3W3nlIwq6M3NSy+7bl37qJAqZoiNp/rifd429r2FJQdiOwxC
        km7Km+Q0BaJrO26RbBUBd+yQ860nWQWEkhMu90tG+wHL1keHeJAFl42CxKjSUH18D75mSs9yFSDNK
        h/lkar2wvBlMUAD/qOXOEaaWAV6UMzx8YxoCbXPWPN7gvV0T28tvGXgicl24PuM7qeSIjyavVCsGY
        48pfo7ItD50RW8r2+DtYofmZyPaZ+/cN5U455nWPteIReQsZ7sBrNHp8pVGyPNIbEB5a3E7YHC0pW
        Bkzm3CScQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQRkO-00038y-3x; Tue, 14 May 2019 07:21:12 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6F1B82029F87A; Tue, 14 May 2019 09:21:10 +0200 (CEST)
Date:   Tue, 14 May 2019 09:21:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
Subject: Re: [RFC KVM 24/27] kvm/isolation: KVM page fault handler
Message-ID: <20190514072110.GF2589@hirez.programming.kicks-ass.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com>
 <20190513151500.GY2589@hirez.programming.kicks-ass.net>
 <13F2FA4F-116F-40C6-9472-A1DE689FE061@oracle.com>
 <CALCETrUcR=3nfOtFW2qt3zaa7CnNJWJLqRY8AS9FTJVHErjhfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUcR=3nfOtFW2qt3zaa7CnNJWJLqRY8AS9FTJVHErjhfg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 07:02:30PM -0700, Andy Lutomirski wrote:

> This sounds like a great use case for static_call().  PeterZ, do you
> suppose we could wire up static_call() with the module infrastructure
> to make it easy to do "static_call to such-and-such GPL module symbol
> if that symbol is in a loaded module, else nop"?

You're basically asking it to do dynamic linking. And I suppose that is
technically possible.

However, I'm really starting to think kvm (or at least these parts of it
that want to play these games) had better not be a module anymore.


