Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51777FDC1
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354295AbjHQSWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354238AbjHQSWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:22:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCA43A97
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 11:21:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d72403b9e03so169908276.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 11:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692296465; x=1692901265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJ/AmT87XjwjHbKdAHeyGn9OgBJOQ1lFwCiDbKXb6nM=;
        b=wMrw9lMFcEffCcRcJtV5g/0/iLKduBVIcEgiIFSA8IrJkJkeTZMPTrR/QMqjTiavcs
         nuaiwQ6pCJ9MIzIs2bZLAL4QUsU24UPYBsHFRaZdaplp82oXRktr6Pr68kKE99GnoZjG
         DlfsZ9bD95+npn4+notpONZY6gdR5kCDexm4mJtnFwtycrLE06/xLqf8KIZ66zNnfX2z
         hESHg4xd/wMAxvta3/eSIFFZf/I6mNlBeVNbU6YBRxlygqvZOowvcjUWe6b54CaUouDG
         HNxF+zackke6qiFESkFImNEnJlysteXDgW9AP8P+UgP9f1fPtq9SItRVjN7GfEdb7z94
         1fug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692296465; x=1692901265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJ/AmT87XjwjHbKdAHeyGn9OgBJOQ1lFwCiDbKXb6nM=;
        b=XIcF6wBHVtnjI2cKCPtO0C+ekcHUTxeNXnupzWcuaNnLzSobh1KS0AhKtRCnzfRZG2
         iwCuyGgVlar1IhsQHxHP6tJiHpZswLF5UddATN889dQxTJ2q1b0th5QqqTqmsCepVOgb
         4pO9LhiQ06f4WssFpbMIcOCIkTDa48lH02MTXv3qO0MfQmU45jaawSiM5MloLJ9chrCK
         KFFED3dbq7Nt7RsEAGYI1TlEgwvScXg6ocaWIfk0D3frKVK4BYQZ0GJG7A3VwaJrRebo
         zCV1pH4rW2Fr0eWEmQx7Fa8i4bGjFJxNGZhuy90h3SZqlQmTWMRkqEgHYKMnHtNWbwER
         cAsw==
X-Gm-Message-State: AOJu0YxeyqVjUvd+7xHW414yp7aDAVX3fxTwCZxKLF0GEv/NyCaq2isY
        o78NeNfLyAv+QQjkX4etaeeO630gFFw=
X-Google-Smtp-Source: AGHT+IENbp20qCwcOf57Y8LNV1qe1Dy/7KYDpwHsK8x2I7A0BeOOwhz8KLF3v6BjkD8DKTGnavlgnCTrjDU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:818e:0:b0:d4f:638b:d7fd with SMTP id
 p14-20020a25818e000000b00d4f638bd7fdmr4674ybk.9.1692296465662; Thu, 17 Aug
 2023 11:21:05 -0700 (PDT)
Date:   Thu, 17 Aug 2023 11:21:03 -0700
In-Reply-To: <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
Mime-Version: 1.0
References: <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
 <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
