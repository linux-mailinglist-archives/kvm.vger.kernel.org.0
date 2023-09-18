Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6B37A4C72
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjIRPeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjIRPdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:33:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4851E44;
        Mon, 18 Sep 2023 08:31:26 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-986d8332f50so633141566b.0;
        Mon, 18 Sep 2023 08:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695050879; x=1695655679; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sLknf5KveUwbOgFiDLEqsKxezP26LvkH2sQEbrP8ZIM=;
        b=efBjhhJ0m5wynLUdIz6LJEHtJW+kU2BuurF2cqKh/Cyinb1GaAVDWnROwlcXmLs1Ob
         ptw/83rSzIJofPlhgAUVuhcVXi6jV15+apeyVCShN6hFzxaZXVNigr1/YFJC8j45BTE2
         PrRDkifm0EJmfGBs0acIZCq4ulbcOFuYWPWk8TrPshB4w6URAZpPBUpHaO/m6fqXyyFo
         7GSr7ZSDVJva4NbwaWfG7wFaf2vFd4+vnyBpUVf6N+Gznvc6BoH4WFRx06PFHEEmxf8J
         218yvZJ5AhJuOEHsl0HOb41voW3KseVl9MHQXGHlDHP/YGOfFBGsGrSY2CIidGJW1S7/
         U8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050879; x=1695655679;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLknf5KveUwbOgFiDLEqsKxezP26LvkH2sQEbrP8ZIM=;
        b=AubXYaYs8CHodtO6Kk/YLBC/t7KRWxUru0hfGQcMOMG78Ug9pyabRmYpeXvUi4ngsU
         Ra0MQOFuYzi1ZpAXajr/wu8DoP+FQS8pfxPQKHXrtQHkkmTq7qnTKeErsRwHNxefk7Mt
         7FQbxlFk2LqzQG5/Q49W31WROCUi0wVEe+zJ+bCMg2huo13i/FQG7l4eHVlMmcyS/3wF
         LbN/kveegKmHaMjwkB8tCOKrID5KsQrDVqovXyZhlf0tGcGYbPfasEx4DAs3R/FPJHAO
         iyYovJ6IjIfwCR3JP5uecwVGQne7QFdzojH+aaqIU0uZp9aq9+5bcCjr+b9pGiC8o2EL
         hcaQ==
X-Gm-Message-State: AOJu0Yyo3AJVZAKdKA/KRnmcpt9rZuWeXDG2IPDE0dGuYZz6s9v3kw1g
        e6uw7VojiyDgcC6PuKWCvzEBsKETPweT3EWV
X-Google-Smtp-Source: AGHT+IE69fOxWC0eTzG+3LP4EPxG9wmOHmALxrhLRO2u7yVgSkOAEAgGa+kECMF2Awm1c0nSRiRh4A==
X-Received: by 2002:a5d:6b03:0:b0:317:1b08:b317 with SMTP id v3-20020a5d6b03000000b003171b08b317mr7489032wrw.6.1695044469398;
        Mon, 18 Sep 2023 06:41:09 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id e1-20020a5d65c1000000b00315af025098sm12710014wrw.46.2023.09.18.06.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 06:41:08 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <f5eab713-fa74-2cbc-7df5-81d8d26fee0a@xen.org>
Date:   Mon, 18 Sep 2023 14:41:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 11/12] KVM: selftests / xen: don't explicitly set the
 vcpu_info address
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-12-paul@xen.org>
 <f649285c0973ec59180ed51c4ee10cdc51279505.camel@infradead.org>
 <56dad458-8816-2de5-544e-a5e50c5ad2a2@xen.org>
 <c9a1961812b0cbb6e9f641dec5c6edcb21482161.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <c9a1961812b0cbb6e9f641dec5c6edcb21482161.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 14:36, David Woodhouse wrote:
> On Mon, 2023-09-18 at 14:26 +0100, Paul Durrant wrote:
>> On 18/09/2023 14:21, David Woodhouse wrote:
>>> On Mon, 2023-09-18 at 11:21 +0000, Paul Durrant wrote:
>>>> From: Paul Durrant <pdurrant@amazon.com>
>>>>
>>>> If the vCPU id is set and the shared_info is mapped using HVA then we can
>>>> infer that KVM has the ability to use a default vcpu_info mapping. Hence
>>>> we can stop setting the address of the vcpu_info structure.
>>>
>>> Again that means we're not *testing* it any more when the test is run
>>> on newer kernels. Can we perhaps set it explicitly, after *half* the
>>> tests are done? Maybe to a *different* address than the default which
>>> is derived from the Xen vcpu_id? And check that the memcpy works right
>>> when we do?
>>>
>>
>> Ok. The VMM is currently responsible for that memcpy. Are you suggesting
>> we push that into KVM too?
> 
> Ah OK.
> 
> Hm, maybe we should?
> 
> What happened before in the case where interrupts were being delivered,
> and the vcpu_info address was changed.
> 
> In Xen, I guess it's effectively atomic? Some locking will mean that
> the event channel is delivered to the vcpu_info either *before* the
> memcpy, or *after* it, but never to the old address after the copy has
> been done, so that the event (well the index of it) gets lost?
> 
> In KVM before we did the automatic placement, it was the VMM's problem.
> 
> If there are any interrupts set up for direct delivery, I suppose the
> VMM should have *removed* the vcpu_info mapping before doing the
> memcpy, then restored it at the new address? I may have to check qemu
> gets that right.
> 
> Then again, it's a very hard race to trigger, given that a guest can
> only set the vcpu_info once. So it can move it from the shinfo to a
> separate address and attempt to trigger this race just that one time.
> 
> But in the case where auto-placement has happened, and then the guest
> sets an explicit vcpu_info location... are we saying that the VMM must
> explicitly *unmap* the vcpu_info first, then memcpy, then set it to the
> new location? Or will we handle the memcpy in-kernel?
> 

Well, if the VMM is using the default then it can't unmap it. But 
setting a vcpu_info *after* enabling any event channels would be a very 
odd thing for a guest to do and IMO it gets to keep the pieces if it 
does so.

   Paul


