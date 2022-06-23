Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B355874B
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 20:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiFWSX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 14:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237455AbiFWSWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 14:22:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA71C2283
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:25:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id cw10so18790693ejb.3
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=crkWefZHArgO+rkiNc/yWUU2AI/aei44IhcaBZPPRa4=;
        b=B69yUz/r3Rs5qYUzhTuML3wd4FZ7bhx0VaGkedo4Drdtl6XSZzOWHcqByef9qtuueo
         ZahVtamiPVhBKHBwHB4liwI80kfxRvGvKf5ZuCzkds9Es2319fkaXPWGnlqXvimzuhdP
         cOfv8E29rNDtMorcpcSSMKePusmtC+TwE7VD+8zaWBDrbKT+yp+rUZ7QE3/fR3fcHgPm
         srSevCPyG64lIK/T2r7DnnBzUAPERrJ6V1H21La/w04C6Kk1i4AHOUaogfeo0gfcKPHX
         i5Ah3prE+7IzqShad53kUg40Vwwp1mrjgtta7Sr6pWG6pzeHWyY4QeNUyQD1bK9sSf+0
         dXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=crkWefZHArgO+rkiNc/yWUU2AI/aei44IhcaBZPPRa4=;
        b=vJdGB6yilzh2zV9JGNIi3eXi6OkJEkq+fWeq2pEq39/JZEpAzflGeojJheTLDMOU0i
         GPP5jgv7sJ9JPnFfKP6psDrQwKQMj/kPa9wzeRgokI0FqLNeOSQI1OQizxUr3uy+np5T
         JAtcJfdsrkVYoVeTyrKZQdbkWr1yCiN7mbl3sdyORnNZMYDvAb8Oc8NvzAsAlfke17DS
         GKiZv0UVRXm+MsWj7i9dnEVc1AUEmA8WR4AlnEU1f6mqxkdpsCNxGoNtVS5AmIqgoRex
         b+mJrLlMO0T51FF36Yi6wB4jayLEFDhS6uN3d8ipLJfBxjAQfkp5l/FuM6sAS1owhUPk
         Uidw==
X-Gm-Message-State: AJIora9tJk/gJnhqyrwxOtyIjxAaoLazmrBiAh4V6rIBhn/mboiMgWfO
        l/E1rZHF4+VkdSafNUf6T+0=
X-Google-Smtp-Source: AGRyM1uVYsWpczLYCuYk+ZrrD4wR6t/LlXrg86SeBhLekzCowD4/w8MnyzIGzZ6KikjijzFebc/B+Q==
X-Received: by 2002:a17:906:dc8b:b0:722:e656:def5 with SMTP id cs11-20020a170906dc8b00b00722e656def5mr9591094ejc.490.1656005126377;
        Thu, 23 Jun 2022 10:25:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p26-20020a170906b21a00b00722f48d1f19sm2776630ejz.67.2022.06.23.10.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 10:25:25 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5312f6eb-4d82-5bee-b4fa-20e9ba97baa8@redhat.com>
Date:   Thu, 23 Jun 2022 19:25:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 0/8] KVM: x86: Add CMCI and UCNA emulation
Content-Language: en-US
To:     Jue Wang <juew@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
References: <20220610171134.772566-1-juew@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/10/22 19:11, Jue Wang wrote:
> This patch series implement emulation for Corrected Machine Check
> Interrupt (CMCI) signaling and UnCorrectable No Action required (UCNA)
> error injection.
> 
> UCNA errors signaled via CMCI allow a guest to be notified as soon as
> uncorrectable memory errors get detected by some background threads,
> e.g., threads that migrate guest memory across hosts or threads that
> constantly scan system memory for errors [1].
> 
> Upon receiving UCNAs, guest kernel isolates the poisoned pages which may
> still be free, preventing future accesses that may cause fatal MCEs.
> 
> 1. https://lore.kernel.org/linux-mm/8eceffc0-01e8-2a55-6eb9-b26faa9e3caf@intel.com/t/
> 
> 
> Patch 1-3 clean up KVM APIC LVT logic in preparation to adding APIC_LVTCMCI.
> 
> Patch 4 adds APIC_LVTCMCI emulation.
> 
> Patch 5 updates mce_banks to use array allocation api.
> 
> Patch 6 adds emulation for MSR_IA32_MCx_CTL2 registers that provide per
> bank control of CMCI signaling.
> 
> Patch 7 enables MCG_CMCI_P and handles injected UCNA errors.
> 
> Patch 8 adds a KVM self test that validates UCNA injection and CMCI
> emulation.
> 
> v5 changes
> - Incorporate feedback from David Matlack <dmatlack@google.com>
> - Rewrite the change log to be more concise and accurate.
> - Removes several duplicated checks in UCNA injection code.
> - Add test cases that validate CMCI emulation to self test.
> 
> v4 changes
> - Incorporate feedback from David Matlack <dmatlack@google.com>
> - Rewrite the change logs to be more descriptive.
> - Add a KVM self test.
> 
> v3 changes
> - Incorporate feedback from Sean Christopherson <seanjc@google.com>
> - Split clean up to KVM APIC LVT logic to 3 patches.
> - Put the clean up of mce_array allocation in a separate patch.
> - Base the MCi_CTL2 register emulation on Sean's clean up and fix
> series [2]
> - Fix bugs around MCi_CTL2 register offset validation and the free of
> mci_ctl2_banks array.
> - Rewrite the change log with more details in architectural information
> about CMCI, UCNA and MCG_CMCI_P.
> - Fix various comments and wrapping style.
> 
> 2. https://lore.kernel.org/lkml/20220512222716.4112548-1-seanjc@google.com/T/
> 
> v2 chanegs
> - Incorporate feedback from Sean Christopherson <seanjc@google.com>
> - Split the single patch into 4:
>    1). clean up KVM APIC LVT logic
>    2). add CMCI emulation to lapic
>    3). add emulation of MSR_IA32_MCx_CTL2
>    4). enable MCG_CMCI_P and handle injected UCNAs
> - Fix various style issues.
> 
> Jue Wang (8):
>    KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
>    KVM: x86: Fill apic_lvt_mask with enums / explicit entries.
>    KVM: x86: Add APIC_LVTx() macro.
>    KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to
>      lapic.
>    KVM: x86: Use kcalloc to allocate the mce_banks array.
>    KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
>    KVM: x86: Enable CMCI capability by default and handle injected UCNA
>      errors
>    KVM: selftests: Add a self test for CMCI and UCNA emulations.
> 
>   arch/x86/include/asm/kvm_host.h               |   1 +
>   arch/x86/kvm/lapic.c                          |  66 ++--
>   arch/x86/kvm/lapic.h                          |  16 +-
>   arch/x86/kvm/vmx/vmx.c                        |   1 +
>   arch/x86/kvm/x86.c                            | 178 ++++++---
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/apic.h       |   1 +
>   .../selftests/kvm/include/x86_64/mce.h        |  25 ++
>   .../selftests/kvm/include/x86_64/processor.h  |   1 +
>   .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
>   .../kvm/x86_64/ucna_injection_test.c          | 347 ++++++++++++++++++
>   12 files changed, 573 insertions(+), 67 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/mce.h
>   create mode 100644 tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> 

Queued, thanks.  The test of course required some changes to adapt to 
the new API.

Paolo
