Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAF5C0049
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 16:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiIUOuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 10:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiIUOur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 10:50:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FA95C373;
        Wed, 21 Sep 2022 07:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45947625C7;
        Wed, 21 Sep 2022 14:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93855C433D7;
        Wed, 21 Sep 2022 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663771844;
        bh=Tt0Sn8n+DGZrRz/CyKJgh6LCApdHqORZQlgzmNzuHV0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=RC44LXaatmyN5AXTd+9HUs6kEUo3wyAr7MGCJRtFv7H2j5iyPAfFeIhQcR0R9lzJ3
         Rn43q+emGquy8vnYUQr/uD9gIt/RMp7vrd24MGaHfJHmViKaMMpQ/GsZsgZh7x/Q5Z
         OZOszTqH8jGuW+3xk1n+XAqL/JdY6Fipmp+D96EuTfx+ABjpJ8I72BYXTHd2cTD6vg
         QDMA6RJfgE05Nw2cB4ipmsz3elvvgC2k0YkvkWNAbPgffa1DJkO9vP7KFdiTnnEvjS
         bPpTJWMPLzWByN3fWEfC6lQXMotj8hMW9K5BPP99mxwQF4CQkmX771qe/d/xxnhtvv
         ApFlFGrmBaz1A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 2C6185C0849; Wed, 21 Sep 2022 07:50:44 -0700 (PDT)
Date:   Wed, 21 Sep 2022 07:50:44 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Mukesh Ojha <quic_mojha@quicinc.com>
Cc:     Zeng Heng <zengheng4@huawei.com>, pbonzini@redhat.com,
        frederic@kernel.org, quic_neeraju@quicinc.com,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, kvm@vger.kernel.org, rcu@vger.kernel.org,
        liwei391@huawei.com
Subject: Re: [PATCH -next] rcu: remove unused 'cpu' in
 rcu_virt_note_context_switch
Message-ID: <20220921145044.GB4196@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220915083824.766645-1-zengheng4@huawei.com>
 <92770899-d56b-8bcd-f613-32d7b7ddd30b@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92770899-d56b-8bcd-f613-32d7b7ddd30b@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 15, 2022 at 02:10:43PM +0530, Mukesh Ojha wrote:
> Hi,
> 
> On 9/15/2022 2:08 PM, Zeng Heng wrote:
> > Remove unused function argument, and there is
> > no logic changes.
> > 
> > Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> > ---
> >   include/linux/kvm_host.h | 2 +-
> >   include/linux/rcutiny.h  | 2 +-
> >   include/linux/rcutree.h  | 2 +-
> >   3 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f4519d3689e1..9cf0c503daf5 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -417,7 +417,7 @@ static __always_inline void guest_context_enter_irqoff(void)
> >   	 */
> >   	if (!context_tracking_guest_enter()) {
> >   		instrumentation_begin();
> > -		rcu_virt_note_context_switch(smp_processor_id());
> > +		rcu_virt_note_context_switch();
> >   		instrumentation_end();
> >   	}
> >   }
> > diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> > index 768196a5f39d..9bc025aa79a3 100644
> > --- a/include/linux/rcutiny.h
> > +++ b/include/linux/rcutiny.h
> > @@ -142,7 +142,7 @@ static inline int rcu_needs_cpu(void)
> >    * Take advantage of the fact that there is only one CPU, which
> >    * allows us to ignore virtualization-based context switches.
> >    */
> > -static inline void rcu_virt_note_context_switch(int cpu) { }
> > +static inline void rcu_virt_note_context_switch(void) { }
> >   static inline void rcu_cpu_stall_reset(void) { }
> >   static inline int rcu_jiffies_till_stall_check(void) { return 21 * HZ; }
> >   static inline void rcu_irq_exit_check_preempt(void) { }
> > diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> > index 5efb51486e8a..70795386b9ff 100644
> > --- a/include/linux/rcutree.h
> > +++ b/include/linux/rcutree.h
> > @@ -27,7 +27,7 @@ void rcu_cpu_stall_reset(void);
> >    * wrapper around rcu_note_context_switch(), which allows TINY_RCU
> >    * to save a few bytes. The caller must have disabled interrupts.
> >    */
> > -static inline void rcu_virt_note_context_switch(int cpu)
> > +static inline void rcu_virt_note_context_switch(void)
> >   {
> >   	rcu_note_context_switch(false);
> >   }
> 
> Good catch.
> 
> Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>

Applied for further review and testing.  Thank you both!

							Thanx, Paul
