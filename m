Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7E60FBFB
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiJ0Pbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbiJ0Pba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:31:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A5572EF6;
        Thu, 27 Oct 2022 08:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666884689; x=1698420689;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lVOCRVi28t80YbE9BOPdmWO5P2frCwjii9hGrK7ApE0=;
  b=UFp3F+lGqlXF2t9LpNUvKuYnWks4Vu3lcQSZHK8RoqzZtponzof/QULE
   X7oKSXFAfMGaR0fzYAMyseUUsoKLenaiNULM5TLzpaKtLmaouVcJA9qrE
   qs2Ix3WSRE2ruH66ha5ZWezIWAPjJQaO8jY54XZs+OcZjxI4aycIgd6Xx
   W0UQ1zh4p4XWYQ4WSR20yOCuEIkAAlmodfTnwQRTy5W2rAfMzmYHfPiZN
   RPL0S1E/MlfJZME2p5x/JJA0M0QR931BzOSNJhJ1DhhELVibWxu2LXZit
   A+BoU0ad83Lz66S32hleoM+TQ4ecxpZWdd/IhnoCq8hrvdcU+fRgpHw0r
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="287972459"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="287972459"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 08:31:26 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="961663589"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="961663589"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.251.5.115]) ([10.251.5.115])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 08:31:22 -0700
Message-ID: <f6d0b10a-94be-ff33-9742-058469078380@linux.intel.com>
Date:   Thu, 27 Oct 2022 08:31:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <fe0e1a1133166ca4008840cd1a5959fa70632f07.1666824663.git.kai.huang@intel.com>
From:   Andi Kleen <ak@linux.intel.com>
In-Reply-To: <fe0e1a1133166ca4008840cd1a5959fa70632f07.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +/* Calculate the actual TDMR_INFO size */
> +static inline int cal_tdmr_size(void)
> +{
> +	int tdmr_sz;
> +
> +	/*
> +	 * The actual size of TDMR_INFO depends on the maximum number
> +	 * of reserved areas.
> +	 */
> +	tdmr_sz = sizeof(struct tdmr_info);
> +	tdmr_sz += sizeof(struct tdmr_reserved_area) *
> +		   tdx_sysinfo.max_reserved_per_tdmr;


would seem safer to have a overflow check here.


