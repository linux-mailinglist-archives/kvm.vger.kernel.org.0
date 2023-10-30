Return-Path: <kvm+bounces-103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5927DBE83
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8F901C20B23
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE33019457;
	Mon, 30 Oct 2023 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AY2V5wUR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C8312E47
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:11:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0646DED
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 10:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698685858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UqaiNp1/9iJwsfU8zxKKKtiVIpF7n5Gp17gJct1n8s4=;
	b=AY2V5wUR10dz1YBQvCJVbLqsBY9qVFzAnD9EK4U10kU4nUakc2pwlgxwQ0a4roTj+G0YPc
	vD5D1U2bkke/7GVVArcOwG3u3l9kpFBw6ae5miCDIDhHvLPjupxgflCQGF73wBIhH4FVZ9
	y85YC+a/r+rUEKXO9w2GfcVnMzh6CCM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-v6TdR7eRP-eQSJHoisd9_A-1; Mon, 30 Oct 2023 13:10:57 -0400
X-MC-Unique: v6TdR7eRP-eQSJHoisd9_A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4092164ee4eso35152255e9.3
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 10:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698685855; x=1699290655;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqaiNp1/9iJwsfU8zxKKKtiVIpF7n5Gp17gJct1n8s4=;
        b=EAjQCRoEW3Xaq4ohzuQ3qW4JOjOgYuaR80c+mLKHdygmvtjCd+j3xhyy1A04VHUWEW
         jMtz5ydZK3hGpYO5BvkpJw80ERJLBpSASMCIzrSQ02sqvvpXgxLZLCLLsbZNviUKPzPF
         7u5cdSiVqJunVAwOfExOf+KQrKB/7+tmWWPessTzObXLtCq2sse4iA3EcLd07mP1noYz
         jY3ttS/htiIAJ0R8u2RfQfwheaFKkxHZw4omZo165y9jL20rTjohUaSFxuadJuRPay3Q
         O2gjnlOgOEhvFIAnFXdFlnNe6Pd16N2qFKTENnMAk/EmqfH15AdfLqoaYUlX8+lpL2C1
         SMow==
X-Gm-Message-State: AOJu0YycE1ef3cwUK93AaANauS1T3BQEiPHcSAVg+ohJddkOzUklcZ4X
	UphIOdAfzziRZ+jr1JUQdRuXz3UeE0vpzUr+5vaM4weEPLil5svYFYexNm13xh3mtBO+ZLA/HEh
	KSDTVEXseSPIbcnfl0BY2
X-Received: by 2002:a05:6000:402c:b0:323:2d01:f043 with SMTP id cp44-20020a056000402c00b003232d01f043mr11367092wrb.3.1698685855090;
        Mon, 30 Oct 2023 10:10:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFHHdSEJrpbn+ierFQ9wubtn0XGSSmrSoVBidNvDlirjU966A/JW0BuNScDCUAb7fpg5inVA==
X-Received: by 2002:a05:6000:402c:b0:323:2d01:f043 with SMTP id cp44-20020a056000402c00b003232d01f043mr11367072wrb.3.1698685854714;
        Mon, 30 Oct 2023 10:10:54 -0700 (PDT)
Received: from [192.168.1.174] ([151.81.68.207])
        by smtp.googlemail.com with ESMTPSA id w16-20020adfcd10000000b0032da75af3easm8617198wrm.80.2023.10.30.10.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 10:10:54 -0700 (PDT)
Message-ID: <146168ae-900d-4eee-9a47-a1ba2ea57aa6@redhat.com>
Date: Mon, 30 Oct 2023 18:10:51 +0100
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
To: Sean Christopherson <seanjc@google.com>,
 Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231030141728.1406118-1-nik.borisov@suse.com>
 <ZT_UtjWSKCwgBxb_@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZT_UtjWSKCwgBxb_@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/23 17:07, Sean Christopherson wrote:
> On Mon, Oct 30, 2023, Nikolay Borisov wrote:
>> Current separation between (__){0,1}kvm_x86_vendor_init() is superfluos as
> 
> superfluous
> 
> But this intro is actively misleading.  The double-underscore variant most definitely
> isn't superfluous, e.g. it eliminates the need for gotos reduces the probability
> of incorrect error codes, bugs in the error handling, etc.  It _becomes_ superflous
> after switching to guard(mutex).
> 
> IMO, this is one of the instances where the "problem, then solution" appoach is
> counter-productive.  If there are no objections, I'll massage the change log to
> the below when applying (for 6.8, in a few weeks).

I think this is a "Speak Now or Forever Rest in Peace" situation.  I'm 
going to wait a couple days more for reviews to come in, post a v14 
myself, and apply the series to kvm/next as soon as Linus merges the 6.7 
changes.  The series will be based on the 6.7 tags/for-linus, and when 
6.7-rc1 comes up, I'll do this to straighten the history:

	git checkout kvm/next
	git tag -s -f kvm-gmem HEAD
	git reset --hard v6.7-rc1
	git merge tags/kvm-gmem
	# fix conflict with Christian Brauner's VFS series
	git commit
	git push kvm

6.8 is not going to be out for four months, and I'm pretty sure that 
anything discovered within "a few weeks" can be applied on top, and the 
heaviness of a 35-patch series will outweigh any imperfections by a long 
margin).

(Full disclosure: this is _also_ because I want to apply this series to 
the RHEL kernel, and Red Hat has a high level of disdain for 
non-upstream patches.  But it's mostly because I want all dependencies 
to be able to move on and be developed on top of stock kvm/next).

Paolo


