Return-Path: <kvm+bounces-9941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A742B867AEB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19296B2754C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA6412BE81;
	Mon, 26 Feb 2024 15:39:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C213A12B159
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708961997; cv=none; b=j1rbq13gKOnjMUb6g+8aoq2RJXChqLDlGdEQTZM95ZBqhevmA1UclWwc89ihEBbuI1JkX5pCjE9KAMT0ESzWjlNmb9j9EWy9/41FLSUhDS/wXGj0bz0DkKyetkWD3pklGeG9VSO6gs+xPkXn9AnYQDTrixh+ktiws2DpOfVvZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708961997; c=relaxed/simple;
	bh=puEq6915oMMKalSNGoyiH/u5RLfoAPkbgv7vSSoejKw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bw46cStYmzdvS3TEg0HPCZzCpSyJD9W2wNW+TpIRRXcXvhNe/CNtpEddw35Y/ae20muvpBEjKat4zfdJlkRAQaypcMZx18c9tC4o4nlb4Mg1rO+uCgxQIczPTQ3eNthqRsWliYcVtoVkac1WwUSBAMAM8COhB7OkTlsM6oHfmgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tk4Sg116Hz6K6VK;
	Mon, 26 Feb 2024 23:35:31 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 1708B140A08;
	Mon, 26 Feb 2024 23:39:50 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 26 Feb
 2024 15:39:49 +0000
Date: Mon, 26 Feb 2024 15:39:47 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Eduardo
 Habkost" <eduardo@habkost.net>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?=
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S .
 Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, "Sia Jee Heng" <jeeheng.sia@starfivetech.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>,
	<qemu-arm@nongnu.org>, "Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu
	<zhao1.liu@intel.com>
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
Message-ID: <20240226153947.00006fd6@Huawei.com>
In-Reply-To: <20240220092504.726064-5-zhao1.liu@linux.intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
	<20240220092504.726064-5-zhao1.liu@linux.intel.com>
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
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Tue, 20 Feb 2024 17:25:00 +0800
Zhao Liu <zhao1.liu@linux.intel.com> wrote:

> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
> -smp to define the cache topology for SMP system.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Hi Zhao Liu

I like the scheme.  Strikes a good balance between complexity of description
and systems that actually exist. Sure there are systems with more cache
levels etc but they are rare and support can be easily added later
if people want to model them.

A few minor comments inline.

Jonathan
> ---
>  hw/core/machine-smp.c | 128 ++++++++++++++++++++++++++++++++++++++++++
>  hw/core/machine.c     |   4 ++
>  qapi/machine.json     |  14 ++++-
>  system/vl.c           |  15 +++++
>  4 files changed, 160 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index 8a8296b0d05b..2cbd19f4aa57 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -61,6 +61,132 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>      return g_string_free(s, false);
>  }
>  
> +static bool machine_check_topo_support(MachineState *ms,
> +                                       CPUTopoLevel topo)
> +{
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> +
> +    if (topo == CPU_TOPO_LEVEL_MODULE && !mc->smp_props.modules_supported) {
> +        return false;
> +    }
> +
> +    if (topo == CPU_TOPO_LEVEL_CLUSTER && !mc->smp_props.clusters_supported) {
> +        return false;
> +    }
> +
> +    if (topo == CPU_TOPO_LEVEL_DIE && !mc->smp_props.dies_supported) {
> +        return false;
> +    }
> +
> +    if (topo == CPU_TOPO_LEVEL_BOOK && !mc->smp_props.books_supported) {
> +        return false;
> +    }
> +
> +    if (topo == CPU_TOPO_LEVEL_DRAWER && !mc->smp_props.drawers_supported) {
> +        return false;
> +    }
> +
> +    return true;
> +}
> +
> +static int smp_cache_string_to_topology(MachineState *ms,

Not a good name for a function that does rather more than that.

> +                                        char *topo_str,
> +                                        CPUTopoLevel *topo,
> +                                        Error **errp)
> +{
> +    *topo = string_to_cpu_topo(topo_str);
> +
> +    if (*topo == CPU_TOPO_LEVEL_MAX || *topo == CPU_TOPO_LEVEL_INVALID) {
> +        error_setg(errp, "Invalid cache topology level: %s. The cache "
> +                   "topology should match the CPU topology level", topo_str);
> +        return -1;
> +    }
> +
> +    if (!machine_check_topo_support(ms, *topo)) {
> +        error_setg(errp, "Invalid cache topology level: %s. The topology "
> +                   "level is not supported by this machine", topo_str);
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +static void machine_parse_smp_cache_config(MachineState *ms,
> +                                           const SMPConfiguration *config,
> +                                           Error **errp)
> +{
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> +
> +    if (config->l1d_cache) {
> +        if (!mc->smp_props.l1_separated_cache_supported) {
> +            error_setg(errp, "L1 D-cache topology not "
> +                       "supported by this machine");
> +            return;
> +        }
> +
> +        if (smp_cache_string_to_topology(ms, config->l1d_cache,
> +            &ms->smp_cache.l1d, errp)) {

Indent is to wrong opening bracket.
Same for other cases.


> +            return;
> +        }
> +    }

> +}
> +
>  /*
>   * machine_parse_smp_config: Generic function used to parse the given
>   *                           SMP configuration
> @@ -249,6 +375,8 @@ void machine_parse_smp_config(MachineState *ms,
>                     mc->name, mc->max_cpus);
>          return;
>      }
> +
> +    machine_parse_smp_cache_config(ms, config, errp);
>  }
>  
>  unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)


