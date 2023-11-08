Return-Path: <kvm+bounces-1275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23AFE7E5F34
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DF931C20C38
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CFE6374D1;
	Wed,  8 Nov 2023 20:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xium73UG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B4A374C3
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:31:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90059258D
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699475493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MtB8ohQOEzMANjmqu0FCOmdxHso7iJv2r+v/FvfKTAE=;
	b=Xium73UG9+BDG3ey0mQHjAix3L2B1DtqNrhzBb6uvyIzAwev79jdnUypASZm/XDB0KwA53
	Tp2/guOfqyT/sVue/yrCkD6MxKDhRwhm8FT3FGXj1QkHJBxHBjp0veQdBnGU+UqHK7l2Ri
	5dQrsdkLzLjpW3PlSXAt3tFXB6wAcJQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-4rv_MWC6PGmVVOf19BElsA-1; Wed, 08 Nov 2023 15:31:32 -0500
X-MC-Unique: 4rv_MWC6PGmVVOf19BElsA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9e293cd8269so11729766b.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:31:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699475491; x=1700080291;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MtB8ohQOEzMANjmqu0FCOmdxHso7iJv2r+v/FvfKTAE=;
        b=M/qdrGbotn9MJqdEycMJOl5EkuZae9qcbuys2hXFmOMFk0zfSrk7dPX9loQ413aev9
         VUDKCqnfPXYRAUhEOgGsO0Df4+shDox+qSmYt2v1KtrKyJrK1cFlJ5wwnVKlt0LfRC5D
         IXD3JxOhdLpF+9j/VWJce1vPJyhAOL3Nq2rxi5HlE50DlGbeWaC5HcuoWrlogFWm9hWQ
         RembsikCXraRUPcFrlMKwTRwzA+Gfy2m0V2dZVJl8reqv6EN/PD8sA/86dp1FeimyCA4
         CCq9piKq2Kz5Y9BAUrVgxaUVnHhHF8V8UNK6qNP/vOHL9B7hnKtOOZXpqVCGj56d+egM
         J5UQ==
X-Gm-Message-State: AOJu0YwxMFSnvQsN8ke242sYtKRB+GNq1F6fHn/KN3Tg1F4ukMERRrNi
	uXM4YdXuixsghsUQJKBJSnlpSofkx5mKOtHFxXPS/y6tIf7fqVjrP/TeVPCmBSpKY6UO5N3X1si
	MA97imDEfW9JM
X-Received: by 2002:a17:907:a4c1:b0:9e3:fbab:e091 with SMTP id vq1-20020a170907a4c100b009e3fbabe091mr1929659ejc.15.1699475491330;
        Wed, 08 Nov 2023 12:31:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHaQFHEMVK2eGELzcR5AsUy+0ZQmgx/f+sWXEc4bB+3m1OFJDynAK5+sSf1PVTvF09KXeogow==
X-Received: by 2002:a17:907:a4c1:b0:9e3:fbab:e091 with SMTP id vq1-20020a170907a4c100b009e3fbabe091mr1929645ejc.15.1699475491070;
        Wed, 08 Nov 2023 12:31:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id a27-20020a1709063a5b00b009c6a4a5ac80sm1519304ejf.169.2023.11.08.12.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Nov 2023 12:31:30 -0800 (PST)
Message-ID: <d47135d7-ee5b-4c57-ac49-e9d94e8fcae2@redhat.com>
Date: Wed, 8 Nov 2023 21:31:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm:guestmemfd 59/59]
 arch/s390/kvm/../../../virt/kvm/kvm_main.c:5517:14: error: 'KVM_TRACE_ENABLE'
 undeclared; did you mean 'KVM_PV_ENABLE'?
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
 Robert Hu <robert.hu@intel.com>, Farrah Chen <farrah.chen@intel.com>,
 Danmei Wei <danmei.wei@intel.com>
References: <202311090100.Zt0adRi9-lkp@intel.com>
 <ZUvtbInra7-Nypgq@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZUvtbInra7-Nypgq@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/23 21:19, Sean Christopherson wrote:
> On Thu, Nov 09, 2023, kernel test robot wrote:
>> tree:https://git.kernel.org/pub/scm/virt/kvm/kvm.git  guestmemfd
>> head:   cd689ddd5c93ea177b28029d57c13e18b160875b
>> commit: cd689ddd5c93ea177b28029d57c13e18b160875b [59/59] KVM: remove deprecated UAPIs
> Paolo, I assume you force pushed to guestmemfd at some point at that this is no
> longer an issue?  I can't find the above object, and given the shortlog I'm guessing
> it was a WIP thing unrelated to guest_memfd.

Yes, I had pushed a bit too much.

Paolo


