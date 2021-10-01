Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0075D41EFB6
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 16:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354581AbhJAOlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 10:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353844AbhJAOk7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 10:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633099155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PVvLSrhnJOGqjYQs3rxAizBVLwy17MoMN0v9tRrAcY=;
        b=LaUtJ+H3thP6az3UcOamuFuNIR8Iilqse+xO3IEsH+aK970BaRUUKIKvJODBSGnRTmiF7h
        8GtD6uNrCbjtSDwNVcNjBp9FjBzf5bbyjI1Qd40ThLOvOMnf40SpGcXQwQhgaYY3MzxMAc
        64HNkr3RlR8LScSjuupflHcgGgXte9A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-bqF6j-mONbKAtU9IhUV-mQ-1; Fri, 01 Oct 2021 10:39:14 -0400
X-MC-Unique: bqF6j-mONbKAtU9IhUV-mQ-1
Received: by mail-ed1-f72.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so10305238edj.21
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 07:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4PVvLSrhnJOGqjYQs3rxAizBVLwy17MoMN0v9tRrAcY=;
        b=4Xwp5oS7KMMNmdXMYqoiuWr/P1wsxW/XSuGKjWWHmb7idfBMApOeW3u3O5XB19xxPg
         VPP3G08ce9CKYNF2pVMfnQl2yVtxQMQWmtyN4uIli/hSCe8uqB5nMNjauWV/sBESjkYb
         ftO130gbeY2BioEctlqUeDBHihnHZDUSCLdDs8gcw30mCNeT2ImQZDl5cP/B+rIw11eS
         5YxlC3TWbk4zNetKt4n+KARe3If/hXJOQgmIuOZMTYR8390qSfSDmXZor7hT3Hu5AXPt
         w/kCa9ISW/9+hOi0LrYkTCojDIreT5bHv/HxfnJSzvpk0VskL1KmHXOBwZ/IMFLzcnbW
         ujpA==
X-Gm-Message-State: AOAM530JD3seU3EFn1v8ywLw0OO449YXUJJvPqOtI4QddhqFG5To02yA
        lmE8e5TfDCbfH8g5ERw6Ty6RyxguFwdKWE+zf7KX/cCFOvNB72XEDCZWVp0C6hpopADb2ds9+Aw
        7QfAA4m1tCYYu
X-Received: by 2002:a17:906:29d0:: with SMTP id y16mr7042822eje.477.1633099152935;
        Fri, 01 Oct 2021 07:39:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8RlMd0BjSON/zIWBi38A/HrGVeQYpbDZkMC1hM+jwKFzAnK3B/OZXyj61nI9hMjkJ+eOS3w==
X-Received: by 2002:a17:906:29d0:: with SMTP id y16mr7042785eje.477.1633099152704;
        Fri, 01 Oct 2021 07:39:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l25sm3426382eda.36.2021.10.01.07.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 07:39:12 -0700 (PDT)
Message-ID: <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
Date:   Fri, 1 Oct 2021 16:39:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181538.968978-5-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 20:15, Oliver Upton wrote:
> +	if (data.flags & ~KVM_CLOCK_REALTIME)
>   		return -EINVAL;

Let's accept KVM_CLOCK_HOST_TSC here even though it's not used; there 
may be programs that expect to send back to KVM_SET_CLOCK whatever they 
got from KVM_GET_CLOCK.

