Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9D33EEB9
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhCQKtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:49:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230352AbhCQKtt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 06:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615978188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4RywPiGpkeJ8ft2kFpbHNdUd62AsRGHndtvEkFVGNC8=;
        b=dKAorJOGFi2ph4oSJcdEKA24QUimXC+EK3aH3J2xJM7/zHLP6W3bmn7zjH9OeVWRFP4x36
        Yun6Vkyzk3lX8v7FPBHo9Oi+y+VhRi8crud0nb+gqIJNkznv9+QIB9YK3QKy0BDWxkx6sK
        0rFtgvIlRsI6QxERr6FOZQXwMso0v4I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-sc8rIVarM_q-q-i9DhhgTw-1; Wed, 17 Mar 2021 06:49:47 -0400
X-MC-Unique: sc8rIVarM_q-q-i9DhhgTw-1
Received: by mail-wr1-f71.google.com with SMTP id 9so2624718wrb.16
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 03:49:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4RywPiGpkeJ8ft2kFpbHNdUd62AsRGHndtvEkFVGNC8=;
        b=WlR6307EsValSThYjSQVWJxm2PDnFBygowNkHDyy8dHZFqyZCgwWC0Ktzikss35IH6
         ee/ak1lKp9aydghQNQhMRip4HVtASZWjyLNGZnUAIuYZeLHnTVneIqBuhsYTF/LY0Ua2
         NUIUqLyLmDoA0hOtOJy4dcW1bZkvjkcYO9KNssn9RRVlWD3lU6A9hocOnB+9zeBSXl8X
         8WHKyIEOVoNN6AQtWkritXi9LJpje7+qYq8uIzUsHcFp2BpRcO4dI6mTEhqIpgiHJYkP
         B3UqKfUG33G8Maht5P9gmMW5lIQk5fS5W1/y0LcObelo4CuKzx91JLP2oPKvf85hjEpw
         L6Ww==
X-Gm-Message-State: AOAM530qJ7N/YdI7NeBWVSKWhkwNCeWVncvWy1Pl/0yr0RWtFlbL+oDu
        RfMgEWiqdXozJgoddCtrxTuNbBsFSJujbatd2AJK6T1y8rVgF888zZAoThr2QPaFWEt0STVZDee
        J+I7oWvXdbAcdL+f742PV8irTunu5SdzVYDdHX3iNDEOjkbAfpgpH59ZSYAhVYI9o
X-Received: by 2002:adf:f60b:: with SMTP id t11mr3743439wrp.269.1615978185574;
        Wed, 17 Mar 2021 03:49:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeBITkSczuPw2QRG3ylbWKh3kqr3A+t3BVC/Hkr6nyjbu75/aKlKIWqvY58OmHj2Y9niHiKA==
X-Received: by 2002:adf:f60b:: with SMTP id t11mr3743419wrp.269.1615978185372;
        Wed, 17 Mar 2021 03:49:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a6sm2522437wmm.0.2021.03.17.03.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 03:49:44 -0700 (PDT)
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210317074552.8550-1-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] selftests/kvm: add test for
 KVM_GET_MSR_FEATURE_INDEX_LIST
Message-ID: <ac3ba1c0-450e-4e24-c2a2-39d037358758@redhat.com>
Date:   Wed, 17 Mar 2021 11:49:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210317074552.8550-1-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/21 08:45, Emanuele Giuseppe Esposito wrote:
> +	struct kvm_msr_list features_list;
>   
>   	buffer.header.nmsrs = 1;
>   	buffer.entry.index = msr_index;
> +	features_list.nmsrs = 1;
> +
>   	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
>   	if (kvm_fd < 0)
>   		exit(KSFT_SKIP);
>   
> +	r = ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, &features_list);
> +	TEST_ASSERT(r < 0 && r != -E2BIG, "KVM_GET_MSR_FEATURE_INDEX_LIST IOCTL failed,\n"
> +		"  rc: %i errno: %i", r, errno);

Careful: because this has nsmrs == 1, you are overwriting an u32 of the 
stack after struct kvm_msr_list.  You need to use your own struct 
similar to what is done with "buffer.header" and "buffer.entry".

>   	r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
>   	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
>   		"  rc: %i errno: %i", r, errno);
> 

More in general, this is not a test, but rather a library function used 
to read a single MSR.

If you would like to add a test for KVM_GET_MSR_FEATURE_INDEX_LIST that 
would be very welcome.  That would be a new executable.  Looking at the 
logic for the ioctl, the main purpose of the test should be:

- check that if features_list.nmsrs is too small it will set the nmsrs 
field and return -E2BIG.

- check that all MSRs returned by KVM_GET_MSR_FEATURE_INDEX_LIST can be 
accessed with KVM_GET_MSRS

So something like this:

   set nmsrs to 0 and try the ioctl
   check that it returns -E2BIG and has changed nmsrs
   if nmsrs != 1 {
     set nmsrs to 1 and try the ioctl again
     check that it returns -E2BIG
   }
   malloc a buffer with room for struct kvm_msr_list and nmsrs indices
   set nmsrs in the malloc-ed buffer and try the ioctl again
   for each index
     invoke kvm_get_feature_msr to read it

(The test should also be skipped if KVM does not expose the 
KVM_CAP_GET_MSR_FEATURES capability).

Thanks,

Paolo

