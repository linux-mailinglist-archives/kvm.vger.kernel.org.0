Return-Path: <kvm+bounces-40333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B91A56642
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 12:07:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E16C6169AA0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 11:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90302153ED;
	Fri,  7 Mar 2025 11:07:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA62153D3
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 11:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741345655; cv=none; b=e5I+Dz4Faajtg9/76/vHuGTgg0R4RvQ5XC9C3HzqbuS1wtNI5hPzeKdowr2h8cEaU8V1PmsuYr1CM4AuWs61pdERw6+5cvB04PlEXszWcKT8zi0p59SF+fiX83Ywu4bmGzPAfqWRDiufjyiKT0o4M0fSww3Zj362VS3O4GHZ0vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741345655; c=relaxed/simple;
	bh=vOeB1lSXh2Q03TVsBIiJrkOe98Ok826Yhds7mOYT7Pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lKNfjBlq1aa/1tZ7gmO7QKX9CKnpwdWcI0ir5y6ZxWRj8w76s/7hr8OZeZGYyyNmNQIw9g/Jonk5kMH9CRh3bOhpU3WCgJ3NdKQwEL98biSWzbpEystPAFMRcSmEdFJnu11XLwZFNW6LmxHtNZhO/zxFm9eou8QsqvzBlo72UEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1tqVYB-00000000RNf-2S43;
	Fri, 07 Mar 2025 12:07:31 +0100
Message-ID: <95a6f718-8fab-434c-9b02-6812f7afbcc3@maciej.szmigiero.name>
Date: Fri, 7 Mar 2025 12:07:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 manos.pitsidianakis@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
 <353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
 <35c2c7a5-5b12-4c21-a40a-375caae60d0c@linaro.org>
 <d62743f5-ca79-47c0-a72b-c36308574bdd@linaro.org>
 <6556fdd8-83ea-4cc6-9a3b-3822fdc8cb5d@linaro.org>
Content-Language: en-US, pl-PL
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <6556fdd8-83ea-4cc6-9a3b-3822fdc8cb5d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

On 6.03.2025 23:56, Pierrick Bouvier wrote:
> On 3/6/25 09:58, Philippe Mathieu-Daudé wrote:
>> On 6/3/25 17:23, Pierrick Bouvier wrote:
>>> On 3/6/25 08:19, Richard Henderson wrote:
>>>> On 3/5/25 22:41, Pierrick Bouvier wrote:
>>>>> Replace TARGET_PAGE.* by runtime calls
>>>>>
>>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>>> ---
>>>>>     hw/hyperv/syndbg.c    | 7 ++++---
>>>>>     hw/hyperv/meson.build | 2 +-
>>>>>     2 files changed, 5 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
>>>>> index d3e39170772..f9382202ed3 100644
>>>>> --- a/hw/hyperv/syndbg.c
>>>>> +++ b/hw/hyperv/syndbg.c
>>>>> @@ -14,7 +14,7 @@
>>>>>     #include "migration/vmstate.h"
>>>>>     #include "hw/qdev-properties.h"
>>>>>     #include "hw/loader.h"
>>>>> -#include "cpu.h"
>>>>> +#include "exec/target_page.h"
>>>>>     #include "hw/hyperv/hyperv.h"
>>>>>     #include "hw/hyperv/vmbus-bridge.h"
>>>>>     #include "hw/hyperv/hyperv-proto.h"
>>>>> @@ -188,7 +188,8 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg,
>>>>> uint64_t outgpa,
>>>>>                                     uint64_t timeout, uint32_t
>>>>> *retrieved_count)
>>>>>     {
>>>>>         uint16_t ret;
>>>>> -    uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEADER_SIZE];
>>>>> +    const size_t buf_size = qemu_target_page_size() -
>>>>> UDP_PKT_HEADER_SIZE;
>>>>> +    uint8_t *data_buf = g_alloca(buf_size);
>>>>>         hwaddr out_len;
>>>>>         void *out_data;
>>>>>         ssize_t recv_byte_count;
>>>>
>>>> We've purged the code base of VLAs, and those are preferable to alloca.
>>>> Just use g_malloc and g_autofree.
>>>>
>>>
>>> I hesitated, due to potential performance considerations for people
>>> reviewing the patch. I'll switch to heap based storage.
>>
>> OTOH hyperv is x86-only, so we could do:
>>
>> #define BUFSZ (4 * KiB)
>>
>> handle_recv_msg()
>> {
>>     uint8_t data_buf[BUFSZ - UDP_PKT_HEADER_SIZE];
>>     ...
>>
>> hv_syndbg_class_init()
>> {
>>     assert(BUFSZ > qemu_target_page_size());
>>     ...
>>
>> and call it a day.
> 
> Could be possible for now yes.
> 
> Any opinion from concerned maintainers?

I think essentially hardcoding 4k pages in hyperv is okay
(with an appropriate checking/enforcement asserts() of course),
since even if this gets ported to ARM64 at some point
it is going to need *a lot* of changes anyway.

Thanks,
Maciej


