Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741E640B685
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 20:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhINSHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 14:07:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhINSHj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 14:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631642781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WdkTeh35hskFjppx/AtCQ+7sni5H8rOPzWMjSfWm50U=;
        b=V1x/lpqKZrj/nOekKwl9yjJBE979ubRrXkUP/oRc678n8F5WfdI3y+o/Gq6y9rkL3Y4BVK
        k3P8iUwVyjXubW5F4dAbwe/8DqFSDiyR/yJxMhZM3QvWRoDz9gngQFiVhb2EA/U0AAHVmr
        BobHd/o+Oh4Y3BFYv1YsZE9nageGhQ8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-XDALBIM2OYSaWSXR8M7bnw-1; Tue, 14 Sep 2021 14:06:20 -0400
X-MC-Unique: XDALBIM2OYSaWSXR8M7bnw-1
Received: by mail-wm1-f72.google.com with SMTP id m9-20020a05600c4f4900b003057c761567so980589wmq.1
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 11:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WdkTeh35hskFjppx/AtCQ+7sni5H8rOPzWMjSfWm50U=;
        b=3bQz9OPx9pXzPnMYb/gSlsRcle/nsPhlSBAvFfSwjBMXHTgaxwSQfz7p4SlnyFP2hx
         2H1S5wUZjqkPOIpt5R1O6mzmXCAuQSaPJqvyj84BHqHdhldyDR0mMDnpwYrsNJn4a/T4
         NY/BeJE+nUAGWX+3RfLpYJ/hQJ6LvR5vUmIRODriA6i93RIjZ9BvYtjV05UGaoIUuMp9
         hTdOK2hgqj+wDTLrhJLXALKKbFWdV3TfVUjuKIrtlGCB13W8CzwIFXhroM0qb4IHeM/d
         rYh2ksL+rEkPF6Gfsa6Pe/4nLgO1C0CMOWkt0D7QPJ0stK36hrYwYPvV6pOAJ2aolRQx
         5wDQ==
X-Gm-Message-State: AOAM530gVlDnf7hA3c8dkf3Sxnuz9A0/OGgHye7j4+jPb6wyI8M6KRfh
        R+nJQ39vEyU+Ak2ZEGrkrLM26CILDuDit6D2iGRoHvWtisxl28a44dWURKHtL61YRKDJ4NP8GzX
        BOgMy2Oz9dKVQ
X-Received: by 2002:a1c:c903:: with SMTP id f3mr450197wmb.101.1631642779382;
        Tue, 14 Sep 2021 11:06:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKIqckQty8a8VOzJidD+CVHVc1oyd0LQz0Ukul/JPoVTfeji3ABJKcoR2cUc0zjpzdgVfVPg==
X-Received: by 2002:a1c:c903:: with SMTP id f3mr450166wmb.101.1631642779102;
        Tue, 14 Sep 2021 11:06:19 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6041.dip0.t-ipconnect.de. [91.12.96.65])
        by smtp.gmail.com with ESMTPSA id g143sm1846758wme.16.2021.09.14.11.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:06:18 -0700 (PDT)
Subject: Re: [PATCH resend RFC 0/9] s390: fixes, cleanups and optimizations
 for page table walkers
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210914185033.367020b3@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <858a5f3b-99c0-6da3-6a60-8d01886399c6@redhat.com>
Date:   Tue, 14 Sep 2021 20:06:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210914185033.367020b3@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.09.21 18:50, Claudio Imbrenda wrote:
> On Thu,  9 Sep 2021 18:22:39 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> Resend because I missed ccing people on the actual patches ...
>>
>> RFC because the patches are essentially untested and I did not actually
>> try to trigger any of the things these patches are supposed to fix. It
> 
> this is an interesting series, and the code makes sense, but I would
> really like to see some regression tests, and maybe even some
> selftests to trigger (at least some of) the issues.

Yep, it most certainly needs regression testing before picking any of 
this. selftests would be great, but I won't find time for it in the 
foreseeable future.

> 
> the follow-up question is: how did we manage to go on so long without
> noticing these issues? :D

Excellent question - I guess we simply weren't aware of the dos and 
don'ts when dealing with process page tables :)

> 
>> merely matches my current understanding (and what other code does :) ). I
>> did compile-test as far as possible.
>>
>> After learning more about the wonderful world of page tables and their
>> interaction with the mmap_sem and VMAs, I spotted some issues in our
>> page table walkers that allow user space to trigger nasty behavior when
>> playing dirty tricks with munmap() or mmap() of hugetlb. While some issues
>> should be hard to trigger, others are fairly easy because we provide
>> conventient interfaces (e.g., KVM_S390_GET_SKEYS and KVM_S390_SET_SKEYS).
>>
>> Future work:
>> - Don't use get_locked_pte() when it's not required to actually allocate
>>    page tables -- similar to how storage keys are now handled. Examples are
>>    get_pgste() and __gmap_zap.
>> - Don't use get_locked_pte() and instead let page fault logic allocate page
>>    tables when we actually do need page tables -- also, similar to how
>>    storage keys are now handled. Examples are set_pgste_bits() and
>>    pgste_perform_essa().
>> - Maybe switch to mm/pagewalk.c to avoid custom page table walkers. For
>>    __gmap_zap() that's very easy.
>>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: Janosch Frank <frankja@linux.ibm.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
>> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>> Cc: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>>
>> David Hildenbrand (9):
>>    s390/gmap: validate VMA in __gmap_zap()
>>    s390/gmap: don't unconditionally call pte_unmap_unlock() in
>>      __gmap_zap()
>>    s390/mm: validate VMA in PGSTE manipulation functions
>>    s390/mm: fix VMA and page table handling code in storage key handling
>>      functions
>>    s390/uv: fully validate the VMA before calling follow_page()
>>    s390/pci_mmio: fully validate the VMA before calling follow_pte()
>>    s390/mm: no need for pte_alloc_map_lock() if we know the pmd is
>>      present
>>    s390/mm: optimize set_guest_storage_key()
>>    s390/mm: optimize reset_guest_reference_bit()
>>
>>   arch/s390/kernel/uv.c    |   2 +-
>>   arch/s390/mm/gmap.c      |  11 +++-
>>   arch/s390/mm/pgtable.c   | 109 +++++++++++++++++++++++++++------------
>>   arch/s390/pci/pci_mmio.c |   4 +-
>>   4 files changed, 89 insertions(+), 37 deletions(-)
>>
>>
>> base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f
> 


-- 
Thanks,

David / dhildenb

