Return-Path: <kvm+bounces-29075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E739F9A236A
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA7D228A85C
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287A71DD54E;
	Thu, 17 Oct 2024 13:16:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3664E1C07E1
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 13:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170980; cv=none; b=Mi5m26azu2Jaq6J605s3dftyZV9mUviXBtvixpfEGKa7+wNxPTpUPmAlRCmQKAML2XgJ5z25RMm1JJdYi0WSfSU/FNqlpSJETQBmrFt1RSVeBSUkWRTJo8K/kvy0f8IwgO6/FVN3QdsU6wAPykEpjeK7bya5bUJotnjhmxeLWsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170980; c=relaxed/simple;
	bh=+WNc8oji6h7lPXXJdmyA5f2/EK7xvLqUvhz3fSwlOlE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lu+CtXnBCsm/otHT0+6W6MbToBmOjdf8JcZBk2MXraAkhQoyj0KttIsEOXN+jPmV41cEzWsRyGHHXo5Omayrm/rLNsDwV8cbrAHT8DqqYNI1BecLIxu5rJCJ8D5U+JZxv/GR9B5V06x/W3FIj1MLuNaEKeBZ058Bq6ksBq2dy48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XTpBl0XCzz6LDG1;
	Thu, 17 Oct 2024 21:11:43 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A46701400C9;
	Thu, 17 Oct 2024 21:16:14 +0800 (CST)
Received: from localhost (10.126.174.164) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 17 Oct
 2024 15:16:13 +0200
Date: Thu, 17 Oct 2024 14:16:11 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S.Tsirkin " <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Alex
 =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v3 7/7] i386/cpu: add has_caches flag to check smp_cache
 configuration
Message-ID: <20241017141611.00007566@Huawei.com>
In-Reply-To: <20241012104429.1048908-8-zhao1.liu@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-8-zhao1.liu@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

RESEND as rejected by server (header issue, hopefully fixed)

On Sat, 12 Oct 2024 18:44:29 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Alireza Sanaee <alireza.sanaee@huawei.com>
> 
> Add has_caches flag to SMPCompatProps, which helps in avoiding
> extra checks for every single layer of caches in x86 (and ARM in
> future).
> 
> Signed-off-by: Alireza Sanaee <alireza.sanaee@huawei.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
LGTM
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
> Note: Picked from Alireza's series with the changes:
>  * Moved the flag to SMPCompatProps with a new name "has_caches".
>    This way, it remains consistent with the function and style of
>    "has_clusters" in SMPCompatProps.
>  * Dropped my previous TODO with the new flag.
> ---
> Changes since Patch v2:
>  * Picked a new patch frome Alireza's ARM smp-cache series.
> ---
>  hw/core/machine-smp.c | 2 ++
>  include/hw/boards.h   | 3 +++
>  target/i386/cpu.c     | 9 ++++-----
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index f3edbded2e7b..16e456678cb6 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -367,6 +367,8 @@ bool machine_parse_smp_cache(MachineState *ms,
>          return false;
>      }
>  
> +    mc->smp_props.has_caches = true;
> +
>      return true;
>  }
>  
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index e4a1035e3fa1..af62b09c89d1 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -153,6 +153,8 @@ typedef struct {
>   * @modules_supported - whether modules are supported by the machine
>   * @cache_supported - whether cache (l1d, l1i, l2 and l3) configuration are
>   *                    supported by the machine
> + * @has_caches - whether cache properties are explicitly specified in the
> + *               user provided smp-cache configuration
>   */
>  typedef struct {
>      bool prefer_sockets;
> @@ -163,6 +165,7 @@ typedef struct {
>      bool drawers_supported;
>      bool modules_supported;
>      bool cache_supported[CACHE_LEVEL_AND_TYPE__MAX];
> +    bool has_caches;
>  } SMPCompatProps;
>  
>  /**
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c8a04faf3764..6f711e98b527 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7853,12 +7853,11 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>  
>  #ifndef CONFIG_USER_ONLY
>      MachineState *ms = MACHINE(qdev_get_machine());
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
>  
> -    /*
> -     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless Updates
> -     * if user didn't set smp_cache.
> -     */
> -    x86_cpu_update_smp_cache_topo(ms, cpu);
> +    if (mc->smp_props.has_caches) {
> +        x86_cpu_update_smp_cache_topo(ms, cpu);
> +    }
>  
>      qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
>  


