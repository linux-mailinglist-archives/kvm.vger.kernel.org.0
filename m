Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3CE2055E0
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbgFWP3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732885AbgFWP3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:29:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8CFC061573;
        Tue, 23 Jun 2020 08:29:15 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ga6so1617924pjb.1;
        Tue, 23 Jun 2020 08:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KDCfSozN/IsFdVgihX+4tXj9STjMapc13JwQrRlGOGI=;
        b=T/OEIZh0zGlP2T9RFvlsU5XYkUCDBl7ASqg608sxi47S9mKGhwAFLwcfgL1MqyXRcp
         uklUH5Or7eaEv71m02+vA97XLy/dXH5U+foa4S7Vj9Q0O50iPLVwvAqj+5jgG9RS9md7
         pQP1ro8onkLP5R/3cMKjIsXABJs/oGVlz13NfuZqm98Vb3xYHslPqTkQ3XCeuz3OesqI
         ZR5AxtYNoJ5OQysH1gWddF5qJ0Zp+bewtxlnLHAeWoSMb4zv4HR0EVfJhvONtvuUnNYy
         HCg0vwEsUV5V960RXRAHsYR8Cy45XFsxCo16xubO//gmpXwHfBksLCgISWWv8156XHdY
         QMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KDCfSozN/IsFdVgihX+4tXj9STjMapc13JwQrRlGOGI=;
        b=WuUhJ0tbeKNfIoLlMXhwtqTvoZfDUXstVbL4F+bcv8pS1iXxHM8hkbxfFQq/ihgoa6
         r9ycCjYMeawXvimWOL9lJCuqhrIpSDKKwTlpXH2vE0aqwXpQp4c2vLYi8F/2/DsHZQ6l
         fBP6uD6zgt0W+gDsjMKf5ADhxaT2w+NmtWFEk88hYwnTNOO3r7bLGyaCGVSpDHnQg8SF
         gKXshFDLutif0BgYvL6ybG0+mlF4uC9OYwrBqNbCb2LR2AsLhdndLKV1vZJdb537HpTU
         lNIdYNWvkxEFJ2sQ4zL3VdZH84cC8bs/W4CK7j+hI8iNMVoPLvqQ3QPTpHk/btybcHEa
         FeSw==
X-Gm-Message-State: AOAM530W6aLVR+AoRMHhCtqHrmoP2MRKDUVQSZvsAJNRsJlDBE962xyj
        I0KLmkjnA4FVCqtyW+OKHQ==
X-Google-Smtp-Source: ABdhPJxkqvJJZzhda47S/KsXfI8hQaJBLoqa63OrEAxyytojiWtkO6JBXA35r6p572mg7DM/mxBfSA==
X-Received: by 2002:a17:902:6b8c:: with SMTP id p12mr22159395plk.256.1592926154950;
        Tue, 23 Jun 2020 08:29:14 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:ceb:846:8098:13b7:478d:bfe2])
        by smtp.gmail.com with ESMTPSA id l2sm2841461pjl.34.2020.06.23.08.29.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2020 08:29:13 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Tue, 23 Jun 2020 20:59:05 +0530
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     madhuparnabhowmik10@gmail.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] kvm: Fix false positive RCU usage warning
Message-ID: <20200623152905.GA9914@madhuparna-HP-Notebook>
References: <20200516082227.22194-1-madhuparnabhowmik10@gmail.com>
 <9fff3c6b-1978-c647-16f7-563a1cdf62ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fff3c6b-1978-c647-16f7-563a1cdf62ff@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 09:39:53AM +0200, Paolo Bonzini wrote:
> On 16/05/20 10:22, madhuparnabhowmik10@gmail.com wrote:
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > Fix the following false positive warnings:
> > 
> > [ 9403.765413][T61744] =============================
> > [ 9403.786541][T61744] WARNING: suspicious RCU usage
> > [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > [ 9403.838945][T61744] -----------------------------
> > [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!
> > 
> > and
> > 
> > [ 9405.859252][T61751] =============================
> > [ 9405.859258][T61751] WARNING: suspicious RCU usage
> > [ 9405.880867][T61755] -----------------------------
> > [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > [ 9405.911942][T61751] -----------------------------
> > [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!
> > 
> > Since srcu read lock is held, these are false positive warnings.
> > Therefore, pass condition srcu_read_lock_held() to
> > list_for_each_entry_rcu().
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > ---
> > v2:
> > -Rebase v5.7-rc5
> > 
> >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > index ddc1ec3bdacd..1ad79c7aa05b 100644
> > --- a/arch/x86/kvm/mmu/page_track.c
> > +++ b/arch/x86/kvm/mmu/page_track.c
> > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> >  		return;
> >  
> >  	idx = srcu_read_lock(&head->track_srcu);
> > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > +				srcu_read_lock_held(&head->track_srcu))
> >  		if (n->track_write)
> >  			n->track_write(vcpu, gpa, new, bytes, n);
> >  	srcu_read_unlock(&head->track_srcu, idx);
> > @@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> >  		return;
> >  
> >  	idx = srcu_read_lock(&head->track_srcu);
> > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > +				srcu_read_lock_held(&head->track_srcu))
> >  		if (n->track_flush_slot)
> >  			n->track_flush_slot(kvm, slot, n);
> >  	srcu_read_unlock(&head->track_srcu, idx);
> > 
> 
> Hi, sorry for the delay in reviewing this patch.  I would like to ask
> Paul about it.
> 
> While you're correctly fixing a false positive, hlist_for_each_entry_rcu
> would have a false _negative_ if you called it under
> rcu_read_lock/unlock and the data structure was protected by SRCU.  This
> is why for example srcu_dereference is used instead of
> rcu_dereference_check, and why srcu_dereference uses
> __rcu_dereference_check (with the two underscores) instead of
> rcu_dereference_check.  Using rcu_dereference_check would add an "||
> rcu_read_lock_held()" to the condition which is wrong.
>
Yes, that makes sense, there would be a false negative, thank you for
pointing out this issue.

> I think instead you should add hlist_for_each_srcu and
> hlist_for_each_entry_srcu macro to include/linux/rculist.h.
> 
This seems good to me, I can work on this, but I would wait for Paul's
suggestion on this.

> There is no need for equivalents of hlist_for_each_entry_continue_rcu
> and hlist_for_each_entry_from_rcu, because they use rcu_dereference_raw.
>  However, it's not documented why they do so.
> 
> Paul, do you have any objections to the idea?  Thanks,
> 
> Paolo

Thank you,
Madhuparna

> 
