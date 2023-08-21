Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DBC78367D
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 01:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjHUXv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 19:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjHUXvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 19:51:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AE4E4
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:51:53 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c091a563ecso2034015ad.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692661913; x=1693266713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R9kwXbxGqC2001JeIj0CmrBymKegw93JF6oDL4dUht8=;
        b=HUOUJzHbrAHEXoNqx1aKECL4Pqp+UBl5DDDPY30HMa0pciRQAToFINptSvJba9QvNy
         Qi5s31Pe5s5eozWnoXELue4YqgFa7flqvMwDpdRH3jHggvYbkROEbzRL5Ut5iUGJqG/Z
         kHy9JCfwDz0X2YwltlGeLoXWFpQg+KqDfvRpjTOpGOPDahtqn5BJWEYqdbXeqHNx7lgL
         mzn4FJcK866OeH7hFhCj8j5Kvd3zshaLZWbokaABjBDW1jIYWUu9cJGC4fo61M8mGG2N
         hIEMRwweMt66JVLx5og5i4GNTuURSNXsT+WjbtglV+CFte/rzm0WTJIeDVwR+DpNCAMl
         LGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692661913; x=1693266713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9kwXbxGqC2001JeIj0CmrBymKegw93JF6oDL4dUht8=;
        b=YJc3DuzBovaKSWlMF+ZC3IltsjT3IguV5Q2mFGApnDmXseOYqb4X7TxE2LdieQ6nju
         3QsYz3RS53qmWevUhjZpqVOHRK+RXSqas74AFIwZ58lBQXvuD4WxGsgGGAK6mLsKPVnV
         LxiHH5kLkNqIN5x3w6nyV/KwJspP/SfuLRc+/6ZcK8h4jMNBcwPCRJHibE9XGdpwoEdN
         qiwI5AVOOQh/QsD/J4vT5eR0TVHn1F7b3JvY+JWyaERyhqhbK8VtcE0Vcu55vQNFwCSF
         KEgYmxCev2y2gRvvqpjYq0sbuzjoIaUkrGB3Rgtg21GBIpfMI9/oLJDJG4zYQ128fBsu
         pdmQ==
X-Gm-Message-State: AOJu0YyZrFN2hgClUFYZ7DQMw5euSOyQy5Oqk2wwqiD0OXt/fsXqwjKP
        JyCPV0kv8oqz0kVg7jOqp6YTbzHLMDQ=
X-Google-Smtp-Source: AGHT+IGrpNpYKpmY2+C60IDwBDm35jOcXkZDKm6a5vKqYEDGny5+Ma7BA1Q+u3+7gVTuFOOZTAR+IHbFlOE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f203:b0:1bc:e6a:205e with SMTP id
 m3-20020a170902f20300b001bc0e6a205emr3558227plc.5.1692661913113; Mon, 21 Aug
 2023 16:51:53 -0700 (PDT)
Date:   Mon, 21 Aug 2023 16:51:51 -0700
In-Reply-To: <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net>
Mime-Version: 1.0
References: <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
 <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
 <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
 <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
 <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net>
