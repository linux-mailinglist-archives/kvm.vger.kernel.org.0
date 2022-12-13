Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4101364B24D
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 10:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbiLMJ0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 04:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiLMJ0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 04:26:31 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01793E7B;
        Tue, 13 Dec 2022 01:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670923589; x=1702459589;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g4HHmozB0c/Gxrb2im4SHD49OZ6P5iOH2HIs2pJo1SM=;
  b=Y28+WLVD0WX5ZbWvsEebCy+fZAxaFvXwNxkCUFpXOrB/zyCLqlr2SUS2
   fsX+mPtLBL9XiEURWKaoa9SpP9xyQdzY/DXGSBgclkIly5RvxarsEMcgf
   LZT9sFEVRkU5llqH+1JeHTteIsC2uxFV7NAtsE/42eHGiqqNVEhOr0Sj0
   +WQfZopjmCCsNqfnkULYAyNSQdS9OzUoY0AqtZkddJw1HteOZeugqp+jW
   b6aoVLdofe2VwUpFo5Lu4QdIlbJOXLzwltKvMIW7KtRWtctEbDFGWyqJT
   H+bcLXMTXWg99GGnItI8y46xc+iYSfeUiQQlUThV2H4zVqo7+WLWCDKSY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="297767582"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="297767582"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 01:26:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="598770587"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="598770587"
Received: from wangl2-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.214.204])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 01:26:27 -0800
Date:   Tue, 13 Dec 2022 17:26:25 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Use the common definition - 'GPA_INVALID' for
 X86
Message-ID: <20221213092534.tvmmhff6rvhhpefv@linux.intel.com>
References: <20221209023622.274715-1-yu.c.zhang@linux.intel.com>
 <Y5gTFPxUTXDsQb5p@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5gTFPxUTXDsQb5p@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 05:52:20AM +0000, Sean Christopherson wrote:
> What if we rename GPA_INVALID to INVALID_GPA and modify _those_ users?  I have
> a slight preference for INVALID_GPA, and we also have INVALID_PAGE.  It'll also
> yield a smaller diff.
> 
> EVMPTR_INVALID is the counter argument, but that's more of an error code than a
> semi-arbitrary value, e.g. there's also EVMPTR_MAP_PENDING.
> 
> $ git grep GPA_INVALID | wc -l
> 17
> $ git grep INVALID_GPA | wc -l
> 55
> 

Good point. Thanks!

B.R.
Yu
