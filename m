Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC417AA61F
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 02:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjIVAgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 20:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjIVAgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 20:36:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58A318F
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 17:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695342957; x=1726878957;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yz/UzV6kHqKGL5M88pH/K0nRDaCXriDTqQPkONdxErU=;
  b=FBaqPYkdQl6yK2rBdX6zH/UoOLwqgkvMoCPotVQLdeWNnor4GjlkKRlv
   G8lNUN0NzpRNel9dd5V9heFlYrrXi3B3RgG+74ty8f2zwZ46OcamdjeEH
   yKXDply6MNOG6NpWGitwSr8ktjUj6Wxbm2kJgsd893kMjim1ospSPl+xF
   A11zaTrdm1H9fb332SWq1msnJMAIXJzyij8fzuh+kd42lAN5JSyt00JnC
   WGUeAlFyGgfv14D3lFHCNlvuz3dxB0/+fAfNpy06KYwSRs3mFzQyxo5ce
   JHX7hRmTlHFuZWS9rXvE+nleXD98ZUQNGA+lABewjMiADdaktgAjABlGf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="365764651"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="365764651"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:24:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="862721080"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="862721080"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.11.250]) ([10.93.11.250])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:24:20 -0700
Message-ID: <11ada91d-4054-2ce9-9a3b-4d182106e860@intel.com>
Date:   Fri, 22 Sep 2023 08:24:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 07/21] i386/pc: Drop pc_machine_kvm_type()
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-8-xiaoyao.li@intel.com>
 <b5ebeeac-9f0f-eb57-b5e2-4c03698e5ee4@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <b5ebeeac-9f0f-eb57-b5e2-4c03698e5ee4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/2023 4:51 PM, David Hildenbrand wrote:
> On 14.09.23 05:51, Xiaoyao Li wrote:
>> pc_machine_kvm_type() was introduced by commit e21be724eaf5 ("i386/xen:
>> add pc_machine_kvm_type to initialize XEN_EMULATE mode") to do Xen
>> specific initialization by utilizing kvm_type method.
>>
>> commit eeedfe6c6316 ("hw/xen: Simplify emulated Xen platform init")
>> moves the Xen specific initialization to pc_basic_device_init().
>>
>> There is no need to keep the PC specific kvm_type() implementation
>> anymore.
> 
> So we'll fallback to kvm_arch_get_default_type(), which simply returns 0.
> 
>> On the other hand, later patch will implement kvm_type()
>> method for all x86/i386 machines to support KVM_X86_SW_PROTECTED_VM.
>>
> 
> ^ I suggest dropping that and merging that patch ahead-of-time as a 
> simple cleanup.

I suppose the "that" here means "this patch", right?

If so, I can submit this patch separately.

> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

