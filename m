Return-Path: <kvm+bounces-437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76DDF7DF9A7
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF76EB211D8
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35B12111F;
	Thu,  2 Nov 2023 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZgZxy9vW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5B2110F
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:12:17 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75364137;
	Thu,  2 Nov 2023 11:12:03 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-5094727fa67so1534456e87.3;
        Thu, 02 Nov 2023 11:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698948721; x=1699553521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MkVsZ5+Rd0U9H1mnDghTkJBk7iRE/g3vZmW4wgakiwE=;
        b=ZgZxy9vWkY9Vb/haHTBw+thzeldB0DOOq8WZwLoyxyDSnWigY4DXfO22tHdAD4lPjG
         QbbElgQMtBQYygpfC9oGSe6WR2gEW5IpzhoFYqf1U1MGomsM3pqEPpCJtApZX3vbeENm
         3UOJY++cOtX2iO1X9i3P5LUu1OD433+wFxS1Kx5//jRZ1MIyU7Do9tN7V6+4xxFgC1kp
         /iT9toR+Tpw2r2BIBfnfworscBtLx4JCrJYhl6576ouDTiWIXZ9O1AJFPH5SYTvNRqf4
         blueXGiKpHRJSiJ2IyFWfs4NyJdAVkDTB15fqHgBzToWH17Mu834FL2GpPJsg0s8mqdG
         AwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948721; x=1699553521;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MkVsZ5+Rd0U9H1mnDghTkJBk7iRE/g3vZmW4wgakiwE=;
        b=lJl0105ftQ8VD2GDmBRQCY55xjZsi04r2uGDZqPtPI8RPx8DsXvw7pcQaEnJzCQESG
         863lww8rM7sAR2DYukoTeUmuMEmU3yQYGbfXrdc4J7C9tg2msVnvl18eNsI4dlsb25S6
         nIvqzODZ2yIDTU/bpJBY13zlCPmCkn47LjN+A5e3CnFYvIHq6J+ZW3e8kLc7IANsh+Oo
         vIYTkD8r5UYoFANjTUPMplryJiiRVRqx4HOsw7RHDLBSFGMecrHDHtagnIaMZxS2fz1O
         j/IK6NcS+U+oZH65JqYbZ+YrOHw6VLtpnAVdYhUyV5IASiwC/Lr2K6lNG22CaqnFAShn
         sLvw==
X-Gm-Message-State: AOJu0YxP8Fuoe0KKqL7xqg6PstG93Mrz5qxA/v6CQw7uc+fdHAJRGa/O
	0Sm2Zk9DZxv0c2Kxmesbc9o=
X-Google-Smtp-Source: AGHT+IFMQmrb61KKMuBNQ61PGeZ+vLWKTwe8PeYDcrW/1/Y4SPtHRz95qVPEWtQvAUdT3uSCFyrqVw==
X-Received: by 2002:a05:6512:3e09:b0:503:19d8:8dc3 with SMTP id i9-20020a0565123e0900b0050319d88dc3mr17803218lfv.31.1698948721221;
        Thu, 02 Nov 2023 11:12:01 -0700 (PDT)
Received: from [192.168.14.38] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b0032fa66bda58sm2962527wrq.101.2023.11.02.11.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 11:12:00 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <b47e82a4-2c01-4207-b4f8-296243061202@xen.org>
Date: Thu, 2 Nov 2023 18:11:59 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v7 04/11] KVM: pfncache: base offset check on khva rather
 than gpa
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20231002095740.1472907-1-paul@xen.org>
 <20231002095740.1472907-5-paul@xen.org> <ZUGQhfH3HE-y6_5C@google.com>
Organization: Xen Project
In-Reply-To: <ZUGQhfH3HE-y6_5C@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2023 23:40, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> After a subsequent patch, the gpa may not always be set whereas khva will
>> (as long as the cache valid flag is also set).
> 
> This holds true only because there are no users of KVM_GUEST_USES_PFN, and
> because hva_to_pfn_retry() rather oddly adds the offset to a NULL khva.
> 
> I think it's time to admit using this to map PFNs into the guest is a bad idea
> and rip out KVM_GUEST_USES_PFN before fully relying on khva.
> 
> https://lore.kernel.org/all/ZQiR8IpqOZrOpzHC@google.com

Is this something you want me to fix?

   Paul


