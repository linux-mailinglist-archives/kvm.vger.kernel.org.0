Return-Path: <kvm+bounces-2980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6BB7FF813
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDD011C21007
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4123856754;
	Thu, 30 Nov 2023 17:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WHKLlnEd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E328DE6
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701364908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8HgmAY67ioM9FcIqRz6yy6nu6nHAS6z6yyJu081UfVM=;
	b=WHKLlnEdFyr/CDevQpEg59fgs4y68DxCzHVMOpv2X9osnmsZjxRR03NObKAFO3wVx4L1M4
	nhpenO4PDMNu6EcE/G73wMFEl+NdEb1MVx6APWR6bRJFOvOFBQCnR4UWGZFA322v2XyuEk
	iXl5ypcbDfXmsGr7JDO3mHmphhiM42Q=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-_u_aux9oPMaIQvOBp1v_Pg-1; Thu, 30 Nov 2023 12:21:47 -0500
X-MC-Unique: _u_aux9oPMaIQvOBp1v_Pg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a1772440a1aso112957366b.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:21:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701364906; x=1701969706;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HgmAY67ioM9FcIqRz6yy6nu6nHAS6z6yyJu081UfVM=;
        b=jAaPFuyxUPO3YgNZfVkoxwYtzUqbj9fz/M+K1VRUlCUc6+cwrUxpAorg4b4Pd3hmjA
         CbthvhnQDcVBynyk5P2aZzBwtNuxcSdh+ap8zk3c1nYWCFyu8lD85iRR9rN4Clkg/gtN
         cYRG5lbnKFNDl9HseLFdeJUyX/isNGW42BZluX1jdTaMOeLKTvABWxZNoTKUdzhS5MNO
         +jkVHvL0B47LUhhlNalVKu/jxb8WWy+TkuFW+2sD91u0+ebXZkEzURlKr6JBuiLJTwUL
         R/t2020QVOdDwlRgSLmvApST7xCjyJWee7YJbra48yUm/E1S/i9p2dXJrw3FbIs2gkg+
         /Zkw==
X-Gm-Message-State: AOJu0Yw+aE98HwybaBTj0odfqX7PhFlDUuptNfzkDcaeYgDR/CYjPrg0
	sTHd8i4LlAGZfwhS2FbnZGEmFOSa2i8JowTQzylC1MgB2Py4CVmSI5R/0BrcB28s8Orst6/Pz9w
	AsHd0oD0yIgBzKlmtbnqL
X-Received: by 2002:a17:906:2209:b0:9dd:7133:881 with SMTP id s9-20020a170906220900b009dd71330881mr4314ejs.40.1701364903513;
        Thu, 30 Nov 2023 09:21:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4gVM/tI2/mmg7DvkKDDf46eY/DSbpROp1iRiOBkmYGoyfHH5bYX55qLUFhKcnvs3aPctdEw==
X-Received: by 2002:a05:600c:3b92:b0:40b:448b:f711 with SMTP id n18-20020a05600c3b9200b0040b448bf711mr13806wms.18.1701363268151;
        Thu, 30 Nov 2023 08:54:28 -0800 (PST)
Received: from ?IPV6:2003:cb:c71c:3600:33e6:971c:5f64:fab5? (p200300cbc71c360033e6971c5f64fab5.dip0.t-ipconnect.de. [2003:cb:c71c:3600:33e6:971c:5f64:fab5])
        by smtp.gmail.com with ESMTPSA id m40-20020a05600c3b2800b004042dbb8925sm6330795wms.38.2023.11.30.08.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 08:54:27 -0800 (PST)
Message-ID: <d6bfd8be-7e8c-4a95-9e27-31775f8e352e@redhat.com>
Date: Thu, 30 Nov 2023 17:54:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable
 KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-4-xiaoyao.li@intel.com>
 <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
 <05f0e440-36a2-4d3a-8caa-842b34e50dce@intel.com>
 <0fbfc413-7c74-4b2a-bade-6f3f04ca82c2@redhat.com>
 <4708c33a-bb8d-484e-ac7b-b7e8d3ed445a@intel.com>
 <45d28654-9565-46df-81b9-6563a4aef78c@redhat.com>
 <ZWixXm-sboNZ-mzG@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZWixXm-sboNZ-mzG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.11.23 17:01, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, David Hildenbrand wrote:
>> On 30.11.23 08:32, Xiaoyao Li wrote:
>>> On 11/20/2023 5:26 PM, David Hildenbrand wrote:
>>>>
>>>>>> ... did you shamelessly copy that from hw/virtio/virtio-mem.c ? ;)
>>>>>
>>>>> Get caught.
>>>>>
>>>>>> This should be factored out into a common helper.
>>>>>
>>>>> Sure, will do it in next version.
>>>>
>>>> Factor it out in a separate patch. Then, this patch is get small that
>>>> you can just squash it into #2.
>>>>
>>>> And my comment regarding "flags = 0" to patch #2 does no longer apply :)
>>>>
>>>
>>> I see.
>>>
>>> But it depends on if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE will appear together
>>> with initial guest memfd in linux (hopefully 6.8)
>>> https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com/
>>>
>>
>> Doesn't seem to be in -next if I am looking at the right tree:
>>
>> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next
> 
> Yeah, we punted on adding hugepage support for the initial guest_memfd merge so
> as not to rush in kludgy uABI.  The internal KVM code isn't problematic, we just
> haven't figured out exactly what the ABI should look like, e.g. should hugepages
> be dependent on THP being enabled, and if not, how does userspace discover the
> supported hugepage sizes?

Are we talking about THP or hugetlb? They are two different things, and 
"KVM_GUEST_MEMFD_ALLOW_HUGEPAGE" doesn't make it clearer what we are 
talking about.

This patch here "get_thp_size()" indicates that we care about THP, not 
hugetlb.


THP lives in:
	/sys/kernel/mm/transparent_hugepage/
and hugetlb in:
	/sys/kernel/mm/hugepages/

THP for shmem+anon currently really only supports PMD-sized THP, that 
size can be observed via:
	/sys/kernel/mm/transparent_hugepage/hpage_pmd_size

hugetlb sizes can be detected simply by looking at the folders inside
/sys/kernel/mm/hugepages/. "tools/testing/selftests/mm/vm_util.c" in the 
kernel has a function "detect_hugetlb_page_sizes()" that uses that 
interface to detect the sizes.


But likely we want THP support here. Because for hugetlb, one would 
actually have to instruct the kernel which size to use, like we do for 
memfd with hugetlb.


Anon support for smaller sizes than PMDs is in the works, and once 
upstream, it can then be detected via 
/sys/kernel/mm/transparent_hugepage/ as well.

shmem support for smaller sizes is partially in the works: only on the 
write() path. Likely, we'll make it configurable/observable in 
/sys/kernel/mm/transparent_hugepage/ as well.


So if we are talking about THP for shmem, there really only is 
/sys/kernel/mm/transparent_hugepage/hpage_pmd_size.

-- 
Cheers,

David / dhildenb


