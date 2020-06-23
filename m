Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2592059F1
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 19:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733144AbgFWRta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 13:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733061AbgFWRt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 13:49:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92520C061573;
        Tue, 23 Jun 2020 10:49:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ne5so1788399pjb.5;
        Tue, 23 Jun 2020 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mU2Mqb/3Lzu3sqpNfQHlFitWN9RRppFyAwuH1XGEq/o=;
        b=Lt4FeIyKfPgR3dcCvP2WoEwHlKCPfb+zd+e7g56VPCjojWT8UAkOuMcNuZ8GfO1e9z
         PLvj9Ie8IethxX+Hvch4tg+PMXZQfAMVl+k1MaZ49GWwd5HLN0nrU3kShISTA8iUUUiy
         nmqzb/gb/ZMfRS87ayTJxcGIfmgVe9uTycEehOic1Q/13UayHkxdqmzzFHgScG0gfCDa
         CzyWaQdhZTEt9hHIqWdlW2gIcur5ZpUV5KVNfWlhXTP58vy+DUtzuEl83SxW6UIjxckQ
         GSn2Y7Zup2rr0S8eh3iENpeAEn8Xdy3XU1N/hIuEWA1Bb35+YYND8xOGo2Du4lwYp0Rr
         XvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mU2Mqb/3Lzu3sqpNfQHlFitWN9RRppFyAwuH1XGEq/o=;
        b=qo247sr4+aOzUn6EMtWzYp1llc/MKp8y57ya7wrWmNhO2I27MqDGEqgzs2rewwukUQ
         cFXtBO/JpG16Igultfq6falT7fjU7Ng+bIbUnV3qmNkTeyGq8ML5Z4ISc48ri1uOwfz2
         UPnj/YYLeIccepC0F4l6PKxQdxzr2MOr6dRLAUpKZsbW5F2OxfBklQkwpw21xepL/chN
         YHKO4DsTzVPmVzKiHyBSmJxcJ+8EA17vcxBUL3eLHkZvWFGTgPgv/Paviu5M2PVrwaSe
         lYHxUxqsFLyGd8XJ+9/iZJJreZSVmE4tTtOxw6CwESjEHmLB8akO0EQWwVdnJ2/8YEOC
         hdmg==
X-Gm-Message-State: AOAM533kIzmNDzQrT6OrxV0s4RcbJ7i82fAA24ksHc61BubkeiPRj84a
        cZTi3SxmIknr6AP0URjycNqPIz8lvg==
X-Google-Smtp-Source: ABdhPJxw/501/ORteOExfhyBnl/+yEVHkdQ3mDOuLpARGMwKOdFv65cx46gPEERRdrAfgGM6ZQ1jSQ==
X-Received: by 2002:a17:90a:70c6:: with SMTP id a6mr22379165pjm.16.1592934569041;
        Tue, 23 Jun 2020 10:49:29 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:ceb:846:8098:13b7:478d:bfe2])
        by smtp.gmail.com with ESMTPSA id y10sm14768935pgi.54.2020.06.23.10.49.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2020 10:49:28 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Tue, 23 Jun 2020 23:19:20 +0530
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] kvm: Fix false positive RCU usage warning
Message-ID: <20200623174920.GA13794@madhuparna-HP-Notebook>
References: <20200516082227.22194-1-madhuparnabhowmik10@gmail.com>
 <9fff3c6b-1978-c647-16f7-563a1cdf62ff@redhat.com>
 <20200623150236.GD9005@google.com>
 <20200623153036.GB9914@madhuparna-HP-Notebook>
 <20200623153901.GG9247@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623153901.GG9247@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 08:39:01AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 23, 2020 at 09:00:36PM +0530, Madhuparna Bhowmik wrote:
