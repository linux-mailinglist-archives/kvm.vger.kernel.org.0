Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC608242A02
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 15:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgHLNEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 09:04:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726404AbgHLNEv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 09:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597237488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Fsgrw+mRjbdWES2GWusstFr/mr6OnkInf7T7tR1iuA=;
        b=favdMBuQM9Qaxvle70A5xo/Fd9S0vPlNLvGEK9NCHXzp6ykG+AkaSdAg6qiStJqLpeDEdZ
        LwH6mwijs1cHTZVlpBSjzy0LqnduARdSreTJZnQYPCbClMsudze5ITlP0rW1Xhee7kfjAQ
        fZQrRkQ2C0rbJbUnFde6BRz8V/91IFE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-fv-95usfPJCJLvpgMGA1cQ-1; Wed, 12 Aug 2020 09:04:47 -0400
X-MC-Unique: fv-95usfPJCJLvpgMGA1cQ-1
Received: by mail-wm1-f72.google.com with SMTP id s4so694945wmh.1
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 06:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Fsgrw+mRjbdWES2GWusstFr/mr6OnkInf7T7tR1iuA=;
        b=VOmy6E608Tbg9b1RxKdEVce3z3vU4PY3lfVCa56oKblJo+Q2EbaTB+bxOPwCri+cVc
         0vBmHsqdb0ud+CQeAnoaljdMNcwkoqNQdSQTbv92Cz57qbiDhTJ9a/0SVTZAwdaWO40Z
         cR3ZmdgO4O9aPfKMcOeyXpryHMY3XFjYnIRqIVwl9AzJTZphIziceK7ICyaveYPFvrp/
         YPYLXSo4VOlDQWY4ALt1I00fPbDRIhIT1Xt8R3gM9LKA5XauHcgCAU9jcZHiNN7EqiUL
         qqq6g5KGKoDM55biAO0gKFhVdVaj1soc33zcDYe5m8trZ++DpDBmxhkXejW5/hM1GqTA
         nEKA==
X-Gm-Message-State: AOAM5326HeUIDVTci2mD01jswg2qvEfpaqXthWdFZyyo8h9pF8QmzPEX
        onAd4Nj4t5kjyTw+Dzbvds7K0lKt2TAvA2kpxNcfPTpEcfGIvl9wfvZq6zbEA7QJn6J0iHcJue+
        8Pn49mz3R6PCP
X-Received: by 2002:adf:ab55:: with SMTP id r21mr32322666wrc.332.1597237485850;
        Wed, 12 Aug 2020 06:04:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJcm6bs/kye85/P+Jyuc7cEjwoDZlomX2S0Ug3Q7nIk7qrF3w/nV2klKWLtDnO1ChUHk9xzA==
X-Received: by 2002:adf:ab55:: with SMTP id r21mr32322639wrc.332.1597237485611;
        Wed, 12 Aug 2020 06:04:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fcdc:39e8:d361:7e30? ([2001:b07:6468:f312:fcdc:39e8:d361:7e30])
        by smtp.gmail.com with ESMTPSA id k204sm3938274wma.21.2020.08.12.06.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 06:04:45 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/pmu: Add '.exclude_hv = 1' for guest perf_event
To:     like.xu@intel.com, peterz@infradead.org
Cc:     Like Xu <like.xu@linux.intel.com>, Yao <yao.jin@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
References: <20200812050722.25824-1-like.xu@linux.intel.com>
 <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
 <20200812111115.GO2674@hirez.programming.kicks-ass.net>
 <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
 <b55afd09-77c8-398b-309b-6bd9f9cfc876@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8bdc60d5-c9ef-4e8f-6b73-b7bd012d9d30@redhat.com>
Date:   Wed, 12 Aug 2020 15:04:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b55afd09-77c8-398b-309b-6bd9f9cfc876@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/20 14:56, Xu, Like wrote:
> 
> My proposal is to define:
> the "hypervisor privilege levels" events in the KVM/x86 context as
> all the host kernel events plus /dev/kvm user space events.

What are "/dev/kvm user space events"?  In any case, this patch should
be included only in the series that adds exclude_hv support in arch/x86.

Paolo

> If we add ".exclude_hv = 1" in the pmc_reprogram_counter(),
> do you see any side effect to cover the above usages?
> 
> The fact that exclude_hv has never been used in x86 does help
> the generic perf code to handle permission checks in a more concise way.

