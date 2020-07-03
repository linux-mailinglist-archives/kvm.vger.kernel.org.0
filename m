Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2154213E37
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgGCRJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 13:09:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47043 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726616AbgGCRJi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 13:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593796176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tM7o80ZiWfgXm8rBnu9PgNPSmr4XCL7PjAd9UL4P9xI=;
        b=F+807nehd6lJKoZSXuv+gjO+lmN6HmQIDSxB2b7RpHvu15CVJVYE8LTthifA5pAQNoMrqU
        LofdSF8/p90r7TLDR7TePWwTZy2oxEmeMMqSkmak2QSMWPE2PO7RAewZACrJn1FRIq26Ko
        mqz37KCfPq8gKcSz5/CThlIyM95TawA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-nlSbRurMMGC-n7l5a4-mPA-1; Fri, 03 Jul 2020 13:09:35 -0400
X-MC-Unique: nlSbRurMMGC-n7l5a4-mPA-1
Received: by mail-wr1-f70.google.com with SMTP id o12so32183890wrj.23
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 10:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tM7o80ZiWfgXm8rBnu9PgNPSmr4XCL7PjAd9UL4P9xI=;
        b=kWwcQJBxJcDYmEf89ruWyvquQFWuY3CU7/cKSgoG9XtYjEvop7Yme0MvpM1DKszKlQ
         LVHN0O/Sz6O6dcKB+DqPw769eEjR/zw+cN4OqVOfIqc4mBb8FMdysqr49Zp/Jraz/qk2
         q17MqJY3ibgDRCuFNpchrkR5bJzEZ4c/6ycnlmn8GdBlSvg2rTQflRuy1POcunhcaS2T
         cpLIn55RcqwEpbdtrgBE5lWCbwKDiXRA8V7nWdKSOqt/idVZ2o3wZoxbC0C/11ui0GND
         4wNZ9c6LZsk5UUuWLEdZwBOU0uRBlpeKqcaaWO7XO6Clx3fqIq0GrfrYVgK2LblNZNG3
         UxIw==
X-Gm-Message-State: AOAM533vYoLMH9syUGLsx1iM88KgBKlWcjibtX/gMgX0q0LxzhKSE3X8
        niYHbGMi9WKcnE3NXFXIGiHtNB1ifAJInyFpLB8ZpCuVnUKeVpN4gRrjln86BHHh9WDnTy0y3UB
        To5cAmPwE2KLQ
X-Received: by 2002:a1c:9a07:: with SMTP id c7mr233791wme.147.1593796173913;
        Fri, 03 Jul 2020 10:09:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwr2MowQzqsrQAQ+dQd7YGWEyNyh+fnv4zmne3XYTbCYm9CV38coOh5KxaQthy1a1zqapiGxQ==
X-Received: by 2002:a1c:9a07:: with SMTP id c7mr233774wme.147.1593796173653;
        Fri, 03 Jul 2020 10:09:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id g3sm4819745wrb.59.2020.07.03.10.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 10:09:33 -0700 (PDT)
Subject: Re: [PATCH 0/3 v3] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun
 of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
 <fff40d79-1731-2f24-227a-bf57e8e33b97@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2b9b813-8c8b-be6d-3c5f-8586466ab21d@redhat.com>
Date:   Fri, 3 Jul 2020 19:09:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fff40d79-1731-2f24-227a-bf57e8e33b97@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 00:33, Krish Sadhukhan wrote:
> Ping.
> 
> On 5/14/20 10:36 PM, Krish Sadhukhan wrote:
>> v2 -> v3:
>>     In patch# 1, the mask for guest CR4 reserved bits is now cached in
>>     'struct kvm_vcpu_arch', instead of in a global variable.
>>
>>
>> [PATCH 1/3 v3] KVM: x86: Create mask for guest CR4 reserved bits in
>> [PATCH 2/3 v3] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not
>> set on
>> [PATCH 3/3 v3] KVM: nSVM: Test that MBZ bits in CR3 and CR4 are not
>> set on vmrun
>>
>>   arch/x86/include/asm/kvm_host.h |  2 ++
>>   arch/x86/kvm/cpuid.c            |  2 ++
>>   arch/x86/kvm/svm/nested.c       | 22 ++++++++++++++++++++--
>>   arch/x86/kvm/svm/svm.h          |  5 ++++-
>>   arch/x86/kvm/x86.c              | 27 ++++-----------------------
>>   arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
>>   6 files changed, 53 insertions(+), 26 deletions(-)
>>
>> Krish Sadhukhan (2):
>>        KVM: x86: Create mask for guest CR4 reserved bits in
>> kvm_update_cpuid()
>>        nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun
>> of nested gu
>>
>>   x86/svm.h       |   6 ++++
>>   x86/svm_tests.c | 105
>> +++++++++++++++++++++++++++++++++++++++++++++++++-------
>>   2 files changed, 99 insertions(+), 12 deletions(-)
>>
>> Krish Sadhukhan (1):
>>        nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of
>> nested g
>>
> 

Queued, thanks.

Paolo

