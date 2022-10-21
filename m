Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC31607A70
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJUP0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJUPZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:25:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1EF44CFD
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:25:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id b5so2821674pgb.6
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WXtKc1Skis76MTjC49qNl1llLLLE1O6jaSQt7bDlJ00=;
        b=LLN1PyCuNtLJP31hg/jw5udlBPxnBHULHo1dZDNJIDuWb0283AFmhB8P5iN/B9vtrh
         M2GoDLTYLNOQaCq3awbwhGTdGbjQb0zC5mNE0Im4hqlr953oOxe1SKpOBdVqtchIth52
         tOKpxIkPRrDMKbHBEaYZ++fAm9kKfGxd/ULiBuLUDO7s5MZf14+gDBmhebU6Q9OLRE2i
         +/MnVwOQZ1+Dj/IL5mQY5g6nHY0l7nnRDMO1vZBS8CB0B7Tv23OG4ECTb8h73Kas0iU0
         7kyI+zBXIlGsLZsXKHZnAxHwiGaB+fG3ZZCmRFGr0h9eoJiAqmXiwaama1YdEeq0+g6B
         v7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXtKc1Skis76MTjC49qNl1llLLLE1O6jaSQt7bDlJ00=;
        b=SU5+1900GGkQ39oXVw3yQNJfTKY3JmVmO76p1XrawOLNv/PfIJmHMpzaV7ZpW8HmQ4
         vLpAoLvzS+hatf+BEVSjBBCukXCiJ5Qu0Qz0HOAC6oyokMAXFfqEtJ7i4pGT8NUk2WGb
         H42efyRvWvDYXwxffiHoZuiBNGm99Ty0pqenm8z3ilhqeDAdas4UE8yWkUrWSL5SNjXQ
         Fif/WrdyyfVal7v8jdXufL1dgfls+d+4CfnTxP9w6P+klsoCtfLPFDA7qGS8+4yZAMlV
         wbvOoqT92+E9FVmFKL9PkY4IS7B3LP/xgcT7DPGPvEZRlMtWYXRwVkc4/Zfs2CssUkdY
         goNw==
X-Gm-Message-State: ACrzQf1w3chly3NRYfz9WFxD720ciAOqbebus9UfQ4bx3qSjuD+1oExA
        PJz1EEQ+mj0TTjXFhF+PplqQFA==
X-Google-Smtp-Source: AMsMyM4DcER9kXQVj2PgcEv6TkmlXH7wJ1BMCn03xYmCnoxgMu2tlWOlzuDgT2rlyWpkhPVwwmNakg==
X-Received: by 2002:a65:4d46:0:b0:43b:e00f:8663 with SMTP id j6-20020a654d46000000b0043be00f8663mr16399783pgt.147.1666365952431;
        Fri, 21 Oct 2022 08:25:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m8-20020a170902db0800b0018157b415dbsm15091230plx.63.2022.10.21.08.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 08:25:51 -0700 (PDT)
Date:   Fri, 21 Oct 2022 15:25:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, shan.gavin@gmail.com
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <Y1K5/MN9o7tEvYu5@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com>
 <Y1HO46UCyhc9M6nM@google.com>
 <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022, Gavin Shan wrote:
> I think Marc want to make the check more generalized with a new event [1].

Generalized code can be achieved with a helper though.  The motivation is indeed
to avoid overhead on every run:

  : A seemingly approach would be to make this a request on dirty log
  : insertion, and avoid the whole "check the log size" on every run,
  : which adds pointless overhead to unsuspecting users (aka everyone).


https://lore.kernel.org/kvmarm/87lerkwtm5.wl-maz@kernel.org

> > I'm pretty sure the check can be moved to the very end of the request checks,
> > e.g. to avoid an aborted VM-Enter attempt if one of the other request triggers
> > KVM_REQ_RING_SOFT_FULL.
> > 
> > Heh, this might actually be a bug fix of sorts.  If anything pushes to the ring
> > after the check at the start of vcpu_enter_guest(), then without the request, KVM
> > would enter the guest while at or above the soft limit, e.g. record_steal_time()
> > can dirty a page, and the big pile of stuff that's behind KVM_REQ_EVENT can
> > certainly dirty pages.
> > 
> 
> When dirty ring becomes full, the VCPU can't handle any operations, which will
> bring more dirty pages.

Right, but there's a buffer of 64 entries on top of what the CPU can buffer (VMX's
PML can buffer 512 entries).  Hence the "soft full".  If x86 is already on the
edge of exhausting that buffer, i.e. can fill 64 entries while handling requests,
than we need to increase the buffer provided by the soft limit because sooner or
later KVM will be able to fill 65 entries, at which point errors will occur
regardless of when the "soft full" request is processed.

In other words, we can take advantage of the fact that the soft-limit buffer needs
to be quite conservative.

> > Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
> > about the overhead of having to re-check the request, the goal would be to help
> > document what causes the request to go away.
> > 
> > E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:
> > 
> > 	if (!kvm_dirty_ring_soft_full(ring))
> > 		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> > 
> 
> It's reasonable to clear KVM_REQ_DIRTY_RING_SOFT_FULL when the ring is reseted.
> @vcpu can be achieved by container_of(..., ring).

Using container_of() is silly, there's literally one caller that does:

	kvm_for_each_vcpu(i, vcpu, kvm)
		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
