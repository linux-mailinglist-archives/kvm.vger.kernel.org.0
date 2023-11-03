Return-Path: <kvm+bounces-521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 391617E082F
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:33:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45B541C210E2
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECB7224FA;
	Fri,  3 Nov 2023 18:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixRlXcvC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D2224D7
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 18:32:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AA5D65
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 11:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699036374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PWE+Q/XUVL/eOoB2mSb/ZIqyS5bE8Px7pWAkOH6htro=;
	b=ixRlXcvCokbPOU0Zv6LXYZmPECBeNCG4F95cbLIeqOHmGEGq6Iqmnnn+ZND5pPZZuIa8+q
	xYT/lAevcfC05/xqGWnQpDf3d6M7OUfoV7GI5XU+4Sw/dwMT+ohKsRCo8XfuvJFQHs2OLq
	6kMVG4/zVqscgK0HqbLkLfG41EguiSY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-thVt5hNmMA-UP3lgGA2JoA-1; Fri, 03 Nov 2023 14:32:53 -0400
X-MC-Unique: thVt5hNmMA-UP3lgGA2JoA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32cef5f8af5so2095997f8f.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 11:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699036372; x=1699641172;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWE+Q/XUVL/eOoB2mSb/ZIqyS5bE8Px7pWAkOH6htro=;
        b=kvs3xqVSlnM22HlQnhaK8+5SDB7A0wZdvcP3Y+qNA6VdRAekdr6ymTUGpnsuZLD3x+
         M+vTyMC/H4treQYSjOtYi/jR2t/o0OjP3GLZSsS0PgCDzWJ88+JoSN0HDfZtnQhr5bPV
         WzcW0626g8UUV4MIPtd+JydRXmx4JcwPoZq5Q3p3p2BuIE5s9CX+r4vDELz10e0zBzpx
         N42vmWIVWXeag1A6e+yXsFeiDZ/hT+J74ugvNJTjYRPAjU6tdJeCWOgyth+fKoPIsGhI
         Vrsmll0h5yWrAq5vn6zQXzPvxOJyvbnK6OFgMpY1z5fR+sNBe8nTmYlauMq7bV2fDIlG
         Defg==
X-Gm-Message-State: AOJu0YwmX13ew2sD1AxUTieaVZHskZaksTIMgxavRovwNVMPYLO6Neeo
	O4iYxyn4qt9+ETqQ3FJCz0n0sb1qRbeOBNZ9xAF8Uoa+CgtpUw/RdD8rXl2QsS5OLqfnhJ7UIgC
	NUO/V+OJ1by91
X-Received: by 2002:a5d:5955:0:b0:32d:d2aa:ed21 with SMTP id e21-20020a5d5955000000b0032dd2aaed21mr3346175wri.28.1699036371861;
        Fri, 03 Nov 2023 11:32:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPCgeIhZEdEDU2rHChDN15msoppbthdhk75IyNMiDwIT9q/r5p/yWd9PcwOZS8FmpuzWePvA==
X-Received: by 2002:a5d:5955:0:b0:32d:d2aa:ed21 with SMTP id e21-20020a5d5955000000b0032dd2aaed21mr3346150wri.28.1699036371410;
        Fri, 03 Nov 2023 11:32:51 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:a600:bc48:cd31:d01f:f468? (p200300cbc70aa600bc48cd31d01ff468.dip0.t-ipconnect.de. [2003:cb:c70a:a600:bc48:cd31:d01f:f468])
        by smtp.gmail.com with ESMTPSA id er14-20020a05600c84ce00b0040472ad9a3dsm3182989wmb.14.2023.11.03.11.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 11:32:50 -0700 (PDT)
Message-ID: <5aa4f2d5-94b5-4e7b-92e1-58ed1d013d00@redhat.com>
Date: Fri, 3 Nov 2023 19:32:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: s390: vsie: Fix STFLE interpretive execution
 identification
Content-Language: en-US
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 David Hildenbrand <dahi@linux.vnet.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Cc: kvm@vger.kernel.org, Michael Mueller <mimu@linux.vnet.ibm.com>,
 linux-s390@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-kernel@vger.kernel.org
References: <20231103173008.630217-1-nsg@linux.ibm.com>
 <20231103173008.630217-2-nsg@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231103173008.630217-2-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.11.23 18:30, Nina Schoetterl-Glausch wrote:
> STFLE can be interpretively executed.
> This occurs when the facility list designation is unequal to zero.
> Perform the check before applying the address mask instead of after.
> 
> Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

No access to documentation, but sounds plausible.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


