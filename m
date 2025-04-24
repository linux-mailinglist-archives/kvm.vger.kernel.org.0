Return-Path: <kvm+bounces-44099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D055DA9A599
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9CC97AC7F9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE1C2066F7;
	Thu, 24 Apr 2025 08:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xh3Crk7c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8178D529
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745482669; cv=none; b=LTzDsz3fyLYU42igD+bvbH38a5E3nFE9hoJDS54LxVepUqcmbx2N0BLZKmlPmKBWk7Bsw4g/EuCl2i5nX4HdE9D0uGjVrd2H7oTgsswv3m00HtDTW6ykhYv2QDUot55tT2cU5+VMb2diva5lTQEQ5bt1I61oj3O8roWV4ggORr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745482669; c=relaxed/simple;
	bh=mtYa619WJaIjkVS6EBoexqG+IimlWzorRTe7Wk42SY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YjsHIXUO8XNCQB3+VwVj621oo5Z4kMJt2dRyHCt8QnGBycvPSDA3TOsdlEALSkZjFaPm5Yuwtsc65bJh/G0IRAtQA+T8E1OaOViafOQ/to8/W0yVX5/zrn1NcCZvl8OnkBABt2639blaUGAU0lUYd7ENSLCunKXWM1IL8l7VVXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xh3Crk7c; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745482668; x=1777018668;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mtYa619WJaIjkVS6EBoexqG+IimlWzorRTe7Wk42SY4=;
  b=Xh3Crk7cLCGpJi27I2G0QGY+51nvPKifIDGit4VtyK6XrvtAf6ib2YQi
   G0g8SXZ9z4YeMg9r3P7pO0HEJnhkgum45w5VkjugHLhL1l49Bym1q24X+
   IsAGIhsV+8DsJUgh/Tds/wTjx9rxyZImOavxPXsTaq1jWY/IPGelhkxL2
   csQC9onnLc+0UBgJc5nioFNFYkG6l8QT3zquGwSO836VsLgQdf5WH/Sy7
   JrxtgfPkGoqy/0oOirWmny92h9gBSnB2Sn9iOd9LXzudJWEFYCfz/NGim
   qTuJIrLVQ2VHjBpJlFIUOYIhHd25ff8tBTsdh9Oj2DsKywhCdPGed+q+S
   g==;
