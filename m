Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02D6475A3A
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 15:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243132AbhLOOCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 09:02:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243130AbhLOOCY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 09:02:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639576943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q6MoDlUh4lUQ6kt2VQqZXRRS2ITxVqs8vvu8gVek5AM=;
        b=jNNIhMSOoIm7myT4bGXyWJMszViigIehcAcIEmVhhjBrHaY3NxdPjZe62OwmZApkHpYhqS
        O1BLNUJfOo33jkuuKozBXOrRz6o3N3wBr5chfy7leT5FCt3g3/pmL0ZlRcjhBS5AASYGBb
        EOzUTqsPv73Yr8hGTjaZEf4hK4f3sfc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-jmffQF90N1eXSYujV8pBfA-1; Wed, 15 Dec 2021 09:02:21 -0500
X-MC-Unique: jmffQF90N1eXSYujV8pBfA-1
Received: by mail-wm1-f71.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so9035774wmq.9
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 06:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=q6MoDlUh4lUQ6kt2VQqZXRRS2ITxVqs8vvu8gVek5AM=;
        b=EeSstsbAb2m91CD9GfTKwro1Apsk4Gq9qM3ekP93kUlLMcAg5PcVv5aeXKI1bbo9Yi
         MPPRXpRq55/KR/WEpT/ruuBO+rEy237orSjRfpoY4tem4n+hQiEQ9I/0uk+VhCT9I3fo
         N9PJh8ZGQ5Z47fNPrOEODkR9K6Da+KFTO0+5P5/syuD6u+Xs4de0iYHfTb18/cN+2MPu
         JKWhoxeHe1hjTWf/ylC4P9R5Kqo0RTanWngJ5BfuV1in7l8zi6Azezyt6022WVWS35ZV
         jP2r0jgqitgMOT+imsovXk9Fmzk+m4afNErmR8Qx2//U3U/GhevNSN1T7p+rTgJqC/uq
         aPAw==
X-Gm-Message-State: AOAM533KH/WTiN0//PTgHRLeUb/imIkrbd46hYoqnvxN0ToitwUln+np
        Rz0DxpP+Yf4wu81y5wiSiigz/bEH57rzjWTzPy2scUz4nGm3MLfX0wpxEe5R4N2/ix5cPhzjhAX
        i9rCppq7mjnMG
X-Received: by 2002:a5d:4c86:: with SMTP id z6mr4479235wrs.219.1639576940104;
        Wed, 15 Dec 2021 06:02:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwT+b4PVmror5PHHyh1MdgIRMB1RrENwGezITjRa5018QaGc8DMlEZhh+RI6d8sbWJ+WNeJFA==
X-Received: by 2002:a5d:4c86:: with SMTP id z6mr4479218wrs.219.1639576939906;
        Wed, 15 Dec 2021 06:02:19 -0800 (PST)
Received: from [192.168.3.132] (p5b0c609b.dip0.t-ipconnect.de. [91.12.96.155])
        by smtp.gmail.com with ESMTPSA id r20sm1146840wmd.37.2021.12.15.06.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 06:02:19 -0800 (PST)
Message-ID: <a7c7567d-9345-ea85-4866-c0de28decd29@redhat.com>
Date:   Wed, 15 Dec 2021 15:02:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v5 1/1] KVM: s390: Clarify SIGP orders versus
 STOP/RESTART
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211213210550.856213-1-farman@linux.ibm.com>
 <20211213210550.856213-2-farman@linux.ibm.com>
 <3832e4ab-ffb7-3389-908d-99225ccea038@redhat.com>
 <28d795f7-e3f7-e64d-88eb-264a30167961@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <28d795f7-e3f7-e64d-88eb-264a30167961@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.12.21 14:57, Christian Borntraeger wrote:
> 
> 
> Am 15.12.21 um 14:24 schrieb David Hildenbrand:
>> On 13.12.21 22:05, Eric Farman wrote:
>>> With KVM_CAP_S390_USER_SIGP, there are only five Signal Processor
>>> orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL, EXTERNAL CALL,
>>> SENSE, and SENSE RUNNING STATUS) which are intended for frequent use
>>> and thus are processed in-kernel. The remainder are sent to userspace
>>> with the KVM_CAP_S390_USER_SIGP capability. Of those, three orders
>>> (RESTART, STOP, and STOP AND STORE STATUS) have the potential to
>>> inject work back into the kernel, and thus are asynchronous.
>>>
>>> Let's look for those pending IRQs when processing one of the in-kernel
>>> SIGP orders, and return BUSY (CC2) if one is in process. This is in
>>> agreement with the Principles of Operation, which states that only one
>>> order can be "active" on a CPU at a time.
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>
>> In general, LGTM. As raised, with SIGP RESTART there are other cases we
>> could fix in the kernel, but they are of very low priority IMHO.
> 
> Does that qualify as an RB, assuming that we can fix the other cases later on?
> 

Certainly an Acked-by: David Hildenbrand <david@redhat.com> , to fully
review I need some more time (maybe tomorrow)

-- 
Thanks,

David / dhildenb

