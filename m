Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B7749250B
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbiARLih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:38:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236389AbiARLif (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 06:38:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642505914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90zal2vcOOx5Nr7M9/hBahohc/axylAG/3ZhLQE76U0=;
        b=DtHaDWu9HzZakfWh7uRzYKn6x2Qsfc8lgAH2JYRrko6gJ0T9kJrCfb/q5BC0vLeqLcxl2W
        gkP2QmdE3orvU3V37pxajg1r4XhTmjQJ+CuXLbbivc6aR3soh8JGHVBa/KIbSt2eBnSNyu
        bQXtputepP2oD6yJUKFrhG/dHXUgVEM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-Yz_-IyzGPjSBue_lgddg5g-1; Tue, 18 Jan 2022 06:38:33 -0500
X-MC-Unique: Yz_-IyzGPjSBue_lgddg5g-1
Received: by mail-wm1-f70.google.com with SMTP id l20-20020a05600c1d1400b0034c29cad547so1647490wms.2
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 03:38:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=90zal2vcOOx5Nr7M9/hBahohc/axylAG/3ZhLQE76U0=;
        b=5LzBwHKT4R7K3malZj67qJQGe6tL4GPsriQIRk6Du1nZV7dEL0Fveiypq3f/Gc2R+a
         z94oABBgIgHgzPZMMJhsNKlVpyqdrRskahnRs0VMsF7OGp/hxeROhlq89wUig5IFYCUN
         8Ahg37eA+G8NtAUQX4QwSQKkBiqMAUpbJDbmGTy4Grcny2n+fmXbwEqD8Ffq3ERolUun
         xym5kaJczRKc2N16Dyn6aoAnM66fdloY7p5VXh5sczNL3QJLA5/OIknxKJBCxUzmJcEf
         25r+GVHs/tTJP6owLG27rJU/pEMGzrcGT6lfCa2+UuDcmqJTtq0LHwUkjlquArt47w/p
         pKrA==
X-Gm-Message-State: AOAM533FJaC2iPxhn+6YGcoDWH0ADyvn+onB7tFoM88OHa6q9fn/GhGm
        0/mEePgliam/48hPuVRW6h6eH3VzCMEVe1sX8lYqme1YHW2UFITOKBCNIS92Uswyz5KF9gpsN/v
        rbevMMstx2uos
X-Received: by 2002:a05:600c:3541:: with SMTP id i1mr12684724wmq.90.1642505912551;
        Tue, 18 Jan 2022 03:38:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6kv3SOcwFtdxItluWT52SndPpddqLdJ6KglA3VTV7P1C488CzREec0sTLEJ4z3DPnn8/hnA==
X-Received: by 2002:a05:600c:3541:: with SMTP id i1mr12684710wmq.90.1642505912391;
        Tue, 18 Jan 2022 03:38:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 10sm2110228wmc.44.2022.01.18.03.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 03:38:31 -0800 (PST)
Message-ID: <47088944-b1f9-1ae2-5ac5-91bab07a1762@redhat.com>
Date:   Tue, 18 Jan 2022 12:38:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH 0/3] Add L2 exception handling KVM unit
 tests for nSVM
Content-Language: en-US
To:     "Shukla, Manali" <mashukla@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Cc:     kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
References: <20211229062201.26269-1-manali.shukla@amd.com>
 <Yd9ITZv48+ehuMsx@google.com> <aaf59b12-4537-8f3e-6c7d-de2571630806@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <aaf59b12-4537-8f3e-6c7d-de2571630806@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 12:11, Shukla, Manali wrote:
>>
>> It doesn't seem like it'd be_that_  difficult to turn vmx_exception_test into a
>> generic-ish l2_exception_test.  To avoid too much scope creep, what if we first get
>> Aaron's code merged, and than attempt to extract the core functionality into a
>> shared library to reuse it for nSVM?  If it turns out to be more trouble then its
>> worth, we can always fall back to something like this series.
>>
>> [*]https://lore.kernel.org/all/20211214011823.3277011-1-aaronlewis@google.com
> This patch has already been queued by Paolo.
> I will wait till Aaron's code is merged and than do appropriate changes.
> I hope this is fine.

Yes, it is.  I am holding on Aaron's series because of the remarks from 
Sean[1], on the other hand it's really difficult to share code between 
VMX and SVM tests.  So while I agree that a lot of code changes can be 
done the same way to VMX and SVM tests, it's not really feasible to keep 
them in sync.

Paolo

[1] https://lore.kernel.org/all/Yd8+n+%2F2GCZtIhaB@google.com/#t

