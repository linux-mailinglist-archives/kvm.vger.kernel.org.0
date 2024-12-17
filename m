Return-Path: <kvm+bounces-33956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 182D49F4D9B
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D2F416C917
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D331F540D;
	Tue, 17 Dec 2024 14:24:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3CF1F4716
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445443; cv=none; b=EC4nGKWIgvqVl56RQTVmwPwz2tJ+4Zz1ZVktxrV/l5Olp/03A14iR7XFFH27R1XcNuUpkEOBs/vEkQ4eCH++PMP11qbmRHQ8r/jRmGRSuzKhSR0NYF3zvcqAz4VIwCWhjovba95KZr4iDBsIw9wX57ATo72HI60n7ZfTBFrNpF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445443; c=relaxed/simple;
	bh=eFPH1Ppzh7jd4mi53EW/imyd/E4opdzfHJB1c/7cJns=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUyRFuPPGzLEhnNUw88ROnxw8LwPoguUmfOKn+MUsFKZPDE4KkgQJz7x2hGje79yMmbDoO/VhbAK1/P2a+NKmo+TwoF1j6+BxzDHzFGl8wyvzUSm6CFnwpcTRt80dZEc/XXAPOUjC5aHoN0f5ufVWwnGuMLsK3AOlBJ6QEJNYDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YCJqj50sNz6K9HY;
	Tue, 17 Dec 2024 22:20:17 +0800 (CST)
Received: from frapeml500003.china.huawei.com (unknown [7.182.85.28])
	by mail.maildlp.com (Postfix) with ESMTPS id B26A4140B33;
	Tue, 17 Dec 2024 22:23:50 +0800 (CST)
Received: from localhost (10.47.30.16) by frapeml500003.china.huawei.com
 (7.182.85.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 17 Dec
 2024 15:23:49 +0100
Date: Tue, 17 Dec 2024 14:23:42 +0000
From: Alireza Sanaee <alireza.sanaee@huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Alex
 =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v2 0/7] Introduce SMP Cache Topology
Message-ID: <20241217142342.00007d96@huawei.com>
In-Reply-To: <20240908125920.1160236-1-zhao1.liu@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
Organization: Huawei
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500003.china.huawei.com (7.182.85.28)

