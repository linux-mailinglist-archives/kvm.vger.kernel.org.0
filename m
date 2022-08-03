Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E90758860D
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 05:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiHCDlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 23:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiHCDlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 23:41:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5BD1D0FF;
        Tue,  2 Aug 2022 20:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659498062; x=1691034062;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/PpJ9OOIYmw8GdhYc+SyoE4NEN+x7pnsx7eNU1nhOoU=;
  b=CDrgzsfyz6yDSbUOIsB9jCorTJ+zMGUHPC1HcX0rY4zPT6OX10E94bkC
   frApt9N19UUczUiYeU64DNkFOLvdannerZRqc887FmfOFhz3qiRIktiX+
   PX1vQ6HzfabInHCaNVbwvCsvcHGqLmba1e/DeLgJ2rtVWGJGQiuo21Cvc
   yjSak24MdvUXFQQWAbYR5jMlnjYtWvLd7dX8xSi94E2ttlxAFr3NzKb2f
   WVerMcmFArA1O5MPr0so5qOfCKJI+Ge7FPBCBaTrGYULBPe2zZPN7voYm
   ONDufsYVlPiDT252yOrQ5Mo2tmay7u+asJ7ZPpNZxLXq0c+4k+XTKSe0J
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="269954305"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="269954305"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 20:41:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="661901185"
Received: from wmoon-mobl.gar.corp.intel.com (HELO [10.255.29.176]) ([10.255.29.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 20:40:56 -0700
Message-ID: <041f2d03-c32f-c578-f714-5b01bb8bc46b@linux.intel.com>
Date:   Wed, 3 Aug 2022 11:40:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
To:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, rdunlap@infradead.org, Jason@zx2c4.com,
        juri.lelli@redhat.com, mark.rutland@arm.com, frederic@kernel.org,
        yuehaibing@huawei.com, dongli.zhang@oracle.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
 <43a67bfe-9707-33e0-2574-1e6eca6aa24b@intel.com>
 <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <5ebd7c3cfb3ab9d77a2577c4864befcffe5359d4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/6/27 13:05, Kai Huang wrote:
> On Fri, 2022-06-24 at 11:57 -0700, Dave Hansen wrote:
>> On 6/22/22 04:15, Kai Huang wrote:
>>> Platforms with confidential computing technology may not support ACPI
>>> CPU hotplug when such technology is enabled by the BIOS.  Examples
>>> include Intel platforms which support Intel Trust Domain Extensions
>>> (TDX).
>>>
>>> If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
>>> bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
>>> bug and reject the new CPU.  For hot-removal, for simplicity just assume
>>> the kernel cannot continue to work normally, and BUG().
>> So, the kernel is now declaring ACPI CPU hotplug and TDX to be
>> incompatible and even BUG()'ing if we see them together.  Has anyone
>> told the firmware guys about this?  Is this in a spec somewhere?  When
>> the kernel goes boom, are the firmware folks going to cry "Kernel bug!!"?
>>
>> This doesn't seem like something the kernel should be doing unilaterally.
> TDX doesn't support ACPI CPU hotplug (both hot-add and hot-removal) is an
> architectural behaviour.  The public specs doesn't explicitly say  it, but it is
> implied:
>
> 1) During platform boot MCHECK verifies all logical CPUs on all packages that
> they are TDX compatible, and it keeps some information, such as total CPU
> packages and total logical cpus at some location of SEAMRR so it can later be
> used by P-SEAMLDR and TDX module.  Please see "3.4 SEAMLDR_SEAMINFO" in the P-
> SEAMLDR spec:
>
> https://cdrdv2.intel.com/v1/dl/getContent/733584
>
> 2) Also some SEAMCALLs must be called on all logical CPUs or CPU packages that
> the platform has (such as such as TDH.SYS.INIT.LP and TDH.SYS.KEY.CONFIG),
> otherwise the further step of TDX module initialization will fail.
>
> Unfortunately there's no public spec mentioning what's the behaviour of ACPI CPU
> hotplug on TDX enabled platform.  For instance, whether BIOS will ever get the
> ACPI CPU hot-plug event, or if BIOS gets the event, will it suppress it.  What I
> got from Intel internally is a non-buggy BIOS should never report such event to
> the kernel, so if kernel receives such event, it should be fair enough to treat
> it as BIOS bug.
>
> But theoretically, the BIOS isn't in TDX's TCB, and can be from 3rd party..
>
> Also, I was told "CPU hot-plug is a system feature, not a CPU feature or Intel
> architecture feature", so Intel doesn't have an architectural specification for
> CPU hot-plug.
>
> At the meantime, I am pushing Intel internally to add some statements regarding
> to the TDX and CPU hotplug interaction to the BIOS write guide and make it
> public.  I guess this is the best thing we can do.
>
> Regarding to the code change, I agree the BUG() isn't good.  I used it because:
> 1) this basically on a theoretical problem and shouldn't happen in practice; 2)
> because there's no architectural specification regarding to the behaviour of TDX
> when CPU hot-removal, so I just used BUG() in assumption that TDX isn't safe to
> use anymore.

host kernel is also not in TDX's TCB either, what would happen if kernel 
doesn't
do anything in case of buggy BIOS? How does TDX handle the case to 
enforce the
secure of TDs?


>
> But Rafael doesn't like current code change either. I think maybe we can just
> disable CPU hotplug code when TDX is enabled by BIOS (something like below):
>
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -707,6 +707,10 @@ bool acpi_duplicate_processor_id(int proc_id)
>   void __init acpi_processor_init(void)
>   {
>          acpi_processor_check_duplicates();
> +
> +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED))
> +               return;
> +
>          acpi_scan_add_handler_with_hotplug(&processor_handler, "processor");
>          acpi_scan_add_handler(&processor_container_handler);
>   }
>
> This approach is cleaner I think, but we won't be able to report "BIOS bug" when
> ACPI CPU hotplug happens.  But to me it's OK as perhaps it's arguable to treat
> it as BIOS bug (as theoretically BIOS can be from 3rd party).
>
> What's your opinion?
>
