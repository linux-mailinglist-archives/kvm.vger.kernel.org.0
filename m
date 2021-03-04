Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE1332D802
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 17:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbhCDQog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 11:44:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238278AbhCDQoK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 11:44:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614876165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rn1StLXZdW6IQ/ZFu/LT6OMRfbl/UTGxj84sgLnKJ1o=;
        b=ZihSgz4BhAVxy/GOZlimg6KTUTHd3ukFH/nNyLR2VzkI1GSFRyV8ateDpiBU3AMFxiUS3M
        3mzwYKO2zVSmHJB8yTHAOn+2/2GXkVqRniLcqPd+bLL66km+MnXuwbCbllfGa23i1aDAXd
        2301sSuQq0RXKDfEOf1OaxKKoOkhH5c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-jYj9oAEbOUeF2ZRmcuVOhA-1; Thu, 04 Mar 2021 11:42:43 -0500
X-MC-Unique: jYj9oAEbOUeF2ZRmcuVOhA-1
Received: by mail-wr1-f69.google.com with SMTP id h21so10192798wrc.19
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 08:42:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rn1StLXZdW6IQ/ZFu/LT6OMRfbl/UTGxj84sgLnKJ1o=;
        b=buKEKu6NSajuaR0B2Czz1C4Mot/PKl1kqSNz8rjQVopR4TF3wyoCz4dhiG5KjzzWnk
         tdsYGllCrRmd0kT9T79Zop4Kt0tQpRmkU0umzP9oBEJCtB5sh8LgkJ8rRfB7hpCZR6s8
         9t3VqcsXgSk+RhwWp8cEuIk89t0DZ/VV/GYzOOm9RNrWaoAp8gbF8UoROcyLJIq7vH/a
         guZvpF9zxmYZlylfrY8ardnfqtYw6h09mrUCEsUm6z1stm4FeR7xVRYoz35fNU8PYYr/
         ZqPpr+NdxBnGYKf+mSyN9olFbVhFDAsrnPfjCDxqvSs96rK9vgy+KWypPJ9gCjjQ6a1E
         VXGw==
X-Gm-Message-State: AOAM532/tykA7nJ6CjE8Cyq7I9onb5c/9nEgsMdHg6ehNlPQOdE8mevj
        KVr1I5lYoUN4beOYI2ZPai2wkR8GmRwUePNkBGD8BVLnA9tqjcivtRTNHPWy+C8Upytb9Y78/f8
        2z9BtAZLPq3ii
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr4806941wml.44.1614876161541;
        Thu, 04 Mar 2021 08:42:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlz2KI52j/UDlEp7oVCtpCjF1XnFxEBvR4mD5eNHUGALzd8nuIyf5zrSrb0kgOsHXKBSMhVw==
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr4806917wml.44.1614876161342;
        Thu, 04 Mar 2021 08:42:41 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id g16sm19407990wrs.76.2021.03.04.08.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 08:42:40 -0800 (PST)
Subject: Re: [RFC PATCH 00/19] accel: Introduce AccelvCPUState opaque
 structure
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com
References: <20210303182219.1631042-1-philmd@redhat.com>
 <a84ce2e5-2c4c-9fce-d140-33e4c55c5055@redhat.com>
 <1eda0f3a-1b11-a90e-8502-cf86ef91f77e@redhat.com>
 <438743f3-6e97-1735-6c11-26d261fa91b4@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <a37683ea-a05f-e3a3-43b0-084f830ccd72@redhat.com>
Date:   Thu, 4 Mar 2021 17:42:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <438743f3-6e97-1735-6c11-26d261fa91b4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/21 4:40 PM, Paolo Bonzini wrote:
> On 04/03/21 15:54, Philippe Mathieu-Daudé wrote:
>> On 3/4/21 2:56 PM, Paolo Bonzini wrote:
>>> On 03/03/21 19:22, Philippe Mathieu-Daudé wrote:
>>>> Series is organized as:
>>>> - preliminary trivial cleanups
>>>> - introduce AccelvCPUState
>>>> - move WHPX fields (build-tested)
>>>> - move HAX fields (not tested)
>>>> - move KVM fields (build-tested)
>>>> - move HVF fields (not tested)
>>>
>>> This approach prevents adding a TCG state.  Have you thought of using a
>>> union instead, or even a void pointer?
>>
>> Why does it prevent it? We can only have one accelerator per vCPU.
> 
> You're right, my misguided assumption was that there can only be one of
> WHPX/HAX/KVM/HVF.  This is true for WHPX/KVM/HVF but HAX can live with
> any of the others.

I suppose you aren't talking about build-time but runtime. There should
be no distinction related to accelerator at runtime. We should be able
to have multiple accelerators at runtime, and eventually be able to
migrate vCPU from one accelerator to another, if it is proven useful.

How accelerators are orchestrated is obviously out of the scope of this
series.

> However this means that AccelvCPUState would have multiple definitions.

Yes.

>  Did you check that gdb copes well with it?

No, I haven't, because we already use opaque pointers elsewhere.

> It's also forbidden by
> C++[1], so another thing to check would be LTO when using the C++
> compiler for linking.

OK, I have no clue about C++ (and tries to keep QEMU way from it)
or about LTO. So I'd need to investigate that.

> 
> Paolo
> 
> [1] https://en.wikipedia.org/wiki/One_Definition_Rule
> 
>> TCG state has to be declared as another AccelvCPUState implementation.
>>
>> Am I missing something?
>>
>> Preventing building different accelerator-specific code in the same
>> unit file is on purpose.
>>
>> Regards,
>>
>> Phil.
>>
> 

