Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B976784517
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 17:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjHVPMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 11:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjHVPMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 11:12:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBE5126
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 08:11:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d6861869bcdso5940384276.3
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 08:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692717119; x=1693321919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5iy/RN0kpG97By2UkREvgvhM+JVh2B2LgflE45qznyU=;
        b=WUz/Qcd0VkxDPOlm5lvm/+7vjn52lB1V+IgMNyQ7S8YEqefLXUoeVaXQRxeIUUnUdk
         aQCameVOtRa2pKAAth/6OwDbaXZ3gIfEk/svEQt9Ms+0I6hAJRfF204+XfpmqwoSSlIW
         GwMwm6uDBaZO6KKaPrB5p8oMJJsHzSeuFBs5fHglkGfBq8LQY8j1O7UCPs6WJKapiflP
         Ze4Iu6JJ+dg5p3oPILl027q30sf/rt6C8z5k8oT/Ty0dZ8LmHILyFR+aO9I+WVEpU2az
         1YfbuVz9GsdfaPr8JFx03ELyT1lpKqzpMhNVqDZGdNZvR9ERl/KtqTYmkZKZphCoV+bS
         OxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692717119; x=1693321919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5iy/RN0kpG97By2UkREvgvhM+JVh2B2LgflE45qznyU=;
        b=RkDluXH7uGqF5oUJXuXnmvzDvgslN7dE7T+l+yWH+f7aYLqPEkhLFftmIGUhR1CpV3
         fxdlkJSyQkOly8c75672anpwpp5Qi5M4X+YgLszcktOM+pECBGZHmKPAWcV5XpYvuiY9
         SF6S6ri3CwiOR6KquBP3MCavGgSsGCTkRxdWDBaQ0+sOHy0OT+RcNyxBJg/srtT3st3a
         eUXp0BPYiUQk6HmvRii7Fhg5xDoCjlPRu4auwiYfShE/lemxY/UL07ZSKTgBRwHI9P6s
         6VYXhh7vdu6vkjN1gjSiTquP+H2HLsyVtG+DdniA71mcqck71c0zmB4bG5crZvcG5wvo
         xPaQ==
X-Gm-Message-State: AOJu0YygPTDBlrD5eSzEh9TCQ7VMUA2gexen3HGVMNxWfeEh69aBpO7O
        O0zo67F1cXR1T9hRSbSKvs8LK01CqBk=
X-Google-Smtp-Source: AGHT+IGK37btXhrXre4xH5U2TlHI5KSbRiBRn4iwOWPcbf0QHL+hcXSTyANGL2Yl+hL5nRlcwkImkEJJx5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa06:0:b0:d15:d6da:7e97 with SMTP id
 s6-20020a25aa06000000b00d15d6da7e97mr101550ybi.3.1692717119189; Tue, 22 Aug
 2023 08:11:59 -0700 (PDT)
Date:   Tue, 22 Aug 2023 08:11:57 -0700
In-Reply-To: <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net>
Mime-Version: 1.0
References: <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
 <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
 <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
 <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
 <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com>
 <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net>