On Sun,  8 Sep 2024 20:59:13 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Hi all,
> 
> Compared with previous Patch v1 [1], I've put the cache properties
> list into -machine, this is to meet current needs and also remain
> compatible with my future topology support (more discussion details,
> pls refer [2]).
> 
> This series is based on the commit 1581a0bc928d ("Merge tag 'pull-ufs-
> 20240906' of https://gitlab.com/jeuk20.kim/qemu into staging ufs
> queue").
> 
> Background
> ==========
> 
> The x86 and ARM (RISCV) need to allow user to configure cache
> properties (current only topology):
>  * For x86, the default cache topology model (of max/host CPU) does
> not always match the Host's real physical cache topology. Performance
> can increase when the configured virtual topology is closer to the
>    physical topology than a default topology would be.
>  * For ARM, QEMU can't get the cache topology information from the CPU
>    registers, then user configuration is necessary. Additionally, the
>    cache information is also needed for MPAM emulation (for TCG) to
>    build the right PPTT. (Originally from Jonathan)
> 
> 
> About smp-cache
> ===============
> 
> In this version, smp-cache is implemented as a array integrated in
> -machine. Though -machine currently can't support JSON format, this is
> the one of the directions of future.
> 
> An example is as follows:
> 
> smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die
> 
> "cache" specifies the cache that the properties will be applied on.
> This field is the combination of cache level and cache type. Now it
> supports "l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2"
> (L2 unified cache) and "l3" (L3 unified cache).
> 
> "topology" field accepts CPU topology levels including "thread",
> "core", "module", "cluster", "die", "socket", "book", "drawer" and a
> special value "default".
> 
> The "default" is introduced to make it easier for libvirt to set a
> default parameter value without having to care about the specific
> machine (because currently there is no proper way for machine to
> expose supported topology levels and caches).
> 
> If "default" is set, then the cache topology will follow the
> architecture's default cache topology model. If other CPU topology
> level is set, the cache will be shared at corresponding CPU topology
> level.
> 
> 
> Welcome your comment!
> 
> 
> [1]: Patch
> v1: https://lore.kernel.org/qemu-devel/20240704031603.1744546-1-zhao1.liu@intel.com/ [2]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Changelog:
> 
> Main changes since Patch v1:
>  * Dropped handwriten smp-cache object and integrated cache properties
>    list into MachineState and used -machine to configure SMP cache
>    properties. (Markus)
>  * Dropped prefix of CpuTopologyLevel enumeration. (Markus)
>  * Rename CPU_TOPO_LEVEL_* to CPU_TOPOLOGY_LEVEL_* to match the QAPI's
>    generated code. (Markus)
>  * Renamed SMPCacheProperty/SMPCacheProperties (QAPI structures) to
>    SmpCacheProperties/SmpCachePropertiesWrapper. (Markus)
>  * Renamed SMPCacheName (QAPI structure) to SmpCacheLevelAndType and
>    dropped prefix. (Markus)
>  * Renamed 'name' field in SmpCacheProperties to 'cache', since the
>    type and level of the cache in SMP system could be able to specify
>    all of these kinds of cache explicitly enough.
>  * Renamed 'topo' field in SmpCacheProperties to 'topology'. (Markus)
>  * Returned error information when user repeats setting cache
>    properties. (Markus)
>  * Renamed SmpCacheLevelAndType to CacheLevelAndType, since this
>    representation is general across SMP or hybrid system.
>  * Dropped machine_check_smp_cache_support() and did the check when
>    -machine parses smp-cache in machine_parse_smp_cache().
> 
> Main changes since RFC v2:
>  * Dropped cpu-topology.h and cpu-topology.c since QAPI has the helper
>    (CpuTopologyLevel_str) to convert enum to string. (Markus)
>  * Fixed text format in machine.json (CpuTopologyLevel naming, 2
> spaces between sentences). (Markus)
>  * Added a new level "default" to de-compatibilize some arch-specific
>    topo settings. (Daniel)
>  * Moved CpuTopologyLevel to qapi/machine-common.json, at where the
>    cache enumeration and smp-cache object would be added.
>    - If smp-cache object is defined in qapi/machine.json,
> storage-daemon will complain about the qmp cmds in qapi/machine.json
> during compiling.
>  * Referred to Daniel's suggestion to introduce cache JSON list,
> though as a standalone object since -smp/-machine can't support JSON.
>  * Linked machine's smp_cache to smp-cache object instead of a builtin
>    structure. This is to get around the fact that the keyval format of
>    -machine can't support JSON.
>  * Wrapped the cache topology level access into a helper.
>  * Split as a separate commit to just include compatibility checking
> and topology checking.
>  * Allow setting "default" topology level even though the cache
>    isn't supported by machine. (Daniel)
>  * Rewrote the document of smp-cache object.
> 
> Main changes since RFC v1:
>  * Split CpuTopology renaimg out of this RFC.
>  * Use QAPI to enumerate CPU topology levels.
>  * Drop string_to_cpu_topo() since QAPI will help to parse the topo
>    levels.
>  * Set has_*_cache field in machine_get_smp(). (JeeHeng)
>  * Use "*_cache=topo_level" as -smp example as the original "level"
>    term for a cache has a totally different meaning. (Jonathan)
> ---
> Zhao Liu (7):
>   hw/core: Make CPU topology enumeration arch-agnostic
>   qapi/qom: Define cache enumeration and properties
>   hw/core: Add smp cache topology for machine
>   hw/core: Check smp cache topology support for machine
>   i386/cpu: Support thread and module level cache topology
>   i386/cpu: Update cache topology with machine's configuration
>   i386/pc: Support cache topology in -machine for PC machine
> 
>  hw/core/machine-smp.c      | 119 +++++++++++++++++++++++
>  hw/core/machine.c          |  44 +++++++++
>  hw/i386/pc.c               |   4 +
>  hw/i386/x86-common.c       |   4 +-
>  include/hw/boards.h        |  13 +++
>  include/hw/i386/topology.h |  22 +----
>  qapi/machine-common.json   |  96 ++++++++++++++++++-
>  qemu-options.hx            |  28 +++++-
>  target/i386/cpu.c          | 191
> ++++++++++++++++++++++--------------- target/i386/cpu.h          |
> 4 +- 10 files changed, 425 insertions(+), 100 deletions(-)
> 

Hi Zhao,

I wonder if this patch-set requires rebase for the new cycle?

Cheers,
Alireza

