Return-Path: <kvm+bounces-4804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE448186ED
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 13:03:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3289D1F211CB
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 12:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1415218EB0;
	Tue, 19 Dec 2023 12:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0BHay/c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDA918AF3
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 12:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702987318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vCITF5dMeDG0BubZdh654QnLC5s3UU0m6bF2nYSAq5Q=;
	b=K0BHay/csUJYVOB5m85jpZWVEd0qW81Do5qxtq0N9DEjNwwWM76uWJwjRQFtHKG1eG6tP4
	f9fVChnmZHt9FGZc1qpHZSqoEu2uzaSH3LltHHyx5U2NO9mrNA/O+OPETM2Co6M6q466I5
	k0sNw5kOyCbWUogyet76+F4+eqgpUiQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-e_AF6di1OOeGDBfnsL1_Zg-1; Tue, 19 Dec 2023 07:01:56 -0500
X-MC-Unique: e_AF6di1OOeGDBfnsL1_Zg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-547dd379955so2254715a12.3
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 04:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702987314; x=1703592114;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCITF5dMeDG0BubZdh654QnLC5s3UU0m6bF2nYSAq5Q=;
        b=t9Wm1g6fKN+JIx76Yr9Lj5AA3OYM/Qdy64XGZORTHbBRcj5Tp+FhwPWGu7bVyHN8rX
         SEQFxkOUGeFe/l3Gv4k5ppCJkReHkFbsYREweOxGDQENiBMBXYnPoM7AD2gKeeVd+X/T
         80jeS4fQyl0+aLR4GL6NNFTofllVZCMVQoSEIPhsM7sJNU1PKCjiBjqiaOGyVq0wcXiB
         xwEUmKNeaTcw4agkc5fvMaIQMXb2LqP/KhMitMhX/mdpFtKUY1w1yBCLzkYAzLJKWBL4
         EFWBbL9tRsJIJy2NvQozOOAtht/CB1BdQI4pRp4wf35EtyCsRFgKHFJ4qpwFyV7RB502
         1g3g==
X-Gm-Message-State: AOJu0YzvVlhriHScJXfI/DKKl1sWH3GRLNiqlxMWNxV9QRc6wywBBRXf
	2FZPXP/8umtyL4U1+jerv0NXSQai2p0tOoJabfcpXWIZW3yD/JP7ARGbgLIaLFxhmT3zLt4Ucrk
	H+WYPL4euTpKw
X-Received: by 2002:a50:f697:0:b0:553:a040:65f9 with SMTP id d23-20020a50f697000000b00553a04065f9mr252233edn.84.1702987314449;
        Tue, 19 Dec 2023 04:01:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7jx3Vq9AAkz7K/qUEg1XLu723bAMS0wk/ho0kixXaWLXah8pb3TdELfRTlbERHVptxuFVYQ==
X-Received: by 2002:a50:f697:0:b0:553:a040:65f9 with SMTP id d23-20020a50f697000000b00553a04065f9mr252227edn.84.1702987314186;
        Tue, 19 Dec 2023 04:01:54 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-177-45.web.vodafone.de. [109.43.177.45])
        by smtp.gmail.com with ESMTPSA id cn24-20020a0564020cb800b005532f5abaedsm2663635edb.72.2023.12.19.04.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 04:01:53 -0800 (PST)
Message-ID: <37e8d8e3-4bd8-4bf0-9652-ac3e5636fb8e@redhat.com>
Date: Tue, 19 Dec 2023 13:01:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v5 16/29] powerpc: Set .got section
 alignment to 256 bytes
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-17-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231216134257.1743345-17-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/12/2023 14.42, Nicholas Piggin wrote:
> Modern powerpc64 toolchains require the .got section have alignment of
> 256 bytes. Incorrect alignment ends up causing the .data section ELF
> load address to move by 8 bytes from its file offset, relative to
> previous sections. This is not a problem for the QEMU bios loader used
> by the pseries machine, but it is a problem for the powernv machine
> using skiboot as the bios and the test programs as a kernel, because the
> skiboot ELF loader is crippled:
> 
>    * Note that we execute the kernel in-place, we don't actually
>    * obey the load informations in the headers. This is expected
>    * to work for the Linux Kernel because it's a fairly dumb ELF
>    * but it will not work for any ELF binary.
> 
> This causes all references to data to be incorrect. Aligning the .got
> to 256 bytes prevents this offset skew and allows the skiboot "flat"
> loader to work. [I don't know why the .got alignment can cause this
> difference in linking.]
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/flat.lds | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/powerpc/flat.lds b/powerpc/flat.lds
> index 5eed368d..e07b91c1 100644
> --- a/powerpc/flat.lds
> +++ b/powerpc/flat.lds
> @@ -41,8 +41,7 @@ SECTIONS
>       /*
>        * tocptr is tocbase + 32K, allowing toc offsets to be +-32K
>        */
> -    tocptr = . + 32K;
> -    .got : { *(.toc) *(.got) }
> +    .got : ALIGN(256) { tocptr = . + 32K; *(.toc .got) }
>       . = ALIGN(64K);
>       edata = .;
>       . += 64K;

Acked-by: Thomas Huth <thuth@redhat.com>


