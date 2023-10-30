Return-Path: <kvm+bounces-129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D37DA7DC057
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 20:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01D381C20AB0
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001E51A27C;
	Mon, 30 Oct 2023 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hh9J8BYP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1119D33F9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 19:24:06 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C14DE
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 12:24:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc591d8177so7041885ad.3
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 12:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698693843; x=1699298643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dGB6dSZQ5h3BaDbAXXnITY/TN6hR2oI3WwWDjEyaftU=;
        b=hh9J8BYPcVVQRuRzypxqPvish8wlXiuvw4+I2mf9TpIy3aDEPQGAfRTDs2tOrvHzpn
         ThDE/sKz4wPOcaEOaSE59afw+b29JyxXB0ovkHGOUeA1ROcGqYpfSeotzK1Kw4/PG4my
         ceR75uh2Bu9dj3lytuCb8vI5AQgPUn46vTV+31RmWcMarv9ZxT5x73NoYNgs4mwsXBKB
         U0CLrcLXlez5bSv6eyCjt9P9slrlyN+H7GJ5NtOdgbHZI8Qgto344O8Nsq0YVX4bOAtX
         OZ9RbcKCfe11Dql/XVqEB8OFTVN4Vg+SLdEKmuBwQGo3BFjo++j+KtWxlOkHeCombQSB
         rAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698693843; x=1699298643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGB6dSZQ5h3BaDbAXXnITY/TN6hR2oI3WwWDjEyaftU=;
        b=eRbLIUqbs7YfJF217+qUbjyEJohJqHlvFvuQCk7B3DIOc1KyfCvQq0NDlaJtFs+QGb
         NUQUKegMlwT41WXmjtah0t3zw9qHEu2JKbv9XVVXJ4w+Z40+kYFDMrJaSDFCWCN1kJdU
         HnVdllM56/niXkUBm4kDQVNymEP4rszrdNSKsDrMfwjTnScR9b1CwrS1XAP5hGPU7P8x
         pEQ3gCLQzDrvkajLICFmqYm/XX/rFd+3RhAYnuRLLNVohG6At0IcGlpRdfbFjXbfwW6Q
         GUt6ahIFadzIWgaQfXHTSe+736Ff4YmvsD+r6b9whf+TiKB84e60T93HKys4asrvNPVB
         d5Yg==
X-Gm-Message-State: AOJu0YxiQsKSZfhgM+N9rqo8Ne/4FzElOY0cDGzic47NHvHANbG+zJ6W
	C1AZfmeQrGBCA1KD+Zpjaqu11xJ/gVw=
X-Google-Smtp-Source: AGHT+IGt0ebEowwZIB8dtEFgv2YGxjnzt21NUYWgAgo30rdG2UxAr4hyLeWNaPrqashnlrivJKBwLReyYzs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:442:b0:1cc:1e05:e0e7 with SMTP id
 iw2-20020a170903044200b001cc1e05e0e7mr157704plb.2.1698693843517; Mon, 30 Oct
 2023 12:24:03 -0700 (PDT)
Date: Mon, 30 Oct 2023 12:24:02 -0700
In-Reply-To: <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com> <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
Message-ID: <ZUAC0jvFE0auohL4@google.com>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yibo Huang <ybhuang@cs.utexas.edu>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 30, 2023, Yan Zhao wrote:
> On Fri, Oct 27, 2023 at 04:13:36PM -0700, Sean Christopherson wrote:
> > E.g. I have a very hard time believing a real world guest kernel mucks with the
> > MTRRs to setup DMA.  And again, this is supported by the absense of bug reports
> > on AMD.
> > 
> > 
> > Yan,
> > 
> > You've been digging into this code recently, am I forgetting something because
> > it's late on a Friday?  Or have we been making the very bad assumption that KVM
> > code from 10+ years ago actually makes sense?  I.e. for non-coherent DMA, can we
> > delete all of the MTRR insanity and simply clear IPAT?
> Not sure if there are guest drivers can program PAT as WB but treat memory type
> as UC.
> In theory, honoring guest MTRRs is the most safe way.
> Do you think a complete analyse of all corner cases are deserved?

I 100% agree that honoring guest MTRRs is the safest, but KVM's current approach
make no sense, at all.  From a hardware virtualization perspective of guest MTRRs,
there is _nothing_ special about EPT.  Legacy shadowing paging doesn't magically
account for guest MTRRs, nor does NPT.

The only wrinkle is that NPT honors gCR0, i.e. actually puts the CPU caches into
no-fill mode, whereas VMX does nothing and forces KVM to (poorly) emulate that
behavior by forcing UC.

TL;DR of the below: Rather than try to make MTRR virtualization suck less for EPT,
I think we should delete that code entirely and take a KVM errata to formally
document that KVM doesn't virtualize guest MTRRs.  In addition to solving the
performance issues with zapping SPTEs for MTRR changes, that'll eliminate 600+
lines of complex code (the overlay shenanigans used for fixed MTRRs are downright
mean).

 arch/x86/include/asm/kvm_host.h |  15 +---
 arch/x86/kvm/mmu/mmu.c          |  16 ----
 arch/x86/kvm/mtrr.c             | 644 ++++++-------------------------------------------------------------------------------------------------------------------------------
 arch/x86/kvm/vmx/vmx.c          |  12 +--
 arch/x86/kvm/x86.c              |   1 -
 arch/x86/kvm/x86.h              |   4 -
 6 files changed, 36 insertions(+), 656 deletions(-)

