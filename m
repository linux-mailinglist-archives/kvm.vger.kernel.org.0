Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B1E5AA41A
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 02:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiIBAKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 20:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbiIBAKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 20:10:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888391A3A4
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 17:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662077406; x=1693613406;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lnu+YfjA5BVODcb7RD0uVkm1klwexqKt6aaFHvIhwl4=;
  b=Xrl0tr0yTWn9UAK39RTi9n7AI+BIOUVgzSQfaoOVQnVgAWh0JBHbmxG/
   8t/BzysoGyu+ZBf1xDX23K3F/FmKz9JYD0NNPqkvDaIztjDt98X9SfcIV
   gbvlKEr/MkJPTbYOqaIGubfvyUwEvc8F6tN4izdidHMKYxYsUUBqTFkYA
   PClnjTzVk7OniK2S87Ax+qDPG1MMoVraEDl7wQ7+OKbEqMk74lIOqM6JQ
   5RQWPNhSjTX4rfF9g21T7D05ax6cpsx5eZDYmXW1fM97LUJIxXcuT8lso
   upVPwwQc/ieW2N5eLrg9e3dWuAULANM7NM4dXZzGC5nuSA4n/cvrQy34H
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="296639034"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="296639034"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 17:10:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="642612565"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.28]) ([10.249.171.28])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 17:10:03 -0700
Message-ID: <34be4132-53f4-8779-1ada-68aa554e0eac@intel.com>
Date:   Fri, 2 Sep 2022 08:10:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
 <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
 <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/2022 12:17 AM, Gerd Hoffmann wrote:
> On Thu, Sep 01, 2022 at 10:36:19PM +0800, Xiaoyao Li wrote:
>> On 9/1/2022 9:58 PM, Gerd Hoffmann wrote:
>>
>>>> Anyway, IMO, guest including guest firmware, should always consult from
>>>> CPUID leaf 0x80000008 for physical address length.
>>>
>>> It simply can't for the reason outlined above.  Even if we fix qemu
>>> today that doesn't solve the problem for the firmware because we want
>>> backward compatibility with older qemu versions.  Thats why I want the
>>> extra bit which essentially says "CPUID leaf 0x80000008 actually works".
>>
>> I don't understand how it backward compatible with older qemu version. Old
>> QEMU won't set the extra bit you introduced in this series, and all the
>> guest created with old QEMU will become untrusted on CPUID leaf 0x80000008 ?
> 
> Correct, on old qemu firmware will not trust CPUID leaf 0x80000008.
> That is not worse than the situation we have today, currently the
> firmware never trusts CPUID leaf 0x80000008.
> 
> So the patches will improves the situation for new qemu only, but I
> don't see a way around that.
> 

I see.

But IMHO, I don't think it's good that guest firmware workaround the 
issue on its own. Instead, it's better to just trust CPUID leaf 
0x80000008 and fail if the given physical address length cannot be 
virtualized/supported.

It's just the bug of VMM to virtualize the physical address length. The 
correction direction is to fix the bug not the workaround to hide the bug.

