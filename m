Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E48341734
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 09:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhCSIR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 04:17:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234249AbhCSIRI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 04:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616141826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GPmISnyfdyOHYuw/DXCIruI/XlrV8vtOEMpbuKM3mnk=;
        b=HAckDQmIBe+P+IE+xgn4WPXa71wGlseRpo1rdTFRMyI8R3wi39ArLdsRdWz0H2iYFIMl9+
        Uf/BEOKhcGNmLFR625XG6/7D4KV79N8hmg7ykqdGNmHAmTXXpQZIMfQEaUgJsWxwdvUnyV
        mQwSM8l2kbj+YqNChjupAg8x1x00rEo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-UKLOAM-IMIi8L5OUnmWAoA-1; Fri, 19 Mar 2021 04:17:02 -0400
X-MC-Unique: UKLOAM-IMIi8L5OUnmWAoA-1
Received: by mail-ej1-f71.google.com with SMTP id e13so17831128ejd.21
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 01:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GPmISnyfdyOHYuw/DXCIruI/XlrV8vtOEMpbuKM3mnk=;
        b=iR6WU9Qa3jI9p/S3jSkLV34slpDayoYqBMWkxCXzhlJ2NiZ/6Ki+YJSpoL5IHdJ5fu
         skOMWoVPGlIwPKlIbzlX7rb2oQb8/mi7meijoEXZcm77Ef5g4TVyBfTCcnFpiDf/yxAG
         QpreC6n8Sx6FjgcQ7AOAOIWsEexXdMkZPHcqWQ9y17hI4WnbVVrQGHvlMuZTWmxjWLdb
         nYKFuKtv0AFZZGmrzC5Vfip5D80LM2iczuSlCYU85UMJU/CbEdgnhUoA6EIx7Y2tg6ac
         kGt/ezA8AZhZc7GncXoBes0p88NLlhHqY72+not5a2hQUEkih1th3A8hk7C/zK+pF37B
         FBTA==
X-Gm-Message-State: AOAM533CpeD41UUQAgKlPyQtDcfmpwT+GZlmuba79U43PO9xAC3726+U
        GmpJtH8ElvuTorqXne1n9FaYNQ9BKrlFPijllDkk7fZpmUhdWnFcVYFvXhDwJTm1B0SWPMZ0Gra
        wILpHK935ZiGS
X-Received: by 2002:a17:907:2661:: with SMTP id ci1mr2901596ejc.403.1616141821328;
        Fri, 19 Mar 2021 01:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy+umNIHUPhcVpo/tua+gabccjV+G857drOdgkFOgKy+Gzwdh2jGJrp54AkTYYu2Pd5+rwTQ==
X-Received: by 2002:a17:907:2661:: with SMTP id ci1mr2901589ejc.403.1616141821192;
        Fri, 19 Mar 2021 01:17:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q26sm3273413eja.45.2021.03.19.01.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 01:17:00 -0700 (PDT)
Subject: Re: [PATCH] selftests/kvm: add get_msr_index_features
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210318145629.486450-1-eesposit@redhat.com>
 <20210318170316.6vah7x2ws4bimmdf@kamzik.brq.redhat.com>
 <52d09cdf-3819-0cd8-5812-387febaa1ab3@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d556faf6-fcf4-ec64-546e-ab80b107751e@redhat.com>
Date:   Fri, 19 Mar 2021 09:16:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <52d09cdf-3819-0cd8-5812-387febaa1ab3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/03/21 09:07, Emanuele Giuseppe Esposito wrote:
>>
>> I'm not sure why the original kvm selftests authors decided to do this
>> internal stuff, but we should either kill that or avoid doing stuff like
>> this.
> 
> I need this include because of the KVM_DEV_PATH macro, to get the kvm_fd.
> No other reason for including it in this test.

I'll take care of moving that macro to the non-internal kvm_util.h 
header, thanks.

No need to do anything, I'll send the pull request later today.

Paolo

