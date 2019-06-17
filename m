Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CBD48813
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 17:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfFQP5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 11:57:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfFQP5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 11:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uJnkwvrHnUKeF2+PJ73eDxHxHEk2QRBcNkGJHa1Q1t8=; b=Fg0tPd9SH6JEk/y2kLvOjezKn
        qzNtQKLAchQKIdhOcH6OJ9U3hTgnF5tOsi0RXbSeaJgkyipRo7MTCE48QTyN7otb6TJvfwNqTcXgB
        IygIwTdS67RokzdzksBbyB0Tqy8cZl225lC/OzjiH2YikCJHdpSKjLe9zWy5T5u0CCaS6uxll7WN3
        JygB3ckjImsyzI8bZg9Y3xnWqTtmdYvfMttc806rvZB1KCvnXGoHL5ABp994JB3TAC4JmwW72Nxrk
        6AqP7fQvylUDKshgNX1OoxbRCGzX6qUNLgsifDcIeBqlcDhY30lmeB57Mn2snXjzhM/9UiAuzxSuY
        w36NWpRLQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcu0a-0001tY-6H; Mon, 17 Jun 2019 15:57:27 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B0EBE201F4619; Mon, 17 Jun 2019 17:57:22 +0200 (CEST)
Date:   Mon, 17 Jun 2019 17:57:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?iso-8859-1?B?S3LEP23DocU/?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [patch 0/3] cpuidle-haltpoll driver (v2)
Message-ID: <20190617155722.GJ3436@hirez.programming.kicks-ass.net>
References: <20190603225242.289109849@amt.cnet>
 <6c411948-9e32-9f41-351e-c9accd1facb0@intel.com>
 <20190610145942.GA24553@amt.cnet>
 <CAJZ5v0idYgETFg4scgvpJ-eGtFAx1Wi6hznXz7+XZAfKjiSAPA@mail.gmail.com>
 <20190611142627.GB4791@amt.cnet>
 <CAJZ5v0gPbSXB3r71XaT-4Q7LsiFO_UVymBwOmU8J1W5+COk_1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gPbSXB3r71XaT-4Q7LsiFO_UVymBwOmU8J1W5+COk_1g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 11:24:39PM +0200, Rafael J. Wysocki wrote:
> > Peter Zijlstra suggested a cpuidle driver for this.
> 
> So I wonder what his rationale was.

I was thinking we don't need this hard-coded in the idle loop when virt
can load a special driver.
