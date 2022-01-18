Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4982E492248
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345405AbiARJL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:11:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345369AbiARJLX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:11:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642497082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnZYlrqb+kccpImxETiPk8O/an1BetjSM81KO3wlhaI=;
        b=LBZK6nT16IOrhWotAgc8fOTiOMp//t4ct2SMS/aYf+vbAVbaXpIal+gdG7PhcWPpKv9S2z
        uP0sdEbNjnQecFuDCLEyjg3gwaaSCea9sr6m+9YV+2KqisQuKBcNQRUuRHUFtKdd+N2Jq3
        gw7LrTY/32LI//Lf1t7raT/3tgZ8+Bg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-Iyw2MmfDP1WdaYr0oy266g-1; Tue, 18 Jan 2022 04:11:20 -0500
X-MC-Unique: Iyw2MmfDP1WdaYr0oy266g-1
Received: by mail-wm1-f71.google.com with SMTP id n13-20020a05600c3b8d00b0034979b7e200so6535706wms.4
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 01:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pnZYlrqb+kccpImxETiPk8O/an1BetjSM81KO3wlhaI=;
        b=xdACinWBuqPARl5yMSP+BPgG713D8cca92VY6V5X+cwMBF/ZeSIijrM0duBrFeWluJ
         /ll4op0WiM5gJ4HvlG1ibQ/vxDJxkCtqvRV5jAJXXKW1BZ6GYmWOcRBhnd1IBwI1ZeFt
         lerz1Dr4bEf6roHVN/Yj0/Y+Mbx0GC0A/bVJp/G4TmQAS59zIqTTPKnUkDFERyscYqCA
         mxcizTl64pGX+TZTk82yGP9ZXHxYvqxVifI1FKM6EPEbLPMCRMADv9aKcIQNRTcCTXBd
         3ms1SGkGtNdTz/kl1Qww4hiDSQLeACQzLu75+yy3sMZ4W9dd4GVQlWvTBqmbvRwq8Etd
         r3jA==
X-Gm-Message-State: AOAM5324u/DPq0BJpJoA0zH6jUeD+ZZOK5C4KW//AfKK2CAvRPPGj57W
        U86Zv6D/e0F5ayzRLdkvctJIiAja1ywrUpwMK9+edvU/7RjypI2Nled37997ojx5hE77Cs4/tOy
        3D8Dckram7+cE
X-Received: by 2002:a5d:6482:: with SMTP id o2mr23288394wri.692.1642497079261;
        Tue, 18 Jan 2022 01:11:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxX9R9/kyDmu9DEklwF6y+7LHIotrcBeoXcHfx0Pl2GXyXMlM9PsObNEZngp5OGmpRXE0DTCg==
X-Received: by 2002:a5d:6482:: with SMTP id o2mr23288360wri.692.1642497078991;
        Tue, 18 Jan 2022 01:11:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z1sm13403595wrw.95.2022.01.18.01.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:11:18 -0800 (PST)
Message-ID: <c173ea91-87a9-bbd5-0216-26bbb0615a38@redhat.com>
Date:   Tue, 18 Jan 2022 10:11:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Like Xu <like.xu.linux@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20211217124934.32893-1-wei.w.wang@intel.com>
 <CALMp9eR18D6omo6kVTUXQ2enPpUBE=5oQWvQ5uiYu_0h6npE8A@mail.gmail.com>
 <0c87c3e5e1dd4c03959c6c1b0e4fd05a@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0c87c3e5e1dd4c03959c6c1b0e4fd05a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 06:04, Wang, Wei W wrote:
> On Tuesday, January 18, 2022 11:54 AM, Jim Mattson wrote:
>> On Fri, Dec 17, 2021 at 6:05 AM Wei Wang <wei.w.wang@intel.com> wrote:
>>>
>>> The fixed counter 3 is used for the Topdown metrics, which hasn't been
>>> enabled for KVM guests. Userspace accessing to it will fail as it's
>>> not included in get_fixed_pmc(). This breaks KVM selftests on ICX+
>>> machines, which have this counter.
>>>
>>> To reproduce it on ICX+ machines, ./state_test reports:
>>> ==== Test Assertion Failure ====
>>> lib/x86_64/processor.c:1078: r == nmsrs
>>> pid=4564 tid=4564 - Argument list too long
>>> 1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
>>> 2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
>>> 3  0x00007fbe21ed5f92: ?? ??:0
>>> 4  0x000000000040264d: _start at ??:?
>>>   Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)
>>>
>>> With this patch, it works well.
>>>
>>> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
>> Reviewed-and-tested-by: Jim Mattson <jmattson@google.com>
>>
>> I believe this fixes commit 2e8cd7a3b828 ("kvm: x86: limit the maximum
>> number of vPMU fixed counters to 3") from v5.9. Should this be cc'ed to
>> stable?
> 
> Sounds good to me.

Sent, thanks.

Paolo

