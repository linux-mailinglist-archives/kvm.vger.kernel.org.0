Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E23533885
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 10:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiEYIcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 04:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiEYIcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 04:32:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E692DE9;
        Wed, 25 May 2022 01:32:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q4so17962817plr.11;
        Wed, 25 May 2022 01:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nKbOgKtlUjU3TGj1E+jXYf223t+SFYJQXWgcOdb/AMg=;
        b=n7Mjzc9f3IEI3faWAlV1FuFa4TmAUdDDFlLD///+He05XLbfwfHgQH/vF4lkbnZgSN
         FmJYpBeQCmvAOPU5kcLqD3GwQPNDX4juzR0CbEsL1JUprPlMIpDtW5d3HW/b8eLFOdJW
         clRSMYSE3ZsEY1lPuEdgD70A0NvcWBbdFK0fS04oX4piIkMfRhUEtzjgytsXiSgilgU2
         mNLiYY40a+7eoiEfg2lrpJDa4PAUHqIpI75qECJcF4Us5h65tBBnv/Hopt1B2BUZhMER
         +jXNNC5vjmprIRltUdVqzrGKlnz8uNHcWVgyqQF7OUobid/5kjaX1SfNUWiB+2FitT1L
         4UZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nKbOgKtlUjU3TGj1E+jXYf223t+SFYJQXWgcOdb/AMg=;
        b=PtXEYLmDO9y2t2WP6spbRurEktMU1guytcCbf1RpDWNjJ/a02929ohQgE6hXcQTi6g
         Y3tgOYIw1VndyJUE6F9BseGl1Q9+V8c13z3JR78M+e6TUX7HMUHyCqm7J6TQShkggYfj
         pp/bvRDEfq/EKFSCLVRHMLa5b9SuRJrGIISFzrWL43Y3QaWxi8WBDLH8a6GFnX4fm7AN
         vl2csAQxMaD/BA5dvdc4uafC7BzU+zfDcu0jH5srLZRd0i+oeclQhe0KEcMg1dY7YgeS
         2NJXQ/CPc8DAfFrTHZEY0vc2DKp2dOHtTz8C50mIsYjw49Wf82HBUP16m2mXRZesDcje
         Ju1Q==
X-Gm-Message-State: AOAM533Zhl7b7icRyvtU308covfGE0belKYzlfj2SV5rP6nCNlUx7UBB
        mKU9wWz/KAoXJ5+PhPn55+0=
X-Google-Smtp-Source: ABdhPJwfM0uTGjqXNWZmQHzYQEE9pEx5LovdMgqD8PxhrGrX/SmPs9dsoeuOxBUcNI1J3djQJ4nsxw==
X-Received: by 2002:a17:902:8608:b0:158:c532:d8b2 with SMTP id f8-20020a170902860800b00158c532d8b2mr31610863plo.46.1653467560337;
        Wed, 25 May 2022 01:32:40 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.80])
        by smtp.gmail.com with ESMTPSA id b8-20020a6541c8000000b003f64036e699sm7894948pgq.24.2022.05.25.01.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 01:32:40 -0700 (PDT)
Message-ID: <289d0c88-36a0-afd4-4d47-f2db3fb63654@gmail.com>
Date:   Wed, 25 May 2022 16:32:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220411101946.20262-1-likexu@tencent.com>
 <87fsl5u3bg.fsf@redhat.com> <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
 <d7461fd4-f6ec-1a0b-6768-0008a3092add@gmail.com> <874k1ltw9y.fsf@redhat.com>
 <f379a933-15b0-6858-eeef-5fbef6e5529c@gmail.com>
 <0848a2da-c9cf-6973-c774-ff16c3e8a248@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <0848a2da-c9cf-6973-c774-ff16c3e8a248@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/5/2022 4:14 pm, Paolo Bonzini wrote:
> On 5/25/22 09:56, Like Xu wrote:
>> Thanks for the clarification.
>>
>> Some kvm x86 selftests have been failing due to this issue even after the last 
>> commit.
>>
>> I blame myself for not passing the msr_info->host_initiated to the 
>> intel_is_valid_msr(),
>> meanwhile I pondered further whether we should check only the MSR addrs range in
>> the kvm_pmu_is_valid_msr() and apply this kind of sanity check in the 
>> pmu_set/get_msr().
>>
>> Vitaly && Paolo, any preference to move forward ?
> 
> I'm not sure what I did wrong to not see the failure, so I'll fix it myself.

More info, some Skylake hosts fail the tests like x86_64/state_test due to this 
issue.

> 
> But from now on, I'll have a hard rule of no new processor features enabled 
> without KVM unit tests or selftests.  In fact, it would be nice if you wrote 
> some for PEBS.

Great, my team (or at least me) is committed to contributing more tests on vPMU 
features.

We may update the process document to the 
Documentation/virt/kvm/review-checklist.rst.

> 
> Paolo
> 
