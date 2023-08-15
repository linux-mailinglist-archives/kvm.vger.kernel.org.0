Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A59877CFEC
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 18:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbjHOQLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 12:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbjHOQKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 12:10:48 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F132213E
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 09:10:47 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68876bbed07so425104b3a.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 09:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692115847; x=1692720647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MydDjvPnH3hw4gMFG0sEvfc+79Ase6rI7Jj7e+9YTXk=;
        b=PRuMaMrNM78s0HL9muIrq5NRTC7QysIdNXPS4GJ8Y3AfU8v6yDorpYNL4xOOXG3g5p
         O1XfJAXimXzBb6E8kQ/KP8TK0AnkRrlUoC7fmRCfI7B+7Bsrcl2YI99ebwj4htK+vmbl
         i/IJXKsYQ765FYMIsjx4JtZkBrjN/a3VsTxfM7wGnBlXkYHv9Gtp3QXDoj3lAsH1IBZM
         mlYtTush+D3Yc4wIR2dtiP1efa4Qk37hEJktWBdNrX3fun6iwYFuT3riXYxDiJFBx2YJ
         NjZobNafrW/pJ3TWH/9YtLGodR8BYp/mLVPqh1BcTEsjUUbziw3u2HUpDbJlQzaDQLnl
         UDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692115847; x=1692720647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MydDjvPnH3hw4gMFG0sEvfc+79Ase6rI7Jj7e+9YTXk=;
        b=kHwaDhU3EdDiA+l2LKVDn8/NKf4Z2wMZ6G4IusbcqZuhKPkjBQOxV4nRdiZsvnAwQb
         lgyypBWR4BSEyc1I2hNBcEo+0IdaVR2O38s04/mULnrmdaVVtwGWpLidOqEFUujFIOtf
         ohzCke0I4AlqiJBVmJKCST6hLMMyhW6DG9OrGDF2VjnT5pn3CRQ0JhiCSVrHolVeAl8F
         2CbZjzy5lhhodqdbffpBxf/VBP5CL6Mk0o/g+lRz9q6udXN2ha9tCwY6qs63ZctxRJo/
         mODvF3wAFPkA+MGviZI4V/4JEQ3Rmv/W0FbCjsJfv0plAmNH35EC2SDAJ/rCEw8myx0G
         AdRg==
X-Gm-Message-State: AOJu0YzdWWfwKBQCNl5CO0qiKV3Kp/yI/zMVtg442NW/X3N8PTikQnbr
        qF+SnGdUPYVZuXj4PQojTw3cEJFmMa4=
X-Google-Smtp-Source: AGHT+IE6jPxeXYemDZqE1gbsOkZXXKXdiJxSPxK60DxJHB+yZj6JyMocl4uc6Xd3DEyk5Ct1UwpUvYjfWwM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a4f:b0:687:9855:ab23 with SMTP id
 h15-20020a056a001a4f00b006879855ab23mr6246607pfv.1.1692115847487; Tue, 15 Aug
 2023 09:10:47 -0700 (PDT)
Date:   Tue, 15 Aug 2023 09:10:46 -0700
In-Reply-To: <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
Mime-Version: 1.0
References: <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
Message-ID: <ZNujhuG++dMbCp6Z@google.com>
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

On Mon, Aug 14, 2023, Eric Wheeler wrote:
> On Tue, 8 Aug 2023, Sean Christopherson wrote:
> > > If you have any suggestions on how modifying the host kernel (and then migrating
> > > a locked up guest to it) or eBPF programs that might help illuminate the issue
> > > further, let me know!
> > > 
> > > Thanks for all your help so far!
> > 
> > Since it sounds like you can test with a custom kernel, try running with this
> > patch and then enable the kvm_page_fault tracepoint when a vCPU gets stuck.  The
> > below expands said tracepoint to capture information about mmu_notifiers and
> > memslots generation.  With luck, it will reveal a smoking gun.
> 
> Getting this patch into production systems is challenging, perhaps live
> patching is an option:

Ah, I take when you gathered information after a live migration you were migrating
VMs into a sidecar environment.

> Questions:
> 
> 1. Do you know if this would be safe to insert as a live kernel patch?

Hmm, probably not safe.

> For example, does adding to TRACE_EVENT modify a struct (which is not
> live-patch-safe) or is it something that should plug in with simple
> function redirection?

Yes, the tracepoint defines a struct, e.g. in this case trace_event_raw_kvm_page_fault.

Looking back, I think I misinterpreted an earlier response regarding bpftrace and
unnecessarily abandoned that tactic. *sigh*

If your environment provides btf info, then this bpftrace program should provide
the mmu_notifier half of the tracepoint hack-a-patch.  If this yields nothing
interesting then we can try diving into whether or not the mmu_root is stale, but
let's cross that bridge when we have to.

I recommend loading this only when you have a stuck vCPU, it'll be quite noisy.

kprobe:handle_ept_violation
{
	printf("vcpu = %lx pid = %u MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
}

If you don't have BTF info, we can still use a bpf program, but to get at the
fields of interested, I think we'd have to resort to pointer arithmetic with struct
offsets grab from your build.
