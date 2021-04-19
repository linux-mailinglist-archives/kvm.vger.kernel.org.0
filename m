Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033183649CD
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbhDSS2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:28:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240963AbhDSS2t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 14:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618856898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=txNx1N9+05ws4mOI5KJIab/ktXs++R1+bTkhgXa8zds=;
        b=QMYHTqK2yKoJyJ/m0zSw7R2G6aQkdj6+OXs+fnBf5/p/gRFmoVyJC/QDrmgQxN6OyhueQL
        5ySdp96QqHHo8r4bPJXWNQxT739gocMNhAWnnLS6RDqzm1buXn+Z8kDGZo1LL8+EPeSM8B
        OpP7wKmPpFASiwTVtP/WTLBOjKiLp8I=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-Qcha80t8N829kajTNPyjqw-1; Mon, 19 Apr 2021 14:28:17 -0400
X-MC-Unique: Qcha80t8N829kajTNPyjqw-1
Received: by mail-ej1-f72.google.com with SMTP id f15-20020a170906738fb029037c94426fffso3985620ejl.22
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=txNx1N9+05ws4mOI5KJIab/ktXs++R1+bTkhgXa8zds=;
        b=gOEmFkXODeaiYoQ1Vdm90MfVPLov/dL6q5cpYgI6k5wnX8W4+uf6pNM8+9ThfFDn+j
         H7Q+X/TvKCknr2NdGha1L0eSBCpMjaL/lFV/+Co3yrk6bXcmgcCROOVb90Xxj6u6n0Ya
         xgIgcArf1I+Fbhxhz4INmH3AhvdNRUE+MRSxztClPLe6z7+U/7x5YjD1WZje4dswgtG1
         2BYPRv9pGnier7o5gB94/iMomviP3I+Yi39spEWNxL4409feFYmLQ3LjV3v5nlIaoi06
         t9wG1FJAxOnJvCW4QfKSc58XztKPk/0XyLMDF/SslOVPo8arOEZLfwCH3C8WHLC7gLOB
         1lfQ==
X-Gm-Message-State: AOAM532/ZsHvbXAt+Sar5eqC0dKWCmVPn7A8bPRsOw4It5IbFE5VVVvB
        bGXSfc8UAG7R9dM1tvtEENukt5hOJ4ArPgUcc6j8f9LTwJ9LT6VctTUoIWwmudWC3emNSCqoBHj
        Ql41uzBI3irVW
X-Received: by 2002:a17:906:cf86:: with SMTP id um6mr14192830ejb.549.1618856895721;
        Mon, 19 Apr 2021 11:28:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxI/Qrhi4hycR92cvQtW7LNvpCK2b9Ty60nr1p3aj1gBT/4Kw9U/YcrWLjPad3Tw3m+2b87BQ==
X-Received: by 2002:a17:906:cf86:: with SMTP id um6mr14192818ejb.549.1618856895526;
        Mon, 19 Apr 2021 11:28:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id m14sm4120705edr.45.2021.04.19.11.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 11:28:14 -0700 (PDT)
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-3-krish.sadhukhan@oracle.com>
 <fdf27d2b-d0b6-96fa-f661-bef368f04469@redhat.com>
 <711a0aa9-c46e-7bd3-5161-49bd9dd56286@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/7 v7] KVM: nSVM: Define an exit code to reflect
 consistency check failure
Message-ID: <7106e7c6-c920-86fb-003e-51a42dfaf700@redhat.com>
Date:   Mon, 19 Apr 2021 20:28:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <711a0aa9-c46e-7bd3-5161-49bd9dd56286@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/21 19:57, Krish Sadhukhan wrote:
> The reason why I thought of this is that SVM implementation uses only 
> the lower half, as all AMD-defined exit code are handled therein only. 
> Is this still going to cause an issue ?

I would have to check what happens on bare metal, but VMEXIT_INVALID is 
defined as "-1", not "FFFFFFFFh", so I think it should use the high 32 
bits (in which case KVM is wrong in not storing the high 32 bits).

Paolo

