Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106906D9166
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbjDFIXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbjDFIXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:23:02 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A157AB9
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 01:22:55 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so19653108wms.5
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 01:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680769373;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f+vv1701z4r3GsWrWzYSdehjnmgPql22xoY5uBZzFYQ=;
        b=gHfZ72U8PDz3pJ0wSpvqzO56iy9RJ0imX7saOaCqxClUJyiEnArU+wNiP3jmx7GuRy
         hjYFHxs1VXKfQs6JeZuQN66v0h/MzWbkw/54erYOfqqRP4IvqRVebixWdejcycrQluvq
         cmFmI/l/3QGAaSDd0eF8KOrr+8Q0lO20Ymt9Qbsp+wHD4MRuYJTrHY8kQMa0iSuuyBV8
         EX0Mw0dI1i5p2m8GUqybfr/A9WAjUtFpbzvpcnshWY6fp2YHYQQNwatnwEwKYWFkQsVc
         hQpbvVFJA8PHRVwsFGuJChPbxSpU/kzukOpWkkyd6JHj/DpPbGk7w8fTt/6S9io95/0R
         yleQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680769373;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+vv1701z4r3GsWrWzYSdehjnmgPql22xoY5uBZzFYQ=;
        b=rwTCpQ3J7urTCVOkV3jM9GW3JarmxHfJEytk9NAHqbT3fB+uY0HVLigrCo6IBJqGw4
         TXqa2KqE6agHkhBK9Dojy+oQN4iteU1/zTndKI1SIWw9Hc5XSzJeqK0D38GJE2Y12GOC
         187UxhDLT0I6mDkBcgrtexBSM/QSjTkoVfKK3w1YlghvVhdcbwxZQ6O89/HfoBA5C+f5
         QhF8lvpkp1pQvVdklxIhrKxRHNPHRV/NAAO5WmobW0Fnszt2yzdZHuwD4dc4BccpKChL
         QzCzEvVcy7SjHP8QvOo3nsHY/egkA6jAzs3GRNN9gq6xfEUOJxM+PAwHStnIwCuceLUp
         TIdg==
X-Gm-Message-State: AAQBX9dkliUnIVxR+oxFQhiGQslkrKWeuocqZOkuvkaM3yVDOjf7b/Pc
        cWY5dQiKPZx6ZJwO+N+ieAu+mg==
X-Google-Smtp-Source: AKy350bcVUwtarMk34DWCLPwzCwjECA0NL2+n2OBSiBjCe9BW3F4CnRqEgBhgifFneH5j/sjzSbckw==
X-Received: by 2002:a1c:7c05:0:b0:3f0:3377:c15f with SMTP id x5-20020a1c7c05000000b003f03377c15fmr6665588wmc.12.1680769373564;
        Thu, 06 Apr 2023 01:22:53 -0700 (PDT)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id iv15-20020a05600c548f00b003ef5b285f65sm4614032wmb.46.2023.04.06.01.22.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 01:22:53 -0700 (PDT)
Message-ID: <c47e1b5a-38bb-fe08-8020-29361fd0e99a@linaro.org>
Date:   Thu, 6 Apr 2023 10:22:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 10/10] hw/s390x: Rename pv.c -> pv-kvm.c
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-11-philmd@linaro.org>
 <3cccc7e6-3a39-b3b4-feaf-85a3faa58570@redhat.com>
 <3fe240da-9a75-0e39-7762-cd91af9ed3f0@linux.ibm.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <3fe240da-9a75-0e39-7762-cd91af9ed3f0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 10:04, Janosch Frank wrote:
> On 4/6/23 09:50, Thomas Huth wrote:
>> On 05/04/2023 18.04, Philippe Mathieu-Daudé wrote:
>>> Protected Virtualization is specific to KVM.
>>> Rename the file as 'pv-kvm.c' to make this clearer.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>    hw/s390x/{pv.c => pv-kvm.c} | 0
>>>    hw/s390x/meson.build        | 2 +-
>>>    2 files changed, 1 insertion(+), 1 deletion(-)
>>>    rename hw/s390x/{pv.c => pv-kvm.c} (100%)
>>>
>>> diff --git a/hw/s390x/pv.c b/hw/s390x/pv-kvm.c
>>> similarity index 100%
>>> rename from hw/s390x/pv.c
>>> rename to hw/s390x/pv-kvm.c
>>> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
>>> index f291016fee..2f43b6c473 100644
>>> --- a/hw/s390x/meson.build
>>> +++ b/hw/s390x/meson.build
>>> @@ -22,7 +22,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>>>      'tod-kvm.c',
>>>      's390-skeys-kvm.c',
>>>      's390-stattrib-kvm.c',
>>> -  'pv.c',
>>> +  'pv-kvm.c',
>>>      's390-pci-kvm.c',
>>>    ))
>>>    s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
>>
>> Hmmm, maybe we should rather move it to target/s390x/kvm/ instead?
>>
>> Janosch, what's your opinion?
>>
>>    Thomas
>>
>>
> 
> Don't care as long as the file is not deleted :)

I followed the current pattern:

$ ls -1 hw/s390x/*kvm*
hw/s390x/s390-pci-kvm.c
hw/s390x/s390-skeys-kvm.c
hw/s390x/s390-stattrib-kvm.c
hw/s390x/tod-kvm.c

I'm still unsure where is the best place to put hw files which are
arch (and accel) specific.
