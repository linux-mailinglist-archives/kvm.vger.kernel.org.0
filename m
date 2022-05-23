Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC90531727
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbiEWTj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiEWTjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:39:10 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F236E153500;
        Mon, 23 May 2022 12:30:12 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gh17so17886770ejc.6;
        Mon, 23 May 2022 12:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JhT7OS+s3Fa0lvACfn3peqHlGb0npjXqSR9TIR2VpDI=;
        b=IaYJ7eGMseXfL3qTfoOgm8tIsOPKgKMXfqg7VAiOuKxO5WsFX8cJQ1xqb8Iq7WDPzQ
         qgq1yw0NqQSMqH6onGy8BNUzqQDzsWg+nUiVaXzkGYn/cgSZioRe37tULfawijr0Y13Y
         4/PifxcEWpsPA1m/EZ/J15LV6Go+IrzEz30gVyhoHEvWqHVTUKlAdxRvPWl+ZayCasvT
         fQ33RgVteDEIQLzYcCY1Y7dzIrBfrS1GDwT7PkBsNqXP2LmS/PehdyunB0ocGpg490ii
         ROMF89KntO1h8nbIATU7MPBJt0+xTCiaEG0c3LUI6Qho2lj9iBQpEfZnYsq+2FHf4/Ku
         nyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JhT7OS+s3Fa0lvACfn3peqHlGb0npjXqSR9TIR2VpDI=;
        b=0fSUOVI+e/a+Yq6L6IxgJ01V+Dc/Y9uwCxojH9oz+gd2yFWNN7vM9TEY3OkDIHSgeG
         UgsObzrjzLeB7bIWfa2EL3VZOjGqov3dQj0a46VK9ZqMpSV5JqzSw4BqkcLRd800H7tR
         ZlgQzvh0fLfZhtaerkoee/ZBCQlYccFjUYpEVlPyLMKfWw6R5ztgd5labbTOUgrFGt+p
         5K4i+LNsSGyv03OV8rrtwolwb03exRATmiCvCAA4wzbXleHLKV7GMwiasom1S3kJJtVK
         cBn9fIk2HgFCiHLJz3u7wETrwcmJcqvwNQ5PlWzSMYh1FqOULV/8+X1Cvy2IIpElXwFu
         9gHA==
X-Gm-Message-State: AOAM532sMu58AJqQZBJxc0SvgXGp0GMAUaUgdB8nZ+0lzZXR/0ZUKcEE
        //n0iFfq1UzweJnl6UX3TlE=
X-Google-Smtp-Source: ABdhPJwdWqabue9wVHqkoAGYlE5AqN8mYwYmrd5XP+mAj01VEfs9KgyQoI4pfojM6vI0Ls+i8FLPHQ==
X-Received: by 2002:a17:906:b74a:b0:6fe:a118:8963 with SMTP id fx10-20020a170906b74a00b006fea1188963mr17577374ejb.537.1653334211424;
        Mon, 23 May 2022 12:30:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w12-20020a170906130c00b006fec69a3978sm2309867ejb.207.2022.05.23.12.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 12:30:10 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7c4ebffe-7b61-9ca8-26b6-1fbaaac5243e@redhat.com>
Date:   Mon, 23 May 2022 21:30:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 0/3] Introduce Notify VM exit
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220421072958.16375-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 09:29, Chenyi Qiang wrote:
> Virtual machines can exploit Intel ISA characterstics to cause
> functional denial of service to the VMM. This series introduces a new
> feature named Notify VM exit, which can help mitigate such kind of
> attacks.
> 
> Patch 1: An extension of KVM_SET_VCPU_EVENTS ioctl to inject a
> synthesized shutdown event from user space. This is also a fix for other
> synthesized triple fault, e.g. the RSM patch or nested_vmx_abort(),
> which could get lost when exit to userspace to do migrate.
> 
> Patch 2: A selftest about get/set triple fault event.
> 
> Patch 3: The main patch to enable Notify VM exit.

