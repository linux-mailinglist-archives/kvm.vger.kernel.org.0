Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF90954ED81
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 00:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379122AbiFPWpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 18:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378747AbiFPWpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 18:45:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E43562137;
        Thu, 16 Jun 2022 15:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655419539; x=1686955539;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TpDQFTxIwPwLxghpQ8wY+d4ntEb8GhUV1bicV27LoHU=;
  b=fdBCSvSFd9ia9jyuWDLDPjEveE/ixZK7Mfa7iljqn80NpO3uPzNlTesi
   0vMkX1+KNowQnlqrOkkhKvayvZYEhYQwgpcWCtfGROz081PgNTr0/Wy3f
   lGI63SxTeT+0Y1ZfyS8FSbiJjvBcGCk/k2t417tLnzBDnGTjkhh9Vx/V+
   snTtPD1wSe4cA8Xjp0Ayg4n1Rb88upUomrPxg1MscWOGAy7xG76feSHQF
   cQk8VKks1KiU8abFwz/380DBlk84/QmF9TU5jk/bzF2GK+X1Gq/0NCxl9
   yR4+f0nMx5edH818iwYWvMnO1M2JDMjFLDpl+LakgnZOCxUXpAzxcJgZY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="304817803"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="304817803"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 15:45:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="536618116"
Received: from krfox2-mobl.amr.corp.intel.com (HELO [10.209.46.80]) ([10.209.46.80])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 15:45:36 -0700
Message-ID: <d8278c53-71fd-3400-9ba6-079c99d66645@intel.com>
Date:   Thu, 16 Jun 2022 15:45:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] Documentation/x86: Add the AMX enabling example
Content-Language: en-US
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com
Cc:     corbet@lwn.net, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
 <20220616212210.3182-2-chang.seok.bae@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220616212210.3182-2-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +  1. **Check the feature availability**. AMX_TILE is enumerated in CPUID
> +     leaf 7, sub-leaf 0, bit 24 of EDX. If available, ``/proc/cpuinfo``
> +     shows ``amx_tile`` in the flag entry of the CPUs.  Given that, the
> +     kernel may have set XSTATE component 18 in the XCR0 register. But a
> +     user needs to ensure the kernel support via the ARCH_GET_XCOMP_SUPP
> +     option::

Why did you bother mentioning the XCR0 and CPUID specifics?  We don't
want applications doing that, right?

> +        #include <asm/prctl.h>
> +        #include <sys/syscall.h>
> +	#include <stdio.h>
> +        #include <unistd.h>

^ Just from the appearance here there looks to be some spaces vs. tabs
inconsistency.

> +        #define ARCH_GET_XCOMP_SUPP  0x1021
> +
> +        #define XFEATURE_XTILECFG    17
> +        #define XFEATURE_XTILEDATA   18
> +        #define XFEATURE_MASK_XTILE ((1 << XFEATURE_XTILECFG) | (1 << XFEATURE_XFILEDATA))
> +
> +        unsigned long features;
> +        long rc;
> +
> +        ...
> +
> +        rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_SUPP, &features);
> +
> +        if (!rc && features & XFEATURE_MASK_XTILE == XFEATURE_MASK_XTILE)
> +            printf("AMX is available.\n");
> +
> +  2. **Request permission**. Now it is found that the kernel supports the
> +     feature. But the permission is not automatically given. A user needs
> +     to explicitly request it via the ARCH_REQ_XCOMP_PERM option::

That phrasing is a bit awkward.  How about:

	After determining support for AMX, an application must
	explicitly ask permission to use it:
	...

> +        #define ARCH_REQ_XCOMP_PERM  0x1023
> +
> +        ...
> +
> +        rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_PERM, XFEATURE_XTILEDATA);
> +
> +        if (!rc)
> +            printf("AMX is ready for use.\n");
> +
> +Note this example does not include the sigaltstack preparation.
> +
>  Dynamic features in signal frames
>  ---------------------------------
>  