> > On Tue, Jun 23, 2020 at 11:02:36AM -0400, Joel Fernandes wrote:
> > > On Tue, Jun 23, 2020 at 09:39:53AM +0200, Paolo Bonzini wrote:
> > > > On 16/05/20 10:22, madhuparnabhowmik10@gmail.com wrote:
> > > > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > > 
> > > > > Fix the following false positive warnings:
> > > > > 
> > > > > [ 9403.765413][T61744] =============================
> > > > > [ 9403.786541][T61744] WARNING: suspicious RCU usage
> > > > > [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > > > > [ 9403.838945][T61744] -----------------------------
> > > > > [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!
> > > > > 
> > > > > and
> > > > > 
> > > > > [ 9405.859252][T61751] =============================
> > > > > [ 9405.859258][T61751] WARNING: suspicious RCU usage
> > > > > [ 9405.880867][T61755] -----------------------------
> > > > > [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > > > > [ 9405.911942][T61751] -----------------------------
> > > > > [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!
> > > > > 
> > > > > Since srcu read lock is held, these are false positive warnings.
> > > > > Therefore, pass condition srcu_read_lock_held() to
> > > > > list_for_each_entry_rcu().
> > > > > 
> > > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > > ---
> > > > > v2:
> > > > > -Rebase v5.7-rc5
> > > > > 
> > > > >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > > > > index ddc1ec3bdacd..1ad79c7aa05b 100644
> > > > > --- a/arch/x86/kvm/mmu/page_track.c
> > > > > +++ b/arch/x86/kvm/mmu/page_track.c
> > > > > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > > > >  		return;
> > > > >  
> > > > >  	idx = srcu_read_lock(&head->track_srcu);
> > > > > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > > > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > > > > +				srcu_read_lock_held(&head->track_srcu))
> > > > >  		if (n->track_write)
> > > > >  			n->track_write(vcpu, gpa, new, bytes, n);
> > > > >  	srcu_read_unlock(&head->track_srcu, idx);
> > > > > @@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > > > >  		return;
> > > > >  
> > > > >  	idx = srcu_read_lock(&head->track_srcu);
> > > > > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > > > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > > > > +				srcu_read_lock_held(&head->track_srcu))
> > > > >  		if (n->track_flush_slot)
> > > > >  			n->track_flush_slot(kvm, slot, n);
> > > > >  	srcu_read_unlock(&head->track_srcu, idx);
> > > > > 
> > > > 
> > > > Hi, sorry for the delay in reviewing this patch.  I would like to ask
> > > > Paul about it.
> > > > 
> > > > While you're correctly fixing a false positive, hlist_for_each_entry_rcu
> > > > would have a false _negative_ if you called it under
> > > > rcu_read_lock/unlock and the data structure was protected by SRCU.  This
> > > > is why for example srcu_dereference is used instead of
> > > > rcu_dereference_check, and why srcu_dereference uses
> > > > __rcu_dereference_check (with the two underscores) instead of
> > > > rcu_dereference_check.  Using rcu_dereference_check would add an "||
> > > > rcu_read_lock_held()" to the condition which is wrong.
> > > > 
> > > > I think instead you should add hlist_for_each_srcu and
> > > > hlist_for_each_entry_srcu macro to include/linux/rculist.h.
> > > > 
> > > > There is no need for equivalents of hlist_for_each_entry_continue_rcu
> > > > and hlist_for_each_entry_from_rcu, because they use rcu_dereference_raw.
> > > >  However, it's not documented why they do so.
> > > 
> > > You are right, this patch is wrong, we need a new SRCU list macro to do the
> > > right thing which would also get rid of the last list argument.
> > >
> > Can we really get rid of the last argument? We would need the
> > srcu_struct right for checking?
> 
> Agreed!  However, the API could be simplified by passing in a pointer to
> the srcu_struct instead of a lockdep expression.  An optional lockdep
> expression might still be helpful for calls from the update side,
> of course.
>
Sure, I will work on this.

Thanks,
Madhuparna
> 							Thanx, Paul
