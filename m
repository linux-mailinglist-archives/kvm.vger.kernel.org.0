Return-Path: <kvm+bounces-5071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19BC581B736
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 14:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4E1128919F
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 13:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E67E745F7;
	Thu, 21 Dec 2023 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="UnADE8T6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AF176DA2
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3ba14203a34so634742b6e.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 05:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1703164776; x=1703769576; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xwacrzLBpA+7qNqKLKW6P7iJRvrUEffyGirc6Z5p94U=;
        b=UnADE8T61ICUBTTORvijP9LWhEsZ8TSjqpyMNkwyYEb2hhLSachtssZBbm4QZvPqSa
         HaxkTJ/IiaG0VSV8G0zbdRD3WLBzujJFnJB2zqzKydInimSmUcZYDCFapMIt/h759pG/
         sNLUWVQfzHzvzhMnhd3GxCH7zpLkx3FCVZgo9AZTePNh4GXn61D9cA5UHqtFogWnsxD3
         tOycfl/ye82JzAsCbqQqutFNE6qT/ZToT1bg82XT/Ur/psE6ycBifj1RQJ8BiGvJZRjz
         C83hBGl30UaAfqQhfTlsd15tShvKgHpIVgW/hyZtNBh6wpSotoj00WOpGHPJkr9oMCha
         aCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703164776; x=1703769576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwacrzLBpA+7qNqKLKW6P7iJRvrUEffyGirc6Z5p94U=;
        b=LS1XmWs/8oyey+HoQJqNmwnlusSLvr9a7nrS8v98+4uK8rs2G+QVxNw7Vv6H+G0pUF
         SvcGwFzDZcIQwRkhLmMj0oAmfLWNQp43vufeIKweAh1QW9V1783PcTbLiqCw7qdAxlcg
         ZHzZIFoGZjZX7URazKupa7CkxWTjboY2WYKR5sueWUedNHKslRquUyL5hBLXS1bExn9H
         +aEOrGYo3b+EKFdzf22L/4dfvySNe1SISoSZfxM8gCjnr0xEQXqayBrysuFQUCFuzzkf
         Xnp0kcrW4ybmQfawcBA5Ajetcd3pHuKIpZoTc68UVwdeoLK/CUq6Didlri6yeiVkpJ6U
         SDig==
X-Gm-Message-State: AOJu0YyR8CC50M21bwcf13fUY4CxgwyqOTgUWEI6soR2B23ymV3tWsb8
	WNOpMBYkT69EtXm19XrywdNRFg==
X-Google-Smtp-Source: AGHT+IGxbsSZ9PeiiKJkEVFCCUo7LUzl75tIosPOKCu5gnxWVDQqzciwl8Jbemw6CO0IZlVeMEgpvA==
X-Received: by 2002:a05:6358:7e14:b0:172:bab8:8a51 with SMTP id o20-20020a0563587e1400b00172bab88a51mr1217478rwm.65.1703164775932;
        Thu, 21 Dec 2023 05:19:35 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:9ac7:6d57:2b16:6932? ([2400:4050:a840:1e00:9ac7:6d57:2b16:6932])
        by smtp.gmail.com with ESMTPSA id w19-20020a63d753000000b005cd78f13608sm1556327pgi.13.2023.12.21.05.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 05:19:35 -0800 (PST)
Message-ID: <a26a55b2-240c-48c3-b341-48c1d7195bd9@daynix.com>
Date: Thu, 21 Dec 2023 22:19:25 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 37/40] plugins: add an API to read registers
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 John Snow <jsnow@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Brian Cain <bcain@quicinc.com>, Laurent Vivier <laurent@vivier.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Cleber Rosa <crosa@redhat.com>,
 David Hildenbrand <david@redhat.com>, Beraldo Leal <bleal@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Weiwei Li <liwei1518@gmail.com>, Paul Durrant <paul@xen.org>,
 qemu-s390x@nongnu.org, David Woodhouse <dwmw2@infradead.org>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Alexandre Iooss <erdnaxe@crans.org>, Thomas Huth <thuth@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-ppc@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Nicholas Piggin <npiggin@gmail.com>, qemu-riscv@nongnu.org,
 qemu-arm@nongnu.org, Song Gao <gaosong@loongson.cn>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Richard Henderson <richard.henderson@linaro.org>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Bin Meng <bin.meng@windriver.com>
References: <20231221103818.1633766-1-alex.bennee@linaro.org>
 <20231221103818.1633766-38-alex.bennee@linaro.org>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20231221103818.1633766-38-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/12/21 19:38, Alex Bennée wrote:
