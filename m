Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7543858861B
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 05:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbiHCD4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 23:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiHCDz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 23:55:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCD61C132;
        Tue,  2 Aug 2022 20:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659498956; x=1691034956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yed2xDQxcr169RPtxD0uw3z2E263LSsDStAx8f8VF3c=;
  b=fi2oFDsNikcOF7QXdA7cKBdnFrofQugjsNDdhCWOsovzmuK4X4np/3lL
   NToq3Se/WY8EfBQAOkiV1I+ap7/3aR7OIYbZPA2mPVE+0gGQ+w+udU1kI
   8zrmP87Z7e7Ko1zfWxKY+QY2bwFaXbcrD+y94cU4gGJ12lGs8wAseEB1Y
   5IJrKX+PSgoMvlo/ERBiuOseSmkKygrdJaJ/uTICEKuEzgv8mn5dXVzxP
   c8Iune3jh3sQFtZa5Dx0hhAxmeHBLM5cMYX+AMZ/tXHJWb+BhBep2c0ly
   aea3ehSGLsGzvi+vmPkFj8DqG1ai9aI0cwjFggG+rO0P/UllQLErS151n
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="269955785"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="269955785"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 20:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="661904672"
Received: from wmoon-mobl.gar.corp.intel.com (HELO [10.255.29.176]) ([10.255.29.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 20:55:51 -0700
Message-ID: <27de096d-4386-fb46-fd6d-229bea7b7a4a@linux.intel.com>
Date:   Wed, 3 Aug 2022 11:55:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-acpi@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
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
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
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


On 2022/6/22 19:15, Kai Huang wrote:
>   
> @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *device,
>   	struct device *dev;
>   	int result = 0;
>   
> +	/*
> +	 * If the confidential computing platform doesn't support ACPI
> +	 * memory hotplug, the BIOS should never deliver such event to
memory or cpu hotplug?


> +	 * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> +	 * the new CPU.
> +	 */
> +	if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
> +		dev_err(&device->dev, "[BIOS bug]: Platform doesn't support ACPI CPU hotplug.  New CPU ignored.\n");
> +		return -EINVAL;
> +	}
> +
>   	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
>   	if (!pr)
>   		return -ENOMEM;
> @@ -434,6 +446,17 @@ static void acpi_processor_remove(struct acpi_device *device)
>   	if (!device || !acpi_driver_data(device))
>   		return;
>   
> +	/*
> +	 * The confidential computing platform is broken if ACPI memory
ditto


> +	 * hot-removal isn't supported but it happened anyway.  Assume
> +	 * it's not guaranteed that the kernel can continue to work
> +	 * normally.  Just BUG().
> +	 */
> +	if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
> +		dev_err(&device->dev, "Platform doesn't support ACPI CPU hotplug. BUG().\n");
> +		BUG();
> +	}
>
