Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75CF539D76
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 08:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349902AbiFAGxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 02:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbiFAGxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 02:53:40 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97D8483B4;
        Tue, 31 May 2022 23:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hmAYDomcwUsUcR7EZzVH/pQ6WlVDw73Be6BYN2YaNzs=; b=EPULHYQ1Sz65HLz+Gdj48QLoFY
        OaPxOAxvuSWJYEX/DHgJg5liasTp4WhjxR0nzv+G3EMnz4qV1sK8AWtv/HgAUgxeyTa4a6M17Bqkt
        yopMmQXT+OcZ4gkbOKvdsRR3cSyFEiyQrIGCbgCzRs8wKWG4761q6ohrP2oL4lWm4mIlHqc5sRL9h
        XQYIB5yNDDsObZPwsF7kpd55oQOEe7Bt46Q3qJUxFeymT/DBsBz1gj1AZ8WSOzx1bQTF9R8BKIddk
        9om0KgCiW4lKwJRsvOmI0hQxW6tldSG47vi0EEa26r48NwnHT1Ixs6W8h+rKJcHDMYnfZxIBQfOx+
        aJroz8ag==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwIDu-003hBF-AM; Wed, 01 Jun 2022 06:52:59 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 30A3A98137D; Wed,  1 Jun 2022 08:52:51 +0200 (CEST)
Date:   Wed, 1 Jun 2022 08:52:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: ...\n
Message-ID: <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 02:52:04PM +0000, Durrant, Paul wrote:
> > -----Original Message-----
> > From: Peter Zijlstra <peterz@infradead.org>
> > Sent: 31 May 2022 15:44
> > To: Allister, Jack <jalliste@amazon.com>
> > Cc: bp@alien8.de; diapop@amazon.co.uk; hpa@zytor.com; jmattson@google.com; joro@8bytes.org;
> > kvm@vger.kernel.org; linux-kernel@vger.kernel.org; metikaya@amazon.co.uk; mingo@redhat.com;
> > pbonzini@redhat.com; rkrcmar@redhat.com; sean.j.christopherson@intel.com; tglx@linutronix.de;
> > vkuznets@redhat.com; wanpengli@tencent.com; x86@kernel.org
> > Subject: RE: [EXTERNAL]...\n
> > 
> > 
> > On Tue, May 31, 2022 at 02:02:36PM +0000, Jack Allister wrote:
> > > The reasoning behind this is that you may want to run a guest at a
> > > lower CPU frequency for the purposes of trying to match performance
> > > parity between a host of an older CPU type to a newer faster one.
> > 
> > That's quite ludicrus. Also, then it should be the host enforcing the
> > cpufreq, not the guest.
> 
> I'll bite... What's ludicrous about wanting to run a guest at a lower
> CPU freq to minimize observable change in whatever workload it is
> running?

*why* would you want to do that? Everybody wants their stuff done
faster.

If this is some hare-brained money scheme; must not give them if they
didn't pay up then I really don't care.

On top of that, you can't hide uarch differences with cpufreq capping.

Also, it is probably more power efficient to let it run faster and idle
more, so you're not being environmental either.
