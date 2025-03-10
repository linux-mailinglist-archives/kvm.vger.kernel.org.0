Return-Path: <kvm+bounces-40643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3C1A59483
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDDFE16514A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC927229B33;
	Mon, 10 Mar 2025 12:29:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201C224258
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 12:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609752; cv=none; b=JqP/LeCeK6QdS56Uhp+ZnCFxaHNMdB6AUBybiE/CwsEjxez296ybvjO19REqGx6TA2+dHbt9KTf4m9FRUBJWIMfWjxRwfLhSAoD6n54QPqysQHGdvaQHL5BaEYRG4rOF7fptiAIQuZRo3UEQcLvVGMVuOTctIByUQdJGeWaJr+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609752; c=relaxed/simple;
	bh=R9ulSbyd37eIR9xBG6V2xkBcJVP+fjD4f+2bh2bCB8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kLGjcQFnptnqT1CLTyYW4tm6DsVQ8BnwOD9upWEZbwcJf8mEzLAHpoC0rupu42DFGQwOCXHdCCfs7Gxx9U4xDs9Exnu10/WaeFUL8b4DXslZ+oGrXSr8auQPWenXtS1VPE6pJWDBl09BhG5CCR9FKzj4+GQVEuG8ScQUgVXQq5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1trcFg-00000000ZO7-2Pv8;
	Mon, 10 Mar 2025 13:29:00 +0100
Message-ID: <6f05eeb5-252b-4dd1-ac7f-5122ea8c4232@maciej.szmigiero.name>
Date: Mon, 10 Mar 2025 13:28:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, qemu-devel@nongnu.org,
 Marcelo Tosatti <mtosatti@redhat.com>, richard.henderson@linaro.org,
 manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <8c511d16-05d6-4852-86fc-a3be993557c7@linaro.org>
 <8d2a19a8-e0a4-4050-8ba5-9baa9b47782f@maciej.szmigiero.name>
 <91ddf98c-3a5d-404b-9e80-ed4580c1c373@linaro.org>
Content-Language: en-US, pl-PL
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <91ddf98c-3a5d-404b-9e80-ed4580c1c373@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

On 10.03.2025 00:33, Pierrick Bouvier wrote:
> Hi Maciej,
> 
> On 3/7/25 14:31, Maciej S. Szmigiero wrote:
>> Hi Philippe,
>>
>> On 7.03.2025 23:25, Philippe Mathieu-Daudé wrote:
>>> Hi Maciej,
>>>
>>> On 7/3/25 22:56, Pierrick Bouvier wrote:
>>>> Work towards having a single binary, by removing duplicated object files.
>>>
>>>> Pierrick Bouvier (7):
>>>>     hw/hyperv/hv-balloon-stub: common compilation unit
>>>>     hw/hyperv/hyperv.h: header cleanup
>>>>     hw/hyperv/vmbus: common compilation unit
>>>>     hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
>>>>     hw/hyperv/syndbg: common compilation unit
>>>>     hw/hyperv/balloon: common balloon compilation units
>>>>     hw/hyperv/hyperv_testdev: common compilation unit
>>>
>>> If you are happy with this series and provide your Ack-by tag,
>>> I can take it in my next hw-misc pull request if that helps.
>>
>> There's nothing obviously wrong in the patch set,
>> but if we can defer this to Monday then I could do
>> a runtime check with a Windows VM too.
>>
> 
> this series needs some fixup after the merge of 58d0053: include/exec: Move TARGET_PAGE_{SIZE,MASK,BITS} to target_page.h.
> 
> I'll re-spin it later, so don't waste your time trying it.

Waiting for updated series then.
  
> Thanks,
> Pierrick
> 

Thanks,
Maciej



