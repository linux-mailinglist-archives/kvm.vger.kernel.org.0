Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C462AFB33
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 23:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgKKWQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 17:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgKKWQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 17:16:41 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13B0C0613D1
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 14:16:40 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id e18so3986275edy.6
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 14:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zD5WzEzQRngl9dmlFqU/zwILd5JYydu2RfHlYM1G/mk=;
        b=KEXyRfGqX7W5BHJoEFj5E0fBY6xIgCFIZneSQbw9Q8ueXS2RhB8LRVk/5lo4LGcGpD
         Lb7xLWbZf0kFXtGJm6Ny85F8NlYlAa0UfslSXaKPzfxoBhYolHYjQxfxXVGmnRSPAw8I
         1UYdE1kVAK2+oGsis+MU3XI798k3p2h7ugO1DcCGre55jNWgaFQTVAp8rilQtH080dIC
         /t3TkzulRQ0/8re0nmV68qsNU2AD/SFfGVqhXTF1yc/BrScncD9N13MGSzoCZnuZSUgj
         pwKAK7vsUiKMxtZrW7LXo9LUWLoEWGgDJOWn1zOKQt6qSxh59se/ZeQUnScAuvYNOz8t
         IIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zD5WzEzQRngl9dmlFqU/zwILd5JYydu2RfHlYM1G/mk=;
        b=uKB07mQKg3YYyuexYGwTGyAsc4Q2eClXuK2pZ8hgPdzHRxKSE6bmYmv1V+TPfox8uZ
         lThVu1PZhZKJC1C4C4WtPMwKbUhnl3dYPWxu+wewNxcQUE/BVgH84a6oxwU5hHO1bpR2
         g1IiqnWWYl4UOvkKSwTKzFu/lAa7hRidjVasPQVuupUoEdRw0Ipx+ybBAKLkdTf2ifLt
         qHHqOOaZQZip7HAIrmei4s4snSlkXQv2aMyxZYhNMkON6+ICruN+QFO2GYZ3Q+AuRYWQ
         tPp8mNm1HoaEX4FCM9qnC1zYmIxhfHXwKoRJ7FZwuBM/ci3Jtjk7okmdJCoS38ZJMp1S
         tvQA==
X-Gm-Message-State: AOAM5318sEP6kcbBsX5+nL1L/btcQp5i5RgG1iLBPhcADUzduxTXnmLa
        6Rj/d5iHq0P45nzDD/U/3Zo0Rupm4QeLoA==
X-Google-Smtp-Source: ABdhPJyx0hx/1kQz0J6BHwHFhb3Pm1sG5YOFcUvNgQO4h+ujmXh6g/wRfo2gvIej5dEXdLbx8Wqeow==
X-Received: by 2002:a05:6402:143:: with SMTP id s3mr1766345edu.267.1605132999608;
        Wed, 11 Nov 2020 14:16:39 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id a17sm1454479eda.45.2020.11.11.14.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 14:16:39 -0800 (PST)
Date:   Wed, 11 Nov 2020 23:16:36 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: Unable to start VM with 5.10-rc3
Message-ID: <20201111231636.453c01c8.zkaspar82@gmail.com>
In-Reply-To: <CANgfPd_qouM3h-3i=kqZvmpz53_qcj5G8eUbn0L75ZKmtZVtvQ@mail.gmail.com>
References: <20201110162344.152663d5.zkaspar82@gmail.com>
        <CANgfPd-gaDhmwPm5CC=cAFn8mBczbUjs7u3KucAGdKmU81Vbeg@mail.gmail.com>
        <20201111120939.54929a50.zkaspar82@gmail.com>
        <CANgfPd_qouM3h-3i=kqZvmpz53_qcj5G8eUbn0L75ZKmtZVtvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

[PATCH] kvm: x86/mmu: Fix is_tdp_mmu_check when using PAE

