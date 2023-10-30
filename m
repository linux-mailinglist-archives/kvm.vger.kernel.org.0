Return-Path: <kvm+bounces-119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF5327DBF4C
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDF44B20F04
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ADFE199BE;
	Mon, 30 Oct 2023 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUG4HoVC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C896199B0
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:45:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEBCBD
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 10:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698687926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mQPi1K/pL8w3CfeDrddOR9pTKOlhaTMiYNASeZ3ge/8=;
	b=IUG4HoVCD1EyHiHbiUlvU4shpjd5BVZBZl5QmOAWDV8ErH33tUivOoFo3UC+znE0RVsZ+m
	8+t52YzURc84OuD0qfKmQhPntuFKJwaM01434d523kJmeSeG17EkhJbITwCh3SZhZflm+L
	dvvPyuhWEMfMJonhmuVsQYM49M8KDxU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-2qPsZhqiNPGgGBddiKmFIw-1; Mon, 30 Oct 2023 13:45:14 -0400
X-MC-Unique: 2qPsZhqiNPGgGBddiKmFIw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32da39f7f2bso2401098f8f.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 10:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698687913; x=1699292713;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQPi1K/pL8w3CfeDrddOR9pTKOlhaTMiYNASeZ3ge/8=;
        b=E+XyCCEcnHWIYoileV1n4+xGmCFHZPOQ31TPOAlC6WtOkft3kYlipNfyrAMB2o4Coz
         drz85rHnA/1THzL3kGYhxPPj5ndIKmzfvuirbmWKHdk8Vd5zYmL5e8+E8WC1KvaPDSyP
         343rDDZVqnLMOfUK6fPgdKFP3de09+STfXfBC8L1ZBHry46H7uKJtDxB0Dz8OG8g/Amj
         0lKNoRtbMEtVUCgpxY+sQ0KTEkBImcYS09EQb+SJmcXr4rKDvX1VHc+lhl04TIX7jO6r
         QcAOhAbKJMr+mdKRM0xQ2rI9DSVboFdJbjFOmZrbj8as5BXMtlSMAf68mAT1Zup9pEMu
         jO3w==
X-Gm-Message-State: AOJu0YxPn1FLPZVcEKzkOYUTEGAigu82qzksdFBkUfHIcVPKR1x1bJhu
	GZfnqSO94zUg06HIii+FxOR+d+aHpPRqH05ena1+oft9iHkV5Yd7YXHvlNse15R4N3SmrsqjIwx
	nkHfoEDtypMz8
X-Received: by 2002:a5d:6f14:0:b0:32d:a469:a1b with SMTP id ay20-20020a5d6f14000000b0032da4690a1bmr12515051wrb.62.1698687913497;
        Mon, 30 Oct 2023 10:45:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8f2WNIs+1QxF1U69CwtgHmTie6gva04qhM1kUELQF/lWKctRvWa++fA7pOixzdpIsYLrbew==
X-Received: by 2002:a5d:6f14:0:b0:32d:a469:a1b with SMTP id ay20-20020a5d6f14000000b0032da4690a1bmr12515030wrb.62.1698687913177;
        Mon, 30 Oct 2023 10:45:13 -0700 (PDT)
Received: from [192.168.1.174] ([151.81.68.207])
        by smtp.googlemail.com with ESMTPSA id bu3-20020a056000078300b0032dab20e773sm8908918wrb.69.2023.10.30.10.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 10:45:12 -0700 (PDT)
Message-ID: <1885f804-3601-4b3b-b8a3-534d7e8db53c@redhat.com>
Date: Mon, 30 Oct 2023 18:45:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate
 __kvm_x86_vendor_init()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231030141728.1406118-1-nik.borisov@suse.com>
 <ZT_UtjWSKCwgBxb_@google.com>
 <146168ae-900d-4eee-9a47-a1ba2ea57aa6@redhat.com>
 <ZT_ppBmxdd6917cl@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZT_ppBmxdd6917cl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/23 18:36, Sean Christopherson wrote:
>>> If there are no objections, I'll massage the change log to
>>> the below when applying (for 6.8, in a few weeks).
>>
>> I think this is a "Speak Now or Forever Rest in Peace" situation.  I'm going
>> to wait a couple days more for reviews to come in, post a v14 myself, and
>> apply the series to kvm/next as soon as Linus merges the 6.7 changes.  The
>> series will be based on the 6.7 tags/for-linus, and when 6.7-rc1 comes up,
>> I'll do this to straighten the history:
>
> Heh, I'm pretty sure you meant to respond to the guest_memfd series.

Well, it was the "in a few weeks" that almost caused me a panic attack. 
:)  But yeah, I soon got to the conclusion that this required a wider 
diffusion and reposted there.

Paolo


