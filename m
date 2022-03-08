Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7304D1E4B
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348684AbiCHRPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344409AbiCHRPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:15:30 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D25B52E0B;
        Tue,  8 Mar 2022 09:14:32 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hw13so40576946ejc.9;
        Tue, 08 Mar 2022 09:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fhW09ywHlIWvxHyjvBP0vXcd0+UN13egflttmd7VoRo=;
        b=bn13C/AkGmAwG/nuqCyIJMC9NLYannba4eloFSYpDgTFhOlBD91oCIEEQSRBuyMYqv
         E+lbcezmFzJWvZwWU09I68/NDGKBZnib62HTnmTZiTixWLNHKQUIVRz1hLWy/cwL1MlF
         VF/2PJk4U9kAwglp5oXiv6vCyWV/b9nKaRNFK37k4NDjy7RzIUjPcdwXrMfs5t9s97W7
         iWT7UsFxkf71UK1dd1h/t/S9kI8bSedbeThdMfxtshI1EHZK4+P/V5QEvkV7hqdQIfz8
         xLxsTAMS5fXCgPLZWeSb3NC/seIl87u5uHqtMPdISP1kN3g6AZGxfCL8/z634OLUlEuY
         UDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fhW09ywHlIWvxHyjvBP0vXcd0+UN13egflttmd7VoRo=;
        b=dX1gGcsVl8ZXfXYU8f/PsXGD8ub/ZiKivsRxDLjrqIVrofQhVHVGeIw9YWd4yzZXEG
         clknktqqSnRg9nEU45vIqm1nXjfCh1v3nYoi2wFuQ51OzCxkGYWnN+eeSWRVpL6kOfr2
         /MU2lQxRewXzWw1Y/qYW/zEpnRWIE33BiewhNB+X/hwR91z+6b8f9XzEvvukagxdFKQl
         vWzIZoTlYHfyOUl7T7Rj45/cPROGJV5r7GW/+M9d/CxuqyFqbJqFD5zcUGc3nIr6fGdh
         Hd8/5BA/tbPFEZ+dwft54SHhqt3Mh/gnGrF2AbTQ5vMPGUxJYORn1RhbsLBKl9jhSsvQ
         WQZA==
X-Gm-Message-State: AOAM530OVMwSczjwDWVq+LR1KtPb22PdsQI+gKU0aYqDwjf68u0RHPGt
        MBFmPkz87PR/GswemWQi0Q5bkozCXGc=
X-Google-Smtp-Source: ABdhPJxs2MwwTvWAl37XplBVwMcLrAsdbW0FtadE3FoJJrD4CmNV8w7xVQikMEiltEwtobmZrmWL/g==
X-Received: by 2002:a17:906:79c4:b0:6cf:5489:da57 with SMTP id m4-20020a17090679c400b006cf5489da57mr13681071ejo.48.1646759671359;
        Tue, 08 Mar 2022 09:14:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a22-20020a50ff16000000b00410d029ea5csm7844646edu.96.2022.03.08.09.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:14:30 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d028d59f-2a33-2562-5709-fcc56c80f7fe@redhat.com>
Date:   Tue, 8 Mar 2022 18:14:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 01/25] KVM: x86/mmu: avoid indirect call for get_cr3
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-2-pbonzini@redhat.com> <YieBXzkOkB9SZpyp@google.com>
 <2652c27e-ce8c-eb40-1979-9fe732aa9085@redhat.com>
 <YieFKfjrgTTnYkL7@google.com>
 <96ff1628-eeb2-4d12-f4eb-287dd8fc9948@redhat.com>
 <YieJ9lkq7R87m1mJ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YieJ9lkq7R87m1mJ@google.com>
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

On 3/8/22 17:53, Sean Christopherson wrote:
>> static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
>> 						  struct kvm_mmu *mmu)
>> {
>> 	if (unlikely(vcpu == &vcpu->arch.guest_mmu))
> Well, not that certainly:-)
> 
> 	if (mmu == &vcpu->arch.guest_mmu)
> 
> But you're right, we need to be able to do kvm_read_cr3() for the actual nested_mmu.
> 

Ok, I'll drop this patch for now since the end of the series actually 
introduces the nested_ops already.  And then we can do it for both 
get_guest_pgd and get_pdptr.

Paolo
