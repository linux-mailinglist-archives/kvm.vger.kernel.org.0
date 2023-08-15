Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6BB77C8FA
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 09:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbjHOH5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 03:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235559AbjHOH5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 03:57:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C9D1998;
        Tue, 15 Aug 2023 00:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692086225; x=1723622225;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/NkiRYZP9eKoasAmY8ofGjnYrdzKcs4bAEe0YJR/m08=;
  b=LUbjgZACW8lmcg8FC5PZP9TTReH56mY/zOU2gb0pD/Xlr10AU9Nn2Fy9
   HLVATNcr9NMkBlrIxiVC9TmLR1MoB9qdC7nSeFuWRAs+BQ2Tx5JfD+T3p
   p/7Ds+IR/iLo0P/ReduOBQ2NHXMG06hXcg9Ca1bhQ+VOo7ntV8Ub6O34X
   AU+egRx4sDvvhj8wQmsrCnn6YlAYgDrQqzII//US6KGe65KsistVtoSup
   2pT2HkW7LW0jf+hkaM3QFw7ahF8QAnkvJIvHyZlFxDu/nXV+lPwggauK4
   XHh5TBGdsfktigKLKgfqQIMdHxi3FjFGbnKIBYOJz4d5/NcSM+ASDzEcd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="357190613"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="357190613"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 00:57:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="736830708"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="736830708"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 00:57:00 -0700
Message-ID: <f7784e00-c3ab-8e6b-b241-c6aaff824944@intel.com>
Date:   Tue, 15 Aug 2023 15:56:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v15 018/115] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
 <e84e0b8e16cf7cd573a8a10a8903689fb9cda713.1690322424.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e84e0b8e16cf7cd573a8a10a8903689fb9cda713.1690322424.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/2023 6:13 AM, isaku.yamahata@intel.com wrote:
...
> +static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx_capabilities __user *user_caps;
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	struct kvm_tdx_capabilities *caps = NULL;
> +	int ret;

needs to initialize ret to 0; otherwise it returns random value on success.

> +
> +	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> +		     sizeof(struct tdx_cpuid_config));
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	tdsysinfo = tdx_get_sysinfo();
> +	if (!tdsysinfo)
> +		return -EOPNOTSUPP;
> +
> +	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
> +	if (!caps)
> +		return -ENOMEM;
> +
> +	user_caps = (void __user *)cmd->data;
> +	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (caps->nr_cpuid_configs < tdsysinfo->num_cpuid_config) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	*caps = (struct kvm_tdx_capabilities) {
> +		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
> +		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
> +		.xfam_fixed0 = tdsysinfo->xfam_fixed0,
> +		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
> +		.supported_gpaw = TDX_CAP_GPAW_48 |
> +		(kvm_get_shadow_phys_bits() >= 52 &&
> +		 cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0,
> +		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
> +		.padding = 0,
> +	};
> +
> +	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +	if (copy_to_user(user_caps->cpuid_configs, &tdsysinfo->cpuid_configs,
> +			 tdsysinfo->num_cpuid_config *
> +			 sizeof(struct tdx_cpuid_config))) {
> +		ret = -EFAULT;
> +	}
> +
> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(caps);
> +	return ret;
> +}

