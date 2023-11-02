Return-Path: <kvm+bounces-453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A55697DFB9D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 21:39:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7EFE1C20F8A
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 20:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8684A1DA4C;
	Thu,  2 Nov 2023 20:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crzzrH7k"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033ACE550
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 20:38:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A891138
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698957528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3J9wj7tampTcsRuCvSqLybE6CcRCrJ4d4Vu1LKhCdhI=;
	b=crzzrH7kvHQ3w8Fs1xVkOS+oOs/tOcW7AWjDcLojbBNnQaeeZwMFrSv5+iZz2O4tt9KaSl
	r0IE+pS1gubKc0/SVPBWv69u/j0I3rvw0opvS3IxPoDliEtFv5aDx3L52uNn0HvpVnDUX8
	9y+uTXcyiuKM/hFdbHSu1ChXgm1gxWk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-706We7MjNMy9l1CZ7RZ3jg-1; Thu, 02 Nov 2023 16:38:46 -0400
X-MC-Unique: 706We7MjNMy9l1CZ7RZ3jg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4084a9e637eso8561185e9.2
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 13:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698957525; x=1699562325;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3J9wj7tampTcsRuCvSqLybE6CcRCrJ4d4Vu1LKhCdhI=;
        b=pTYXc55JDeX8Fn9r36pSbTEM8xUceEpM0I3T9vT0ws1GyYkRYyvxQarJX+o0qMxVKD
         HLzl0trZOAlKDo/IC1bP0QLS115LDQzkWC8FmQHVPYy6fpVQH6+Cf/EkV0Gvh1Ec9dVI
         4oJVAPLLQ4Esa7w/7Ei7v50quyEsT84o34m6X3ZYm+TGrsr9y+Kx1XDrm4f2QBhVSyH2
         zWGb3IEviOdPFUUwIsTwyMDqJf3D0m1eQoc3C34CiC9IGijpUgPEnExd0yek9hTPos10
         ycRePamxH4G7NWRAqrdz0whQ8uwg/S+HOotFkdHMQvmgJlhzuxUyWdgXZv68DyfTIa/0
         owUA==
X-Gm-Message-State: AOJu0YxbuAxc/HossG+MMaEdstFLoRohPZIMRqQf30p7LhHb0CHjc0WI
	5GZpevjw22li9lNbC7I0oCR1wQ8PSF/ADOsLXFMB8E1UqmVNT0V5Qrjzp2Z7hYOILhU0N2KFg9C
	xGmderux1h9vi
X-Received: by 2002:a05:600c:4ecb:b0:407:5ad0:ab5b with SMTP id g11-20020a05600c4ecb00b004075ad0ab5bmr16383707wmq.8.1698957525346;
        Thu, 02 Nov 2023 13:38:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF86iT6qNKR5U9FfNjKECYVteHSVQeEburhBKqksrkdS1WwU6ozKwmofR91OugnX3UsxKnxZg==
X-Received: by 2002:a05:600c:4ecb:b0:407:5ad0:ab5b with SMTP id g11-20020a05600c4ecb00b004075ad0ab5bmr16383693wmq.8.1698957524886;
        Thu, 02 Nov 2023 13:38:44 -0700 (PDT)
Received: from ?IPV6:2003:cb:c716:3000:f155:cef2:ff4d:c7? (p200300cbc7163000f155cef2ff4d00c7.dip0.t-ipconnect.de. [2003:cb:c716:3000:f155:cef2:ff4d:c7])
        by smtp.gmail.com with ESMTPSA id v2-20020a05600c428200b0040303a9965asm236045wmc.40.2023.11.02.13.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 13:38:44 -0700 (PDT)
Message-ID: <87e310d4-bf9b-41c4-a284-193c1a50bf88@redhat.com>
Date: Thu, 2 Nov 2023 21:38:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: s390: vsie: fix wrong VIR 37 when MSO is used
Content-Language: en-US
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, nsg@linux.ibm.com, borntraeger@de.ibm.com,
 frankja@linux.ibm.com
References: <20231102153549.53984-1-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231102153549.53984-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02.11.23 16:35, Claudio Imbrenda wrote:
> When the host invalidates a guest page, it will also check if the page
> was used to map the prefix of any guest CPUs, in which case they are
> stopped and marked as needing a prefix refresh. Upon starting the
> affected CPUs again, their prefix pages are explicitly faulted in and
> revalidated if they had been invalidated. A bit in the PGSTEs indicates
> whether or not a page might contain a prefix. The bit is allowed to
> overindicate. Pages above 2G are skipped, because they cannot be
> prefixes, since KVM runs all guests with MSO = 0.
> 
> The same applies for nested guests (VSIE). When the host invalidates a
> guest page that maps the prefix of the nested guest, it has to stop the
> affected nested guest CPUs and mark them as needing a prefix refresh.
> The same PGSTE bit used for the guest prefix is also used for the
> nested guest. Pages above 2G are skipped like for normal guests, which
> is the source of the bug.
> 
> The nested guest runs is the guest primary address space. The guest
> could be running the nested guest using MSO != 0. If the MSO + prefix
> for the nested guest is above 2G, the check for nested prefix will skip
> it. This will cause the invalidation notifier to not stop the CPUs of
> the nested guest and not mark them as needing refresh. When the nested
> guest is run again, its prefix will not be refreshed, since it has not
> been marked for refresh. This will cause a fatal validity intercept
> with VIR code 37.
> 
> Fix this by removing the check for 2G for nested guests. Now all
> invalidations of pages with the notify bit set will always scan the
> existing VSIE shadow state descriptors.
> 
> This allows to catch invalidations of nested guest prefix mappings even
> when the prefix is above 2G in the guest virtual address space.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/vsie.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 61499293c2ac..e55f489e1fb7 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -587,10 +587,6 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
>   
>   	if (!gmap_is_shadow(gmap))
>   		return;
> -	if (start >= 1UL << 31)
> -		/* We are only interested in prefix pages */
> -		return;
> -
>   	/*
>   	 * Only new shadow blocks are added to the list during runtime,
>   	 * therefore we can safely reference them all the time.

Right, mso is 64bit, the prefix is 18bit (shifted by 13) -> 31bit.

Reviewed-by: David Hildenbrand <david@redhat.com>

Does it make sense to remember the maximum prefix address across all 
shadows (or if the mso was ever 0), so we can optimize for the mso == 0 
case and not have to go through all vsie pages on all notification? 
Sounds like a reasonable optimization on top.

-- 
Cheers,

David / dhildenb


