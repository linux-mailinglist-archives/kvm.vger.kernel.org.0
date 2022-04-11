Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F0A4FC5EC
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 22:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349922AbiDKUjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 16:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349900AbiDKUjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 16:39:42 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2909C1BEA3
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 13:37:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a42so9064257pfx.7
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 13:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AYKc8ZeDRNtBCWJwQpHr7JcieMpfMfOkAMNDb3v8MjY=;
        b=hWfvTE+5RKFSbpiLlmi4b5/iTRF1eQULyL8xZLRHFm/u7l3Rwd4oaMM4vBtwvH50/k
         Rfbpsu+k4nTnFXBMH8k1khmANVJhl97UDy89rTpe+kU+G8brFoXwN2GDFh66yJIEa7ck
         YIySXZvImVcfXLw6QOukQllDrCv0GF9RZ3uOrD9fFcE4AqJvZ4Z2ow7aIeEeDfCl6ZJe
         0/F+KgoA7GWxPW4Of9ImDmNwgX4rvnLAquVYP2o4DKwx8UHlS89VOeCAjdPlb1TXUSSd
         0p3CLTXgdOmzPrXX38+m5G5kLFldgONBUfWxwC6td0eDBUq+BccnCu/0m4WPZ+GAL4Tw
         u/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AYKc8ZeDRNtBCWJwQpHr7JcieMpfMfOkAMNDb3v8MjY=;
        b=AKDtlG3869+PQjERt5k4NYick8nXnW5yq8bYKZvydwamCSq9xrnW9IDT21pZ/sK9SY
         kv5sQooMArfIrmJ1uo9p7EcI4m6dnD5nQZ0vhgDjcwfl7gh44MepeSwawKJ3rQ8dxJc7
         Lthsa2BhQXRRaLBpNmw9+DMbP+q3kvcqFQqFyb2Ti2iGejWTHQo85TJCwl3Pv/hE9+WT
         cX2MQzFSFP9k10LoXA+FNTq3VT0WosR+HFrqc1SGDyKa0DEbx+kM2uOjN5J6aGlUFw77
         A2Tuw8l9w5zwsU46mlUyHheWQdc034PBUUprcEhP2dod+qoNXjgWBBXNJf49j2lJO3AN
         mRuQ==
X-Gm-Message-State: AOAM530ssNZVoLgMH2HyQcwn3e2s/mTCBFgi5VVIP7oecVttH8cxjN0P
        bMLgNCUFzNCD1m84vYqfF4jt7A==
X-Google-Smtp-Source: ABdhPJzZ64CwOXnrawiJRiNmvAMK3O1eLGBgCgolpctZJ4DZKuhTsSiJwt0g7J+Rh+QifwXJbj/jXQ==
X-Received: by 2002:a63:2263:0:b0:399:561e:810b with SMTP id t35-20020a632263000000b00399561e810bmr27472837pgm.615.1649709446436;
        Mon, 11 Apr 2022 13:37:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gt14-20020a17090af2ce00b001c701e0a129sm327234pjb.38.2022.04.11.13.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 13:37:25 -0700 (PDT)
Date:   Mon, 11 Apr 2022 20:37:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/31] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <YlSRgiKPkNZTBpl+@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-4-vkuznets@redhat.com>
 <Yk8i+A3E9/JL96A2@google.com>
 <87a6cr7t5k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6cr7t5k.fsf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> >> @@ -1840,15 +1891,47 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
> >>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> >> -
> >> -	kvm_vcpu_flush_tlb_guest(vcpu);
> >> -
> >> -	if (!hv_vcpu)
> >> +	struct kvm_vcpu_hv_tlbflush_entry *entry;
> >> +	int read_idx, write_idx;
> >> +	u64 address;
> >> +	u32 count;
> >> +	int i, j;
> >> +
> >> +	if (!tdp_enabled || !hv_vcpu) {
> >> +		kvm_vcpu_flush_tlb_guest(vcpu);
> >>  		return;
> >> +	}
> >>  
> >>  	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
> >> +	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
> >> +	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
> >> +
> >> +	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
> >> +	smp_rmb();
> >>  
> >> -	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
> >> +	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
> >> +		entry = &tlb_flush_ring->entries[i];
> >> +
> >> +		if (entry->flush_all)
> >> +			goto out_flush_all;
> >> +
> >> +		/*
> >> +		 * Lower 12 bits of 'address' encode the number of additional
> >> +		 * pages to flush.
> >> +		 */
> >> +		address = entry->addr & PAGE_MASK;
> >> +		count = (entry->addr & ~PAGE_MASK) + 1;
> >> +		for (j = 0; j < count; j++)
> >> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
> >> +	}
> >> +	++vcpu->stat.tlb_flush;
> >> +	goto out_empty_ring;
> >> +
> >> +out_flush_all:
> >> +	kvm_vcpu_flush_tlb_guest(vcpu);
> >> +
> >> +out_empty_ring:
> >> +	tlb_flush_ring->read_idx = write_idx;
> >
> > Does this need WRITE_ONCE?  My usual "I suck at memory ordering" disclaimer applies.
> >
> 
> Same here) I *think* we're fine for 'read_idx' as it shouldn't matter at
> which point in this function 'tlb_flush_ring->read_idx' gets modified
> (relative to other things, e.g. actual TLB flushes) and there's no
> concurency as we only have one reader (the vCPU which needs its TLB
> flushed). On the other hand, I'm not against adding WRITE_ONCE() here
> even if just to aid an unprepared reader (thinking myself couple years
> in the future).

Ah, read_idx == tail and write_idx == head.  I didn't look at the structure very
closely, or maybe not at all :-)  And IIUC, only the vCPU itself ever writes to
tail?  In that case, I would omit the READ_ONCE() from both the write to tail here
and the read above, and probably add a brief comment stating that the flush must
be performed on the target vCPU, i.e. must hold vcpu->mutex, and so it's safe for
the compiler to re-read tlb_flush_ring->read_idx in the loop because it cannot
change.
