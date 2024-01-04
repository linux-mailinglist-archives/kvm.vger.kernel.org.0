Return-Path: <kvm+bounces-5646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 185878242A0
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 14:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60762878D0
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 13:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB44722335;
	Thu,  4 Jan 2024 13:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="3MXUW490"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6917922323
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 13:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5ced19f15c3so47095a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 05:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1704374568; x=1704979368; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+UaUoSEUxULvKOz2jhQuoYpr4rLktnoBGVluoHHYMOU=;
        b=3MXUW490lpm1gxsecqvb4zClWYxX4L+gqikjJzj3nodfrtRPMXJkxi9tFeVdMvmnZn
         WU0jA4DYdbmC3nv9ht+q16QMt3cTFn1Qz/Wb5+8dBS6R0Q6/gVeZhynlAhtQD5vtYY1e
         YTvSOHFr2s7GaKsKifOC8FwoyzNZVJKZkvkZwrU7hCBOjZK4spszovZv/aaCkJbXwlxM
         zHkkbBrIg7K3lswR/hcdn2ZxQm0Twqv7Njt3qEHQBWUTdZkEcbBmeUt/62e4yEuhvxpg
         SAgrMgzXjx8ZgqsJGMGr+uafgX/rV27ZhqDvBUUV4I4QAfVf71OjxBb2vFbQt97QSsW3
         GWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704374568; x=1704979368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+UaUoSEUxULvKOz2jhQuoYpr4rLktnoBGVluoHHYMOU=;
        b=wGOIia6TIbSwVCFPzR6/z0B33/fMWhUfyuA5Ffcxr8ilQTVjc1Okue40MtCNOQTke7
         F/+sQ47bWINXl70G3Ym58iq7mVz6fYsuzqcP6gBX9kdLZxekJFwqRb9IV1CaBKZYDJng
         6yymj5T+bkqKzpeqNBo3J6Fn5238dP+LdcsrcgcyZ8H4KyFtFJshX4Dl1UxCJ0IcwHbQ
         +GJQisJ3mg18ZvnnFWPnv0CNXhaahSGRkYkML+jrd80hEX+AO3K4u+ERuBz9P7KBWy9o
         7auFgmmaFRU8aFOm/9PbPE6xQS8ytCd/aIVN0gpwhG9S0XHxep1r9yvwbufYe9BNN3Ff
         b4eQ==
X-Gm-Message-State: AOJu0Ywvcvpu0UgQsUPUB0fMMTKuCIdcjXSX30OziQCK0THLA1dXHePi
	3VP2uNVhFpHe9NgmsHOyDQF3jFKK4vkryw==
X-Google-Smtp-Source: AGHT+IFokc8I4M12wpRZbGFseRS03dNmYQJFm1uTthsqLJ9zrTgE2OKJgGw72Fa3MExoY1OmaCb7cA==
X-Received: by 2002:a05:6a20:1445:b0:199:247a:1044 with SMTP id a5-20020a056a20144500b00199247a1044mr201672pzi.17.1704374568632;
        Thu, 04 Jan 2024 05:22:48 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:9ac7:6d57:2b16:6932? ([2400:4050:a840:1e00:9ac7:6d57:2b16:6932])
        by smtp.gmail.com with ESMTPSA id a25-20020a634d19000000b005c6617b52e6sm24378620pgb.5.2024.01.04.05.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jan 2024 05:22:48 -0800 (PST)
Message-ID: <4cf878c6-0adf-4c97-b404-446d8a3dabf1@daynix.com>
Date: Thu, 4 Jan 2024 22:22:39 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 38/43] plugins: add an API to read registers
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Song Gao <gaosong@loongson.cn>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 David Hildenbrand <david@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Bin Meng <bin.meng@windriver.com>,
 Laurent Vivier <lvivier@redhat.com>, Michael Rolnik <mrolnik@gmail.com>,
 Alexandre Iooss <erdnaxe@crans.org>, David Woodhouse <dwmw2@infradead.org>,
 Laurent Vivier <laurent@vivier.eu>, Paolo Bonzini <pbonzini@redhat.com>,
 Brian Cain <bcain@quicinc.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Beraldo Leal <bleal@redhat.com>, Paul Durrant <paul@xen.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Thomas Huth <thuth@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Cleber Rosa <crosa@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, John Snow <jsnow@redhat.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-riscv@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-39-alex.bennee@linaro.org>
 <52cac44e-a467-4748-8c5b-c9c47f5b0f79@daynix.com>
 <87cyuhguf4.fsf@draig.linaro.org>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <87cyuhguf4.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/01/04 21:22, Alex Bennée wrote:
