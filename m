Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5244663E77C
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiLACIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiLACIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:08:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49B054458;
        Wed, 30 Nov 2022 18:08:18 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so557325pjm.2;
        Wed, 30 Nov 2022 18:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jQlAx9lKPScxGGfc3CC8H/Jx0iyz4bic8EJkpT/M2jI=;
        b=Nwj1WxUJAaLfNiKHaI0pWqiTFA9+VA/yPW9LsNTTVV1uJqlv5fCqWNRt3OPUKJ3MiZ
         z0rcLwG4SxNyez8/8v39mWLI6dbmF+5G+7v2a4LGINtpNM4p0ZqU4NENd5QB8P9nZR6O
         nGFyvXJD8GFek00uO4vcUI8woAjG2+KbsLbhFNN0sVkttxi7Aaw0ruG1ZUu3qwD4U6Kr
         JtX01gHvuJwl5GXor+F7ULZ+8e51+CEDTLTwO3BlSxlVGRdo2Y6WuMhsKvBu9CrdCoDa
         9GcVIqmpx7FRxQ7RQBsLLG2kV2gyzOdlH4JKFKJBq5rK3PYuc6Vuxtmbx4zKO7HedI3Z
         YS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jQlAx9lKPScxGGfc3CC8H/Jx0iyz4bic8EJkpT/M2jI=;
        b=hxcNVHagMAqrNPH4atMYkCIUA4i2AS/10AQU5xdVeVlcK6ggs6snWa69f9a+mUs4Sk
         XEoX/Lge6832WDJzCCkSTHEQMrS/qfbUWtpDDMxF8LmzjQxQO6wwTg86tE5Yx2byrYBw
         o+FHLev4FYv56cIdORTkTTtR4rCXJyc5RSf0O9BTO87VXgPMe6jEMAWFBSmk6QTyZA18
         K02Vv2pL9nY4Lv4LzkFhoQMqTuSbCO5Zh2sBt8u5lHPxMRhhD40CV9UR2WiNVF3IU1mJ
         ah26v/aPt4Yrja7XQR3ixfbf+SjnpBCzYA1lEApu9/yShiyGlldEZ/fpXfrGvthS4zmM
         lJiA==
X-Gm-Message-State: ANoB5pkg1nK1cGvvcwez+SZFkAgjNxUF9diRH4sODceXwJ2JUE+t70f5
        Ip1hq1pr5E/zY/nLikXaWfY=
X-Google-Smtp-Source: AA0mqf6/uA384U4Nei+SEBIMCckwR3SmjrSoj4Q/bOYgRXCstZznPn6frnqajxMXfGvbTf1Vqpvklw==
X-Received: by 2002:a17:903:2407:b0:17f:3da:f19d with SMTP id e7-20020a170903240700b0017f03daf19dmr47789781plo.147.1669860498419;
        Wed, 30 Nov 2022 18:08:18 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id oj4-20020a17090b4d8400b00217cdc4b0a5sm3734488pjb.16.2022.11.30.18.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 18:08:18 -0800 (PST)
Message-ID: <f361e22d-b953-1f9a-a3a5-0283ca444e79@gmail.com>
Date:   Thu, 1 Dec 2022 10:08:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH 05/14] KVM: x86: Remove unnecessary export of
 kvm_inject_page_fault()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221114095606.39785-1-likexu@tencent.com>
 <20221114095606.39785-6-likexu@tencent.com> <Y4gLke+jtw07/Rrb@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y4gLke+jtw07/Rrb@google.com>
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

On 1/12/2022 10:04 am, Sean Christopherson wrote:
> On Mon, Nov 14, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Don't export x86's kvm_inject_page_fault(), the helper isn't used by
>> KVM x86's vendor modules. Add declaration to header file out of
>> existing callers' need.
> 
> ...
> 
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 9de72586f406..69811b4f3eac 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -307,6 +307,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
>>   int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>   			    int emulation_type, void *insn, int insn_len);
>>   fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
>> +void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
> 
> arch/x86/include/asm/kvm_host.h already has a definition, no need for one here.
> The definition could obviously be moved, but I'd prefer not to bother at this time
> as I want to move _all_ of kvm_host.h out of the "public" include directories (WIP).

Great, we may need more decoupling at the code level.
