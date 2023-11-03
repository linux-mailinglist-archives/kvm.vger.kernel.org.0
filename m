Return-Path: <kvm+bounces-524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A30A7E085B
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B8931C20962
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D5B2572;
	Fri,  3 Nov 2023 18:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEwZpCeQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65082D60B
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 18:41:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22AB134
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 11:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699036905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rQdlhLsgwoDUWtGk1QN2qdmt5PoNVil6qIYYzzkXmf8=;
	b=MEwZpCeQNSA/T7SRDDOeDo1wvFLz1Hk9mS/3ZTODvGdot4JSW7qt8M+VUjJ769V7U0+Xez
	4qvvPFOPpEP7wuJ66l8xcXn+wQIq648+Y0MRR47nyZu4VE3+Qcr7AG6DkA0+nEbzhSG76D
	xZDaIVphJ8o89qFUcOb9PtFfVDqmkhY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-GDiOqjzCNXKjM_6jwuWmqA-1; Fri, 03 Nov 2023 14:41:43 -0400
X-MC-Unique: GDiOqjzCNXKjM_6jwuWmqA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32db6a28e24so1080130f8f.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 11:41:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699036902; x=1699641702;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:from:content-language:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rQdlhLsgwoDUWtGk1QN2qdmt5PoNVil6qIYYzzkXmf8=;
        b=k2/2GS0GgkGjbz2wrSzIvAkuoVAHfyQlxW+ZisH5/JO/N1gZ2grprcRyVFP5uMLY6C
         MPgWwqLu7NF+AZpnLwx4YJ3DMcK6eLtDmCty8ENXfx/3oDLaz2I7RBv54toF+qS8r+z/
         IR+GFL/wM5CrcPA5ZcXjO3b0tb2oqgbs4LnutbPh6BVZ55jL0C2QisYZspGlHHn9GB6S
         JvBW2CXY7l/iA8thMc0I0BXGYbwpullCdB6RnMkYqq5mnaBktsgVoE9iHmVyqyhIaUtA
         34T5wGW+jSG6+ikzswLNp06ou5SgkbeTD68EKHJ25Ox5FA+UoetCY/0kSYS+fKo8xNzs
         T/uQ==
X-Gm-Message-State: AOJu0YwAJov4DjzIGCDokBHYp6Bk5EvMD+5+ERwPm8s8nQ396e+wThvv
	wS3Le21NJHnQryM+VHioTWsJvh71nttN195pDZ5wRlymar1WfGFuym1umR2j0GiEnu995Rw1WVp
	e/l0NGiYttCCK
X-Received: by 2002:a05:6000:1ce:b0:31f:f753:5897 with SMTP id t14-20020a05600001ce00b0031ff7535897mr20414709wrx.59.1699036902499;
        Fri, 03 Nov 2023 11:41:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDXKVSFHCqELK9UNyOjjCQaFsE3qSEeRJXe06NKwAr08GvR30qcJa0LO7VP9KZXwoCJUWWgg==
X-Received: by 2002:a05:6000:1ce:b0:31f:f753:5897 with SMTP id t14-20020a05600001ce00b0031ff7535897mr20414690wrx.59.1699036902075;
        Fri, 03 Nov 2023 11:41:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:a600:bc48:cd31:d01f:f468? (p200300cbc70aa600bc48cd31d01ff468.dip0.t-ipconnect.de. [2003:cb:c70a:a600:bc48:cd31:d01f:f468])
        by smtp.gmail.com with ESMTPSA id g2-20020a056000118200b0032dcb08bf94sm2454372wrx.60.2023.11.03.11.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 11:41:41 -0700 (PDT)
Message-ID: <47d18f06-13b2-4ec5-b601-eb9a2738f06b@redhat.com>
Date: Fri, 3 Nov 2023 19:41:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] KVM: s390: cpu model: Use previously unused constant
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Cornelia Huck <cornelia.huck@de.ibm.com>,
 Michael Mueller <mimu@linux.vnet.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 David Hildenbrand <dahi@linux.vnet.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20231103173008.630217-1-nsg@linux.ibm.com>
 <20231103173008.630217-4-nsg@linux.ibm.com>
 <4c3cec3c-da81-426c-815b-afee1de68947@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <4c3cec3c-da81-426c-815b-afee1de68947@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.11.23 19:36, David Hildenbrand wrote:
> On 03.11.23 18:30, Nina Schoetterl-Glausch wrote:
>> No point in defining a size for the mask if we're not going to use it.
> 
> I neither understand the patch description nor what the bug is that is
> being fixed (and how that description relates to the patch
> subject+description).
> 
> Please improve the patch description.
> 

Should this be

"
KVM: s390: cpu model: use proper define for facility mask size

We're using S390_ARCH_FAC_LIST_SIZE_U64 instead of 
S390_ARCH_FAC_MASK_SIZE_U64 to define the array size of the facility 
mask. Let's properly use S390_ARCH_FAC_MASK_SIZE_U64. Note that both
values are the same and, therefore, this is a pure cleanup.
"

I'm not convinced there is a bug and that this deserves a "Fixes:".

-- 
Cheers,

David / dhildenb


