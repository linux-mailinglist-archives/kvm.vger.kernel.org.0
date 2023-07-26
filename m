Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30427763FF5
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 21:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjGZTv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 15:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjGZTv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 15:51:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAE4189
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 12:51:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d052f49702dso121390276.3
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 12:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690401085; x=1691005885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SYrzFDTuuSJZKYNzTYSbOz1luDGV+2s6LzOYbnZf1J8=;
        b=2nJqtx4kbI4+5JxgdpiHexsdX/YlcLzizo0l24j7eedr2y37Pr0apAxCtTJ1VjxsQB
         SR2PSLKX0gNW1dW3drEVCNg9jSA/BFP3In68gieYvHx60WEF0QNWLfUq6UAp4zlpHYYw
         PSgpE9DUJIuVbWcwidlEzlCU3a9zBH3Ail0+i9Ev5yg5YiDFwyjHGOVis/I1+PSVQaIB
         NJussd6dSET0WNyJ8CR0+E0F5u+f1aow8dheWBpUePh1WlN7s3XJEujjr+NtixtwqJuv
         CnilTb2rJf+o+ItGdizeUyBFt6bWGG7htKllMtQ/MV48edIJ83NwGkzmtmLkupHe7+/N
         psNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690401085; x=1691005885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SYrzFDTuuSJZKYNzTYSbOz1luDGV+2s6LzOYbnZf1J8=;
        b=czOHlWETnEM5BfKT9BcXFYcRr7EGmh9CsiE1p4k35DzqZ5NmbIGS6hhzi3SE2/5HVs
         0sUMsff3KL5sIqCSCbmJ28MMyCrJCBeLugZ2tnBhtypuhcFJN67tjajhxPcMWvaBnx2y
         2OQ0Xj8AcEiWCfvT10tZUqAsgrQZtW2IpwM2ht7Sm3HGszA/hCRge4foPrjahWeC+40y
         vh7P0BcQGDUoZGRd6F/4PxWz+okKURcjaiGKufBM7o4nFRezUJWH4iYSwjpQRJCAgPbv
         9/eUzi9GomK3QOToxhCXTHTHsC51jEyKZz9ZBz2XkyX6ujADWuAfqozqu3Lm1Nfs1tR+
         xK4g==
X-Gm-Message-State: ABy/qLaKsz8YWA8KIQHCkR4piHINeChiqzTpR03MdE1Z4urtcfvtL+oZ
        PeGgrY2015nr+hwB8HV0LZ4i8pPBAGo=
X-Google-Smtp-Source: APBJJlEHYb+AdLvOArQhp87xeelIRyABVpqNv3antT1AF7mZtyrVG5E++bm6Xq5qwdhpOs4V2yINc44O8Oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:814a:0:b0:d1a:4d0e:c11c with SMTP id
 j10-20020a25814a000000b00d1a4d0ec11cmr18409ybm.11.1690401084844; Wed, 26 Jul
 2023 12:51:24 -0700 (PDT)
Date:   Wed, 26 Jul 2023 12:51:23 -0700
In-Reply-To: <27f998f5-748b-c356-9bb6-813573c758e5@cs.utexas.edu>
Mime-Version: 1.0
References: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
 <ZMFVLiC3YvPY3bSP@google.com> <27f998f5-748b-c356-9bb6-813573c758e5@cs.utexas.edu>
Message-ID: <ZMF5O6Tq1UTQHvX0@google.com>
Subject: Re: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
From:   Sean Christopherson <seanjc@google.com>
To:     Yahya Sohail <ysohail@cs.utexas.edu>
Cc:     kvm@vger.kernel.org
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

