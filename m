Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5D2502BB8
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354386AbiDOOXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354472AbiDOOW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:22:59 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50C013D1A;
        Fri, 15 Apr 2022 07:20:29 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r13so15610318ejd.5;
        Fri, 15 Apr 2022 07:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I+8+SXYywmABWGlIYadF/DTQr7dJU4Q1NjstdTanSr8=;
        b=Ya2WM2Tui/Nk8NL4I4C3K8csbywtdvpKpoJn1+x/a7RjClRAWSYWrD/p9KbcJkip2R
         8XYI6iSYMrxl3Lp/noQDvD5tLUs/4IwC+VhQrwLEpiwaxspgVDR7czzPDEw7GlRN3pgk
         nS9dx8JOxVU/+TjK4dLth83FhMB+Tf7g5L1uZYQToIgsSgwduzaha/VMexIy68t0alKH
         794KpDTPNnG+YAb6mJ7fVzcawyeJHj1Bf9kU/ZWNpIq2LbeFfCThS/H3lezAbphFaVr3
         8jtAlgifveS1RSzrQNJgiuwe2mMn3QTll1kUR5bJ4Zk/bFOmQEbJVhswDJbkL1+FdshH
         yFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I+8+SXYywmABWGlIYadF/DTQr7dJU4Q1NjstdTanSr8=;
        b=3dNPJ6TzcLbLZXHuBhXlacz4atB8oTlG/GFPtpeYzuoXntlNb3/EEgPBUYD58KyXS3
         wBT1clQFplsgTOLUk55rWpq5zPH3IgK4Wq+KoZlHISaS3Np0sMpgHeE4Oo60B6KvZxNY
         Q7LaSalUtmVnc9DIMzurcy4D2Qru6Zk2x/To3RZw578r8f/mW+bCHSqmSvj1u2CWhO80
         mRP4ndYfwxTC69oH+nlK/00TOaI7z+noRP6TbWVtYn8cnkDF+TIKOzPFtlbPTPi0iLQu
         VvWTlg0mk4AnH/jRXwyb7F34BtJ9Y8SBHBsddgMZAJIk6YFZq83NgTyM3AXpJGWPOBQO
         bthw==
X-Gm-Message-State: AOAM531YmR/MfVDuLDr1pKJG2ep7ZK8qWYDs/2wRidMlZ6oECunDjJga
        Olac9C9JjyU98wvmBXmEWts=
X-Google-Smtp-Source: ABdhPJyddX8XUT6WGBSo3fVtG/wR1chzV8or/C6toPynnN7YjvXPn0kNDvZGg5wyzHbG0JSgnfCuQQ==
X-Received: by 2002:a17:906:4e48:b0:6e8:a246:9645 with SMTP id g8-20020a1709064e4800b006e8a2469645mr6482857ejw.642.1650032428351;
        Fri, 15 Apr 2022 07:20:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id b12-20020a056402278c00b004195a50759fsm2912853ede.84.2022.04.15.07.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:20:27 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <1bff7526-c532-3ca8-7d7a-c7face576a37@redhat.com>
Date:   Fri, 15 Apr 2022 16:20:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 075/104] KVM: x86: Check for pending APICv
 interrupt in kvm_vcpu_has_events()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d28f3b27c281e0c6a8f93c01bb4da78980d654c8.1646422845.git.isaku.yamahata@intel.com>
 <YlBhuWElVRwYrrS+@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YlBhuWElVRwYrrS+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/22 18:24, Sean Christopherson wrote:
>> Return true for kvm_vcpu_has_events() if the vCPU has a pending APICv
>> interrupt to support TDX's usage of APICv.  Unlike VMX, TDX doesn't have
>> access to vmcs.GUEST_INTR_STATUS and so can't emulate posted interrupts,
> Based on the discussion in the HLT patch, this is no longer true.
> 

It's still true, it only has access to RVI > PPR (which is enough to check
if the vCPU is runnable).

> Rather than hook this path, I would rather we tag kvm_apic has having some of its
> state protected.  Then kvm_cpu_has_interrupt() can invoke the alternative,
> protected-apic-only hook when appropriate, and kvm_apic_has_interrupt() can bail
> immediately instead of doing useless processing of stale vAPIC state.

Agreed, this is similar to my suggestion on the HLT patch:

https://lkml.kernel.org/r/a7d28775-2dbe-7d97-7053-e182bd5be51c@redhat.com

Paolo
