Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC6D67172E
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjARJN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjARJMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:12:07 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98D5656CF;
        Wed, 18 Jan 2023 00:30:12 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id h26so16687303ila.11;
        Wed, 18 Jan 2023 00:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q+6S8VCFPk8FKrn+yY52ikZ/m7qi0dBmA8cT03eekw0=;
        b=HAb4E7p5PiL0Uj+816/CQJVTG6oFNyedAszxOBEakiOYhy6og4Rl7AIo+g3WAv3avS
         JkELpq0ND62biIiDxkvJwyN2dLQOwrI2DZSqhxbDLqm15qmoKcdg3jGCyU47Ps/aRfme
         kWvHkb+qk3L/rs8c6nRO8PfVUmAEzpxJZEzR3vzr8eRZToCUD8GbUGDvv3lkmqSDO4D8
         0TYKXsIopA77DtLRB0oIVOhvFO7enoaFSschePJeNK2GFLvSz5Rd2eLymJWILaA4yNR0
         K9gC4OHE2pUb2gFCOK9gbUQhaCVq3xWeUahVy+JjrHmro8oiZV/8NeGkm+xozIWfpZdY
         b2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q+6S8VCFPk8FKrn+yY52ikZ/m7qi0dBmA8cT03eekw0=;
        b=J7EdDWbW9VAJBVFzC9wKZpYqGolQGFvh9+/I57cUL6+DNCSrV2rRiAvaE4UkizeChA
         3tTc641S5ASHPgydqmNm/gp+iPgsaRKdxPhgf1ormNJjjy+L/kvBAfYcR0u3cE/h55IE
         bvStqGjG3N+Yp9kevW85RgGp508FU9hUx4gMOlckMQ8CmBbQcDEcNwYRabEyKKMOrSIm
         Zx/AFNxTULHRIPDp81sPAjCEkWa22D+eQfQv4fKZNYtJCI4/AkSRuiwvMGfj+vLe/DF3
         PgtSEf6ijA/ywkcLbodR2181+ix3/yek5tsK95EnvGuExKgVZ2MnJG6N3ww1bkZLdRLH
         dndA==
X-Gm-Message-State: AFqh2kqt/DaFZqqPah7IvNfVZxwMnGwgSikSXst519esOyxSo5oQpWRW
        TFLu5YKGq5E/Gygmspa4RSY=
X-Google-Smtp-Source: AMrXdXtqqlhseldo8YGvJaYnQIebkl93fL5Z1Am6ciRIaMhj9UXqA9aeeVMYSBmsZUHlbcgJO62iUQ==
X-Received: by 2002:a92:d10:0:b0:30e:f89b:6652 with SMTP id 16-20020a920d10000000b0030ef89b6652mr904523iln.0.1674030609498;
        Wed, 18 Jan 2023 00:30:09 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id d1-20020a92d781000000b00302bb083c2bsm9834800iln.21.2023.01.18.00.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 00:30:09 -0800 (PST)
Date:   Wed, 18 Jan 2023 10:30:03 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v5 0/6] KVM: x86: add per-vCPU exits disable
 capability
Message-ID: <20230118103003.00006f15@gmail.com>
In-Reply-To: <20230113220114.2437-1-kechenl@nvidia.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Jan 2023 22:01:08 +0000
Kechen Lu <kechenl@nvidia.com> wrote:

Hi:

checkpatch.pl throws a lot of warning and errors when I was trying
this series. Can you fix them?

total: 470 errors, 22 warnings, 464 lines checked

> Summary
> ===========
> Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
> cap for disabling exits to enable finer-grained VM exits disabling
> on per vCPU scales instead of whole guest. This patch series enabled
> the vCPU-scoped exits control and toggling.
> 
> Motivation
> ============
> In use cases like Windows guest running heavy CPU-bound
> workloads, disabling HLT VM-exits could mitigate host sched ctx switch
> overhead. Simply HLT disabling on all vCPUs could bring
> performance benefits, but if no pCPUs reserved for host threads, could
> happened to the forced preemption as host does not know the time to do
> the schedule for other host threads want to run. With this patch, we
> could only disable part of vCPUs HLT exits for one guest, this still
> keeps performance benefits, and also shows resiliency to host stressing
> workload running at the same time.
> 
> Performance and Testing
> =========================
> In the host stressing workload experiment with Windows guest heavy
> CPU-bound workloads, it shows good resiliency and having the ~3%
> performance improvement. E.g. Passmark running in a Windows guest
> with this patch disabling HLT exits on only half of vCPUs still
> showing 2.4% higher main score v/s baseline.
> 
> Tested everything on AMD machines.
> 
> v4->v5 :
> - Drop the usage of KVM request, keep the VM-scoped exits disable
>   as the existing design, and only allow per-vCPU settings to
>   override the per-VM settings (Sean Christopherson)
> - Refactor the disable exits selftest without introducing any
>   new prerequisite patch, tests per-vCPU exits disable and overrides,
>   and per-VM exits disable
> 
> v3->v4 (Chao Gao) :
> - Use kvm vCPU request KVM_REQ_DISABLE_EXIT to perform the arch
>   VMCS updating (patch 5)
> - Fix selftests redundant arguments (patch 7)
> - Merge overlapped fix bits from patch 4 to patch 3
> 
> v2->v3 (Sean Christopherson) :
> - Reject KVM_CAP_X86_DISABLE_EXITS if userspace disable MWAIT exits
>   when MWAIT is not allowed in guest (patch 3)
> - Make userspace able to re-enable previously disabled exits (patch 4)
> - Add mwait/pause/cstate exits flag toggling instead of only hlt
>   exits (patch 5)
> - Add selftests for KVM_CAP_X86_DISABLE_EXITS (patch 7)
> 
> v1->v2 (Sean Christopherson) :
> - Add explicit restriction for VM-scoped exits disabling to be called
>   before vCPUs creation (patch 1)
> - Use vCPU ioctl instead of 64bit vCPU bitmask (patch 5), and make exits
>   disable flags check purely for vCPU instead of VM (patch 2)
> 
> Best Regards,
> Kechen
> 
> Kechen Lu (3):
>   KVM: x86: Move *_in_guest power management flags to vCPU scope
>   KVM: x86: add vCPU scoped toggling for disabled exits
>   KVM: selftests: Add tests for VM and vCPU cap
>     KVM_CAP_X86_DISABLE_EXITS
> 
> Sean Christopherson (3):
>   KVM: x86: only allow exits disable before vCPUs created
>   KVM: x86: Reject disabling of MWAIT interception when not allowed
>   KVM: x86: Let userspace re-enable previously disabled exits
> 
>  Documentation/virt/kvm/api.rst                |   8 +-
>  arch/x86/include/asm/kvm-x86-ops.h            |   1 +
>  arch/x86/include/asm/kvm_host.h               |   7 +
>  arch/x86/kvm/cpuid.c                          |   4 +-
>  arch/x86/kvm/lapic.c                          |   7 +-
>  arch/x86/kvm/svm/nested.c                     |   4 +-
>  arch/x86/kvm/svm/svm.c                        |  42 +-
>  arch/x86/kvm/vmx/vmx.c                        |  53 +-
>  arch/x86/kvm/x86.c                            |  69 ++-
>  arch/x86/kvm/x86.h                            |  16 +-
>  include/uapi/linux/kvm.h                      |   4 +-
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/disable_exits_test.c | 457 ++++++++++++++++++
>  13 files changed, 626 insertions(+), 47 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> 

