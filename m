Return-Path: <kvm+bounces-42268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B82DA76FBC
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:56:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14D373A539C
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 20:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D593F21C189;
	Mon, 31 Mar 2025 20:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LD97Y7SS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787181E0E0B;
	Mon, 31 Mar 2025 20:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743454569; cv=none; b=kc82f19BNBc8F3gCKhkO/VyKYMWxi6XWk7bcGR0cGL9oSC0blnzqH6ZzTBvXra69863+UdicBd/ltTdF5hXaBRDiqbYINLMmA+zsFaF6Zpq9gibKnFPjXayQUVz+tQSdfO8p1Cu/gfc47j3xVnvDdCK1pzKZTrAVPIh+gnaPEok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743454569; c=relaxed/simple;
	bh=BKcRdLKRYeLS92+jgK2NznbnU5/0fhFnhqd09FApGAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QU3e3pQj7na7VB6qTTGvBn+x6oliEUcUwE5LP5X08zCjR2bvvvAEyx0hJMuxb0VMXokiRBRKM59Zui33NxVxMZYuHHSpD3nS3bVn3qpX+4hOkripHaW10zQ3Y0siMa1qLsTiyKU68GR7mokEGAsp/yCwgyLTxwsgo/EoTCSlMnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LD97Y7SS; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [172.27.3.244] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52VKtBNP3418600
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 31 Mar 2025 13:55:12 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52VKtBNP3418600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743454520;
	bh=VWL5qq9zWu3cNVnIm7LG7BNkZkCMGz8p/x6Wg1aq0Vk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LD97Y7SSrMxEUulSMZu+ff9YU54RyfVQzj+cvjC0nuyPVAEvUTBY9vRHA9kuqRBck
	 zCpoYM2uH/99eIUDQGh5oDFn03Tifu66IeQ3yxFSTx24lBmHWwTojxMeI1feo+cKyk
	 7eP21xGMkfSjHVWZupPDlETH4s1vyAwJDOC+QWi0AcWJErrmD9O7x5BZvgDMta9Uss
	 0c3ftb/ovwly81i9hfmlGacobBgXN1Th2kgo58DJsSRQjb9x/QGkISc7TVQc+0OMDc
	 i/TzJFXz/ephJVSay1Qes3/ceo2JQmIVHTc6M8xH77vra6FcPLxFWWqYEiisToZPWj
	 Zy5DmP5WmybQw==
Message-ID: <1add8de0-8c62-444e-a7d6-5681432d48a9@zytor.com>
Date: Mon, 31 Mar 2025 13:55:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/15] KVM: VMX: Use WRMSRNS or its immediate form
 when available
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-11-xin@zytor.com>
 <Z-r6qxmk7niRssee@char.us.oracle.com>
 <fde11fbb-4b3f-44f1-90cf-6aaefb6bb7c1@citrix.com>
Content-Language: en-US
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <fde11fbb-4b3f-44f1-90cf-6aaefb6bb7c1@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/25 13:41, Andrew Cooper wrote:
>>
>> That is replace the MSR write to disable speculative execution with a
>> non-serialized WRMSR? Doesn't that mean the WRMSRNS is speculative?
> 
> MSR_SPEC_CTRL is explicitly non-serialising, even with a plain WRMSR.
> 
> non-serialising != non-speculative.
> 
> Although WRMSRNS's precise statement on the matter of
> non-speculativeness is woolly, given an intent to optimise it some more
> in the future.
> 

To be specific, "serializing" is a much harder statement than 
"non-speculative."

For architecturally non-serializing MSRs, WRMSRNS and WRMSR are 
equivalent (or to put it differently, WRMSR acts like WRMSRNS.)

The advantage with making them explicitly WRMSRNS is that it allows for 
the substitution of the upcoming immediate forms.

	-hpa


