Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D526369616B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 11:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjBNKuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 05:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjBNKtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 05:49:49 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F211A138;
        Tue, 14 Feb 2023 02:49:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id bx22so14695254pjb.3;
        Tue, 14 Feb 2023 02:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pUdKercMwIzfCNwi4nXhcJunGaPC6aQ18aVtD0+Afx0=;
        b=pTg9tmmAA/bvDbEYMKfFp3A2ZngmUpK5yL1c2kHC3TXKGt+yCXE4TgPE0vdJj5P+Fq
         yO9EWMTUPB1jBmQvC3tGxAG56Uyvrgu3rCkJXN3QjG96QD+RQZiuU4+yWsG0XOLoVlyo
         aZiruIrTPs1PmpHF8eowCdumteLWtPYBVaDbIAeLaDOoEha5e8aIB8uJvZaS0Fo5DSV+
         KlZK84PnQakzSH26kjgNQmQ5+2MktIugXiy6mZ+o+yRQkLc20rAnURN+MAsTvy48aUUA
         ARlh5Qh0ykOj9BGgs/u8BHtm1RV4RbvZMsjNsECnusEtRfm3voUZptSRi63AVXYmWa4h
         hehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUdKercMwIzfCNwi4nXhcJunGaPC6aQ18aVtD0+Afx0=;
        b=P041H4J72PYzXGyY26Tq4TI2d2ppEzo0IeuB6dL5uPC8Sx4VQjjyaPSlvZRlxK+aUi
         q7fpdIgBeMlpcVyPFvUvDZLLhN/dlZgPA3fuMOE0eiU9qTeEkXu72J0T7ipO3N1G8uWx
         IaWPNX1oFP1fJTZDWtSOEGjO66yRxd99DLnNt4KmIOQlG9tBwxmzZaktcFA1VoWIyrb3
         VwfNUHhrsJ/wjl1VcI97JG9yRIaVDcTYcAy8nzuq0FSty2pPxkvLSgIBKwWETDIOQ/8Q
         9O120quqDgzcg1T8qOwluJJJg5qDFhSawtpRqfFuDwZkVS8jIobYbT1Q4eEcHOO0ygSn
         sPYw==
X-Gm-Message-State: AO0yUKVa2Ioq5Wd41uZflYWVwfBGzhuGo07O0cDvvvc+0deSlHU+TeEk
        cc7dbc8GPoapMMQcixgo6yw=
X-Google-Smtp-Source: AK7set9TMA7b72PJHBf9qda1QRhsBpPP15denuLukpwCcgHpNmh8Rw69/ujtyFkT9ktxiFaCDRedlw==
X-Received: by 2002:a05:6a20:728b:b0:c6:5d8b:494b with SMTP id o11-20020a056a20728b00b000c65d8b494bmr2121410pzk.33.1676371734266;
        Tue, 14 Feb 2023 02:48:54 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902a51200b00199136ded1dsm9942101plq.112.2023.02.14.02.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 02:48:53 -0800 (PST)
Message-ID: <5771a4cb-4df7-e9a0-9e7e-9a116a40a411@gmail.com>
Date:   Tue, 14 Feb 2023 18:48:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 03/21] KVM: x86: Add macros to track first...last VMX
 feature MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-4-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230210003148.2646712-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2023 8:31 am, Sean Christopherson wrote:
> +/*
> + * The first...last VMX feature MSRs that are emulated by KVM.  This may or may
> + * not cover all known VMX MSRs, as KVM doesn't emulate an MSR until there's an
> + * associated feature that KVM supports for nested virtualization.
> + */
> +#define KVM_FIRST_EMULATED_VMX_MSR	MSR_IA32_VMX_BASIC
> +#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_VMFUNC

Off-topic, we now have "#define MSR_IA32_VMX_PROCBASED_CTLS3 0x00000492",
any further changes needed here if L2 guest needs IPI virtualization or why not ?