Message-ID: <ZN5lD5Ro9LVgTA6M@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023, Eric Wheeler wrote:
> On Tue, 15 Aug 2023, Sean Christopherson wrote:
> > On Mon, Aug 14, 2023, Eric Wheeler wrote:
> > > On Tue, 8 Aug 2023, Sean Christopherson wrote:
> > > > > If you have any suggestions on how modifying the host kernel (and then migrating
> > > > > a locked up guest to it) or eBPF programs that might help illuminate the issue
> > > > > further, let me know!
> > > > > 
> > > > > Thanks for all your help so far!
> > > > 
> > > > Since it sounds like you can test with a custom kernel, try running with this
> > > > patch and then enable the kvm_page_fault tracepoint when a vCPU gets stuck.  The
> > > > below expands said tracepoint to capture information about mmu_notifiers and
> > > > memslots generation.  With luck, it will reveal a smoking gun.
> > > 
> > > Getting this patch into production systems is challenging, perhaps live
> > > patching is an option:
> > 
> > Ah, I take when you gathered information after a live migration you were migrating
> > VMs into a sidecar environment.
> > 
> > > Questions:
> > > 
> > > 1. Do you know if this would be safe to insert as a live kernel patch?
> > 
> > Hmm, probably not safe.
> > 
> > > For example, does adding to TRACE_EVENT modify a struct (which is not
> > > live-patch-safe) or is it something that should plug in with simple
> > > function redirection?
> > 
> > Yes, the tracepoint defines a struct, e.g. in this case trace_event_raw_kvm_page_fault.
> > 
> > Looking back, I think I misinterpreted an earlier response regarding bpftrace and
> > unnecessarily abandoned that tactic. *sigh*
> > 
> > If your environment provides btf info, then this bpftrace program should provide
> > the mmu_notifier half of the tracepoint hack-a-patch.  If this yields nothing
> > interesting then we can try diving into whether or not the mmu_root is stale, but
> > let's cross that bridge when we have to.
> > 
> > I recommend loading this only when you have a stuck vCPU, it'll be quite noisy.
> > 
> > kprobe:handle_ept_violation
> > {
> > 	printf("vcpu = %lx pid = %u MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> > 	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> > }
> > 
> > If you don't have BTF info, we can still use a bpf program, but to get at the
> > fields of interested, I think we'd have to resort to pointer arithmetic with struct
> > offsets grab from your build.
> 
> We have BTF, so hurray for not needing struct offsets!
> 
> I am testing this on a host that is not (yet) known to be stuck. Please do 
> a quick sanity check for me and make sure this looks like the kind of 
> output that you want to see:
> 
> I had to shrink the printf line because it was longer than 64 bytes. I put 
> the process ID as the first item and changed %lx to %08lx for visual 
> alignment. Aside from that, it is the same as what you provided.
> 
> We're piping it through `uniq -c` to only see interesting changes (and 
> show counts) because it is extremely noisy. If this looks good to you then 
> please confirm and I will run it on a production system after a lock-up:
> 
> 	kprobe:handle_ept_violation
> 	{
> 		printf("ept[%u] vcpu=%08lx seq=%08lx inprog=%lx start=%08lx end=%08lx\n",
> 		       ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> 			arg0, 
> 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> 		       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> 	}
> 
> Questions:
>   - Should pid be zero?  (Note this is not yet running on a host with a 
>     locked-up guest, in case that is the reason.)

No.  I'm not at all familiar with PID management, I just copy+pasted from
pid_nr(), which is what KVM uses when displaying the pid in debugfs.  I printed
the PID purely to be able to unambiguously correlated prints to vCPUs without
needing to cross reference kernel addresses.  I.e. having the PID makes life
easier, but it shouldn't be strictly necessary.

>   - Can you think of any reason that this would be unsafe? (Forgive my 
>     paranoia, but of course this will be running on a production
>     hypervisor.)

Printing the raw address of the vCPU structure will effectively neuter KASLR, but
KASLR isn't all that much of a barrier, and whoever has permission to load a BPF
program on the system can do far, far more damage.

>   - Can you think of any adjustments to the bpf script above before 
>     running this for real?

You could try and make it less noisy or more precise, e.g. by tailoring it to
print only information on the vCPU that is stuck.  If the noise isn't a problem
though, I would keep it as-is, the more information the better.

> Here is an example trace on a test host that isn't locked up:
> 
>  ~]# bpftrace handle_ept_violation.bt | grep ^ept --line-buffered | uniq -c
>    1926 ept[0] vcpu=ffff969569468000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
>  215722 ept[0] vcpu=ffff9695684b8000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
>   66280 ept[0] vcpu=ffff969569468000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000
> 18609437 ept[0] vcpu=ffff9695684b8000 seq=8009c7eb inprog=0 start=7f5993200000 end=7f5993400000

Woah.  That's over 2 *billion* invalidations for a single VM.  Even if that's a
long-lived VM, that's still seems rather insane.  E.g. if the uptime of that VM
*on that host* is 6 months, my back of the napkin math says that that's nearly
100 invalidations every second for 6 months straight.

Bit 31 being set in relative isolation almost makes me wonder if mmu_invalidate_seq
got corrupted somehow.  Either that or you are thrashing that VM with a vengeance.