X-CSE-ConnectionGUID: EmmdT4pfS1Cp5sAXWhC3Hw==
X-CSE-MsgGUID: pf3CJAT+QlSqOLsysrf+uQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="57751491"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="57751491"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:17:47 -0700
X-CSE-ConnectionGUID: H5wE5xOYT8y6Safq7OTS6g==
X-CSE-MsgGUID: 48Uunm39R1qZjQcrQ1tj/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="163526100"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:17:37 -0700
Message-ID: <c800f523-2b1e-4f0a-b553-eb5a717e617b@linux.intel.com>
Date: Thu, 24 Apr 2025 16:17:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] i386/kvm: Support fixed counter in KVM PMU filter
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Eric Auger <eauger@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-6-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250409082649.14733-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/9/2025 4:26 PM, Zhao Liu wrote:
> KVM_SET_PMU_EVENT_FILTER of x86 KVM allows user to configure x86 fixed
> function counters by a bitmap.
>
> Add the support of x86-fixed-counter in kvm-pmu-filter object and handle
> this in i386 kvm codes.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
> Changes since RFC v2:
>  * Drop KVMPMUX86FixedCounter structure and use uint32_t to represent
>    bitmap in QAPI directly.
>  * Add Tested-by from Yi.
>  * Add documentation in qemu-options.hx.
>  * Bump up the supported QAPI version to v10.1.
>
> Changes since RFC v1:
>  * Make "action" as a global (per filter object) item, not a per-counter
>    parameter. (Dapeng)
>  * Bump up the supported QAPI version to v10.0.
> ---
>  accel/kvm/kvm-pmu.c      | 31 +++++++++++++++++++++++++++++++
>  include/system/kvm-pmu.h |  5 ++++-
>  qapi/kvm.json            |  6 +++++-
>  qemu-options.hx          |  6 +++++-
>  target/i386/kvm/kvm.c    | 39 ++++++++++++++++++++++++---------------
>  5 files changed, 69 insertions(+), 18 deletions(-)
>
> diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
> index 9205907d1779..509d69d9c515 100644
> --- a/accel/kvm/kvm-pmu.c
> +++ b/accel/kvm/kvm-pmu.c
> @@ -101,6 +101,29 @@ fail:
>      qapi_free_KvmPmuFilterEventList(head);
>  }
>  
> +static void kvm_pmu_filter_get_fixed_counter(Object *obj, Visitor *v,
> +                                             const char *name, void *opaque,
> +                                             Error **errp)
> +{
> +    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
> +
> +    visit_type_uint32(v, name, &filter->x86_fixed_counter, errp);
> +}
> +
> +static void kvm_pmu_filter_set_fixed_counter(Object *obj, Visitor *v,
> +                                             const char *name, void *opaque,
> +                                             Error **errp)
> +{
> +    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
> +    uint32_t counter;
> +
> +    if (!visit_type_uint32(v, name, &counter, errp)) {
> +        return;
> +    }
> +
> +    filter->x86_fixed_counter = counter;
> +}
> +
>  static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
>  {
>      object_class_property_add_enum(oc, "action", "KvmPmuFilterAction",
> @@ -116,6 +139,14 @@ static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
>                                NULL, NULL);
>      object_class_property_set_description(oc, "events",
>                                            "KVM PMU event list");
> +
> +    object_class_property_add(oc, "x86-fixed-counter", "uint32_t",
> +                              kvm_pmu_filter_get_fixed_counter,
> +                              kvm_pmu_filter_set_fixed_counter,
> +                              NULL, NULL);
> +    object_class_property_set_description(oc, "x86-fixed-counter",
> +                                          "Enablement bitmap of "
> +                                          "x86 PMU fixed counter");
>  }
>  
>  static void kvm_pmu_filter_instance_init(Object *obj)
> diff --git a/include/system/kvm-pmu.h b/include/system/kvm-pmu.h
> index 6abc0d037aee..5238b2b4dcc7 100644
> --- a/include/system/kvm-pmu.h
> +++ b/include/system/kvm-pmu.h
> @@ -19,10 +19,12 @@ OBJECT_DECLARE_SIMPLE_TYPE(KVMPMUFilter, KVM_PMU_FILTER)
>  
>  /**
>   * KVMPMUFilter:
> - * @action: action that KVM PMU filter will take for selected PMU events.
> + * @action: action that KVM PMU filter will take for selected PMU events
> + *    and counters.

Maybe more accurate "fixed counters".


>   * @nevents: number of PMU event entries listed in @events
>   * @events: list of PMU event entries.  A PMU event entry may represent one
>   *    event or multiple events due to its format.
> + * @x86_fixed_counter: bitmap of x86 fixed counter.
>   */
>  struct KVMPMUFilter {
>      Object parent_obj;
> @@ -30,6 +32,7 @@ struct KVMPMUFilter {
>      KvmPmuFilterAction action;
>      uint32_t nevents;
>      KvmPmuFilterEventList *events;
> +    uint32_t x86_fixed_counter;
>  };
>  
>  /*
> diff --git a/qapi/kvm.json b/qapi/kvm.json
> index 1b523e058731..5374c8340e5a 100644
> --- a/qapi/kvm.json
> +++ b/qapi/kvm.json
> @@ -115,7 +115,10 @@
>  #
>  # Properties of KVM PMU Filter.
>  #
> -# @action: action that KVM PMU filter will take for selected PMU events.
> +# @action: action that KVM PMU filter will take for selected PMU events
> +#     and counters.
> +#
> +# @x86-fixed-counter: enablement bitmap of x86 fixed counters.
>  #
>  # @events: list of selected PMU events.
>  #
> @@ -123,4 +126,5 @@
>  ##
>  { 'struct': 'KvmPmuFilterProperties',
>    'data': { 'action': 'KvmPmuFilterAction',
> +            '*x86-fixed-counter': 'uint32',
>              '*events': ['KvmPmuFilterEvent'] } }
> diff --git a/qemu-options.hx b/qemu-options.hx
> index bb89198971e0..eadfb69c8876 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -6150,7 +6150,7 @@ SRST
>  
>              (qemu) qom-set /objects/iothread1 poll-max-ns 100000
>  
> -    ``-object '{"qom-type":"kvm-pmu-filter","id":id,"action":action,"events":[entry_list]}'``
> +    ``-object '{"qom-type":"kvm-pmu-filter","id":id,"x86-fixed-counter":bitmap,"action":action,"events":[entry_list]}'``
>          Create a kvm-pmu-filter object that configures KVM to filter
>          selected PMU events for Guest.
>  
> @@ -6165,6 +6165,10 @@ SRST
>          will be denied, while all other events can be accessed normally
>          in the Guest.
>  
> +        The ``x86-fixed-counter`` parameter sets a bitmap of x86 fixed
> +        counters, and ``action`` will also take effect on the selected
> +        fixed counters.
> +
>          The ``events`` parameter accepts a list of PMU event entries in
>          JSON format. Event entries, based on different encoding formats,
>          have the following types:
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8786501e9c7e..8b916dbb5d6f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -6016,19 +6016,25 @@ static int kvm_install_pmu_event_filter(KVMState *s)
>          g_assert_not_reached();
>      }
>  
> -    kvm_filter->flags = filter->events->value->format ==
> -                        KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY ?
> -                        KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
> -
> -    if (kvm_filter->flags == KVM_PMU_EVENT_FLAG_MASKED_EVENTS &&
> -        !kvm_vm_check_extension(s, KVM_CAP_PMU_EVENT_MASKED_EVENTS)) {
> -        error_report("Masked entry format of PMU event "
> -                     "is not supported by Host.");
> -        goto fail;
> +    if (filter->x86_fixed_counter) {
> +        kvm_filter->fixed_counter_bitmap = filter->x86_fixed_counter;
>      }
>  
> -    if (!kvm_config_pmu_event(filter, kvm_filter)) {
> -        goto fail;
> +    if (filter->nevents) {
> +        kvm_filter->flags = filter->events->value->format ==
> +                            KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY ?
> +                            KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
> +
> +        if (kvm_filter->flags == KVM_PMU_EVENT_FLAG_MASKED_EVENTS &&
> +            !kvm_vm_check_extension(s, KVM_CAP_PMU_EVENT_MASKED_EVENTS)) {
> +            error_report("Masked entry format of PMU event "
> +                         "is not supported by Host.");
> +            goto fail;
> +        }
> +
> +        if (!kvm_config_pmu_event(filter, kvm_filter)) {
> +            goto fail;
> +        }
>      }
>  
>      ret = kvm_vm_ioctl(s, KVM_SET_PMU_EVENT_FILTER, kvm_filter);
> @@ -6656,16 +6662,19 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
>      KvmPmuFilterEventList *events = filter->events;
>      uint32_t base_flag;
>  
> -    if (!filter->nevents) {
> +    if (!filter->x86_fixed_counter && !filter->nevents) {
>          error_setg(errp,
>                     "Empty KVM PMU filter.");
>          return;
>      }
>  
>      /* Pick the first event's flag as the base one. */
> -    base_flag = events->value->format ==
> -                KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY ?
> -                KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
> +    base_flag = 0;
> +    if (filter->nevents &&
> +        events->value->format == KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY) {
> +        base_flag = KVM_PMU_EVENT_FLAG_MASKED_EVENTS;
> +    }
> +
>      while (events) {
>          KvmPmuFilterEvent *event = events->value;
>          uint32_t flag;

