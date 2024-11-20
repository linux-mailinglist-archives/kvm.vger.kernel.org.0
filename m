Return-Path: <kvm+bounces-32161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D19849D3D6F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AF0A1F22BD4
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E541AA1DC;
	Wed, 20 Nov 2024 14:22:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EAA149C42;
	Wed, 20 Nov 2024 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732112536; cv=none; b=B4w/TLcK3bdzyYPzrJYwVQ3M+qyWyXSzPhXgSpLqSrwHLOW4uYaAtGjN7fbRRM2PwLMmhbwQ4757C6CVuarIUKKZpU6J25RV5YEsFbzLR3GPxpt519Bdf9zhEXStyyO+xaCrS7M3CbDtOEYlb4abBIeTN5Bg+nEi361A8fYaHjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732112536; c=relaxed/simple;
	bh=plJ6EQ3VjvAPbIHz/+2XUa9OXqozHLwx8Q7PHhtFzNM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FM4kqv9cIVvnz4x1FW3TM0RYp3VMk0eYNcR8KZr7dIx0gt8dRnFvXTnvWkS2ft6uEUrAXlJCghDOB6hIhcgminysEfg6IxEjTEyQc7yQHP5q+amg8KqIHDdT2mM1ALG6QBmRmB/avWy3w2BfaNLa07EGbrJBp5CnGXTSFD0JBS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Xtk7v3b1bz6LD3m;
	Wed, 20 Nov 2024 22:21:47 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 19870140114;
	Wed, 20 Nov 2024 22:22:10 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 20 Nov
 2024 15:22:09 +0100
Date: Wed, 20 Nov 2024 14:22:08 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC: Igor Mammedov <imammedo@redhat.com>, Shiju Jose <shiju.jose@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <qemu-arm@nongnu.org>,
	<qemu-devel@nongnu.org>
Subject: Re: [PATCH v3 09/15] acpi/ghes: better name GHES memory error
 function
Message-ID: <20241120142208.00005cbe@huawei.com>
In-Reply-To: <b1d2b24dbfb375c5bda03561b31b7130a4b9939b.1731406254.git.mchehab+huawei@kernel.org>
References: <cover.1731406254.git.mchehab+huawei@kernel.org>
	<b1d2b24dbfb375c5bda03561b31b7130a4b9939b.1731406254.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 12 Nov 2024 11:14:53 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> The current function used to generate GHES data is specific for
> memory errors. Give a better name for it, as we now have a generic
> function as well.
> 
> Reviewed-by: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

A couple of unnecessary line breaks I think.

Otherwise LGTM
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  hw/acpi/ghes-stub.c    | 2 +-
>  hw/acpi/ghes.c         | 2 +-
>  include/hw/acpi/ghes.h | 5 +++--
>  target/arm/kvm.c       | 3 ++-
>  4 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
> index 2b64cbd2819a..7cec1812dad9 100644
> --- a/hw/acpi/ghes-stub.c
> +++ b/hw/acpi/ghes-stub.c
> @@ -11,7 +11,7 @@
>  #include "qemu/osdep.h"
>  #include "hw/acpi/ghes.h"
>  
> -int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
> +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>  {
>      return -1;
>  }
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index 0eb874a11ff7..1dbcbefbc2ee 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -421,7 +421,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>      return;
>  }
>  
> -int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
> +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>  {
>      /* Memory Error Section Type */
>      const uint8_t guid[] =
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 8859346af51a..a35097d5207c 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -74,15 +74,16 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
>                       const char *oem_id, const char *oem_table_id);
>  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
>                            GArray *hardware_errors);
> +int acpi_ghes_memory_errors(uint16_t source_id,
> +                            uint64_t error_physical_addr);
No need for line break as under 80 chars anyway.

>  void ghes_record_cper_errors(const void *cper, size_t len,
>                               uint16_t source_id, Error **errp);
> -int acpi_ghes_record_errors(uint16_t source_id, uint64_t error_physical_addr);
>  
>  /**
>   * acpi_ghes_present: Report whether ACPI GHES table is present
>   *
>   * Returns: true if the system has an ACPI GHES table and it is
> - * safe to call acpi_ghes_record_errors() to record a memory error.
> + * safe to call acpi_ghes_memory_errors() to record a memory error.
>   */
>  bool acpi_ghes_present(void);
>  #endif
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 7b6812c0de2e..8e281d920052 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -2387,7 +2387,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>               */
>              if (code == BUS_MCEERR_AR) {
>                  kvm_cpu_synchronize_state(c);
> -                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> +                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA,
> +                                             paddr)) {
Why the line break?

It will be under 80 chars on one line.

>                      kvm_inject_arm_sea(c);
>                  } else {
>                      error_report("failed to record the error");