Chenyi, can you send v7 for inclusion?

Paolo

> ---
> Change logs:
> v5 -> v6
> - Do some changes in document.
> - Add a selftest about get/set triple fault event. (Sean)
> - extend the argument to include both the notify window and some flags
>    when enabling KVM_CAP_X86_BUS_LOCK_EXIT CAP. (Sean)
> - Change to use KVM_VCPUEVENT_VALID_TRIPE_FAULT in flags field and add
>    pending_triple_fault field in struct kvm_vcpu_events, which allows
>    userspace to make/clear triple fault request. (Sean)
> - Add a flag in kvm_x86_ops to avoid the kvm_has_notify_vmexit global
>    varialbe and its export.(Sean)
> - v5: https://lore.kernel.org/lkml/20220318074955.22428-1-chenyi.qiang@intel.com/
> 
> v4 -> v5
> - rename KVM_VCPUEVENTS_SHUTDOWN to KVM_VCPUEVENTS_TRIPLE_FAULT. Make it
>    bidirection and add it to get_vcpu_events. (Sean)
> - v4: https://lore.kernel.org/all/20220310084001.10235-1-chenyi.qiang@intel.com/
> 
> v3 -> v4
> - Change this feature to per-VM scope. (Jim)
> - Once VM_CONTEXT_INVALID set in exit_qualification, exit to user space
>    notify this fatal case, especially the notify VM exit happens in L2.
>    (Jim)
> - extend KVM_SET_VCPU_EVENTS to allow user space to inject a shutdown
>    event. (Jim)
> - A minor code changes.
> - Add document for the new KVM capability.
> - v3: https://lore.kernel.org/lkml/20220223062412.22334-1-chenyi.qiang@intel.com/
> 
> v2 -> v3
> - add a vcpu state notify_window_exits to record the number of
>    occurence as well as a pr_warn output. (Sean)
> - Add the handling in nested VM to prevent L1 bypassing the restriction
>    through launching a L2. (Sean)
> - Only kill L2 when L2 VM is context invalid, synthesize a
>    EXIT_REASON_TRIPLE_FAULT to L1 (Sean)
> - To ease the current implementation, make module parameter
>    notify_window read-only. (Sean)
> - Disable notify window exit by default.
> - v2: https://lore.kernel.org/lkml/20210525051204.1480610-1-tao3.xu@intel.com/
> 
> v1 -> v2
> - Default set notify window to 0, less than 0 to disable.
> - Add more description in commit message.
> ---
> 
> Chenyi Qiang (2):
>    KVM: X86: Save&restore the triple fault request
>    KVM: selftests: Add a test to get/set triple fault event
> 
> Tao Xu (1):
>    KVM: VMX: Enable Notify VM exit
> 
>   Documentation/virt/kvm/api.rst                | 55 +++++++++++
>   arch/x86/include/asm/kvm_host.h               |  9 ++
>   arch/x86/include/asm/vmx.h                    |  7 ++
>   arch/x86/include/asm/vmxfeatures.h            |  1 +
>   arch/x86/include/uapi/asm/kvm.h               |  4 +-
>   arch/x86/include/uapi/asm/vmx.h               |  4 +-
>   arch/x86/kvm/vmx/capabilities.h               |  6 ++
>   arch/x86/kvm/vmx/nested.c                     |  8 ++
>   arch/x86/kvm/vmx/vmx.c                        | 48 +++++++++-
>   arch/x86/kvm/x86.c                            | 33 ++++++-
>   arch/x86/kvm/x86.h                            |  5 +
>   include/uapi/linux/kvm.h                      | 10 ++
>   tools/testing/selftests/kvm/.gitignore        |  1 +
>   tools/testing/selftests/kvm/Makefile          |  1 +
>   .../kvm/x86_64/triple_fault_event_test.c      | 96 +++++++++++++++++++
>   15 files changed, 280 insertions(+), 8 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
> 

