Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62474D1D40
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348169AbiCHQeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiCHQeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:34:18 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E5133886
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:33:21 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qx21so40446757ejb.13
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m4lEEL7OjcAY1HfUcpLz3IYhiv6nz2PwDfEfANYxisM=;
        b=KZwOTOmjPBkyU8M4q8KL0IzL9D8ob0u1VzdK9gmbx+/m06OAiMq7jxJt8EUgPvLkdP
         AyAC6aZZ3x/hN+ouDEyhEU47eX9i4xMzN5qnxprqNuJlR5sBrmzYORD9H6hz4jtQX6de
         cAQaTLhmvbaiinhI/Zsnu+oza/I0hpSv0ACqeipjJQaBZm5sjS7S4wcKXVZH8DryI7E0
         XEMDBPVTli/+mkGeFqaCJE8b2ekeZTXohJ1BPZ1x97r5ghtQ83u3j5CWNtyswK6d3HvL
         d2R3ZE/+UOXV/NFMOfhctBvUwH/TMfyo4oOJGEeMkoegBNBthfVEyraqMyNsARRbVLAi
         43Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m4lEEL7OjcAY1HfUcpLz3IYhiv6nz2PwDfEfANYxisM=;
        b=gHqWzC9YRhrau12YtveysIycEabPe3thmT58xidiHL4KXa9uww7NZnS3P5qgeukbnN
         wt/5sFO98ZwPBYMp+dXWdQ8l/zvCEdvYFPmdncVatqsFaZTni7cTHJLtuQ/SCtuSp8r7
         KbSAfjaMQUvJJtTZO6VC92vlBzv36Zrus9rl8tkRcT1hBjNbHPXcLuShY1Kz8J/w1UGd
         x6bnVWotJ0EDRG86Djh/yz3CFd/qp3kHOhxBqW750woOweN7shAYwaivmKvDde/TCIea
         6LatF/gZI9A/aWOiNOnDKkx5hJBTnXPgyP81FffFbctMv0H6M4DTeux73b/46hrMlOB4
         /EgQ==
X-Gm-Message-State: AOAM53147YkfrWOibD8NrZmS8kV70R48suchnSfSFwsFwUaoaFfEKnfp
        B6PsnenpnXR2XxwKIhsnKHE=
X-Google-Smtp-Source: ABdhPJwWeZPBPIAJpRoPDbl24IrfAHUKcfCTAjJeCKOvRms4nIpiVQBsYjuB9HJbl5xnH5vABJpzDg==
X-Received: by 2002:a17:907:7d94:b0:6db:207:c0cd with SMTP id oz20-20020a1709077d9400b006db0207c0cdmr13996402ejc.362.1646757199691;
        Tue, 08 Mar 2022 08:33:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c14-20020a170906340e00b006ce98f2581asm5989740ejb.205.2022.03.08.08.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:33:19 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <db8515e4-3668-51d2-d9af-711ebd48ad9b@redhat.com>
Date:   Tue, 8 Mar 2022 17:33:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/17] KVM: Add Xen event channel acceleration
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220303154127.202856-1-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220303154127.202856-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 3/3/22 16:41, David Woodhouse wrote:
> This series adds event channel acceleration for Xen guests. In particular
> it allows guest vCPUs to send each other IPIs without having to bounce
> all the way out to the userspace VMM in order to do so. Likewise, the
> Xen singleshot timer is added, and a version of SCHEDOP_poll. Those
> major features are based on Joao and Boris' patches from 2019.
> 
> Cleaning up the event delivery into the vcpu_info involved using the new
> gfn_to_pfn_cache for that, and that means I ended up doing so for *all*
> the places the guest can have a pvclock.
> 
> v0: Proof-of-concept RFC
> 
> v1:
>   • Drop the runstate fix which is merged now.
>   • Add Sean's gfn_to_pfn_cache API change at the start of the series.
>   • Add KVM self tests
>   • Minor bug fixes
> 
> v2:
>   • Drop dirty handling from gfn_to_pfn_cache
>   • Fix !CONFIG_KVM_XEN build and duplicate call to kvm_xen_init_vcpu()
> 
> v3:
>   • Add KVM_XEN_EVTCHN_RESET to clear all outbound ports.
>   • Clean up a stray #if	1 in a part of the the test case that was once
>     being recalcitrant.
>   • Check kvm_xen_has_pending_events() in kvm_vcpu_has_events() and *not*
>     kvm_xen_has_pending_timer() which is checked from elsewhere.
>   • Fix warnings noted by the kernel test robot <lkp@intel.com>:
>      • Make kvm_xen_init_timer() static.
>      • Make timer delta calculation use an explicit s64 to fix 32-bit build.
> 
> Boris Ostrovsky (1):
>        KVM: x86/xen: handle PV spinlocks slowpath
> 
> David Woodhouse (12):
>        KVM: Remove dirty handling from gfn_to_pfn_cache completely
>        KVM: x86/xen: Use gfn_to_pfn_cache for runstate area
>        KVM: x86: Use gfn_to_pfn_cache for pv_time
>        KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info
>        KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_time_info
>        KVM: x86/xen: Make kvm_xen_set_evtchn() reusable from other places
>        KVM: x86/xen: Support direct injection of event channel events
>        KVM: x86/xen: Add KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
>        KVM: x86/xen: Kernel acceleration for XENVER_version
>        KVM: x86/xen: Support per-vCPU event channel upcall via local APIC
>        KVM: x86/xen: Advertise and document KVM_XEN_HVM_CONFIG_EVTCHN_SEND
>        KVM: x86/xen: Add self tests for KVM_XEN_HVM_CONFIG_EVTCHN_SEND
> 
> Joao Martins (3):
>        KVM: x86/xen: intercept EVTCHNOP_send from guests
>        KVM: x86/xen: handle PV IPI vcpu yield
>        KVM: x86/xen: handle PV timers oneshot mode
> 
> Sean Christopherson (1):
>        KVM: Use enum to track if cached PFN will be used in guest and/or host
> 
>   Documentation/virt/kvm/api.rst                     |  133 +-
>   arch/x86/include/asm/kvm_host.h                    |   23 +-
>   arch/x86/kvm/irq.c                                 |   11 +-
>   arch/x86/kvm/irq_comm.c                            |    2 +-
>   arch/x86/kvm/x86.c                                 |  119 +-
>   arch/x86/kvm/xen.c                                 | 1271 ++++++++++++++++----
>   arch/x86/kvm/xen.h                                 |   67 +-
>   include/linux/kvm_host.h                           |   26 +-
>   include/linux/kvm_types.h                          |   11 +-
>   include/uapi/linux/kvm.h                           |   44 +
>   .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  337 +++++-
>   virt/kvm/pfncache.c                                |   53 +-
>   12 files changed, 1722 insertions(+), 375 deletions(-)
> 
> 
> 

Queued, thanks.

Paolo
