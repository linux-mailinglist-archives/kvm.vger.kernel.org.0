Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E83458D18
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 12:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhKVLQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 06:16:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235744AbhKVLQe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 06:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637579608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y6VXcLw5X3uiBZIAHdyQgcXUhgzdVRHz8ZP32LM6T7E=;
        b=fu1GTfwwGxyHPnaRPAkNHREwZCuSXm/AW6IIAVkSMn/3lpU7nFLZ4XGXfipkLf84pcPf1+
        1alL0oWIrNg8NrsgTliLMch62GNg0zLflDTRT4bHbabw1DrLboFKRr7GpM3CU170o2r/hs
        xjpo+/G9xTBH68qwvDufTrIfi+xo4K0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-EGYX1XPKPbWfTMf5u3L0WA-1; Mon, 22 Nov 2021 06:13:26 -0500
X-MC-Unique: EGYX1XPKPbWfTMf5u3L0WA-1
Received: by mail-wr1-f69.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so3020332wro.18
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 03:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=y6VXcLw5X3uiBZIAHdyQgcXUhgzdVRHz8ZP32LM6T7E=;
        b=SY/U0UZag/8PtyuFJVsCTBZ1nCeydIdDuPo6K6Ph5YMYs34WZXcRlP5mDwObYBjVWl
         pXcla3Q62IseXq6G5L0ZxcpZwjf+wN3g9ugEq/yxi5Z9kkF5fcGdd+tUlXmk1t26MVDa
         G1xm5X6HtxxixRKVoobyA66TPDaP3cyhUGxVerRPPnumRXeueaJBN3cpLy43T6zSsKoM
         epYmwJiefl/ZKH9yZM6NE0Xqyg9EG7VpnVTavQXFTlvvSsYQ1S0hf1VxuTRazuJkTSdf
         T9azzCu7/e9FpYtJTQR+f0TKX+hbPt/HhQYMx6E/sx0j3s/0b15JM7BnBH2nkBa06u6L
         gqzA==
X-Gm-Message-State: AOAM531nY6zEaitLYNtIC6PJt3CqoXTLBSP6WlMJyRD3SHjU2jG6kH/T
        bJHJfsMNsNmkzll7IuEnpt7VX7BNrH+AaEorOgG0VtBPb1iYlNvTFjj6oEJzMT6lv6I4fX6ZzU1
        GTmji2dRYwxMr
X-Received: by 2002:a7b:c934:: with SMTP id h20mr29443430wml.94.1637579605756;
        Mon, 22 Nov 2021 03:13:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjcFE8ijIkUoMntFaszqHarPnfNVk0OpT2sg9vvgErKXCyyG7gOUahAUb0whahijqTQfYjhA==
X-Received: by 2002:a7b:c934:: with SMTP id h20mr29443400wml.94.1637579605561;
        Mon, 22 Nov 2021 03:13:25 -0800 (PST)
Received: from [192.168.3.132] (p5b0c667b.dip0.t-ipconnect.de. [91.12.102.123])
        by smtp.gmail.com with ESMTPSA id l7sm10407970wry.86.2021.11.22.03.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 03:13:25 -0800 (PST)
Message-ID: <62fb425d-4bda-63e0-469b-f0ae43539929@redhat.com>
Date:   Mon, 22 Nov 2021 12:13:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
 <20211028135556.1793063-4-scgl@linux.ibm.com>
 <4ac7c459-8e13-087a-f98d-9f3e0e6d8ee6@redhat.com>
 <457896b2-b462-639e-bb40-dee3716fcb9a@linux.vnet.ibm.com>
 <1a380055-536e-123d-499e-40314cf35f44@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 3/3] KVM: s390: gaccess: Cleanup access to guest frames
In-Reply-To: <1a380055-536e-123d-499e-40314cf35f44@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.11.21 10:00, Janosch Frank wrote:
> On 10/28/21 16:48, Janis Schoetterl-Glausch wrote:
>> On 10/28/21 16:25, David Hildenbrand wrote:
>>> On 28.10.21 15:55, Janis Schoetterl-Glausch wrote:
>>>> Introduce a helper function for guest frame access.
>>>
>>> "guest page access"
>>
>> Ok.
>>>
>>> But I do wonder if you actually want to call it
>>>
>>> "access_guest_abs"
>>>
>>> and say "guest absolute access" instead here.
>>>
>>> Because we're dealing with absolute addresses and the fact that we are
>>> accessing it page-wise is just because we have to perform a page-wise
>>> translation in the callers (either virtual->absolute or real->absolute).
>>>
>>> Theoretically, if you know you're across X pages but they are contiguous
>>> in absolute address space, nothing speaks against using that function
>>> directly across X pages with a single call.
>>
>> There currently is no point to this, is there?
>> kvm_read/write_guest break the region up into pages anyway,
>> so no reason to try to identify larger continuous chunks.
> 

Right, we're changing the calls from e.g., kvm_write_guest() and
write_guest_abs() to kvm_write_guest_page().

As we're not exposing this function via arch/s390/kvm/gaccess.h, I think
it's ok. Because for external functions we have nice function names like
write_guest_abs(), write_guest_real(), write_guest_lc(), write_guest(),
which implicitly state in their name which kind of address they expect.
access_guest_page() now accepts an absolute address whereby
access_guest() accepts a virtual address. This is for example different
to kvm_read_guest() and kvm_read_guest_page(), which expect absolute
addresses. But there, the _page functions are not internal helpers.

> 
> @David: How strongly do you feel about this?

Not strongly :)

-- 
Thanks,

David / dhildenb

