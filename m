Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1433407CE
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 15:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhCRO0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 10:26:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhCRO0P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 10:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616077572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RT22nPEqCjgDja9UBpvjcLJwuyEkwwefmcnH5QrEDSM=;
        b=eGA3RbzfgHnEtLKOJxgjO+Uy7dIKCsB0VxBHytKOrxlZlivnibeQjxdaQVdrZe83pzVVKm
        Inf0NThOh5IsdoZilLy5S1HnuCRyqqpH+3BjsFpu0BgHm5l+SBd+iJ8EXC87BTggNCNjC+
        ACloD0CQ5j5s9laiVhdlFGp42NXoPPQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-2uyDdD-PO8KPM01vIu7X5w-1; Thu, 18 Mar 2021 10:26:10 -0400
X-MC-Unique: 2uyDdD-PO8KPM01vIu7X5w-1
Received: by mail-ej1-f71.google.com with SMTP id li22so12285501ejb.18
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 07:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RT22nPEqCjgDja9UBpvjcLJwuyEkwwefmcnH5QrEDSM=;
        b=gtkkkxZ4CPh6mywmJXnU9IdTUZVFlBFiHSrIoRSuKZVmUNQAtRTreicJlVlL8tE9Hj
         zcx2UswNjEPWv0pD/93pDgIlb+89MyV5hAIZZ2KNT9AqVtg/2xWA5H0xydlgE/cuqouw
         QzZMEDv+K4SZFHIaubFyoLPXCfhWHUrG5ha8lGP2DVnT/AOfEqNpsjoZqfovBXOq6Clb
         WCbkmNOIcyIzvQp7ol7Qs6Neg0ITH4LPiBJLFk8Xrra3LVk0oEz9ddEkAFYpu9MxYgMS
         Shn7Z1u9iJttsC92SqC8emFL0WdPljS4mw/crFqaLY2GT3UEkxwvJZ5p1K4HIoIRBFkP
         1pIg==
X-Gm-Message-State: AOAM5305hGXiZqB/f9iqFbGilfBe2Llo1/I49qaR3zR415c57cVuxSuV
        N3b0Em1kgb6PGyqHYOIXm60Smi5YxZPFVjrSNRVSmcI1NT6z41oFD0QCRpL1U/vT9XNTzgrVI0N
        VM8emUX1McFvG
X-Received: by 2002:a05:6402:17d6:: with SMTP id s22mr3975146edy.232.1616077569415;
        Thu, 18 Mar 2021 07:26:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcun0Sijy7J7tptGznTVTxmqax5khOcEdQMVABVzI0n88yDIRLj8oksXxLzj/zk94B8oq5+Q==
X-Received: by 2002:a05:6402:17d6:: with SMTP id s22mr3975130edy.232.1616077569222;
        Thu, 18 Mar 2021 07:26:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id si7sm2057935ejb.84.2021.03.18.07.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 07:26:08 -0700 (PDT)
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1176f351-220d-003e-2cae-65f0b42c8f18@redhat.com>
Date:   Thu, 18 Mar 2021 15:26:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210318140949.1065740-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 15:09, Vitaly Kuznetsov wrote:
> +static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
> +{
> +	u64 r1, r2, t1, t2;
> +	s64 delta_ns;
> +
> +	/* Compare TSC page clocksource with HV_X64_MSR_TIME_REF_COUNT */
> +	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
> +	r1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
> +	nop_loop();
> +	t2 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
> +	r2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
> +
> +	delta_ns = ((r2 - r1) - (t2 - t1)) * 100;
> +	if (delta_ns < 0)
> +		delta_ns = -delta_ns;
> +
> +	/* 1% tolerance */
> +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
> +}
> +

I think you should also be able to check r1 and r2 individually, not 
just r1 and r2.  Is that correct?

Paolo