Digging deeper through the history, this *mostly* appears to be the result of coming
to the complete wrong conclusion for handling memtypes during EPT and VT-d enabling.

The zapping GFNs logic came from

  commit efdfe536d8c643391e19d5726b072f82964bfbdb
  Author: Xiao Guangrong <guangrong.xiao@linux.intel.com>
  Date:   Wed May 13 14:42:27 2015 +0800

    KVM: MMU: fix MTRR update
    
    Currently, whenever guest MTRR registers are changed
    kvm_mmu_reset_context is called to switch to the new root shadow page
    table, however, it's useless since:
    1) the cache type is not cached into shadow page's attribute so that
       the original root shadow page will be reused
    
    2) the cache type is set on the last spte, that means we should sync
       the last sptes when MTRR is changed
    
    This patch fixs this issue by drop all the spte in the gfn range which
    is being updated by MTRR

which was a fix for 

  commit 0bed3b568b68e5835ef5da888a372b9beabf7544
  Author:     Sheng Yang <sheng@linux.intel.com>
  AuthorDate: Thu Oct 9 16:01:54 2008 +0800
  Commit:     Avi Kivity <avi@redhat.com>
  CommitDate: Wed Dec 31 16:51:44 2008 +0200
  
      KVM: Improve MTRR structure
      
      As well as reset mmu context when set MTRR.

(side topic, if anyone wonders why I am so particular about changelogs, the above
is exactly 

Anyways, the above was part of a "MTRR/PAT support for EPT" series that also added

+	if (mt_mask) {
+		mt_mask = get_memory_type(vcpu, gfn) <<
+			  kvm_x86_ops->get_mt_mask_shift();
+		spte |= mt_mask;
+	}

where get_memory_type() was a truly gnarly helper to retrive the guest MTRR memtype
for a given memtype.  And *very* subtly, at the time of that change, KVM *always*
set VMX_EPT_IGMT_BIT,

        kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
                VMX_EPT_WRITABLE_MASK |
                VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT |
                VMX_EPT_IGMT_BIT);

which came in via

  commit 928d4bf747e9c290b690ff515d8f81e8ee226d97
  Author:     Sheng Yang <sheng@linux.intel.com>
  AuthorDate: Thu Nov 6 14:55:45 2008 +0800
  Commit:     Avi Kivity <avi@redhat.com>
  CommitDate: Tue Nov 11 21:00:37 2008 +0200
  
      KVM: VMX: Set IGMT bit in EPT entry
      
      There is a potential issue that, when guest using pagetable without vmexit when
      EPT enabled, guest would use PAT/PCD/PWT bits to index PAT msr for it's memory,
      which would be inconsistent with host side and would cause host MCE due to
      inconsistent cache attribute.
      
      The patch set IGMT bit in EPT entry to ignore guest PAT and use WB as default
      memory type to protect host (notice that all memory mapped by KVM should be WB).

Note the CommitDates!  The AuthorDates strongly suggests Sheng Yang added the whole
IGMT things as a bug fix for issues that were detected during EPT + VT-d + passthrough
enabling, but Avi applied it earlier because it was a generic fix.

Jumping back to 0bed3b568b68 ("KVM: Improve MTRR structure"), the other relevant
code, or rather lack thereof, is the handling of *host* MMIO.  That fix came in a
bit later, but given the author and timing, I think it's safe to say it was all
part of the same EPT+VT-d enabling mess.

  commit 2aaf69dcee864f4fb6402638dd2f263324ac839f
  Author:     Sheng Yang <sheng@linux.intel.com>
  AuthorDate: Wed Jan 21 16:52:16 2009 +0800
  Commit:     Avi Kivity <avi@redhat.com>
  CommitDate: Sun Feb 15 02:47:37 2009 +0200

    KVM: MMU: Map device MMIO as UC in EPT
    
    Software are not allow to access device MMIO using cacheable memory type, the
    patch limit MMIO region with UC and WC(guest can select WC using PAT and
    PCD/PWT).

In addition to the host MMIO and IGMT issues, this code was obviously never tested
on NPT until much later, which lends further credence to my theory/argument that
this was all the result of misdiagnosed issues.

Discussion from the EPT+MTRR enabling thread[*] more or less confirms that Sheng
Yang was trying to resolve issues with passthrough MMIO.

 * Sheng Yang 
  : Do you mean host(qemu) would access this memory and if we set it to guest 
  : MTRR, host access would be broken? We would cover this in our shadow MTRR 
  : patch, for we encountered this in video ram when doing some experiment with 
  : VGA assignment. 

