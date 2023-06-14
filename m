Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F157309C1
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 23:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbjFNVXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 17:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjFNVXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 17:23:30 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BD61FFA
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:23:29 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56561689700so15920157b3.2
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686777808; x=1689369808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EguF6lsG5lYio4UZZ1vADQabPc9eHzO82CmbKeM2Gps=;
        b=1OB4P93nQ9hnwu1SKXSh9Rv08V9u9apR87yzMCxcD97fBtyXQJmA332SMyINsuwF5k
         WDP3zbqRSh1YCG51O8vkwWH9UOylzOgoCLECbGuGxdNvsJ9P+t6xN5lXJVF2MDyWQ87d
         g0kY3pdBzSUOSNlJopYI0Ol7QwH1IW9f/F1Rp9zDz5QHxviCsfLnNikWMf6G8MxzKnVN
         Hkrgiju4CIHHe98opG11KR1x2fJVrXdKGQE9rYvKpUdRZpc6IXYrwgWM5oT55OGSLJ6k
         /GCv5DjRwFS8JcP6fnZdTAWkndoEDNIel4yJiNwk7IwCqMj8H448JxLQqHA/Bc8wTCGB
         WbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686777808; x=1689369808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EguF6lsG5lYio4UZZ1vADQabPc9eHzO82CmbKeM2Gps=;
        b=SJRr/3J0nHAy63yzGTah4eK+bvzjLGadvjY9Lti9rFvvY1AQoSeMeWCZfyoXqq3IlV
         VtmadlJOVc0pskcCOAQtb3ji6PvqAibkQDv/zZL/w9kbCvr7fyhV9fqvoA43QVynVxvD
         RzwkcetLfIxPONDWG35Wut5OF0cLpMNPnqkhw6Fx0mS7LpKhc/kcsZ6Ru0z1C6GCxOg7
         xg8ToX8vpU7rwRtxtyrb7fBdAuARCGxbkQFqBJGUMbVlnpQOtBA5L0AwQuvOr19DT3fr
         ua+/KVg2I6q7AmUOqXugA6nZWgO+kU1QAQDqnytyLZ6N5NMsqWF1UWwwJ1kt+h+Y91jL
         Y4HA==
X-Gm-Message-State: AC+VfDypLBoC1PHMUfXTkn+KIlXfpUkjnmaJb/nNgj3JZGm4JuSVySXY
        W+F6vpHBOnEkEBoIp64QYh9dKRcjHXk=
X-Google-Smtp-Source: ACHHUZ4bOpC/uhJHVrKJmWqgRppZDc2NExGMN/kWxkPS3c90+dp9htpQTQSdFXtKL8nnsymOBcUnz5oiwGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:320d:0:b0:bcc:285c:66de with SMTP id
 y13-20020a25320d000000b00bcc285c66demr1522968yby.5.1686777808777; Wed, 14 Jun
 2023 14:23:28 -0700 (PDT)
Date:   Wed, 14 Jun 2023 14:23:27 -0700
In-Reply-To: <ZIovIBVLIM69E5Bo@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com>
Message-ID: <ZIovz22R5dm05u6/@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023, Sean Christopherson wrote:
> On Fri, Jun 02, 2023, Anish Moorthy wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 69a221f71914..abbc5dd72292 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2297,4 +2297,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
> >   */
> >  inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> >  				     uint64_t gpa, uint64_t len, uint64_t flags);
> > +
> > +static inline bool kvm_slot_nowait_on_fault(
> > +	const struct kvm_memory_slot *slot)
> 
> Just when I was starting to think that we had beat all of the Google3 out of you :-)
> 
> And predicate helpers in KVM typically have "is" or "has" in the name, so that it's
> clear the helper queries, versus e.g. sets the flag or something. 
> 
> > +{
> > +	return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> 
> KVM is anything but consistent, but if the helper is likely to be called without
> a known good memslot, it probably makes sense to have the helper check for NULL,
> e.g.
> 
> static inline bool kvm_is_slot_nowait_on_fault(const struct kvm_memory_slot *slot)
> {
> 	return slot && slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> }
> 
> However, do we actually need to force vendor code to query nowait?  At a glance,
> the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslot() are
> in flows that play nice with nowait or that don't support it at all.  So I *think*
> we can do this?
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index be06b09e9104..78024318286d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2403,6 +2403,11 @@ static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
>         return slot->flags & KVM_MEM_READONLY;
>  }
>  
> +static bool memslot_is_nowait_on_fault(const struct kvm_memory_slot *slot)
> +{
> +       return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> +}
> +
>  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
>                                        gfn_t *nr_pages, bool write)
>  {
> @@ -2730,6 +2735,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>                 writable = NULL;
>         }
>  
> +       if (async && memslot_is_nowait_on_fault(slot)) {
> +               *async = false;
> +               async = NULL;
> +       }

Gah, got turned around and forgot to account for @atomic.  So this?

	if (!atomic && memslot_is_nowait_on_fault(slot)) {
		atomic = true;
		if (async) {
			*async = false;
			async = NULL;
		}
	}
	
> +
>         return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
>                           writable);
>  }
> 
> Ah, crud.  The above highlights something I missed in v3.  The memslot NOWAIT
> flag isn't tied to FOLL_NOWAIT, it's really truly a "fast-only" flag.  And even
> more confusingly, KVM does set FOLL_NOWAIT, but for the async #PF case, which will
> get even more confusing if/when KVM uses FOLL_NOWAIT internally.
> 
> Drat.  I really like the NOWAIT name, but unfortunately it doesn't do what as the
> name says.
> 
> I still don't love "fast-only" as that bleeds kernel internals to userspace.
> Anyone have ideas?  Maybe something about not installing new mappings?
