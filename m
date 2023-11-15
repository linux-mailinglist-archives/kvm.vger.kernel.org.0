Return-Path: <kvm+bounces-1843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A625A7ECA6D
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 19:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDF6F1C20B48
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 18:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B62364B6;
	Wed, 15 Nov 2023 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QshAZ26Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6803218B
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700072428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HD4icerkSXDuFzc3QWH2GfX4IZAoWdNJxuLXkU5j7lg=;
	b=QshAZ26Y+efqKLdYhuc8P/t/LbEF/e6dv4RvXFy74Q+sDrfvhpK2ItfLA+DCSIHMiio3X4
	CrpymM9wrdhZIStb8vPtk7obuQthpbd8p/d0FB5VEKjmUsiOwhE/IbZYvcvYiWE65elEOw
	BsWuNbGLzYqhRUlwjXnpRa7Bo7Y0poI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-CgMt-UbSPgei3Hv8PitQYA-1; Wed, 15 Nov 2023 13:20:27 -0500
X-MC-Unique: CgMt-UbSPgei3Hv8PitQYA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32de9f93148so3581408f8f.2
        for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700072426; x=1700677226;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HD4icerkSXDuFzc3QWH2GfX4IZAoWdNJxuLXkU5j7lg=;
        b=gJcWcJkoxkhUn/XR4TvEDlZnNunexXm91o6IMHWBO3/rYnVfRB3O8R1mK+DWIYzyLu
         8QnZ2IzJCW5tFLni4BnHCEogoO0jr6SrdMjnifcCP+QDxpQjOIkDlaWRDuOy/FG1NmyS
         lFK3emC8bUtAuTXQ6FYUD0S/4mNJsz7Us85RcF5DPqAyJ6I+RItinC0lBKHCqrnVKwL/
         COamIE+1NJivXdWgXy0WtIB/UqyrC1yKqQWEEQHL34Em4r6A09s41EvlPoqPoiHLRGoF
         lD/ILThwJvFDskBpeRSOHM9/PQZ5ePEu3iS0fFdYrdTvodZFSkbEdn1IEhStYrLaHE0P
         szyA==
X-Gm-Message-State: AOJu0YwmAFkYIVPTl22CXSCrHh5zYQrHDWmbul5cyJnSxkQDQp6F6MPq
	qCyW15gZiqjVLt5ZACh4fZiEu4GtcCJZuXC2Iu5dnQi0bAuYhpYSF6OVsUc6IpR7UcCKca2VBRm
	vV8H6Ot8hDUGA
X-Received: by 2002:a05:6000:118c:b0:32d:ad44:cec1 with SMTP id g12-20020a056000118c00b0032dad44cec1mr117148wrx.3.1700072425872;
        Wed, 15 Nov 2023 10:20:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJCugW+hQi7qzlMw2hTAONeHHw9A9gBgxuyLctoWXex0jnCqanMmOlxqGmmLzJyUeTvQyfcw==
X-Received: by 2002:a05:6000:118c:b0:32d:ad44:cec1 with SMTP id g12-20020a056000118c00b0032dad44cec1mr117121wrx.3.1700072425424;
        Wed, 15 Nov 2023 10:20:25 -0800 (PST)
Received: from ?IPV6:2003:cb:c706:ed00:59ee:f048:4ed9:62a6? (p200300cbc706ed0059eef0484ed962a6.dip0.t-ipconnect.de. [2003:cb:c706:ed00:59ee:f048:4ed9:62a6])
        by smtp.gmail.com with ESMTPSA id q12-20020a05600000cc00b0032db4e660d9sm11191172wrx.56.2023.11.15.10.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 10:20:24 -0800 (PST)
Message-ID: <a61206eb-03c4-41e3-a876-bb67577e5204@redhat.com>
Date: Wed, 15 Nov 2023 19:20:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/70] physmem: Relax the alignment check of
 host_startaddr in ram_block_discard_range()
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-8-xiaoyao.li@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231115071519.2864957-8-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.11.23 08:14, Xiaoyao Li wrote:
> Commit d3a5038c461 ("exec: ram_block_discard_range") introduced
> ram_block_discard_range() which grabs some code from
> ram_discard_range(). However, during code movement, it changed alignment
> check of host_startaddr from qemu_host_page_size to rb->page_size.
> 
> When ramblock is back'ed by hugepage, it requires the startaddr to be
> huge page size aligned, which is a overkill. e.g., TDX's private-shared
> page conversion is done at 4KB granularity. Shared page is discarded
> when it gets converts to private and when shared page back'ed by
> hugepage it is going to fail on this check.
> 
> So change to alignment check back to qemu_host_page_size.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
>   - Newly added in v3;
> ---
>   system/physmem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index c56b17e44df6..8a4e42c7cf60 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -3532,7 +3532,7 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
>   
>       uint8_t *host_startaddr = rb->host + start;
>   
> -    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
> +    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, qemu_host_page_size)) {

For your use cases, rb->page_size should always match qemu_host_page_size.

IIRC, we only set rb->page_size to different values for hugetlb. And 
guest_memfd does not support hugetlb.

Even if QEMU is using THP, rb->page_size should 4k.

Please elaborate how you can actually trigger that. From what I recall, 
guest_memfd is not compatible with hugetlb.

And the check here makes perfect sense for existing callers of 
ram_block_discard_range(): you cannot partially zap a hugetlb page.

-- 
Cheers,

David / dhildenb


