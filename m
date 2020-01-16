Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403DA13E1B4
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgAPQvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:51:10 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39991 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgAPQvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:51:10 -0500
Received: by mail-pg1-f193.google.com with SMTP id k25so10168566pgt.7
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=WX8RB1wfJCliH8/zi+tgub32ZBfKjuIQgKJ9j2z+hKk=;
        b=kv/rnQJpRXl8xuYnke8mUPEG7MMS88JHDJvb4E6uV0XFinTRPPD5C/d39TE0W1yLGg
         IveHIwSKvWqF8GWIAVXys0ek01P0zlslB1NhEkYuOQTobMKrpWAalExl/JFK7yyU0Yq0
         RN4d7oM83AIzhO/LQ+k2eKOtqcDgfMqR5K2BBoTBgPPcCQKjQY1vZxVsvLeeVpRJOZmD
         eRQROKW+eN7NWuqRF8n1g54NyVDjBhvST3om4ni5PwBSIHk02pNmz2QDJ3oaBuELwJCe
         7fXGPGZ2gXBewewkWEIYT5M6hJVT30iUAhLwPdqGbI+xXXqAP3MBupENf9wLl5FFPuhq
         48fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=WX8RB1wfJCliH8/zi+tgub32ZBfKjuIQgKJ9j2z+hKk=;
        b=IqF7+mwdrW2VOsMYLoS14J1NtUX3xMl/SiwgzRZFn4LHfN23+AlZaoX3bXEcarmOMm
         HErr2gRA2j0NIgFH5OngkK6tDQWSNoYGgEJww+LonrwA15Rn76I2azyynTMKEDxhRiES
         Ozhgc9ihMFuW2sV9oDjjM42LsZ5GhaqtYLOzXka7Xyuxi+mfBFnXqaFTutKkVDGw9EWF
         189q36pKx6wxAT32qr3FpZutcqTcD8pHCO/1e3u2jpbL+SKVgzXbNrjxVEhvlmsL2SeK
         AQvRBSgZVEKJ28ST5U2EsKBfxaCJJyuiAc+4VOE0Qs7Ds0fSaB620csUvdRtfVes46nm
         +KBA==
X-Gm-Message-State: APjAAAV3YSJw6e1is6wcKb6Jk+xySvrBnaY5WIhFNW4GgOXGO/XWVvhX
        WDGzME4ggP1LaqI+UAxFwsj59A==
X-Google-Smtp-Source: APXvYqy27Y/ZAUAQAnIzlxv1ajCi6HqFGtLCh8M57hfohNhgC3bsmthRFBrHGcYWEFQ5TfRZ98IBsQ==
X-Received: by 2002:a65:530d:: with SMTP id m13mr40368954pgq.351.1579193469245;
        Thu, 16 Jan 2020 08:51:09 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id s1sm24561586pgv.87.2020.01.16.08.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:51:08 -0800 (PST)
Date:   Thu, 16 Jan 2020 08:51:08 -0800 (PST)
X-Google-Original-Date: Thu, 16 Jan 2020 08:34:33 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH v10 01/19] RISC-V: Export riscv_cpuid_to_hartid_mask() API
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <Anup.Patel@wdc.com>
To:     Anup Patel <Anup.Patel@wdc.com>
In-Reply-To: <20191223113443.68969-2-anup.patel@wdc.com>
References: <20191223113443.68969-2-anup.patel@wdc.com>
  <20191223113443.68969-1-anup.patel@wdc.com>
Message-ID: <mhng-81eb8962-4c58-4e5b-9ee1-0e6c0afb2c00@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Dec 2019 03:35:19 PST (-0800), Anup Patel wrote:
> The riscv_cpuid_to_hartid_mask() API should be exported to allow
> building KVM RISC-V as loadable module.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  arch/riscv/kernel/smp.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
> index eb878abcaaf8..6fc7828d41e4 100644
> --- a/arch/riscv/kernel/smp.c
> +++ b/arch/riscv/kernel/smp.c
> @@ -10,6 +10,7 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/interrupt.h>
> +#include <linux/module.h>
>  #include <linux/profile.h>
>  #include <linux/smp.h>
>  #include <linux/sched.h>
> @@ -63,6 +64,7 @@ void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out)
>  	for_each_cpu(cpu, in)
>  		cpumask_set_cpu(cpuid_to_hartid_map(cpu), out);
>  }
> +EXPORT_SYMBOL_GPL(riscv_cpuid_to_hartid_mask);
>  
>  bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
>  {
> -- 
> 2.17.1

Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
