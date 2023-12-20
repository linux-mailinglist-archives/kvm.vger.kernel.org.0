Return-Path: <kvm+bounces-4925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5DA819F8D
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 14:12:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 145A31F21C37
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95912576F;
	Wed, 20 Dec 2023 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ah0Mg7E3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F1425752
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703077919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CJ7ahpzwRIJAw0Q3ffnJIxb51dpLYSDvSOS0JNQhsbY=;
	b=Ah0Mg7E3HapgfNV83T6/Qsx/JBeYeVBCF1WlSRjw+XiMTaDtHjB0/ZYeH71FsQvMlbavBQ
	17lIhqdUA2Qr87WrNLh1ybLUhXJNioZ7ElpbIQgBjOsCnEg3diFzi5jWK2XDpJPTbf/v47
	cX5v8RgIbf56Z4f66yzsdCIEuLTQvRI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-Nq0sFo95Nu6TdTyDeqew8A-1; Wed, 20 Dec 2023 08:11:58 -0500
X-MC-Unique: Nq0sFo95Nu6TdTyDeqew8A-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-336688e89dbso350569f8f.0
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 05:11:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703077917; x=1703682717;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJ7ahpzwRIJAw0Q3ffnJIxb51dpLYSDvSOS0JNQhsbY=;
        b=iUnZHLjIAjzZcM16mAwWHqVUguNQD9qBQUiV5/kWu5gSFrF4CFJszi8GgE/nqMZr55
         hiF3LZuZ7LKGCpqfKwGI7Vx4N6WPH1D+BKZk0KyZU0MaVgLE117Sa+shjwDlmoE0HCsg
         pwzP83B8CkhTwdZdkujNi6g2Un/qbneaBGttEVGeebZof/rgVBcdUZHe9+qMpNInNmW2
         d1uaf95qwRkilvWT+YaJ585tF0DR4UjJ+pn3jgZUiMqARsze3PKQdpC35pb39TT871Ol
         YFvrKiqz87A470TuECAi+V9315B0nBKkXiukYhNcTpYRnYR7QK3gnmVMMTr9ijRDs9Sb
         mgOg==
X-Gm-Message-State: AOJu0YziNSAFXcw5OMyC6IBuEmo4irHq3UChpIgNf8D4SYNi/MOQi1x/
	UOJwkjr0cTt0oSJPcIgRpOc9wrJ6+Nt9ugsiag5FP2M8VY6MCj44gsb9r67us9brGP5ADNgzjHu
	+0cqLpRWwj1lq
X-Received: by 2002:a05:600c:a04:b0:40c:3db4:70f2 with SMTP id z4-20020a05600c0a0400b0040c3db470f2mr1698363wmp.142.1703077916871;
        Wed, 20 Dec 2023 05:11:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhiNjSRbezWfzwfp5soiz/fB9zcBCtyxcFl8EY/cMLmbsR+sJmk59eAyvGW46BSpWdLilDZw==
X-Received: by 2002:a05:600c:a04:b0:40c:3db4:70f2 with SMTP id z4-20020a05600c0a0400b0040c3db470f2mr1698354wmp.142.1703077916444;
        Wed, 20 Dec 2023 05:11:56 -0800 (PST)
Received: from ?IPV6:2003:cb:c73b:eb00:8e25:6953:927:1802? (p200300cbc73beb008e25695309271802.dip0.t-ipconnect.de. [2003:cb:c73b:eb00:8e25:6953:927:1802])
        by smtp.gmail.com with ESMTPSA id x12-20020a5d650c000000b003366c058509sm2194735wru.23.2023.12.20.05.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 05:11:56 -0800 (PST)
Message-ID: <6c92d19d-536a-45e8-95b1-576f407ce727@redhat.com>
Date: Wed, 20 Dec 2023 14:11:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: fix race during shadow creation
Content-Language: en-US
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 KVM <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>,
 linux-s390 <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20231220073400.257813-1-borntraeger@linux.ibm.com>
 <00f45b68-00cc-4cf1-a492-47d3bfce7e9f@redhat.com>
 <5a035ab2-f704-470a-8b98-f8e5813ef08c@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <5a035ab2-f704-470a-8b98-f8e5813ef08c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index 6f96b5a71c63..e083fade7a5d 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -1691,6 +1691,7 @@ struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce,
>>                   return ERR_PTR(-ENOMEM);
>>           new->mm = parent->mm;
>>           new->parent = gmap_get(parent);
>> +       new->private = patent->private;
>>           new->orig_asce = asce;
>>           new->edat_level = edat_level;
>>           new->initialized = false;
>>
>> Or am I missing something?
> 
> That would work as well. I discussed several alternatives with Janosch.
> The only thing that bothers me is that the owner should define private. So an
> alternative would be to have a parameter for gmap_shadow. On the other hand I
> like the simplicity of this patch. (we need to get rid of the 2nd assignment
> in acquire_gmap_shadow to make it complete.

Right. Conceptually, the owner setup parent->private and the owner 
requests to create a shadow. So inheriting the ->private setting does 
not sound completely wrong.

-- 
Cheers,

David / dhildenb


