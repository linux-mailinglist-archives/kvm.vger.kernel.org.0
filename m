Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3093161FCF0
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiKGSLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiKGSK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:10:59 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133832A703
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:08:49 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p16so7386753wmc.3
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iyemd4HvK+DGYoF1NoBJb/8v7rlPpLIo+qNtTJ7A0Ww=;
        b=BZYjDsn/5DylRVSBVwNfJ49v8b0I/sVskWuhe3YR71vQtj5NDJzzp3iI6/QEi20uYL
         FfZ9yZ5wd4+4/poDHpX42prieA/ABkyC9CMQCh8Kecv0rC8XTeq3E1iJZPH8TjytnPdm
         2KlApBArF0MjvFn6tfAVN1Px/03htSrzGTSD/rZimuCZerxfr5UZaOjlok3me3++Tac1
         K28jTJyoLWZDWNcVKYmtEPRMBcnpqfotxiVKufkl0BqNoMln9J5KDjPL/ZHqGFGRkhzA
         cC0F9ou2jlvBM4qjHfFw/yQsFEv8QxoEYMTpdr5v19/00tG9yoLn+OiUMjV1ySZYM1SP
         3mjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iyemd4HvK+DGYoF1NoBJb/8v7rlPpLIo+qNtTJ7A0Ww=;
        b=cirNi2vFDU9iEqDvx2OeNbB5ldvhfc2XcTOmIYKJa0Rp/LehFOA+xllphjXYkND2+8
         8Buv+FVJOmoL9zjJypnmnN9gBGiozfGqGcDzPWsYCJdTLv+ZDWjnl+SUAr3jZHnEgaIk
         gUwrpt1OEeL10BKaSbv+Rz3o1GJxy4tM0GvxixfpbR00hNrlso0ZlmZ25LVT+uUhcZAe
         zzROaf+NIdbm/18nKGQN3MwN4gohzNl1Z92Rr062y/Hidp9PXuz3pHUMZNi91335EDa1
         xgXCGFkx14UsS70muUvNUDQ/is29yfm4Je4qli3a8EbLgMU+pmrOfFlDXU7zMzX4ChBW
         XxeQ==
X-Gm-Message-State: ACrzQf0biaEqnhZ2HPajMuIPmVB8Q+OnlToo3/I+ItBjqHiGWXNyodRB
        EYeYRCH31yIa0Wx7mUIpEWkTTA==
X-Google-Smtp-Source: AMsMyM5Hh1s5ndsMCASrivT9+H550/0X3uXptpk3+2XbPJSWiaha1BuW5q/Uu0FobiOLXQQyw1iRlA==
X-Received: by 2002:a05:600c:1609:b0:3cf:4dc4:5a99 with SMTP id m9-20020a05600c160900b003cf4dc45a99mr34442575wmn.67.1667844527658;
        Mon, 07 Nov 2022 10:08:47 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8? ([2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003b4fdbb6319sm13186914wmq.21.2022.11.07.10.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 10:08:46 -0800 (PST)
Message-ID: <71a41442-b1eb-d02e-53fe-c35dbcfc8416@bytedance.com>
Date:   Mon, 7 Nov 2022 18:08:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [v2 2/6] KVM: arm64: Add SMCCC paravirtualised lock calls
Content-Language: en-US
To:     Punit Agrawal <punit.agrawal@bytedance.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, fam.zheng@bytedance.com, liangma@liangbit.com
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <20221104062105.4119003-3-usama.arif@bytedance.com> <87cz9y3avq.fsf@stealth>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <87cz9y3avq.fsf@stealth>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/11/2022 17:58, Punit Agrawal wrote:
> Usama Arif <usama.arif@bytedance.com> writes:
> 
>> Add a new SMCCC compatible hypercalls for PV lock features:
>>    ARM_SMCCC_KVM_FUNC_PV_LOCK:   0xC6000002
>>
>> Also add the header file which defines the ABI for the paravirtualized
>> lock features we're about to add.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> ---
>>   arch/arm64/include/asm/pvlock-abi.h | 17 +++++++++++++++++
>>   include/linux/arm-smccc.h           |  8 ++++++++
>>   tools/include/linux/arm-smccc.h     |  8 ++++++++
>>   3 files changed, 33 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/pvlock-abi.h
>>
>> diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
>> new file mode 100644
>> index 000000000000..3f4574071679
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pvlock-abi.h
>> @@ -0,0 +1,17 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
>> + * Author: Zengruan Ye <yezengruan@huawei.com>
>> + *         Usama Arif <usama.arif@bytedance.com>
>> + */
>> +
>> +#ifndef __ASM_PVLOCK_ABI_H
>> +#define __ASM_PVLOCK_ABI_H
>> +
>> +struct pvlock_vcpu_state {
>> +	__le64 preempted;
>> +	/* Structure must be 64 byte aligned, pad to that size */
>> +	u8 padding[56];
>> +} __packed;
> 
> For structure alignment, I'd have expected to see the use of "aligned"
> attribute. Is there any benefit in using padding to achieve alignment?
> 
Just made it consistent with pvclock-abi.h. If its more appropriate, can 
change to aligned in next patchset:

diff --git a/arch/arm64/include/asm/pvlock-abi.h 
b/arch/arm64/include/asm/pvlock-abi.h
index 3f4574071679..bacec4cb927a 100644
--- a/arch/arm64/include/asm/pvlock-abi.h
+++ b/arch/arm64/include/asm/pvlock-abi.h
@@ -11,7 +11,6 @@
  struct pvlock_vcpu_state {
         __le64 preempted;
         /* Structure must be 64 byte aligned, pad to that size */
-       u8 padding[56];
-} __packed;
+} __attribute__((aligned(64)));


> [...]
