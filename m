Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40757FCA7
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiGYJqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 05:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiGYJqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 05:46:36 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7196513F7E;
        Mon, 25 Jul 2022 02:46:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e15so13180305edj.2;
        Mon, 25 Jul 2022 02:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lAkb7puspXquT0bsiwgisLMFryx+Wz5auwx9RMI2LmU=;
        b=H3pIXNhhOHwVgfLCJVeDE06PPyvsddMOe6JsiXep0xrsEfZaDLKkqLKRpUZL1jwmbI
         ycIdL5JD4XwivJMJHTYEAJT60KkWKYnLYVx9d/8w6Hf7z2TAGEOLouU8VYMtHl0NizWT
         VN012x2d9ResJe16lA2l4kwEH+g72kt8w8m7ZRhEtyV4SXItMfaKzI8QSB5b1pmMNufl
         kq0p3KBQnA2949xQUZnhawM1NFXKwVTkQK9TBX1APV5tVXdU39rxtlje8V17yB58cf0H
         IHqPOZvhn5Fag35+o+cL30Hpw4T7FEBpwD+AwVZZOmu+as7tmkMyPJ5X5qcd365oCRKP
         4qDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lAkb7puspXquT0bsiwgisLMFryx+Wz5auwx9RMI2LmU=;
        b=F84Z9F9ziUefIA/+2Ow1TRdmK+y6l8Ay7TrMMksUZwh+nXcUrXkCD62mxwmRxAMEF8
         bI0JETuthmxyzG2ut2Oo/iahkVYERS3mIUS5tM+7tknIKXvKlmmilUOcPpvkpmwkNd6W
         hwitAD7x3SqbvZ5RjnbwNCoYK+TbyYQU9OoY3diPeM4fbYAeYFwtvpohP7P4JsiJAK+U
         NF/RkkmX1iH90vWv8PUYlytJXE2tKLT8NTfm0+LlVtXuC9F8DfXwnNJix8/piIqGZz4b
         55ObUM0W2YEIxpSf+mF9qwBAfhQY8Wx5CIoi9Hcz1ZTl49ngOAMgj0OnNoSLPhDX6sb6
         5yrw==
X-Gm-Message-State: AJIora+bOEad45yscn2+43G84tR5lAerM5Xo7APGwsrNzztJNPbqxJYu
        sbhZXgibisp7zbt5mHxF1dLFja9/cee11g==
X-Google-Smtp-Source: AGRyM1sC4zg18VP8dxHhutj3sw1Up3QjtEd4sUm4ogG+JVSZDSV5OxpdaA9t4vFu9PSzVRtV3lOFkg==
X-Received: by 2002:a05:6402:3228:b0:43b:de2e:2fc0 with SMTP id g40-20020a056402322800b0043bde2e2fc0mr11370591eda.299.1658742393810;
        Mon, 25 Jul 2022 02:46:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 11-20020a170906310b00b0072b3391193dsm5123595ejx.154.2022.07.25.02.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 02:46:33 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4d03f8b0-723c-7ac5-5078-95330e888e60@redhat.com>
Date:   Mon, 25 Jul 2022 11:46:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: SVM: Do not virtualize MSR accesses for APIC LVTT
 register
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, jon.grimm@amd.com
References: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/25/22 05:34, Suravee Suthikulpanit wrote:
> AMD does not support APIC TSC-deadline timer mode. AVIC hardware
> will generate GP fault when guest kernel writes 1 to bits [18]
> of the APIC LVTT register (offset 0x32) to set the timer mode.
> (Note: bit 18 is reserved on AMD system).
> 
> Therefore, always intercept and let KVM emulate the MSR accesses.
> 
> Fixes: f3d7c8aa6882 ("KVM: SVM: Fix x2APIC MSRs interception")
> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>

Does this fix some kvm-unit-tests testcase?

Anyway, I queued the patch, thanks!

Paolo
