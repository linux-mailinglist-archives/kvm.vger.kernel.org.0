Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0487786910
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbjHXHz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbjHXHzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:55:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D48F170D
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 00:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692863742; x=1724399742;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=zfT/KhKzo3z/OH6/SXYYDpwCJ6frnf7e+NMK432cYQw=;
  b=bYICqhRJJ+aBKlYMO+Bp2i3BZjWvfDHwjiZROR3Pk94nOK99Jq2JNMy2
   pLAhunwraTy3Oi9DNF5EcdsBmkkwR36/i9F1wVlynF3wlqLOItvOLfVd5
   v+YFQmeKTj4W9+ps4tZ0tw8Pop5/ArdfnfbSHuW/UnV6l4aArm96mlnxo
   eL48IfZ4j26wO3jx2wRb5V47IcTvmbIpWHm98crJbV1fMVAPTi6mKrsPs
   2gXNqonZvTBGRyyERdno2Du33V0OD/Cf5oe0GwmQP8ACYwfLPU/E9qvaZ
   H9BnRpXTWCa6T8jlmDa5eqfYFvdDW50YwVCbqq+IhFRYDm+JUdQmBncci
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="373255946"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="373255946"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:55:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="740074273"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="740074273"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.81]) ([10.93.16.81])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:55:35 -0700
Message-ID: <bc2eba9a-7467-3a27-9d72-f7cc4745f338@intel.com>
Date:   Thu, 24 Aug 2023 15:55:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 33/58] headers: Add definitions from UEFI spec for
 volumes, resources, etc...
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
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
 <48444107-d240-059b-a231-cddb085e4adf@intel.com>
In-Reply-To: <48444107-d240-059b-a231-cddb085e4adf@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/2023 3:50 PM, Xiaoyao Li wrote:
> On 8/24/2023 3:41 AM, Isaku Yamahata wrote:
>> On Fri, Aug 18, 2023 at 05:50:16AM -0400,
>> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>>> Add UEFI definitions for literals, enums, structs, GUIDs, etc... that
>>> will be used by TDX to build the UEFI Hand-Off Block (HOB) that is 
>>> passed
>>> to the Trusted Domain Virtual Firmware (TDVF).
>>>
>>> All values come from the UEFI specification and TDVF design guide. [1]
>>>
>>> Note, EFI_RESOURCE_MEMORY_UNACCEPTED will be added in future UEFI spec.
>>>
>>> [1] 
>>> https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf
>>
>> Nitpick: The specs [1] [2] include unaccepted memory.
> 
> EfiUnacceptedMemoryType shows in UEFI spec while 
> EFI_RESOURCE_MEMORY_UNACCEPTED is still missing in PI spec.
> 
> https://github.com/tianocore/edk2/commit/00bbb1e584ec05547159f405cca383e8ba5e4ddb

Sorry, I just find it shows in latest PI spec.

https://uefi.org/sites/default/files/resources/UEFI_PI_Spec_1_8_March3.pdf

>> [1] UEFI Specification Version 2.10 (released August 2022)
>> [2] UEFI Platform Initialization Distribution Packaging Specification 
>> Version 1.1)
> 
> 

