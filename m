Return-Path: <kvm+bounces-2236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8134A7F3A00
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 00:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C3DA282B0C
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 23:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440E33BB45;
	Tue, 21 Nov 2023 23:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8Wkw69E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0CA185
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 15:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700607740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35Vx+tN6z+QqmLpji6c9JPBO8+KdiIzwgrs9kWGJbWw=;
	b=T8Wkw69EQYWGChwbXOKsU4Demxh2sUX4/9SuYYQWkfzoWR7hktjQUkkRbVcu+P6CBMu4lE
	JQSK4GP/UtXK/bohnWUTjHeNYRrEJWwzUBDmqkhnxswo1jKJZ83DhPR5nUqHSI6QjgtFot
	rwo9XA+WFDmgZ2TWY413bexLfpiUZA0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-0TGc95F5NPCFzt6T6T8OkQ-1; Tue, 21 Nov 2023 18:02:19 -0500
X-MC-Unique: 0TGc95F5NPCFzt6T6T8OkQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1cc49991f33so2552305ad.1
        for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 15:02:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700607738; x=1701212538;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=35Vx+tN6z+QqmLpji6c9JPBO8+KdiIzwgrs9kWGJbWw=;
        b=a1yIyAitUjBIaMctmhtIFjfUz3JGelQGVPRfhQHFQGlBqZS2ZW/ed6vbNBRug5RxpV
         py1BCUotpP/pjw7SK3+FxlqivBvKR+7WQRhJTLDElienBi3ea/eADfHzyeUwjCv3rjRd
         p8+EOdt9B4PjnvvC7alWT7NpRHiaA7xf5xoF8jPL39KT7cG9+rFTQtEmuHPRHQ1trey5
         uTkGR0IdHUPcrm7FIDVGehlN5srnAdcwIGOHM9Uob+DA5BqrG0bh72MLa58T8toUDkhh
         H2AzHFl23hRVqN6+b+rFNiuAbBLXJ701QCW2RKA16RGJxOMWV4BHj/2gnJ/k5AtChckq
         y8Vw==
X-Gm-Message-State: AOJu0YwJ09Wm13wSe3QutXI7ShZpjSkk4eMhcv7lefggDm8WoG8YBl5K
	vp81rDthiEa2PJB7wfdLFa2ZYCF2IbSFUcWJu+yx9SGC4tXvw7wIjhXQukEz9aseynlPiJqExIm
	bBR4hzR9ZuCbiOM6Sdjmc
X-Received: by 2002:a17:903:2341:b0:1cf:6832:46c with SMTP id c1-20020a170903234100b001cf6832046cmr903763plh.6.1700607738122;
        Tue, 21 Nov 2023 15:02:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQxNfDN/exMbNG8sxIbSIBwzNNSjvkEf3+l7v4sDzQROVAcylsUK1QJbli5gsAuBDSBNwd9g==
X-Received: by 2002:a17:903:2341:b0:1cf:6832:46c with SMTP id c1-20020a170903234100b001cf6832046cmr903742plh.6.1700607737739;
        Tue, 21 Nov 2023 15:02:17 -0800 (PST)
Received: from ?IPV6:2001:8003:e5b0:9f00:b890:3e54:96bb:2a15? ([2001:8003:e5b0:9f00:b890:3e54:96bb:2a15])
        by smtp.gmail.com with ESMTPSA id l14-20020a170902f68e00b001ca4ad86357sm8421321plg.227.2023.11.21.15.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Nov 2023 15:02:17 -0800 (PST)
Message-ID: <647efdf8-66aa-4ea3-8625-bf657839f6f0@redhat.com>
Date: Wed, 22 Nov 2023 09:02:13 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/kvm: fix compilation on non-x86_64 platforms
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: broonie@kernel.org
References: <20231121165915.1170987-1-pbonzini@redhat.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231121165915.1170987-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/22/23 02:59, Paolo Bonzini wrote:
> MEM_REGION_SLOT and MEM_REGION_GPA are not really needed in
> test_invalid_memory_region_flags; the VM never runs and there are no
> other slots, so it is okay to use slot 0 and place it at address
> zero.  This fixes compilation on architectures that do not
> define them.
> 
> Fixes: 5d74316466f4 ("KVM: selftests: Add a memory region subtest to validate invalid flags", 2023-11-14)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   tools/testing/selftests/kvm/set_memory_region_test.c | 12 ++++++------
>   1 files changed, 6 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


