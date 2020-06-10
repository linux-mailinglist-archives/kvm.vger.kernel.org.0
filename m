Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959F61F56A5
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 16:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgFJON4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 10:13:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35592 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbgFJONz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 10:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591798433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=vQGmaF3kJuwxZRfFPgkkAxZRnaRj43xPvFfzjX5dh88=;
        b=ad26TQm6n4zvt+IAWJaS9SAU3nRH7LwwiSQmHf6eYDsAcTMZ+axOdVYCm2lu8ykEAny4x7
        o4OOl7ZkcqujXlFNUtzSAm2iT1a3gCUzbaK+Ilh7xwLg4PMGfiQskAfUfPbDW8+Lk5oKxE
        1FzW7njivU7Xv3cY41Agn3BGHemgr7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-1tyO6TELM-2iYkoxtz2SDQ-1; Wed, 10 Jun 2020 10:13:49 -0400
X-MC-Unique: 1tyO6TELM-2iYkoxtz2SDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AEA2461;
        Wed, 10 Jun 2020 14:13:48 +0000 (UTC)
Received: from [10.36.114.42] (ovpn-114-42.ams2.redhat.com [10.36.114.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C039F5D9E5;
        Wed, 10 Jun 2020 14:13:39 +0000 (UTC)
Subject: Re: [PATCH v4 02/21] vfio: Convert to ram_block_discard_disable()
To:     Tony Krowiak <akrowiak@linux.ibm.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20200610115419.51688-1-david@redhat.com>
 <20200610115419.51688-3-david@redhat.com>
 <8c71bfda-e958-56f8-ddaf-6a831fff2bc6@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAlgEEwEIAEICGwMFCQlmAYAGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl3pImkCGQEACgkQTd4Q
 9wD/g1o+VA//SFvIHUAvul05u6wKv/pIR6aICPdpF9EIgEU448g+7FfDgQwcEny1pbEzAmiw
 zAXIQ9H0NZh96lcq+yDLtONnXk/bEYWHHUA014A1wqcYNRY8RvY1+eVHb0uu0KYQoXkzvu+s
 Dncuguk470XPnscL27hs8PgOP6QjG4jt75K2LfZ0eAqTOUCZTJxA8A7E9+XTYuU0hs7QVrWJ
 jQdFxQbRMrYz7uP8KmTK9/Cnvqehgl4EzyRaZppshruKMeyheBgvgJd5On1wWq4ZUV5PFM4x
 II3QbD3EJfWbaJMR55jI9dMFa+vK7MFz3rhWOkEx/QR959lfdRSTXdxs8V3zDvChcmRVGN8U
 Vo93d1YNtWnA9w6oCW1dnDZ4kgQZZSBIjp6iHcA08apzh7DPi08jL7M9UQByeYGr8KuR4i6e
 RZI6xhlZerUScVzn35ONwOC91VdYiQgjemiVLq1WDDZ3B7DIzUZ4RQTOaIWdtXBWb8zWakt/
 ztGhsx0e39Gvt3391O1PgcA7ilhvqrBPemJrlb9xSPPRbaNAW39P8ws/UJnzSJqnHMVxbRZC
 Am4add/SM+OCP0w3xYss1jy9T+XdZa0lhUvJfLy7tNcjVG/sxkBXOaSC24MFPuwnoC9WvCVQ
 ZBxouph3kqc4Dt5X1EeXVLeba+466P1fe1rC8MbcwDkoUo65Ag0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAGJAiUEGAECAA8FAlXLn5ECGwwFCQlmAYAACgkQTd4Q
 9wD/g1qA6w/+M+ggFv+JdVsz5+ZIc6MSyGUozASX+bmIuPeIecc9UsFRatc91LuJCKMkD9Uv
 GOcWSeFpLrSGRQ1Z7EMzFVU//qVs6uzhsNk0RYMyS0B6oloW3FpyQ+zOVylFWQCzoyyf227y
 GW8HnXunJSC+4PtlL2AY4yZjAVAPLK2l6mhgClVXTQ/S7cBoTQKP+jvVJOoYkpnFxWE9pn4t
 H5QIFk7Ip8TKr5k3fXVWk4lnUi9MTF/5L/mWqdyIO1s7cjharQCstfWCzWrVeVctpVoDfJWp
 4LwTuQ5yEM2KcPeElLg5fR7WB2zH97oI6/Ko2DlovmfQqXh9xWozQt0iGy5tWzh6I0JrlcxJ
 ileZWLccC4XKD1037Hy2FLAjzfoWgwBLA6ULu0exOOdIa58H4PsXtkFPrUF980EEibUp0zFz
 GotRVekFAceUaRvAj7dh76cToeZkfsjAvBVb4COXuhgX6N4pofgNkW2AtgYu1nUsPAo+NftU
 CxrhjHtLn4QEBpkbErnXQyMjHpIatlYGutVMS91XTQXYydCh5crMPs7hYVsvnmGHIaB9ZMfB
 njnuI31KBiLUks+paRkHQlFcgS2N3gkRBzH7xSZ+t7Re3jvXdXEzKBbQ+dC3lpJB0wPnyMcX
 FOTT3aZT7IgePkt5iC/BKBk3hqKteTnJFeVIT7EC+a6YUFg=
Organization: Red Hat GmbH
Message-ID: <56d20632-cab6-5768-ce9f-96f6587e4c2f@redhat.com>
Date:   Wed, 10 Jun 2020 16:13:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8c71bfda-e958-56f8-ddaf-6a831fff2bc6@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.06.20 15:04, Tony Krowiak wrote:
> 
> 
> On 6/10/20 7:54 AM, David Hildenbrand wrote:
>> VFIO is (except devices without a physical IOMMU or some mediated devices)
>> incompatible with discarding of RAM. The kernel will pin basically all VM
>> memory. Let's convert to ram_block_discard_disable(), which can now
>> fail, in contrast to qemu_balloon_inhibit().
>>
>> Leave "x-balloon-allowed" named as it is for now.
>>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
>> Cc: Halil Pasic <pasic@linux.ibm.com>
>> Cc: Pierre Morel <pmorel@linux.ibm.com>
>> Cc: Eric Farman <farman@linux.ibm.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> See my two minor comments, other than that:
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> 
>> ---
>>   hw/vfio/ap.c                  | 10 +++----
>>   hw/vfio/ccw.c                 | 11 ++++----
>>   hw/vfio/common.c              | 53 +++++++++++++++++++----------------
>>   hw/vfio/pci.c                 |  6 ++--
>>   include/hw/vfio/vfio-common.h |  4 +--
>>   5 files changed, 45 insertions(+), 39 deletions(-)
>>
>> diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
>> index 95564c17ed..d0b1bc7581 100644
>> --- a/hw/vfio/ap.c
>> +++ b/hw/vfio/ap.c
>> @@ -105,12 +105,12 @@ static void vfio_ap_realize(DeviceState *dev, Error **errp)
>>       vapdev->vdev.dev = dev;
>>   
>>       /*
>> -     * vfio-ap devices operate in a way compatible with
>> -     * memory ballooning, as no pages are pinned in the host.
>> -     * This needs to be set before vfio_get_device() for vfio common to
>> -     * handle the balloon inhibitor.
>> +     * vfio-ap devices operate in a way compatible discarding of memory in
> 
> s/compatible discarding/compatible with discarding/?

Very right!

[...]
>> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
>> index 342dd6b912..c33c11b7e4 100644
>> --- a/hw/vfio/pci.c
>> +++ b/hw/vfio/pci.c
>> @@ -2796,7 +2796,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>>       }
>>   
>>       /*
>> -     * Mediated devices *might* operate compatibly with memory ballooning, but
>> +     * Mediated devices *might* operate compatibly with discarding of RAM, but
>>        * we cannot know for certain, it depends on whether the mdev vendor driver
>>        * stays in sync with the active working set of the guest driver.  Prevent
>>        * the x-balloon-allowed option unless this is minimally an mdev device.
>> @@ -2809,7 +2809,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>>   
>>       trace_vfio_mdev(vdev->vbasedev.name, is_mdev);
>>   
>> -    if (vdev->vbasedev.balloon_allowed && !is_mdev) {
>> +    if (vdev->vbasedev.ram_block_discard_allowed && !is_mdev) {
>>           error_setg(errp, "x-balloon-allowed only potentially compatible "
>>                      "with mdev devices");
> 
> Should this error message be changed?

I didn't rename the property ("x-balloon-allowed"), so the error message
is still correct.

Thanks!

-- 
Thanks,

David / dhildenb

