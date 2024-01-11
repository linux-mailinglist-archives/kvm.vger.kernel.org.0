Return-Path: <kvm+bounces-6075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F1482AEC7
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B818C28329A
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F098C15AE4;
	Thu, 11 Jan 2024 12:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ezqkqGWd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1546D156FD
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 12:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40e60e13581so4379245e9.1
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 04:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704976472; x=1705581272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Laj5dgyw/ZFfRFO13kyKlguGgpT3a+jIHEPtaFCGeuY=;
        b=ezqkqGWdVq5lXioztcIMU+dOMUgfLJGFwrtFRGPl0vUBr404t6jg2+mhjQ2YN9GtU2
         oEQIeG28JPrAPIlJPgRtfKTdRfhGPFmOEr2oiU2EqNzzlwbRYGx2AAQT1/8HwIcZU5i3
         d2AZF7vV5XI17bujV0s5x/IVZmOoMrEVqMg76Ks+KkCbiH9+mR6NDwpKgamc0uchHdS2
         PbeNgdbbK8ZsRGERVAd25SXTZo3ldBwwI5kPGy+zIG+RQrRJtpPcD4nirRoDXMN7FaC/
         moYMIc4YjkhYR70EZYCnE2LpAfGGa2sOui+waZ8WYIjH9R2F16VUSzBMaMtrB1nKghcG
         6v/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976472; x=1705581272;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Laj5dgyw/ZFfRFO13kyKlguGgpT3a+jIHEPtaFCGeuY=;
        b=n1SahVKAzJz55Z25AYYQHf2jIfVD4vYfI/gMLbTUMnL1THAugAnP1DS79GKIEO3SKr
         DbzgW7eoUrtfoZR7gfqYiIsb6Z5e8bQCo2/1h1uQsXZxCxBWeRSS1DHDhEeURSJH0T90
         5MmkuhBcKPOhEBvk13NkAJQG9W2akL0fG96GQfx/wRikm8jFRKpKq8Dyj81iOfAa3tVH
         J5ex2kDpdXQq7iieSMvVDs4Dhp48zUzuxOOY93TqepGRYSVMCZa6WZEk6+jRnr/0HFeg
         /3a6dvc0Qo6+YvjWuPCUFAO7qGZl9PDKtOhk24IVLRnSodH+P3K0qiwIB+Loh6D4WmYu
         bm9g==
X-Gm-Message-State: AOJu0Yy1zbgjGZFVTSjaYnwc/ixDjfty99gIi2J+R5F1p++JG8OnBMn4
	Juubjc++FMa8J9p5ZykXRVLo2PQjJuvd6A==
X-Google-Smtp-Source: AGHT+IHCqvU083WGqGcVqRzQLj+PUoocXsxh/YK9sBx/8GpEXqP1xY2y/M7R8Oui7TCF0nRIj3X61w==
X-Received: by 2002:a7b:c8c8:0:b0:40e:540a:aefb with SMTP id f8-20020a7bc8c8000000b0040e540aaefbmr274151wml.26.1704976472020;
        Thu, 11 Jan 2024 04:34:32 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id x9-20020adfec09000000b00336b8461a5esm1126877wrn.88.2024.01.11.04.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 04:34:31 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 4752F5F7AD;
	Thu, 11 Jan 2024 12:34:31 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  qemu-s390x@nongnu.org,  qemu-ppc@nongnu.org,
  Richard Henderson <richard.henderson@linaro.org>,  Song Gao
 <gaosong@loongson.cn>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  David Hildenbrand <david@redhat.com>,  Aurelien Jarno
 <aurelien@aurel32.net>,  Yoshinori Sato <ysato@users.sourceforge.jp>,
  Yanan Wang <wangyanan55@huawei.com>,  Bin Meng <bin.meng@windriver.com>,
  Laurent Vivier <lvivier@redhat.com>,  Michael Rolnik <mrolnik@gmail.com>,
  Alexandre Iooss <erdnaxe@crans.org>,  David Woodhouse
 <dwmw2@infradead.org>,  Laurent Vivier <laurent@vivier.eu>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Brian Cain <bcain@quicinc.com>,  Daniel Henrique
 Barboza <danielhb413@gmail.com>,  Beraldo Leal <bleal@redhat.com>,  Paul
 Durrant <paul@xen.org>,  Mahmoud Mandour <ma.mandourr@gmail.com>,  Thomas
 Huth <thuth@redhat.com>,  Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
  Cleber Rosa <crosa@redhat.com>,  kvm@vger.kernel.org,  Peter Maydell
 <peter.maydell@linaro.org>,  Wainer dos Santos Moschetta
 <wainersm@redhat.com>,  qemu-arm@nongnu.org,  Weiwei Li
 <liwei1518@gmail.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  John
 Snow <jsnow@redhat.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Nicholas Piggin <npiggin@gmail.com>,  Palmer
 Dabbelt <palmer@dabbelt.com>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Ilya Leoshkevich <iii@linux.ibm.com>,
  =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,  "Edgar E. Iglesias"
 <edgar.iglesias@gmail.com>,  Eduardo Habkost <eduardo@habkost.net>,
  qemu-riscv@nongnu.org,  Alistair Francis <alistair.francis@wdc.com>,
  Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH v2 38/43] plugins: add an API to read registers
