Return-Path: <kvm+bounces-245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6BCF7DD7AF
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 22:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAF2F1C20C9B
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 21:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171B0249E6;
	Tue, 31 Oct 2023 21:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKETZ8SA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697541DFE5
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 21:19:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBF7137
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698787111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2Rrjdi9DTty7aAk4woYQrRI31UDKjKoJPhnl+IoVTnI=;
	b=UKETZ8SAxfFgXGY1X+B4p+dBjowPx8p860pUP41f1L+/XcbKpQWCJCjxlVji/8cYBzzrpu
	Tb0CHDlJJf9e6JjFXkBQro0yBqBlI8dUsrS/8t3Jb7NGYEPvBkwzS98UwxyB6NicBgrLEP
	Pmm4ThhBf8mPwQrH25/HNzezL4VVgfk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-BFACyn_ANBuk4zPWICHcew-1; Tue, 31 Oct 2023 17:18:20 -0400
X-MC-Unique: BFACyn_ANBuk4zPWICHcew-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9c15543088aso25295466b.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698787099; x=1699391899;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Rrjdi9DTty7aAk4woYQrRI31UDKjKoJPhnl+IoVTnI=;
        b=C/EBC01QcudFErbZAfo0rMnUnfVXgTwWrexI4LgiIWzHpzW9V0kNnCmw9fHGB9JkxF
         2DdkZIvuZyVXzAv+iZoqpeH37WTcZlhnmbdOBkq3aYgqh0aks6EkyVvK6MixVYTYoj17
         49ljKp3AJ3L2JF+y3e1j7Px2v9UU1e+DtbrCRXOZg1p6lip4HEIZVzcNgUE60MFY9ZqU
         Hq74plWkDA+OtURPp0MA2ckRnkDZBQ3RPp8Fu5S046z56WfIwLO7m51ABHhl+oj9C/U0
         RM57igTCJz586xifADmIsYk3dsJ/ocZcgh4o5hD+EPh41MWAsIIcof46A+hxJFGVbAWK
         +WIA==
X-Gm-Message-State: AOJu0YzCwUrQVBLg6+eBGxhScqLtL4K/EYYVAmEL+I7jzXewzAfVgWaK
	ZFK1tn8/bJkyWdaj0eCEmf8fvfAZ9fJbC+hHA3PgJ1JrbvNWqeIc33xDSltpl89muif+Ou9O+8C
	myZSrJLi4+x1W
X-Received: by 2002:a17:907:868d:b0:9b2:b15b:383d with SMTP id qa13-20020a170907868d00b009b2b15b383dmr513047ejc.11.1698787098963;
        Tue, 31 Oct 2023 14:18:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsIBOS6Ncn77FdPc/mtn7hXXc00pVJn3s0QpuyI9x/XC9nBdICVrabRywoSQShJQZnZZQnHA==
X-Received: by 2002:a17:907:868d:b0:9b2:b15b:383d with SMTP id qa13-20020a170907868d00b009b2b15b383dmr513029ejc.11.1698787098616;
        Tue, 31 Oct 2023 14:18:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s25-20020a170906bc5900b009b9977867fbsm1525241ejv.109.2023.10.31.14.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 14:18:18 -0700 (PDT)
Message-ID: <03ff2765-2785-4590-8b92-19fdcf67d71e@redhat.com>
Date: Tue, 31 Oct 2023 22:18:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.7
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Jing Zhang <jingzhangos@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Miguel Luis <miguel.luis@oracle.com>
References: <ZUFL9AUV36xHGaBE@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZUFL9AUV36xHGaBE@thinky-boi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/23 19:48, Oliver Upton wrote:
> Hi Paolo, Here's the pile of KVM/arm64 changes for 6.7. Almost all of 
> these changes have been baking in -next for a while, although I did need 
> to rebase to back out a broken change last minute. I'm only aware of a 
> single (trivial) conflict with the arm64 tree resulting from a moved 
> cpucap check, resolution below. Please pull.

Pulled, thanks.

Paolo


