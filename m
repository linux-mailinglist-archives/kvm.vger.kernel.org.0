Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFB976D629
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbjHBRyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 13:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjHBRxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 13:53:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB3610E7
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 10:52:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d061f324d64so70181276.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 10:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690998766; x=1691603566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o9xLasiI1QpQmYZlmA61fAHENI9Lul/s9FI/EIn/JnY=;
        b=kOI8w41LlihPT323Aq8Ap+JNEARPFDRYIBgdN37uOB98GoEeveuvvuEy91n5k0sVkS
         5GGA1ICR3Wg942ugEZ8BDKaG1sZjPEViLN77pn0Phe1tiYxCn4i0rBWrtQl5EulGjIWf
         Y2Uo3FAAiA7cWKwrIcfxnOwImDLOzUPevkph95szugiXyike4mMUBJN917f49tOzwV7T
         IXqHLOSH0IefJQx87mMR2k3fNaJZhxV80sOhKP/cMEt2IlicNPofUNkpHufvccQzS/JA
         39eS7V00GqOGen/HZuaxqIoNiTojE4tlE1BpjOLXJ/7cTTjccowApjC/asvpHVK0T/g9
         ePRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690998766; x=1691603566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9xLasiI1QpQmYZlmA61fAHENI9Lul/s9FI/EIn/JnY=;
        b=NihOVXINiMo4++QnwXNkdqs6TXjsixQP95JUiFbv4Q4tRGLq60OBkrSN964gNw3rqu
         Wm6a/bLz77yzvIrEXf6O/3G/OH6GwEWtSx+Fp6waSsPxO4Y8QSMo6/vfwfohEHf62tTZ
         usQgT7hgY5TP3hPSx9EZ+m4o9IBBrp4FONTGzUONPpkQAUkjfpPz6BAR4rGaNHA8thCt
         75AoIqqppqyMinSI0a/oosE4wlF+CYa9xm95vgxscTbNU/alPV+0HqdhiJ0dy9ae1GYY
         s9eh5xHpBftef1UVnEvdR/R8Z3I0aXHzCs3bTk4wSVSZqKuqdfpjfQD5QmLMclPEYdtp
         Lgmg==
X-Gm-Message-State: ABy/qLbRcFRxeq2mDMbtYq3trdRxSPivXnRfIFRfDz+uxLhzl4Q24N0E
        Mx6dbg3DeGSXvK1o2pfTEmHtgRH4wGg=
X-Google-Smtp-Source: APBJJlFeirc5L28TZbXdrADjrqG+IT1wrE5WO9H36XSSa1s2/jxjkcC+67jmu1JmFzGpSwrJIPlOsMF0wow=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:db8d:0:b0:d18:73fc:40af with SMTP id
 g135-20020a25db8d000000b00d1873fc40afmr113950ybf.5.1690998766485; Wed, 02 Aug
 2023 10:52:46 -0700 (PDT)
Date:   Wed, 2 Aug 2023 10:52:45 -0700
In-Reply-To: <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
Mime-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
Message-ID: <ZMqX7TJavsx8WEY2@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Amaan Cheval <amaan.cheval@gmail.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
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

On Wed, Aug 02, 2023, Amaan Cheval wrote:
> > LOL, NUMA autobalancing.  I have a longstanding hatred of that feature.  I'm sure
> > there are setups where it adds value, but from my perspective it's nothing but
> > pain and misery.
> 
> Do you think autobalancing is increasing the odds of some edge-case race
> condition, perhaps?
> I find it really curious that numa_balancing definitely affects this issue, but
> particularly when thp=0. Is it just too many EPT entries to install
> when transparent hugepages is disabled, increasing the likelihood of
> a race condition / lock contention of some sort?

NUMA balancing works by zapping PTEs[*] in userspace page tables for mappings to
remote memory, and then migrating the data to local memory on the resulting page
fault.  When that memory is being used to back a KVM guest, zapping the userspace
(primary) PTEs triggers an mmu_notifier event that in turn saps KVM's PTEs, a.k.a.
SPTEs (which used to mean Shadow PTEs, but we're retroactively redefining SPTE to
also mean Secondary PTEs so that it's correct when shadow paging isn't being used).

If NUMA balancing is going nuclear and constantly zapping PTEs, the resulting
mmu_notifier events could theoretically stall a vCPU indefinitely.  The reason I
dislike NUMA balancing is that it's all too easy to end up with subtle bugs
and/or misconfigured setups where the NUMA balancing logic zaps PTEs/SPTEs without
actuablly being able to move the page in the end, i.e. it's (IMO) too easy for
NUMA balancing to get false positives when determining whether or not to try and
migrate a page.

That said, it's definitely very unexpected that NUMA balancing would be zapping
SPTEs to the point where a vCPU can't make forward progress.   It's theoretically
possible that that's what's happening, but quite unlikely, especially since it
sounds like you're seeing issues even with NUMA balancing disabled.

More likely is that there is a bug somewhere that results in the mmu_notifier
event refcount staying incorrectly eleveated, but that type of bug shouldn't follow
the VM across a live migration...

[*] Not technically a full zap of the PTE, it's just marked PROT_NONE, i.e.
    !PRESET, but on the KVM side of things it does manifest as a full zap of the
    SPTE.

> > > They still remain locked up, but that might be because the original cause of the
> > > looping EPT_VIOLATIONs corrupted/crashed them in an unrecoverable way (are there
> > > any ways you can think of that that might happen)?
> >
> > Define "remain locked up".  If the vCPUs are actively running in the guest and
> > making forward progress, i.e. not looping on VM-Exits on a single RIP, then they
> > aren't stuck from KVM's perspective.
> 
> Right, the traces look like they're not stuck (i.e. no looping on the same
> RIP). By "remain locked up" I mean that the VM is unresponsive on both the
> console and services (such as ssh) used to connect to it.
> 
> > But that doesn't mean the guest didn't take punitive action when a vCPU was
> > effectively stalled indefinitely by KVM, e.g. from the guest's perspective the
> > stuck vCPU will likely manifest as a soft lockup, and that could lead to a panic()
> > if the guest is a Linux kernel running with softlockup_panic=1.
> 
> So far we haven't had any guest kernels with softlockup_panic=1 have this issue,
> so it's hard to confirm, but it makes sense that the guest took punitive action
> in response to being stalled.
> 
> Any thoughts on how we might reproduce the issue or trace it down better?

Before going further, can you confirm that this earlier statement is correct?

 : Another interesting observation we made was that when we migrate a guest to a
 : different host, the guest _stays_ locked up and throws EPT violations on the new
 : host as well

Specifically, after migration, is the vCPU still fully stuck on EPT violations,
i.e. not making forward progress from KVM's perspective?  Or is the guest "stuck"
after migration purely because the guest itself gave up?