And in the same thread, there's also what appears to be confirmation of Intel
running into issues with Windows XP related to a guest device driver mapping
DMA with WC in the PAT.  Hilariously, Avi effectively said "KVM can't modify the
SPTE memtype to match the guest for EPT/NPT", which while true, completely overlooks
the fact that EPT and NPT both honor guest PAT by default.  /facepalm
 
 * Avi Kavity
  : Sheng Yang wrote:
  : > Yes... But it's easy to do with assigned devices' mmio, but what if guest 
  : > specific some non-mmio memory's memory type? E.g. we have met one issue in 
  : > Xen, that a assigned-device's XP driver specific one memory region as buffer, 
  : > and modify the memory type then do DMA.
  : >
  : > Only map MMIO space can be first step, but I guess we can modify assigned 
  : > memory region memory type follow guest's? 
  : >   
  : 
  : With ept/npt, we can't, since the memory type is in the guest's 
  : pagetable entries, and these are not accessible.

[*] https://lore.kernel.org/all/1223539317-32379-1-git-send-email-sheng@linux.intel.com

So, for the most part, what I think happened is that 15 years ago, a few engineers
(a) fixed a #MC problem by ignoring guest PAT and (b) initially "fixed" passthrough
device MMIO by emulating *guest* MTRRs.  Except for the below case, everything since
then has been a result of those two intertwined changes.

The one exception, which is actually yet more confirmation of all of the above,
is the revert of Paolo's attempt at "full" virtualization of guest MTRRs:

  commit 606decd67049217684e3cb5a54104d51ddd4ef35
  Author: Paolo Bonzini <pbonzini@redhat.com>
  Date:   Thu Oct 1 13:12:47 2015 +0200

    Revert "KVM: x86: apply guest MTRR virtualization on host reserved pages"
    
    This reverts commit fd717f11015f673487ffc826e59b2bad69d20fe5.
    It was reported to cause Machine Check Exceptions (bug 104091).

...

  commit fd717f11015f673487ffc826e59b2bad69d20fe5
  Author: Paolo Bonzini <pbonzini@redhat.com>
  Date:   Tue Jul 7 14:38:13 2015 +0200

    KVM: x86: apply guest MTRR virtualization on host reserved pages
    
    Currently guest MTRR is avoided if kvm_is_reserved_pfn returns true.
    However, the guest could prefer a different page type than UC for
    such pages. A good example is that pass-throughed VGA frame buffer is
    not always UC as host expected.
    
    This patch enables full use of virtual guest MTRRs.

I.e. Paolo tried to add back KVM's behavior before "Map device MMIO as UC in EPT"
and got the same result: machine checks, likely due to the guest MTRRs not being
trustworthy/sane at all times.

And FWIW, Paolo also tried to enable MTRR virtualization on NP, but that too got
reverted.  I read through the threads, and AFAICT no one ever found a smoking gun,
i.e. exactly why emulating guest MTRRs via NPT PAT caused extremely slow boot times
doesn't appear to have a definitive root cause.

  commit fc07e76ac7ffa3afd621a1c3858a503386a14281
  Author: Paolo Bonzini <pbonzini@redhat.com>
  Date:   Thu Oct 1 13:20:22 2015 +0200

    Revert "KVM: SVM: use NPT page attributes"
    
    This reverts commit 3c2e7f7de3240216042b61073803b61b9b3cfb22.
    Initializing the mapping from MTRR to PAT values was reported to
    fail nondeterministically, and it also caused extremely slow boot
    (due to caching getting disabled---bug 103321) with assigned devices.

...

  commit 3c2e7f7de3240216042b61073803b61b9b3cfb22
  Author: Paolo Bonzini <pbonzini@redhat.com>
  Date:   Tue Jul 7 14:32:17 2015 +0200

    KVM: SVM: use NPT page attributes
    
    Right now, NPT page attributes are not used, and the final page
    attribute depends solely on gPAT (which however is not synced
    correctly), the guest MTRRs and the guest page attributes.
    
    However, we can do better by mimicking what is done for VMX.
    In the absence of PCI passthrough, the guest PAT can be ignored
    and the page attributes can be just WB.  If passthrough is being
    used, instead, keep respecting the guest PAT, and emulate the guest
    MTRRs through the PAT field of the nested page tables.
    
    The only snag is that WP memory cannot be emulated correctly,
    because Linux's default PAT setting only includes the other types.

In other words, my reading of the tea leaves is that honoring guest MTRRs for VMX
was initially a workaround of sorts for KVM ignoring guest PAT *and* for KVM not
forcing UC for host MMIO.  And while there *are* known cases where honoring guest
MTRRs is desirable, e.g. passthrough VGA frame buffers, the desired behavior in
that case is to get WC instead of UC, i.e. at this point it's for performance,
not correctness.

Furthermore, the complete absense of MTRR virtualization on NPT and shadow paging
proves that while KVM theoretically can do better, it's by no means necessary for
correctnesss.

Lastly, I would argue that since kernels mostly rely on firmware to do MTRR setup,
and the host typically provides guest firmware, honoring guest MTRRs is effectively
honoring *host* userspace memtypes, which is also backwards, i.e. it would be far
better for host userspace to communicate its desired directly to KVM (or perhaps
indirectly via VMAs in the host kernel, just not through guest MTRRs).