Message-ID: <ZOP4lwiMU2Uf89eQ@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023, Eric Wheeler wrote:
> On Fri, 18 Aug 2023, Eric Wheeler wrote:
> > On Fri, 18 Aug 2023, Sean Christopherson wrote:
> > > On Thu, Aug 17, 2023, Eric Wheeler wrote:
> > > > On Thu, 17 Aug 2023, Sean Christopherson wrote:
> > > > > > > kprobe:handle_ept_violation
> > > > > > > {
> > > > > > > 	printf("vcpu = %lx pid = %u MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> > > > > > > 	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> > > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> > > > > > > }
> > > > > > > 
> > > > > > > If you don't have BTF info, we can still use a bpf program, but to get at the
> > > > > > > fields of interested, I think we'd have to resort to pointer arithmetic with struct
> > > > > > > offsets grab from your build.
> > > > > > 
> > > > > > We have BTF, so hurray for not needing struct offsets!
> 
> We found a new sample in 6.1.38, right after a lockup, where _all_ log 
> entries show inprog=1, in case that is interesting. Here is a sample, 
> there are 500,000+ entries so let me know if you want the whole log.
> 
> To me, these are opaque numbers.  What do they represent?  What are you looking for in them?

inprog is '1' if there is an in-progress mmu_notifier invalidation at the time
of the EPT violation.  start/end are the range that is being invalidated _if_
there is an in-progress invalidation.  If a vCPU were stuck with inprog=1, then
the most likely scenario is that there's an unpaired invalidation, i.e. something
started an invalidation but never completed it.

seq is a sequence count that is incremented when an invalidation completes, e.g.
if a vCPU was stuck and seq were constantly changing, then it would mean that
the primary MMU is invalidating the same range over and over so quickly that the
vCPU can't make forward progress.

>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854227 inprog=1 start=7fa3183a3000 end=7fa3183a4000

...

> > The entire dump is 22,687 lines if you want to see it, here (expires in 1 week):
> > 
> > 	https://privatebin.net/?9a3bff6b6fd2566f#BHjrt4NGpoXL12NWiUDpThifi9E46LNXCy7eWzGXgqYx

Hrm, so it doesn't look like there's an mmu_notifier bug.  None of the traces show
inprog being '1' for more than a single EPT violation, i.e. there's no incomplete
invalidation.  And the stuck vCPU sees a stable sequence count, so it doesn't appear
to be racing with an invalidation, e.g. in theory an invalidation could start and
finish between the initial VM-Exit and when KVM tries to "fix" the fault.

4983329 ept[0] vcpu=ffff9c533e1da340 seq=8002c058 inprog=0 start=7fb47c1f5000 end=7fb47c1f6000
7585048 ept[0] vcpu=ffff9c533e1da340 seq=8002c058 inprog=0 start=7fb47c1f5000 end=7fb47c1f6000
1234546 ept[0] vcpu=ffff9c533e1da340 seq=8002c058 inprog=0 start=7fb47c1f5000 end=7fb47c1f6000
 865885 ept[0] vcpu=ffff9c533e1da340 seq=8002c058 inprog=0 start=7fb47c1f5000 end=7fb47c1f6000
4548972 ept[0] vcpu=ffff9c533e1da340 seq=8002c058 inprog=0 start=7fb47c1f5000 end=7fb47c1f6000
1091282 ept[0] vcpu=ffff9c533e1da340 seq=8002c058 inprog=0 start=7fb47c1f5000 end=7fb47c1f6000

Below is another bpftrace program that will hopefully shrink the haystack to
the point where we can find something via code inspection.

Just a heads up, if we don't find a smoking gun, I likely won't be able to help
beyond high level guidance as we're approaching what I can do with bpftrace without
a significant time investment (which I can't make).

---
struct kvm_page_fault {
	const gpa_t addr;
	const u32 error_code;
	const bool prefetch;

	const bool exec;
	const bool write;
	const bool present;
	const bool rsvd;
	const bool user;

	const bool is_tdp;
	const bool nx_huge_page_workaround_enabled;

	bool huge_page_disallowed;
	u8 max_level;

	u8 req_level;

	u8 goal_level;

	gfn_t gfn;

	struct kvm_memory_slot *slot;

	kvm_pfn_t pfn;
	unsigned long hva;
	bool map_writable;
};

kprobe:handle_ept_violation
{
	$vcpu = (struct kvm_vcpu *)arg0;
	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;

	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
		printf("PID = %u stuck, taken = %lu, emulated = %lu, fixed = %lu, spurious = %lu\n",
		       pid, $vcpu->stat.pf_taken, $vcpu->stat.pf_emulate, $vcpu->stat.pf_fixed, $vcpu->stat.pf_spurious);
	}
}

kprobe:kvm_faultin_pfn
{
	$vcpu = (struct kvm_vcpu *)arg0;
	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;

	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
		$fault = (struct kvm_page_fault *)arg1;
		$flags = 0;

		if ($fault->slot != 0) {
			$flags = $fault->slot->flags;
		}

		printf("PID = %u stuck, reached kvm_faultin_pfn(), slot = %lx, flags = %lx\n",
		       pid, arg1, $flags);
	}
}

kprobe:make_mmio_spte
{
	$vcpu = (struct kvm_vcpu *)arg0;
	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;

	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
		printf("PID %u stuck, reached make_mmio_spte()", pid);
	}
}

kprobe:make_spte
{
	$vcpu = (struct kvm_vcpu *)arg0;
	$nr_handled = $vcpu->stat.pf_emulate + $vcpu->stat.pf_fixed + $vcpu->stat.pf_spurious;

	if (($vcpu->stat.pf_taken / 5) > $nr_handled) {
		printf("PID %u stuck, reached make_spte()", pid);
	}
}

