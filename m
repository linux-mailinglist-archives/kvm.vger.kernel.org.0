Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46291146ACC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgAWOFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:05:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29587 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729365AbgAWOFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 09:05:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579788343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=WPUndn+3PlaftyGJyUhWMdZQ5jf1QcGRmeI6Yc2wsnQ=;
        b=cxSHZjZP2w1dUfKouVAmLxELNtJbMi1oo0mePOeg6z/n4+48xY03JOADGmrUuQux4dYFKk
        J5jiVbLlEl+Cu/zM4KbGWyABwB9//k0itHEkApEQIGzy8fDfcXIkFa8cjdgTvXrRvESZj8
        Sg+kxXhF//ujinJdkdfmwdc7A/kG/Cw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-gMCv7wvPNRaGl0ErooX8Bw-1; Thu, 23 Jan 2020 09:05:41 -0500
X-MC-Unique: gMCv7wvPNRaGl0ErooX8Bw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D30BDBF7;
        Thu, 23 Jan 2020 14:05:37 +0000 (UTC)
Received: from [10.36.117.56] (ovpn-117-56.ams2.redhat.com [10.36.117.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91FF98CCEB;
        Thu, 23 Jan 2020 14:05:12 +0000 (UTC)
Subject: Re: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
To:     Alexander Graf <graf@amazon.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de,
        "Paterson-Jones, Roland" <rolandp@amazon.com>, hannes@cmpxchg.org,
        hare@suse.com
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
 <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <0e2d04a8-af74-e2db-cab0-c67286e33a2a@redhat.com>
Date:   Thu, 23 Jan 2020 15:05:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.01.20 11:20, Alexander Graf wrote:
> Hi Alex,
> 
> On 22.01.20 18:43, Alexander Duyck wrote:
>> This series provides an asynchronous means of reporting free guest pages
>> to a hypervisor so that the memory associated with those pages can be
>> dropped and reused by other processes and/or guests on the host. Using
>> this it is possible to avoid unnecessary I/O to disk and greatly improve
>> performance in the case of memory overcommit on the host.
>>
>> When enabled we will be performing a scan of free memory every 2 seconds
>> while pages of sufficiently high order are being freed. In each pass at
>> least one sixteenth of each free list will be reported. By doing this we
>> avoid racing against other threads that may be causing a high amount of
>> memory churn.
>>
>> The lowest page order currently scanned when reporting pages is
>> pageblock_order so that this feature will not interfere with the use of
>> Transparent Huge Pages in the case of virtualization.
>>
>> Currently this is only in use by virtio-balloon however there is the hope
>> that at some point in the future other hypervisors might be able to make
>> use of it. In the virtio-balloon/QEMU implementation the hypervisor is
>> currently using MADV_DONTNEED to indicate to the host kernel that the page
>> is currently free. It will be zeroed and faulted back into the guest the
>> next time the page is accessed.
>>
>> To track if a page is reported or not the Uptodate flag was repurposed and
>> used as a Reported flag for Buddy pages. We walk though the free list
>> isolating pages and adding them to the scatterlist until we either
>> encounter the end of the list, processed as many pages as were listed in
>> nr_free prior to us starting, or have filled the scatterlist with pages to
>> be reported. If we fill the scatterlist before we reach the end of the
>> list we rotate the list so that the first unreported page we encounter is
>> moved to the head of the list as that is where we will resume after we
>> have freed the reported pages back into the tail of the list.
>>
>> Below are the results from various benchmarks. I primarily focused on two
>> tests. The first is the will-it-scale/page_fault2 test, and the other is
>> a modified version of will-it-scale/page_fault1 that was enabled to use
>> THP. I did this as it allows for better visibility into different parts
>> of the memory subsystem. The guest is running with 32G for RAM on one
>> node of a E5-2630 v3. The host has had some features such as CPU turbo
>> disabled in the BIOS.
>>
>> Test                   page_fault1 (THP)    page_fault2
>> Name            tasks  Process Iter  STDEV  Process Iter  STDEV
>> Baseline            1    1012402.50  0.14%     361855.25  0.81%
>>                     16    8827457.25  0.09%    3282347.00  0.34%
>>
>> Patches Applied     1    1007897.00  0.23%     361887.00  0.26%
>>                     16    8784741.75  0.39%    3240669.25  0.48%
>>
>> Patches Enabled     1    1010227.50  0.39%     359749.25  0.56%
>>                     16    8756219.00  0.24%    3226608.75  0.97%
>>
>> Patches Enabled     1    1050982.00  4.26%     357966.25  0.14%
>>   page shuffle      16    8672601.25  0.49%    3223177.75  0.40%
>>
>> Patches enabled     1    1003238.00  0.22%     360211.00  0.22%
>>   shuffle w/ RFC    16    8767010.50  0.32%    3199874.00  0.71%
>>
>> The results above are for a baseline with a linux-next-20191219 kernel,
>> that kernel with this patch set applied but page reporting disabled in
>> virtio-balloon, the patches applied and page reporting fully enabled, the
>> patches enabled with page shuffling enabled, and the patches applied with
>> page shuffling enabled and an RFC patch that makes used of MADV_FREE in
>> QEMU. These results include the deviation seen between the average value
>> reported here versus the high and/or low value. I observed that during the
>> test memory usage for the first three tests never dropped whereas with the
>> patches fully enabled the VM would drop to using only a few GB of the
>> host's memory when switching from memhog to page fault tests.
>>
>> Any of the overhead visible with this patch set enabled seems due to page
>> faults caused by accessing the reported pages and the host zeroing the page
>> before giving it back to the guest. This overhead is much more visible when
>> using THP than with standard 4K pages. In addition page shuffling seemed to
>> increase the amount of faults generated due to an increase in memory churn.
>> The overhead is reduced when using MADV_FREE as we can avoid the extra
>> zeroing of the pages when they are reintroduced to the host, as can be seen
>> when the RFC is applied with shuffling enabled.
>>
>> The overall guest size is kept fairly small to only a few GB while the test
>> is running. If the host memory were oversubscribed this patch set should
>> result in a performance improvement as swapping memory in the host can be
>> avoided.
> 
> 
> I really like the approach overall. Voluntarily propagating free memory 
> from a guest to the host has been a sore point ever since KVM was 
> around. This solution looks like a very elegant way to do so.
> 
> The big piece I'm missing is the page cache. Linux will by default try 
> to keep the free list as small as it can in favor of page cache, so most 
> of the benefit of this patch set will be void in real world scenarios.

One approach is to move (parts of) the page cache from the guest to the
hypervisor - e.g., using emulated NVDIMM or virtio-pmem.

-- 
Thanks,

David / dhildenb

