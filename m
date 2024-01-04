Return-Path: <kvm+bounces-5642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D48E824142
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 13:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F18471F24B79
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0976D21376;
	Thu,  4 Jan 2024 12:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="DqZPVY40"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5967B21364
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6d9cdd0a5e6so240901b3a.3
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 04:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1704369932; x=1704974732; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1JfSYgvG+gN3IuIgW3mKT13qe2Rfz3AaTGl7a0v25sQ=;
        b=DqZPVY40CvFXGSVW8W+FqAFMsAI65RLlmdTD1JGXg0LLmnf7Eb/qYOBdd8P5uglRBw
         Of6A2ZaEkTGBqGr5PW1gFCm+sFlfXY7mI7mDP1JEThnlaEyNU0N7DzCQJLFAqdvpdhkK
         8GcO0QcltUzEfsiMVZVnYZxH62MRZpODICqtTZmJykK+ZqRaVaGS9MUisfySi5byA0Hq
         KUNrS1eE3MBvs+QjzSAjVf+HLXPOa3LciCDc1b2XZtGTDvY74Xir04Cq3pkC+pFGwkJd
         yJ5xhk5EPZRNvdhu24Q0N1LQRx/PSSCNRAdcC2Ki6LVPqo/m1DQHB/q+1vwk5MMyi3F7
         ZkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704369932; x=1704974732;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1JfSYgvG+gN3IuIgW3mKT13qe2Rfz3AaTGl7a0v25sQ=;
        b=nhBzEd0sIMM3BuoxB/V5NFyeJyFLS3rhOoFOZHeNf1ZoKLYv+G3b6lTFug5mvq80jb
         zV7uI0KWGil9zVPhXcmR9vfagqQOiLE+rPNM734KAND9wLxzVQixv4YW01XpxqOCbQB0
         fIlpire96cAflzh1WMwJD9cFgAhe3NxSh7pbDrCKVYCJ/g4FFTwsokOpXHaESElGYTWo
         ia+5WfE9MuvrnpPNlK7SApGzQKb4Z/dk0VZewLGj3mFHqjbYKgL55jipYnc4gH9ZFIeK
         LvT6dR/8ka+N0Cd7a6iECSSJjpoWP7ubk3IFEO/qvWyw5VEkG1ZuKn0CtFYPu2c8bvyv
         gPLw==
X-Gm-Message-State: AOJu0YzJANv17CsEgj2aHVM9bEzHKZ1ZTbS3PKb3SBBEvArIp7OqKQTr
	KY0ZuFyrTO29KyCml/jWRVnRbIa7kIOEQQ==
X-Google-Smtp-Source: AGHT+IF2iS1huYrRTsdmtHUlZNPJuYf+UOYa/O57oEjcrmBp+rJUuvidSwvdw5+1d7IxIqlfD1OWKQ==
X-Received: by 2002:a05:6a20:430d:b0:198:f146:b2da with SMTP id h13-20020a056a20430d00b00198f146b2damr405894pzk.93.1704369932451;
        Thu, 04 Jan 2024 04:05:32 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:9ac7:6d57:2b16:6932? ([2400:4050:a840:1e00:9ac7:6d57:2b16:6932])
        by smtp.gmail.com with ESMTPSA id c1-20020a63a441000000b005ce472f2d0fsm12383424pgp.66.2024.01.04.04.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jan 2024 04:05:32 -0800 (PST)
Message-ID: <52cac44e-a467-4748-8c5b-c9c47f5b0f79@daynix.com>
Date: Thu, 4 Jan 2024 21:05:22 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 38/43] plugins: add an API to read registers
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
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
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240103173349.398526-39-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/01/04 2:33, Alex Bennée wrote:
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
> v3
>    - also g_intern_string the register name
>    - make get_registers documentation a bit less verbose
> v2
>    - use new get whole list api, and expose upwards
> 
> vAJB:
> 
> The main difference to Akikio's version is hiding the gdb register
> detail from the plugin for the reasons described above.
> ---
>   include/qemu/qemu-plugin.h   |  51 +++++++++++++++++-
>   plugins/api.c                | 102 +++++++++++++++++++++++++++++++++++
>   plugins/qemu-plugins.symbols |   2 +
>   3 files changed, 153 insertions(+), 2 deletions(-)
> 
> diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
> index 4daab6efd29..95380895f81 100644
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
> @@ -708,4 +709,50 @@ uint64_t qemu_plugin_end_code(void);
>   QEMU_PLUGIN_API
>   uint64_t qemu_plugin_entry_code(void);
>   
> +/** struct qemu_plugin_register - Opaque handle for register access */
> +struct qemu_plugin_register;

Just in case you missed my comment for the earlier version:

What about identifying a register with an index in an array returned
by qemu_plugin_get_registers(). That saves troubles having the handle
member in qemu_plugin_reg_descriptor.

Regards,
Akihiko Odaki

