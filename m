Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9226A7196
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 17:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCAQ4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 11:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCAQ4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 11:56:21 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD023C79B;
        Wed,  1 Mar 2023 08:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677689778; x=1709225778;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8NEWTaD5RnYbcKDVZrq2Ew/2DFfHh2dyMO/xAIfd+2Q=;
  b=EP37rrPt80qPF9xzYZsfwsYu0f3YnL2SyOuBG52Nhu2Ws3aGYSJWYMH0
   6s5d4yR7e3q6Y2heNX401vI4t3vItsjD3HMixW807cXMVlt06wQj4xZxK
   Zpq6mf1vRRjfe14XZTRW87nzlBTUnWdXzFMkR7mDDaTZsaZeu20QC96Ea
   Dx1uJ7cvn49RG5keoPaOvSMjL6uQpZkPckfBIbMbunNyP7KTirATOMetX
   EZfVodjcIxFiWlZKH+6wd4b0jsAbHxrPImqeVGcaHFrWA2uHoZV5xqVLM
   9HEvdUX5m/gJtQj1hGXFTQuDq6qCGckkyFiz/Y0Srzk8wnJofF+280yRJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="314881610"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="314881610"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:56:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="738700170"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="738700170"
Received: from asaha3-mobl1.amr.corp.intel.com (HELO [10.251.12.67]) ([10.251.12.67])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:56:06 -0800
Message-ID: <f2c904f6-996a-e903-5d56-662781567578@intel.com>
Date:   Wed, 1 Mar 2023 08:56:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 00/56] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
References: <20230220183847.59159-1-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 10:37, Michael Roth wrote:
> The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
> access requires an RMP check. In particular, the read accesses from the
> hypervisor do not require RMP checks because the data confidentiality is
> already protected via memory encryption. When hardware encounters an RMP
> checks failure, it raises a page-fault exception. If RMP check failure
> is due to the page-size mismatch, then split the large page to resolve
> the fault.

What does this all _mean_?

When does the kernel need to care about a "page-size mismatch"?
