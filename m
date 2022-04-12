Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017E64FD1EC
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 09:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351190AbiDLHJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 03:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353186AbiDLHHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 03:07:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B54949CB6;
        Mon, 11 Apr 2022 23:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649746177; x=1681282177;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6Vrf9v/aelxqJtAMQ3CWYcL1rqDUMznv81Ys5xCr/Hg=;
  b=QaeWB0b6U8PxPsmgkiEe8yPlu7A1KNOyjXAx6NwcTh5aai5xnY0qLIMY
   e+oTfIiALftW4ei02RkUfH/7GdYxybtCyJKhyUAfJ4akEZjkKOwA+Q5Ct
   5i/rYuhE1zxYKMKcndo4dGLc6bXQ7w/MznSydNqsW+YkFRvB/jw+1FFxf
   MwSDM9hWvtDYFhKbRFPQJ5ETXW43MLdrwcRX0YLpT6ZyPku4JbuCv3xZn
   iByeYZBIpo59MVDcr7OhJLMWS5x03v63VU+B5mw4Mz96hVbr6UTlybwrD
   mmL29l5gMcedxxQS8GuNXKoOmfs70uIT+S99PrvaYlYUN2Hm6OuF53Fsd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="242231184"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="242231184"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 23:49:25 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="551563763"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.239]) ([10.255.31.239])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 23:49:22 -0700
Message-ID: <ec60ba8e-3ed9-1d06-d8c2-4db9529daf93@intel.com>
Date:   Tue, 12 Apr 2022 14:49:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 102/104] KVM: TDX: Add methods to ignore accesses
 to CPU state
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <3a278829a8617b86b36c32b68a82bc727013ace8.1646422845.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <3a278829a8617b86b36c32b68a82bc727013ace8.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/5/2022 3:49 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX protects TDX guest state from VMM.  Implements to access methods for
> TDX guest state to ignore them or return zero.
> 

...

> +void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> +{
> +	kvm_register_mark_available(vcpu, reg);
> +	switch (reg) {
> +	case VCPU_REGS_RSP:
> +	case VCPU_REGS_RIP:
> +	case VCPU_EXREG_PDPTR:
> +	case VCPU_EXREG_CR0:
> +	case VCPU_EXREG_CR3:
> +	case VCPU_EXREG_CR4:
> +		break;
> +	default:
> +		KVM_BUG_ON(1, vcpu->kvm);
> +		break;
> +	}
> +}

Isaku,

We missed one case that some GPRs are accessible by KVM/userspace for 
TDVMCALL exit.
