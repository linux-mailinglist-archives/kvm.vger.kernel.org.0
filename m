Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4246B761D
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 12:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjCMLhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 07:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCMLhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 07:37:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2594449DA;
        Mon, 13 Mar 2023 04:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678707470; x=1710243470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R9bhcQY8H1oALSIz4P7Cb9C+b3hkGqYXKDdE7/Y++SE=;
  b=VScoet3wWS1iYrzBvOxeYYxTZH1cQ88XOleVLdE90nnYPUpFbhFjYN56
   xDD5HR+9EkWbOAYCV35ZAXSQXOK5Vus9VI3OVOCR2cdD42OxX2reHUxni
   j/kY3vacO+0qvGk61KMdeOrTjV8lxxMGvfl5DckpJOFQRj0nngAy4rcN2
   jBwmtZkY2OT6jYeNDy2zTI0AKW9GIQL5km7nE3JmRE8RAPRJGmIQHuoep
   XS3k6VhIjAyA9zTTJzskdHbniisaZsKtlcS7g9/Hii0rrjC53iDdN1l+D
   2TNr+NIYVypdTfdRzFj5sDlpTsxMhTeSxyYhrj1R6aJdVDTvThT90icA+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316771068"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="316771068"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 04:37:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="671867179"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="671867179"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.213.42]) ([10.254.213.42])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 04:37:46 -0700
Message-ID: <b0c8af03-882c-e675-8397-5b6f843fa4df@intel.com>
Date:   Mon, 13 Mar 2023 19:37:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v13 009/113] KVM: TDX: Define TDX architectural
 definitions
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <1e73822eacaa512aeb559a3f3b71ae4963bf9fdd.1678643052.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1e73822eacaa512aeb559a3f3b71ae4963bf9fdd.1678643052.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/13/2023 1:55 AM, isaku.yamahata@intel.com wrote:
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> new file mode 100644
> index 000000000000..942a0e561a7b
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
...
> +
> +#define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO		0x10000
> +#define TDG_VP_VMCALL_MAP_GPA				0x10001
> +#define TDG_VP_VMCALL_GET_QUOTE				0x10002
> +#define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
> +#define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004

TDX guest side implementation defines

     /* TDX hypercall Leaf IDs */
     #define TDVMCALL_MAP_GPA			0x10001
     #define TDVMCALL_REPORT_FATAL_ERROR		0x10003

We need put these shared definitions between host and guest into some 
shared header file.
