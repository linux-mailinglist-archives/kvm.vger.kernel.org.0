Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1E734085A
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhCRPBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:01:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229960AbhCRPBi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 11:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616079698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1rx05wqrEccBPQiT/JWW+n1ZhZ299TLAdtCxZkZhV7Y=;
        b=IzraEQp2RLUGvZ15+5fleFt/2x+8jBiPX+WtKpQuN3l65m/7GDcGJaxf1l6HkqMyDKmjKu
        /KEAv91szrPR61Fwmr3sWPcGuk4GQ9SGyi65+i4YXwnInSltRb0FqVuM3oMM3+ruw+UoAr
        fcVWLT4+4JB33bvH2lA+glZ4Ai8qGp0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-MB8d_PmjOoy2NiOZU3_nFw-1; Thu, 18 Mar 2021 11:01:35 -0400
X-MC-Unique: MB8d_PmjOoy2NiOZU3_nFw-1
Received: by mail-wr1-f70.google.com with SMTP id i5so20245178wrp.8
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1rx05wqrEccBPQiT/JWW+n1ZhZ299TLAdtCxZkZhV7Y=;
        b=nvGgDBchWhbMmRX7IMj16pWjdOIN47f+Biyt7VagVRORk/BFBXPfpD0d6of5zAH3jL
         OTQ5jg5r4oj2d7D/RwOkGHX0cH8qtpvWDTzxf2XDorw+SwPeasZDHcTecydTtpkNo6M0
         odEKn1rEFBNZKUoptS6OQu7GVHvGVLIprNPfavjlO1ZIvP+KdTpXEaTOb8QjDKAXl/eG
         ytyG3hZ94Qjtjiijppgrf9iR2DnKMV7sSDboW/BFmFEGdKU4BXU+KaKfEMQixoSVw5st
         fa9lmlQBuNyj+Mnbiz/rEHsUVwgbThQBPG92FeWzRIZ6OogmGwSC2kQ+35WXcxH7loMd
         w2SA==
X-Gm-Message-State: AOAM530YF5qs0V6smAzkMuwNwolFJyQY0k5FVQ/XU0oGFvBhUVj0IqCr
        k6hPoiQujW0K8WMcBmpAvYHZHRthCKrtivtrmGexqrAHxtzIEm+YJlgbVKIoGbbvVZOfFhEiXjf
        Yn/dGg7AX1Ev+
X-Received: by 2002:a5d:4904:: with SMTP id x4mr9990755wrq.69.1616079694156;
        Thu, 18 Mar 2021 08:01:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwCtWMkUzWNFYjXVNG6aTOmrHFGcBodR/LKntjeXJtPrYoEKEjZLGRWANjxTvAN7wj9gc/pg==
X-Received: by 2002:a5d:4904:: with SMTP id x4mr9990735wrq.69.1616079693905;
        Thu, 18 Mar 2021 08:01:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l21sm2638793wmg.41.2021.03.18.08.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 08:01:33 -0700 (PDT)
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
 <1176f351-220d-003e-2cae-65f0b42c8f18@redhat.com>
 <8735ws7bva.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41897f61-9d1a-519b-e1cb-e19efa34ab55@redhat.com>
Date:   Thu, 18 Mar 2021 16:01:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8735ws7bva.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 15:52, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 18/03/21 15:09, Vitaly Kuznetsov wrote:
>>> +static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
>>> +{
>>> +	u64 r1, r2, t1, t2;
>>> +	s64 delta_ns;
>>> +
>>> +	/* Compare TSC page clocksource with HV_X64_MSR_TIME_REF_COUNT */
>>> +	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
>>> +	r1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
>>> +	nop_loop();
>>> +	t2 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
>>> +	r2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
>>> +
>>> +	delta_ns = ((r2 - r1) - (t2 - t1)) * 100;
>>> +	if (delta_ns < 0)
>>> +		delta_ns = -delta_ns;
>>> +
>>> +	/* 1% tolerance */
>>> +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
>>> +}
>>> +
>>
>> I think you should also be able to check r1 and r2 individually, not
>> just r1 and r2.  Is that correct?
> 
> Right, we could've checked r1 == t1 and r2 == t2 actually (with some
> tiny margin of course). Let me try that.

np, I can do that too.  Just checking my recollection of the TLFS.

Paolo

