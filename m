Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6116C616B
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 09:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCWIQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 04:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCWIQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 04:16:17 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9284D2F786;
        Thu, 23 Mar 2023 01:16:16 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y2so8200582pfw.9;
        Thu, 23 Mar 2023 01:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679559376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=usnIjHwz36hfSgB6TOSaOZ0wc+pBGQXqLiqMJobH5vs=;
        b=SSDMz4HNblLnK3JC26k6p35IrRxAfF1kISi4xbyv76O/Jlo66wzdT/f1HBn4xEDutV
         TgvtcIi92PIqkf78deWWk4VYp64zcUaw2wdJVfW9bncxJ7eFxaysLGqx0OipH9+fyD4w
         tI80bLBOyeNaRiDVF+enE7gE6hDw1o5X0xj6FAsiTFrUle6Xu8r0UJ7jc3NOlwz5iIJQ
         dxThj3WcUJERbg39EsPvJibU6mOUM3fC0Hq5YEvo95xHHTl6bX/ARNWwlWDaslLaVR1j
         33nzNSyYiGg2GqARlP4GHsdm1sWIRfmf3MFarnNc2PJ/ei/578clPxEzErr33vGVhIsZ
         hwag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679559376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=usnIjHwz36hfSgB6TOSaOZ0wc+pBGQXqLiqMJobH5vs=;
        b=7kyrYD5QfsnNtPGcUnH/DdN+lrWnQpM0p/XQebUqeAFqbxc884CJjby1TeRs7VJov3
         aMQmGpCGX5gE8/Q/4czpHecgWevqT4HbPXi0/ap3cHj3dO5wu1FVsa1RvrQlxwWG2cLC
         RVVN4rc1Yf1CujOVLV+SyvAYagpS6xQyY3rk63dDZOu47HwD8koVdmSn/bR7d2SFiKO4
         v6m1lAlFKxnJYD1qzL+Lnropeim7+0QhltNVtnwpEBa2OBChyNH4G9vs5mczPcgnrgXp
         Zqk9e4uanqADfi1kujJwoOhg55XoXBZ2bVfpNssfkIecy9yNP9rADJaisP/PuR1WOB7w
         Wcvg==
X-Gm-Message-State: AO0yUKXJ9cmGbbSBV6CfWDxEVQl8fnOAzO1emoz4L7NXYFtRQ7FN0kw3
        C3lihLrtilDApk3o+VJ/TRYUX9GnjbKNjKg7
X-Google-Smtp-Source: AK7set+PTZ9zt7tw/2afPwV2sY4SwtDV5GUrQmHbZPb2gtTaRyYjxl2Gw7Mvo0qnW8FenvvHpPSr8g==
X-Received: by 2002:aa7:9e44:0:b0:624:2e60:f21e with SMTP id z4-20020aa79e44000000b006242e60f21emr5580517pfq.29.1679559376054;
        Thu, 23 Mar 2023 01:16:16 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m26-20020aa78a1a000000b005a8a5be96b2sm7898233pfa.104.2023.03.23.01.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 01:16:15 -0700 (PDT)
Message-ID: <589b70b6-6795-7f15-45c8-59a9736d3488@gmail.com>
Date:   Thu, 23 Mar 2023 16:16:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH 0/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>,
        Sandipan Das <sandipan.das@amd.com>
References: <20230310105346.12302-1-likexu@tencent.com>
 <a53c8ba7-f66d-5bd7-c934-2357f42b3ac9@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <a53c8ba7-f66d-5bd7-c934-2357f42b3ac9@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/3/2023 6:57 pm, Sandipan Das wrote:
> +CC: Santosh, Tom, Ananth
> 
> Hi Like,
> 
> On 3/10/2023 4:23 PM, Like Xu wrote:
>> Considering that developers are more likely to have access to AMD VMs
>> and use vPMU inside guest, there's a dark cloud that needs to rain.
>> The x86_64/pmu_event_filter_test always fails on Zen3 boxes:
>>
>>    test_amd_deny_list: Branch instructions retired = 43 (expected 42)
>>    test_without_filter: Branch instructions retired = 43 (expected 42)
>>    test_member_allow_list: Branch instructions retired = 43 (expected 42)
>>    test_not_member_deny_list: Branch instructions retired = 43 (expected 42)
>>
>> ,which is not caused by the event_filter feature (otherwise it's zero).
>>
>> After some dubious guessing and microtesting on Zen3+ pmu hardware,
>> we found that VMRUN or one of the instructions in __svm_vcpu_run()
>> causes a guest-only enabled counter for counting guest instruction (in the
>> pmu_event_filter case, the branch instruction) to always increase by one
>> right after each vm_entry.
>>
>> This creates an inconsistency with the AMD64_EVENTSEL_GUESTONLY,
>> where the vPMU user in the VM does not expect to see any counter
>> changes due to the SVM transaction at all. This patch set provides a low
>> overhead software fix until HW change arrives or simply no fix planned.
>>
> 
> Yes, VMRUNs do get counted as retired branches in the guest context. My
> understanding is that this behaviour applies to all generations of Zen
> and even some older ones too, not just Zen 3 and later. I also do not
> expect this to change in the near future.
> 
> - Sandipan
> 

Interesting, thanks for confirming this issue (I presume this is an official reply).

If this hardware behavior is not expected to change, this software-based correction
would be essential and urgent for those who only use vPMU inside AMD guests.

Let's see what will happen ...