fixes is_tdp_mmu_root NULL pointer dereference,
tested on: Intel(R) Core(TM)2 CPU 6600  @ 2.40GHz

Thanks, Z.

On Wed, 11 Nov 2020 10:37:49 -0800
Ben Gardon <bgardon@google.com> wrote:

> Hi Zdenek,
> 
> I'm working on reproducing the issue. I don't have access to a CPU
> without EPT, but I tried turning off EPT on a Skylake and I think I
> reproduced the issue, but wasn't able to confirm in the logs.
> 
> If you were operating without EPT I assume the guest was in non-paging
> mode to get into direct_page_fault in the first place. I would still
> have expected the root HPA to be valid unless...
> 
> Ah, if you're operating with PAE, then the root hpa will be valid but
> not have a shadow page associated with it, as it is set to
> __pa(vcpu->arch.mmu->pae_root) in mmu_alloc_direct_roots.
> In that case, I can see why we get a NULL pointer dereference in
> is_tdp_mmu_root.
> 
> I will send out a patch that should fix this if the issue is as
> described above. I don't have hardware to test this on, but if you
> don't mind applying the patch and checking it, that would be awesome.
> 
> Ben
> 
> On Wed, Nov 11, 2020 at 3:09 AM Zdenek Kaspar <zkaspar82@gmail.com>
> wrote:
> >
> > Hi, I'm sure my bisect has nothing to do with KVM,
> > because it was quick shot between -rc1 and previous release.
> >
> > This old CPU doesn't have EPT (see attached file)
> >
> > ./run_tests.sh
> > FAIL apic-split (timeout; duration=90s)
> > FAIL ioapic-split (timeout; duration=90s)
> > FAIL apic (timeout; duration=30)
> > ... ^C
> > few RIP is_tdp_mmu_root observed in dmesg
> >
> > Z.
> >
> > On Tue, 10 Nov 2020 17:13:21 -0800
> > Ben Gardon <bgardon@google.com> wrote:
> >
> > > Hi Zdenek,
> > >
> > > That crash is most likely the result of a missing check for an
> > > invalid root HPA or NULL shadow page in is_tdp_mmu_root, which
> > > could have prevented the NULL pointer dereference.
> > > However, I'm not sure how a vCPU got to that point in the page
> > > fault handler with a bad EPT root page.
> > >
> > > I see VMX in your list of flags, is your machine 64 bit with EPT
> > > or some other configuration?
> > >
> > > I'm surprised you are finding your machine unable to boot for
> > > bisecting. Do you know if it's crashing in the same spot or
> > > somewhere else? I wouldn't expect the KVM page fault handler to
> > > run as part of boot.
> > >
> > > I will send out a patch first thing tomorrow morning (PST) to WARN
> > > instead of crashing with a NULL pointer dereference. Are you able
> > > to reproduce the issue with any KVM selftest?
> > >
> > > Ben
> > >
> > >
> > > On Tue, Nov 10, 2020 at 7:24 AM Zdenek Kaspar
> > > <zkaspar82@gmail.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > attached file is result from today's linux-master (with fixes
> > > > for 5.10-rc4) when I try to start VM on older machine:
> > > >
> > > > model name      : Intel(R) Core(TM)2 CPU          6600  @
> > > > 2.40GHz flags           : fpu vme de pse tsc msr pae mce cx8
> > > > apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr
> > > > sse sse2 ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs
> > > > bts rep_good nopl cpuid aperfmperf pni dtes64 monitor ds_cpl
> > > > vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm pti tpr_shadow dtherm
> > > > vmx flags       : tsc_offset vtpr
> > > >
> > > > I did quick check with 5.9 (distro kernel) and it works,
> > > > but VM performance seems extremely impacted. 5.8 works fine.
> > > >
> > > > Back to 5.10 issue: it's problematic since 5.10-rc1 and I have
> > > > no luck with bisecting (machine doesn't boot).
> > > >
> > > > TIA, Z.
> >

