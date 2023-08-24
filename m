Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1A47868E8
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbjHXHuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbjHXHuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:50:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7505210F5
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 00:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692863414; x=1724399414;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tCIikIPhcQYCsRzjrCmHh/ppXNZOuvNBYjiHui7HL80=;
  b=H4BI4nzTPvLzTS6lEdkSARzxu+QZBKGxjR72hva+V6nHRii7ao3v9aph
   jAdfSE+/Ir8K7WrLePQWTqPUF2h8sTh1lzIaKbHpaNtYfc53H/xxn5MPE
   Kks9pJqJzJn0X932Kx/u56cEWS3Q+AizT24Cj/OfCh34vujHr3FKXMdny
   9fYxfG4WB1EbgrmtWthPMlJSMWYCn6vu/vR0i9++O8/YSy0MMP9JDfYnc
   6HKisTLFd+W+ZGAj86GZcgVD94vtUH9LMogy5jh+SJs4CgqZs3nORZeYK
   MYohuLJzbYu3X6IQb21vTMivKQIEKfQy4jskb6qlBEuJRikAyFrnavtlU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="377100560"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="377100560"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:50:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="736953081"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="736953081"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.81]) ([10.93.16.81])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:50:06 -0700
Message-ID: <48444107-d240-059b-a231-cddb085e4adf@intel.com>
Date:   Thu, 24 Aug 2023 15:50:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 33/58] headers: Add definitions from UEFI spec for
 volumes, resources, etc...
To:     Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>,
        isaku.yamahata@intel.com
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-34-xiaoyao.li@intel.com>
 <20230823194114.GE3642077@ls.amr.corp.intel.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230823194114.GE3642077@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/2023 3:41 AM, Isaku Yamahata wrote:
> On Fri, Aug 18, 2023 at 05:50:16AM -0400,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> Add UEFI definitions for literals, enums, structs, GUIDs, etc... that
>> will be used by TDX to build the UEFI Hand-Off Block (HOB) that is passed
>> to the Trusted Domain Virtual Firmware (TDVF).
>>
>> All values come from the UEFI specification and TDVF design guide. [1]
>>
>> Note, EFI_RESOURCE_MEMORY_UNACCEPTED will be added in future UEFI spec.
>>
>> [1] https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf
> 
> Nitpick: The specs [1] [2] include unaccepted memory.

EfiUnacceptedMemoryType shows in UEFI spec while 
EFI_RESOURCE_MEMORY_UNACCEPTED is still missing in PI spec.

https://github.com/tianocore/edk2/commit/00bbb1e584ec05547159f405cca383e8ba5e4ddb

> [1] UEFI Specification Version 2.10 (released August 2022)
> [2] UEFI Platform Initialization Distribution Packaging Specification Version 1.1)

