Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F5674A252
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjGFQjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjGFQjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB71BD4;
        Thu,  6 Jul 2023 09:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 817B660F4F;
        Thu,  6 Jul 2023 16:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5B4C433C8;
        Thu,  6 Jul 2023 16:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688661556;
        bh=h0OgFh+n1mPvFs2BQeBGKqCup9+gz5oIEYrZdP/kZ1I=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=R0xErIoJDEDCPvtj6yutBpmBjH5+sNN2DTcaezc0n9WR9TmEy1Nr2SEjJS8AccSd3
         25C6dIotYWq8C5oJ9XdKjIpstBZeJWrrI9E27qO7jpwLOi76bYLKoIyXlH2wfstEMQ
         tPDpcvtxi4PytZqu0bwUna2NlsoyPW4LBUJOY/NsN0hai4AjwHDjPZzylD8bgAPtdb
         Cwl4u1kw+cVOCyrTxYlUiTtFJt//p8FjGirDXyUgy4nS8jwMLqoMNQN/rB22Oc6zG4
         gH6et2pDl9nnxtn2MeaAt2F24E81hxy8q8zy8E74z/IjrpOLVV0NQ5YhU+0Jter5Dd
         vcGyaW6m9hrYA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 6BCE5CE3BFC; Thu,  6 Jul 2023 09:39:16 -0700 (PDT)
Date:   Thu, 6 Jul 2023 09:39:16 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 11/14] context-tracking: Introduce work deferral
 infrastructure
Message-ID: <4c2cb573-168f-4806-b1d9-164e8276e66a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705181256.3539027-12-vschneid@redhat.com>
 <ZKXtfWZiM66dK5xC@localhost.localdomain>
 <xhsmhttuhuvix.mognet@vschneid.remote.csb>
 <ZKaoHrm0Fejb7kAl@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKaoHrm0Fejb7kAl@lothringen>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 01:40:14PM +0200, Frederic Weisbecker wrote:
> On Thu, Jul 06, 2023 at 12:30:46PM +0100, Valentin Schneider wrote:
> > >> +		ret = atomic_try_cmpxchg(&ct->work, &old_work, old_work | work);
> > >> +
> > >> +	preempt_enable();
> > >> +	return ret;
> > >> +}
> > > [...]
> > >> @@ -100,14 +158,19 @@ static noinstr void ct_kernel_exit_state(int offset)
> > >>   */
> > >>  static noinstr void ct_kernel_enter_state(int offset)
> > >>  {
> > >> +	struct context_tracking *ct = this_cpu_ptr(&context_tracking);
> > >>      int seq;
> > >> +	unsigned int work;
> > >>
> > >> +	work = ct_work_fetch(ct);
> > >
> > > So this adds another fully ordered operation on user <-> kernel transition.
> > > How many such IPIs can we expect?
> > >
> > 
> > Despite having spent quite a lot of time on that question, I think I still
> > only have a hunch.
> > 
> > Poking around RHEL systems, I'd say 99% of the problematic IPIs are
> > instruction patching and TLB flushes.
> > 
> > Staring at the code, there's quite a lot of smp_calls for which it's hard
> > to say whether the target CPUs can actually be isolated or not (e.g. the
> > CPU comes from a cpumask shoved in a struct that was built using data from
> > another struct of uncertain origins), but then again some of them don't
> > need to hook into context_tracking.
> > 
> > Long story short: I /think/ we can consider that number to be fairly small,
> > but there could be more lurking in the shadows.
> 
> I guess it will still be time to reconsider the design if we ever reach such size.
> 
> > > If this is just about a dozen, can we stuff them in the state like in the
> > > following? We can potentially add more of them especially on 64 bits we could
> > > afford 30 different works, this is just shrinking the RCU extended quiescent
> > > state counter space. Worst case that can happen is that RCU misses 65535
> > > idle/user <-> kernel transitions and delays a grace period...
> > >
> > 
> > I'm trying to grok how this impacts RCU, IIUC most of RCU mostly cares about the
> > even/odd-ness of the thing, and rcu_gp_fqs() cares about the actual value
> > but only to check if it has changed over time (rcu_dynticks_in_eqs_since()
> > only does a !=).
> > 
> > I'm rephrasing here to make sure I get it - is it then that the worst case
> > here is 2^(dynticks_counter_size) transitions happen between saving the
> > dynticks snapshot and checking it again, so RCU waits some more?
> 
> That's my understanding as well but I have to defer on Paul to make sure I'm
> not overlooking something.

That does look plausible to me.

And yes, RCU really cares about whether its part of this counter has
been a multiple of two during a given interval of time, because this
indicates that the CPU has no pre-existing RCU readers still active.
One way that this can happen is for that value to be a multiple of two
at some point in time.  The other way that this can happen is for the
value to have changed.  No matter what the start and end values, if they
are different, the counter must necessarily have at least passed through
multiple of two in the meantime, again guaranteeing that any RCU readers
that around when the count was first fetched have now finished.

But we should take the machine's opinions much more seriously than we
take any of our own opinions.  Why not adjust RCU_DYNTICKS_IDX so as
to crank RCU's portion of this counter down to (say) two or three bits
and let rcutorture have at it on TREE04 or TREE07, both of which have
nohz_full CPUs?

Maybe also adjust mkinitrd.sh to make the user/kernel transitions more
frequent?

Please note that I do -not- recommend production use of a three-bit
(let alone a two-bit) RCU portion because this has a high probability
of excessively extending grace periods.  But it might be good to keep
a tiny counter as a debug option so that we regularly rcutorture it.

							Thanx, Paul