In-Reply-To: <6c22ed26-7906-47a2-ab66-57d545ef59f5@linaro.org> (Pierrick
	Bouvier's message of "Tue, 9 Jan 2024 19:05:12 +0400")
References: <20240103173349.398526-1-alex.bennee@linaro.org>
	<20240103173349.398526-39-alex.bennee@linaro.org>
	<6c22ed26-7906-47a2-ab66-57d545ef59f5@linaro.org>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Thu, 11 Jan 2024 12:34:31 +0000
Message-ID: <87il40f3qg.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> On 1/3/24 21:33, Alex Benn=C3=A9e wrote:
>> We can only request a list of registers once the vCPU has been
>> initialised so the user needs to use either call the get function on
>> vCPU initialisation or during the translation phase.
>> We don't expose the reg number to the plugin instead hiding it
>> behind
>> an opaque handle. This allows for a bit of future proofing should the
>> internals need to be changed while also being hashed against the
>> CPUClass so we can handle different register sets per-vCPU in
>> hetrogenous situations.
>> Having an internal state within the plugins also allows us to expand
>> the interface in future (for example providing callbacks on register
>> change if the translator can track changes).
>> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1706
>> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
>> Based-on: <20231025093128.33116-18-akihiko.odaki@daynix.com>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>> v3
>>    - also g_intern_string the register name
>>    - make get_registers documentation a bit less verbose
>> v2
>>    - use new get whole list api, and expose upwards
>> vAJB:
>> The main difference to Akikio's version is hiding the gdb register
>> detail from the plugin for the reasons described above.
>> ---
>>   include/qemu/qemu-plugin.h   |  51 +++++++++++++++++-
>>   plugins/api.c                | 102 +++++++++++++++++++++++++++++++++++
>>   plugins/qemu-plugins.symbols |   2 +
>>   3 files changed, 153 insertions(+), 2 deletions(-)
>> diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
>> index 4daab6efd29..95380895f81 100644
>> --- a/include/qemu/qemu-plugin.h
>> +++ b/include/qemu/qemu-plugin.h
>> @@ -11,6 +11,7 @@
>>   #ifndef QEMU_QEMU_PLUGIN_H
>>   #define QEMU_QEMU_PLUGIN_H
>>   +#include <glib.h>
>>   #include <inttypes.h>
>>   #include <stdbool.h>
>>   #include <stddef.h>
>> @@ -227,8 +228,8 @@ struct qemu_plugin_insn;
>>    * @QEMU_PLUGIN_CB_R_REGS: callback reads the CPU's regs
>>    * @QEMU_PLUGIN_CB_RW_REGS: callback reads and writes the CPU's regs
>>    *
>> - * Note: currently unused, plugins cannot read or change system
>> - * register state.
>> + * Note: currently QEMU_PLUGIN_CB_RW_REGS is unused, plugins cannot cha=
nge
>> + * system register state.
>>    */
>>   enum qemu_plugin_cb_flags {
>>       QEMU_PLUGIN_CB_NO_REGS,
>> @@ -708,4 +709,50 @@ uint64_t qemu_plugin_end_code(void);
>>   QEMU_PLUGIN_API
>>   uint64_t qemu_plugin_entry_code(void);
>>   +/** struct qemu_plugin_register - Opaque handle for register
>> access */
>> +struct qemu_plugin_register;
>> +
>> +/**
>> + * typedef qemu_plugin_reg_descriptor - register descriptions
>> + *
>> + * @handle: opaque handle for retrieving value with qemu_plugin_read_re=
gister
>> + * @name: register name
>> + * @feature: optional feature descriptor, can be NULL
>> + */
>> +typedef struct {
>> +    struct qemu_plugin_register *handle;
>> +    const char *name;
>> +    const char *feature;
>> +} qemu_plugin_reg_descriptor;
>> +
>> +/**
>> + * qemu_plugin_get_registers() - return register list for vCPU
>> + * @vcpu_index: vcpu to query
>> + *
>> + * Returns a GArray of qemu_plugin_reg_descriptor or NULL. Caller
>> + * frees the array (but not the const strings).
>> + *
>> + * Should be used from a qemu_plugin_register_vcpu_init_cb() callback
>> + * after the vCPU is initialised.
>> + */
>> +GArray * qemu_plugin_get_registers(unsigned int vcpu_index);
>> +
>> +/**
>> + * qemu_plugin_read_register() - read register
>> + *
>> + * @vcpu: vcpu index
>> + * @handle: a @qemu_plugin_reg_handle handle
>> + * @buf: A GByteArray for the data owned by the plugin
>> + *
>> + * This function is only available in a context that register read acce=
ss is
>> + * explicitly requested.
>> + *
>> + * Returns the size of the read register. The content of @buf is in tar=
get byte
>> + * order. On failure returns -1
>> + */
>> +int qemu_plugin_read_register(unsigned int vcpu,
>> +                              struct qemu_plugin_register *handle,
>> +                              GByteArray *buf);
>> +
>> +
>>   #endif /* QEMU_QEMU_PLUGIN_H */
>> diff --git a/plugins/api.c b/plugins/api.c
>> index ac39cdea0b3..f8905325c43 100644
>> --- a/plugins/api.c
>> +++ b/plugins/api.c
>> @@ -8,6 +8,7 @@
>>    *
>>    *  qemu_plugin_tb
>>    *  qemu_plugin_insn
>> + *  qemu_plugin_register
>>    *
>>    * Which can then be passed back into the API to do additional things.
>>    * As such all the public functions in here are exported in
>> @@ -35,10 +36,12 @@
>>    */
>>     #include "qemu/osdep.h"
>> +#include "qemu/main-loop.h"
>>   #include "qemu/plugin.h"
>>   #include "qemu/log.h"
>>   #include "tcg/tcg.h"
>>   #include "exec/exec-all.h"
>> +#include "exec/gdbstub.h"
>>   #include "exec/ram_addr.h"
>>   #include "disas/disas.h"
>>   #include "plugin.h"
>> @@ -435,3 +438,102 @@ uint64_t qemu_plugin_entry_code(void)
>>   #endif
>>       return entry;
>>   }
>> +
>> +/*
>> + * Register handles
>> + *
>> + * The plugin infrastructure keeps hold of these internal data
>> + * structures which are presented to plugins as opaque handles. They
>> + * are global to the system and therefor additions to the hash table
>> + * must be protected by the @reg_handle_lock.
>> + *
>> + * In order to future proof for up-coming heterogeneous work we want
>> + * different entries for each CPU type while sharing them in the
>> + * common case of multiple cores of the same type.
>> + */
>> +
>> +static QemuMutex reg_handle_lock;
>> +
>> +struct qemu_plugin_register {
>> +    const char *name;
>> +    int gdb_reg_num;
>> +};
>> +
>> +static GHashTable *reg_handles; /* hash table of PluginReg */
>> +
>> +/* Generate a stable key - would xxhash be overkill? */
>> +static gpointer cpu_plus_reg_to_key(CPUState *cs, int gdb_regnum)
>> +{
>> +    uintptr_t key =3D (uintptr_t) cs->cc;
>> +    key ^=3D gdb_regnum;
>> +    return GUINT_TO_POINTER(key);
>> +}
>> +
>> +/*
>> + * Create register handles.
>> + *
>> + * We need to create a handle for each register so the plugin
>> + * infrastructure can call gdbstub to read a register. We also
>> + * construct a result array with those handles and some ancillary data
>> + * the plugin might find useful.
>> + */
>> +
>> +static GArray * create_register_handles(CPUState *cs, GArray *gdbstub_r=
egs) {
>> +    GArray *find_data =3D g_array_new(true, true, sizeof(qemu_plugin_re=
g_descriptor));
>> +
>> +    WITH_QEMU_LOCK_GUARD(&reg_handle_lock) {
>> +
>> +        if (!reg_handles) {
>> +            reg_handles =3D g_hash_table_new(g_direct_hash, g_direct_eq=
ual);
>> +        }
>> +
>> +        for (int i=3D0; i < gdbstub_regs->len; i++) {
>> +            GDBRegDesc *grd =3D &g_array_index(gdbstub_regs, GDBRegDesc=
, i);
>> +            gpointer key =3D cpu_plus_reg_to_key(cs, grd->gdb_reg);
>> +            struct qemu_plugin_register *val =3D g_hash_table_lookup(re=
g_handles, key);
>> +
>> +            /* Doesn't exist, create one */
>> +            if (!val) {
>> +                val =3D g_new0(struct qemu_plugin_register, 1);
>> +                val->gdb_reg_num =3D grd->gdb_reg;
>> +                val->name =3D g_intern_string(grd->name);
>> +
>> +                g_hash_table_insert(reg_handles, key, val);
>> +            }
>> +
>> +            /* Create a record for the plugin */
>> +            qemu_plugin_reg_descriptor desc =3D {
>> +                .handle =3D val,
>> +                .name =3D val->name,
>> +                .feature =3D g_intern_string(grd->feature_name)
>> +            };
>> +            g_array_append_val(find_data, desc);
>> +        }
>> +    }
>> +
>> +    return find_data;
>> +}
>> +
>> +GArray * qemu_plugin_get_registers(unsigned int vcpu)
>> +{
>> +    CPUState *cs =3D qemu_get_cpu(vcpu);
>> +    if (cs) {
>> +        g_autoptr(GArray) regs =3D gdb_get_register_list(cs);
>> +        return regs->len ? create_register_handles(cs, regs) : NULL;
>> +    } else {
>> +        return NULL;
>> +    }
>> +}
>
> Would that be useful to cache the returned value on plugin runtime
> side (per vcpu)? This way, a plugin could call
> qemu_plugin_get_registers as many time as it wants without having to
> pay for the creation of the array.

I suspect plugins would still want to work out what it needed ahead of
time and the cpu list should be static from vcpu_init onwards.

> In more, could we return a hashtable (indexed by regname string)
> instead of an array?

Hmm maybe. Arrays do benefit from being easy to cleanup and we would
still need an internal hash table to track stuff we don't want to expose
to the plugin.

We can always change it later if there is a compelling use case.

> With both changes, a plugin could simply perform a lookup in table
> returned by qemu_plugin_get_registers without having to keep anything
> on its side.
>
>> +
>> +int qemu_plugin_read_register(unsigned int vcpu, struct qemu_plugin_reg=
ister *reg, GByteArray *buf)
>> +{
>> +    CPUState *cs =3D qemu_get_cpu(vcpu);
>> +    /* assert with debugging on? */
>> +    return gdb_read_register(cs, buf, reg->gdb_reg_num);
>> +}
>> +
>> +static void __attribute__((__constructor__)) qemu_api_init(void)
>> +{
>> +    qemu_mutex_init(&reg_handle_lock);
>> +
>> +}
>> diff --git a/plugins/qemu-plugins.symbols b/plugins/qemu-plugins.symbols
>> index 71f6c90549d..6963585c1ea 100644
>> --- a/plugins/qemu-plugins.symbols
>> +++ b/plugins/qemu-plugins.symbols
>> @@ -3,6 +3,7 @@
>>     qemu_plugin_end_code;
>>     qemu_plugin_entry_code;
>>     qemu_plugin_get_hwaddr;
>> +  qemu_plugin_get_registers;
>>     qemu_plugin_hwaddr_device_name;
>>     qemu_plugin_hwaddr_is_io;
>>     qemu_plugin_hwaddr_phys_addr;
>> @@ -20,6 +21,7 @@
>>     qemu_plugin_n_vcpus;
>>     qemu_plugin_outs;
>>     qemu_plugin_path_to_binary;
>> +  qemu_plugin_read_register;
>>     qemu_plugin_register_atexit_cb;
>>     qemu_plugin_register_flush_cb;
>>     qemu_plugin_register_vcpu_exit_cb;

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

