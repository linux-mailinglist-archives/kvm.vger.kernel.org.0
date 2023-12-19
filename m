Return-Path: <kvm+bounces-4800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF2D818675
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 12:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8C41F23BC7
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 11:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FDE15AE6;
	Tue, 19 Dec 2023 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAsRPszc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4832F156E7
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702985662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WAp3//I333KruVNGSong7V6HbVZ8bL6EuOovu7xqHWE=;
	b=SAsRPszcKn0RxdtWZ8qEN3TR/TobfkfAvLE47ahb2Cdmxk6qxgJ/4MZOT1xNqAqyMxtc6l
	fGF3/p7jqAS8CdXEYRMfkRexNaS3dQlx6zdU/pVznxhKIjpsjcODl4Y0H85CdmCKoxFcV+
	lfanO8xByi0OScewoD9dNKCcKK9QifY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-NlNuXZNnOpeSG0wftjEQpw-1; Tue, 19 Dec 2023 06:34:20 -0500
X-MC-Unique: NlNuXZNnOpeSG0wftjEQpw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3365bc111a5so2909375f8f.1
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 03:34:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702985659; x=1703590459;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WAp3//I333KruVNGSong7V6HbVZ8bL6EuOovu7xqHWE=;
        b=QFF/U7Bi9UqpvLYSJRrz8dj6McnW/qh19MYR2xfOEwYQkyBzI01e6nnH5juy/SlcFN
         5Vodapb2nliMEgTwIlnL17Lhc+yNzcoQsT1lfmA0tbYyvHy5HgjNF/QRfpQeWtU4EjSk
         FhHqMTOtwgiEOEkP8JjuxThhjJ1Sxphkk2IuIHqU/PP+FQmqLlRTFHJN75MHkS3y9Yn2
         abAJqScZKsi9Yu9V8PxzLlST6Uax+tzCc5FCycvoE1Z7q+tGn5+0CR31m12tGLDcW3qf
         NDWmBVvnvSILxQ3PRYko01qZkGDv/19QM4YYDXd2lcEX41YdxVV7wuLOSedMXI7cOe55
         hdGg==
X-Gm-Message-State: AOJu0Yzp4fYlBY1pBOrzNFmWUkdiLYntlEv4oIOseyxLt0ssIWFUB8qP
	wZq/89fE0L2G35JZRX83Z1NdiAlpPDgnr2LD7JJFlzRq9BRa7zQ3KuGMuhJsJXjE6WC8fBxn62I
	FhygT4mDCzBsrxG9Cmxv9
X-Received: by 2002:a5d:4e05:0:b0:336:6287:1236 with SMTP id p5-20020a5d4e05000000b0033662871236mr1897695wrt.72.1702985659731;
        Tue, 19 Dec 2023 03:34:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGcxni5+kdh5Rn4ZqsC2WlYIEPkIvSIyoTFDJQg355BpOkdx7EWsChSPU6glkYzgCMjztolw==
X-Received: by 2002:a5d:4e05:0:b0:336:6287:1236 with SMTP id p5-20020a5d4e05000000b0033662871236mr1897686wrt.72.1702985659451;
        Tue, 19 Dec 2023 03:34:19 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-177-45.web.vodafone.de. [109.43.177.45])
        by smtp.gmail.com with ESMTPSA id h4-20020a05600004c400b0033621fe3a29sm22710668wri.26.2023.12.19.03.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 03:34:19 -0800 (PST)
Message-ID: <543560d4-522d-4c25-9d18-58a90240e570@redhat.com>
Date: Tue, 19 Dec 2023 12:34:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v5 11/29] powerpc/sprs: Don't fail changed
 SPRs that are used by the test harness
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-12-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231216134257.1743345-12-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/12/2023 14.42, Nicholas Piggin wrote:
> SPRs annotated with SPR_HARNESS can change between consecutive reads
> because the test harness code has changed them. Avoid failing the
> test in this case.
> 
> [XER was observed to change after the next changeset to use mdelay.]
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/sprs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index cd8b472d..01041912 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -557,7 +557,7 @@ int main(int argc, char **argv)
>   			if (before[i] >> 32)
>   				pass = false;
>   		}
> -		if (!(sprs[i].type & SPR_ASYNC) && (before[i] != after[i]))
> +		if (!(sprs[i].type & (SPR_HARNESS|SPR_ASYNC)) && (before[i] != after[i]))
>   			pass = false;

I guess you could even squash this into the previous patch.

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>