> Akihiko Odaki <akihiko.odaki@daynix.com> writes:
> 
>> On 2024/01/04 2:33, Alex Bennée wrote:
>>> We can only request a list of registers once the vCPU has been
>>> initialised so the user needs to use either call the get function on
>>> vCPU initialisation or during the translation phase.
>>> We don't expose the reg number to the plugin instead hiding it
>>> behind
>>> an opaque handle. This allows for a bit of future proofing should the
>>> internals need to be changed while also being hashed against the
>>> CPUClass so we can handle different register sets per-vCPU in
>>> hetrogenous situations.
>>> Having an internal state within the plugins also allows us to expand
>>> the interface in future (for example providing callbacks on register
>>> change if the translator can track changes).
>>> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1706
>>> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
>>> Based-on: <20231025093128.33116-18-akihiko.odaki@daynix.com>
>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>> ---
>>> v3
>>>     - also g_intern_string the register name
>>>     - make get_registers documentation a bit less verbose
>>> v2
>>>     - use new get whole list api, and expose upwards
>>> vAJB:
>>> The main difference to Akikio's version is hiding the gdb register
>>> detail from the plugin for the reasons described above.
>>> ---
>>>    include/qemu/qemu-plugin.h   |  51 +++++++++++++++++-
>>>    plugins/api.c                | 102 +++++++++++++++++++++++++++++++++++
>>>    plugins/qemu-plugins.symbols |   2 +
>>>    3 files changed, 153 insertions(+), 2 deletions(-)
>>> diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
>>> index 4daab6efd29..95380895f81 100644
>>> --- a/include/qemu/qemu-plugin.h
>>> +++ b/include/qemu/qemu-plugin.h
>>> @@ -11,6 +11,7 @@
>>>    #ifndef QEMU_QEMU_PLUGIN_H
>>>    #define QEMU_QEMU_PLUGIN_H
>>>    +#include <glib.h>
>>>    #include <inttypes.h>
>>>    #include <stdbool.h>
>>>    #include <stddef.h>
>>> @@ -227,8 +228,8 @@ struct qemu_plugin_insn;
>>>     * @QEMU_PLUGIN_CB_R_REGS: callback reads the CPU's regs
>>>     * @QEMU_PLUGIN_CB_RW_REGS: callback reads and writes the CPU's regs
>>>     *
>>> - * Note: currently unused, plugins cannot read or change system
>>> - * register state.
>>> + * Note: currently QEMU_PLUGIN_CB_RW_REGS is unused, plugins cannot change
>>> + * system register state.
>>>     */
>>>    enum qemu_plugin_cb_flags {
>>>        QEMU_PLUGIN_CB_NO_REGS,
>>> @@ -708,4 +709,50 @@ uint64_t qemu_plugin_end_code(void);
>>>    QEMU_PLUGIN_API
>>>    uint64_t qemu_plugin_entry_code(void);
>>>    +/** struct qemu_plugin_register - Opaque handle for register
>>> access */
>>> +struct qemu_plugin_register;
>>
>> Just in case you missed my comment for the earlier version:
>>
>> What about identifying a register with an index in an array returned
>> by qemu_plugin_get_registers(). That saves troubles having the handle
>> member in qemu_plugin_reg_descriptor.
> 
> The handle gets de-referenced internally in the plugin api and
> additional checking could be added there. If we pass an index then we'd
> end up having to track the index assigned during get_registers as well
> as account for a potential skew in the index value if the register
> layout varies between vCPUs (although I admit this is future proofing
> for potential heterogeneous models).
> 
> The concept of opaque handle == pointer is fairly common in the QEMU
> code base. We are not making it hard for a plugin author to bypass this
> "protection", just making it clear if you do so your violating the
> principle of the API.

Now I get the idea. Indeed index values are not guaranteed to be stable 
across CPUs.

Why don't you pass gdb_reg_num as is then? qemu_plugin_register has the 
name member, but it's unused so gdb_reg_num is effectively the only 
member we need. You can even cast gdb_reg_num to (struct 
qemu_plugin_register *), but I don't think pointers are more opaque or 
future-proof than integers.