> We can only request a list of registers once the vCPU has been
> initialised so the user needs to use either call the get function on
> vCPU initialisation or during the translation phase.
> 
> We don't expose the reg number to the plugin instead hiding it behind
> an opaque handle. This allows for a bit of future proofing should the
> internals need to be changed while also being hashed against the
> CPUClass so we can handle different register sets per-vCPU in
> hetrogenous situations.
> 
> Having an internal state within the plugins also allows us to expand
> the interface in future (for example providing callbacks on register
> change if the translator can track changes).
> 
> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1706
> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> Based-on: <20231025093128.33116-18-akihiko.odaki@daynix.com>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v2
>    - use new get whole list api, and expose upwards
> 
> vAJB:
> 
> The main difference to Akikio's version is hiding the gdb register
> detail from the plugin for the reasons described above.
> ---
>   include/qemu/qemu-plugin.h   |  53 +++++++++++++++++-
>   plugins/api.c                | 102 +++++++++++++++++++++++++++++++++++
>   plugins/qemu-plugins.symbols |   2 +
>   3 files changed, 155 insertions(+), 2 deletions(-)
> 
> diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
> index 4daab6efd29..e3b35c6ee81 100644
> --- a/include/qemu/qemu-plugin.h
> +++ b/include/qemu/qemu-plugin.h
> @@ -11,6 +11,7 @@
>   #ifndef QEMU_QEMU_PLUGIN_H
>   #define QEMU_QEMU_PLUGIN_H
>   
> +#include <glib.h>
>   #include <inttypes.h>
>   #include <stdbool.h>
>   #include <stddef.h>
> @@ -227,8 +228,8 @@ struct qemu_plugin_insn;
>    * @QEMU_PLUGIN_CB_R_REGS: callback reads the CPU's regs
>    * @QEMU_PLUGIN_CB_RW_REGS: callback reads and writes the CPU's regs
>    *
> - * Note: currently unused, plugins cannot read or change system
> - * register state.
> + * Note: currently QEMU_PLUGIN_CB_RW_REGS is unused, plugins cannot change
> + * system register state.
>    */
>   enum qemu_plugin_cb_flags {
>       QEMU_PLUGIN_CB_NO_REGS,
> @@ -708,4 +709,52 @@ uint64_t qemu_plugin_end_code(void);
>   QEMU_PLUGIN_API
>   uint64_t qemu_plugin_entry_code(void);
>   
> +/** struct qemu_plugin_register - Opaque handle for a translated instruction */
> +struct qemu_plugin_register;

What about identifying a register with an index in an array returned by 
qemu_plugin_get_registers(). That saves troubles having the handle 
member in qemu_plugin_reg_descriptor.

> +
> +/**
> + * typedef qemu_plugin_reg_descriptor - register descriptions
> + *
> + * @name: register name
> + * @handle: opaque handle for retrieving value with qemu_plugin_read_register
> + * @feature: optional feature descriptor, can be NULL

Why can it be NULL?

> + */
> +typedef struct {
> +    char name[32];

Why not const char *?

> +    struct qemu_plugin_register *handle;
> +    const char *feature;
> +} qemu_plugin_reg_descriptor;
> +
> +/**
> + * qemu_plugin_get_registers() - return register list for vCPU
> + * @vcpu_index: vcpu to query
> + *
> + * Returns a GArray of qemu_plugin_reg_descriptor or NULL. Caller
> + * frees the array (but not the const strings).
> + *
> + * As the register set of a given vCPU is only available once
> + * the vCPU is initialised if you want to monitor registers from the
> + * start you should call this from a qemu_plugin_register_vcpu_init_cb()
> + * callback.

Is this note really necessary? You won't know vcpu_index before 
qemu_plugin_register_vcpu_init_cb() anyway.

> + */
> +GArray * qemu_plugin_get_registers(unsigned int vcpu_index);

Spurious space after *.

> +
> +/**
> + * qemu_plugin_read_register() - read register
> + *
> + * @vcpu: vcpu index
> + * @handle: a @qemu_plugin_reg_handle handle
> + * @buf: A GByteArray for the data owned by the plugin
> + *
> + * This function is only available in a context that register read access is
> + * explicitly requested.
> + *
> + * Returns the size of the read register. The content of @buf is in target byte
> + * order. On failure returns -1
> + */
> +int qemu_plugin_read_register(unsigned int vcpu,
> +                              struct qemu_plugin_register *handle,
> +                              GByteArray *buf);

Indention is not correct. docs/devel/style.rst says:

 > In case of function, there are several variants:
 >
 > * 4 spaces indent from the beginning
 > * align the secondary lines just after the opening parenthesis of the 
first

