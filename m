Return-Path: <kvm+bounces-503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDC07E049B
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 865EDB2147B
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1741A29A;
	Fri,  3 Nov 2023 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NznC/wi6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE95B19BC3
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 14:22:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C339D5F
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 07:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699021368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9j4Kv9c/zBI2m4Ph1PFHstPJ4yqQ4wNi4UN0gFyRfig=;
	b=NznC/wi6HqPWjh1RtGKBubYttuV0y5yGUf9e84xtODMKgo+HdpdDNTx4Syb7NEsSDegVTD
	4RsV/KyeSgjFENCRRLdOKb5UxBzW7CvNbIHWENQxXDbfNQhSdTC8kR+j04zNpuiqKKcFQy
	X5VNqaRNhn7aSiZg86HjrBdLlgDTrkk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-ab5Si-W8N_Sf6DQMLGvgDA-1; Fri, 03 Nov 2023 10:22:46 -0400
X-MC-Unique: ab5Si-W8N_Sf6DQMLGvgDA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-507b9078aaaso2247176e87.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 07:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699021365; x=1699626165;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9j4Kv9c/zBI2m4Ph1PFHstPJ4yqQ4wNi4UN0gFyRfig=;
        b=TYnuP8uEAnhPOFfXGliqbHKnNQaGLCIwq5R1MPTyHpaPfJwkgmWuiq51kqLWOv3D9h
         hKmBapITeytOFp5kZDU4G+KNR+YQKcCdQ+qpUG7KcEKN1tKtMPrIWAxVmZtcUVGaQ79Y
         jfNSpfoZigCZzA/579334I6NVmZmUpeOhh7XQqoT0lJQZHifrOPjMIib9hMUxPQPFQsy
         M72VPjP+4knB8AKR4PpCKWVdpWLwjUbdcWx+LGj0VbOFxHaK42XC8O6uZM1z0QmWBpX3
         HiuLGrrjuIGBka54pWa9GtbtGgdvI3maZImsVFPiMGiI+edsNBmXbrK6tvWQdmvgsdOE
         jGfA==
X-Gm-Message-State: AOJu0YxaOVcsKCdU6T8klhS9IuOPHNLL8wMhYwJCleCgTO6ZxeMP1Oyc
	3nF+nDk0Q63ox9Az2x4VlNDX2lcuf/8MvwHM7qTO0A8TtKjAqjr6blcP2m7Uoj2MofuvnsIeNmm
	Wl0W/4hfttvDk
X-Received: by 2002:a19:505a:0:b0:509:b3f:8a7b with SMTP id z26-20020a19505a000000b005090b3f8a7bmr13460958lfj.22.1699021365299;
        Fri, 03 Nov 2023 07:22:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGr+e404QxzitZjj6D78McDvmskAoZMTW7f26nWDraA0RIQeKRL+ZD4cl3YyZoDdaykW2fk8A==
X-Received: by 2002:a19:505a:0:b0:509:b3f:8a7b with SMTP id z26-20020a19505a000000b005090b3f8a7bmr13460939lfj.22.1699021364895;
        Fri, 03 Nov 2023 07:22:44 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:a600:bc48:cd31:d01f:f468? (p200300cbc70aa600bc48cd31d01ff468.dip0.t-ipconnect.de. [2003:cb:c70a:a600:bc48:cd31:d01f:f468])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d50ce000000b00326f0ca3566sm1988269wrt.50.2023.11.03.07.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 07:22:44 -0700 (PDT)
Message-ID: <23600901-fd02-408c-906e-3e8911e7f42d@redhat.com>
Date: Fri, 3 Nov 2023 15:22:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: s390: vsie: fix wrong VIR 37 when MSO is used
Content-Language: en-US
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, nrb@linux.ibm.com, nsg@linux.ibm.com,
 borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20231102153549.53984-1-imbrenda@linux.ibm.com>
 <87e310d4-bf9b-41c4-a284-193c1a50bf88@redhat.com>
 <20231103152122.4d0d01cf@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231103152122.4d0d01cf@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.11.23 15:21, Claudio Imbrenda wrote:
> On Thu, 2 Nov 2023 21:38:43 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
> [...]
> 
>>>    	/*
>>>    	 * Only new shadow blocks are added to the list during runtime,
>>>    	 * therefore we can safely reference them all the time.
>>
>> Right, mso is 64bit, the prefix is 18bit (shifted by 13) -> 31bit.
>>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> thanks
> 
>>
>> Does it make sense to remember the maximum prefix address across all
>> shadows (or if the mso was ever 0), so we can optimize for the mso == 0
>> case and not have to go through all vsie pages on all notification?
>> Sounds like a reasonable optimization on top.
>   
> yes, but it adds complexity to already complex code
> 

Such an optimization would be very simplistic.

-- 
Cheers,

David / dhildenb