Message-ID: <ZOTQPUk5kxskDcsi@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023, Eric Wheeler wrote:
> On Mon, 21 Aug 2023, Sean Christopherson wrote:
> > On Mon, Aug 21, 2023, Eric Wheeler wrote:
> > > On Fri, 18 Aug 2023, Eric Wheeler wrote:
> > > > On Fri, 18 Aug 2023, Sean Christopherson wrote:
> > > > > On Thu, Aug 17, 2023, Eric Wheeler wrote:
> > > > > > On Thu, 17 Aug 2023, Sean Christopherson wrote:
> > > To me, these are opaque numbers.  What do they represent?  What are you looking for in them?
> > 
> > inprog is '1' if there is an in-progress mmu_notifier invalidation at the time
> > of the EPT violation.  start/end are the range that is being invalidated _if_
> > there is an in-progress invalidation.  If a vCPU were stuck with inprog=1, then
> > the most likely scenario is that there's an unpaired invalidation, i.e. something
> > started an invalidation but never completed it.
> > 
> > seq is a sequence count that is incremented when an invalidation completes, e.g.
> > if a vCPU was stuck and seq were constantly changing, then it would mean that
> > the primary MMU is invalidating the same range over and over so quickly that the
> > vCPU can't make forward progress.
> 
> Here is another one, I think you described exactly this: the vcpu is 
> always the same, and the sequence increments, forever:
> 
>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854227 inprog=1 start=7fa3183a3000 end=7fa3183a4000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854228 inprog=1 start=7fa3183a3000 end=7fa3183a4000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854229 inprog=1 start=7fa3183a4000 end=7fa3183a5000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=8085422a inprog=1 start=7fa3183a4000 end=7fa3183a5000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=8085422b inprog=1 start=7fa3183a8000 end=7fa3183a9000
>       2 ept[0] vcpu=ffff9964cdc48000 seq=8085422d inprog=1 start=7fa3183a9000 end=7fa3183aa000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=8085422e inprog=1 start=7fa3183a9000 end=7fa3183aa000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854232 inprog=1 start=7fa3183ac000 end=7fa3183ad000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854233 inprog=1 start=7fa3183ad000 end=7fa3183ae000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854235 inprog=1 start=7fa3183ae000 end=7fa3183af000
>       1 ept[0] vcpu=ffff9964cdc48000 seq=80854236 inprog=1 start=7fa3183ae000 end=7fa3183af000
> 
> Here is the whole log with 500,000+ lines over 5 minutes of recording, it 
> was first stuck on one vcpu for most of the time, and toward the end it 
> was stuck on a different VCPU:
> 
> The file starts with 555,596 occurances of vcpu=ffff9964cdc48000 and is 
> then followed by 31,784 occurances of vcpu=ffff9934ed50c680.  As you can 
> see in the file, they are not interleaved:
> 
> 	https://www.linuxglobal.com/out/handle_ept_violation.log2
> 
>   # awk '{print $3}' handle_ept_violation.log2 |uniq -c
>    555596 vcpu=ffff9964cdc48000
>     31784 vcpu=ffff9934ed50c680

Hrm, but the address range being invalidated is changing.  Without seeing the
guest RIP, or even a timestamp, it's impossible to tell if the vCPU is well and
truly stuck or if it's just getting thrashed so hard by NUMA balancing or KSM
that it looks stuck.

Drat.

> > Below is another bpftrace program that will hopefully shrink the 
> > haystack to the point where we can find something via code inspection.
> 
> Ok thanks, we'll give it a try.

Try this version instead.  It's more comprehensive and more precise, e.g. should
only trigger on the guest being 100% stuck, and also fixes a PID vs. TID goof.

Note!  Enable trace_kvm_exit before/when running this to ensure KVM grabs the guest RIP
from the VMCS.  Without that enabled, RIP from vcpu->arch.regs[16] may be stale.

struct kvm_page_fault {
	const u64 addr;
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

	u64 gfn;

	struct kvm_memory_slot *slot;

	u64 pfn;
	unsigned long hva;
	bool map_writable;
};

kprobe:kvm_faultin_pfn
{
	$vcpu = (struct kvm_vcpu *)arg0;
	$kvm = $vcpu->kvm;
	$rip = $vcpu->arch.regs[16];

	if (@last_rip[tid] == $rip) {
		@same[tid]++
	} else {
		@same[tid] = 0;
	}
	@last_rip[tid] = $rip;

	if (@same[tid] > 1000) {
		$fault = (struct kvm_page_fault *)arg1;
		$hva = -1;
		$flags = 0;

		if ($fault->slot != 0) {
			$hva = $fault->slot->userspace_addr +
			       (($fault->gfn - $fault->slot->base_gfn) << 12);
			$flags = $fault->slot->flags;
		}

		printf("%s tid[%u] pid[%u] stuck @ rip %lx (%lu hits), gpa = %lx, hva = %lx : MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip, @same[tid], $fault->addr, $hva,
		       $kvm->mmu_invalidate_seq, $kvm->mmu_invalidate_in_progress,
		       $kvm->mmu_invalidate_range_start, $kvm->mmu_invalidate_range_end);
	}
}

kprobe:make_mmio_spte
{
        if (@same[tid] > 1000) {
	        $vcpu = (struct kvm_vcpu *)arg0;
		$rip = $vcpu->arch.regs[16];

		printf("%s tid[%u] pid[%u] stuck @ rip %lx made it to make_mmio_spte()\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip);
	}
}

kprobe:make_spte
{
        if (@same[tid] > 1000) {
	        $vcpu = (struct kvm_vcpu *)arg0;
		$rip = $vcpu->arch.regs[16];

		printf("%s tid[%u] pid[%u] stuck @ rip %lx made it to make_spte()\n",
		       strftime("%H:%M:%S:%f", nsecs), tid, pid, $rip);
	}
}