On Wed, Jul 26, 2023, Yahya Sohail wrote:
> On 7/26/23 12:17, Sean Christopherson wrote:
> > > If so, what fields in the kvm_run struct should I check that could cause such
> > > an issue?
> > 
> > Heh, all of them.  I'm only somewhat joking.  Root causing "invalid control field"
> > errors on bare metal is painfully difficult, bordering on impossible if you don't
> > have something to give you a hint as to what might be going wrong.
> 
> I suppose that's what I was expecting, but was hoping it could be narrowed
> down a bit. Could the values of the CPU control registers or other special
> registers set with KVM_SET_SREGS also cause this error (with
> hardware_entry_failure_reason = 7)? I'd expect this not to be possible
> because I don't think the CPU registers are part of the VMCS, but I'm not
> very familiar with VMX.
> 
> I do know that the emulator I'm copying state from likely doesn't consider
> all bits in the control fields, so it's possible that they're in an invalid
> state. When I ran the model before with the value for cr0 copied out of the
> emulator I also got KVM_EXIT_FAIL_ENTRY, but with a different value for
> hardware_entry_failure_reason = 0x80000021. I fixed this by changing the
> value of cr0 to be (hopefully) valid.

What were the before and after values of CR0?

> > If you can, try running a nested setup, i.e. run a normal Linux guest as your L1
> > VM (L0 is bare metal), and then run your problematic x86 emulator VM within that
> > L1 guest (that's your L2).  Then, in L0 (your bare metal host), enable the
> > kvm_nested_vmenter_failed tracepoint.
> > 
> > The kvm_nested_vmenter_failed tracepoint logs all VM-Enter failures that _KVM_
> > detects when L1 attempts a nested VM-Enter from L1 to L2.  If you're at all lucky,
> > KVM in L0 (acting a the CPU from L1's perspective) will detect the invalid state
> > and explicitly log which consistency check failed.
> 
> I did this and had an interesting result. Instead of exiting with
> KVM_EXIT_FAIL_ENTRY, it exited with KVM_EXIT_UNkNOWN, and
> hardware_exit_reason = 0.

Hrm, what kernel version are you running as L1?  KVM on x86 doesn't explicitly
return KVM_EXIT_UNKNOWN except in a few paths that I highly doubt you are hitting.

> I also didn't get anything logged from the kvm_nested_vmenter_failed trace
> point. When I checked the value of rip after KVM_RUN, it was the same as the
> starting value, so it probably failed without executing any instructions.
> 
> I then tried setting the kvm_nested_vmexit tracepoint to see if I could get
> any more information about the vmexit. When the vmexit occurred, I got a
> line in the log that looked like this:
> 
> CPU 3/KVM-9310    [013] ....  6076.453278: kvm_nested_vmexit: vcpu 3 reason
> EPT_VIOLATION rip 0x103c00 info1 0x0000000000000781 info2 0x000000008000030d
> intr_info 0x00000000 error_code 0x00000000

So getting an EPT violation VM-Exit means the VM-Entry was successful.  Are you
running different kernel versions for L0 versus L1?  If so, it's possible that
there's a bug (or bug fix) in one kernel and not the other.

> It appears this occurred due to an EPT_VIOLATION. I have some questions:
> I believe an EPT_VIOLATION is caused by trying to access physical memory
> that is not mapped. Is that correct?

Yep.  The "info1 0x0000000000000781" from above is the EXIT_QUALIFICATION field,
which for EPT violations is equivalent to a #PF error code.  0x781 means a read
access faulted and the mapping was !present, e.g. as opposed to the mapping
being !readable (EPT supports execute-only mappings).

The other interesting bit is "info 0x000000008000030d", which is the vectoring
info.  That value means that the EPT violation occurred while the CPU was trying
to deliver a #GP in the guest.  In and of itself, that isn't fatal, but it does
suggest that something might be going wrong in the emulator.

> Also, could this be the same error that causes the KVM_EXIT_FAIL_ENTRY when
> running the VM as L1, or must that be a separate issue?

Maybe?  EPT violations themselves are not errors (ignore the "violation" part,
it's not as scary as it sounds).  But if the exit to userspace is related to the
EPT violation, I would expect uuuKVM_EXIT_MMIO, not KVM_EXIT_UNKNOWN.

> I know that the paging code of the emulator the state is from is a little
> suspect (in fact, one of my reasons to get this VM working in KVM is to help
> debug the emulator), and it is possible that the page tables of the VM are
> not setup properly and are mapping linear addresses to unexpected physical
> addresses and causing an EPT_VIOLATION. I'll have to look into that further.

Turn on the kvm_page_fault tracepoint, that will give the gpa on which the fault
occurs.
