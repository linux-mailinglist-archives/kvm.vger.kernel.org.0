Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2C8547DAE
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 04:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiFMCsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jun 2022 22:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238022AbiFMCsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jun 2022 22:48:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435A235DDE;
        Sun, 12 Jun 2022 19:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655088482; x=1686624482;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Id3r50KAC6n1LQmSYAGmS0BHouJosblSAvLJLDDRodg=;
  b=MEhHbBzC+e2QJkoGLxZ3H6HSFod3clYLfpFowd9caCRX9msKezT4hMMD
   sMfn3JeyE5xshIJSQppJqTG5Rv1fl3Va4o1o+bRkYSlfsWOdirtr+MTN1
   jZlDBT9Ffa/aAQhKohIq42MUGCQZBu/Qu58o9E3Zd/8tLAaMPxFifAXvf
   IQyd9/cDL+3wCiLv8bbMePTt6cTtiiOPA0mN7NBWVJ3Zw1j38jktxZqBY
   NFLsYUZ/RVXiYjv1pBOzpqy1viSoHSVSC1pGdVbi3ZGKfNw2NSn3FsXa3
   wCNbmDsCRKtPxBIKDXxDu14wUeolMPRa/g9OnkpYuMz6dlzeKbYJ/SiNW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="279193278"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="279193278"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 19:48:00 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="639447922"
Received: from xiaoxiax-mobl1.ccr.corp.intel.com (HELO [10.249.173.95]) ([10.249.173.95])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 19:47:56 -0700
Message-ID: <66c1cf3a-9f2a-e05a-3c76-62b1ee056385@intel.com>
Date:   Mon, 13 Jun 2022 10:47:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH] KVM: x86/mmu: Remove unused "type" of split_page_type()
Content-Language: en-US
To:     sunliming <sunliming@kylinos.cn>, isaku.yamahata@intel.com,
        pbonzini@redhat.com, seanjc@google.com, mingo@kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kelulanainsley@gmail.com, x86@kernel.org,
        kernel test robot <lkp@intel.com>
References: <20220612035641.1161945-1-sunliming@kylinos.cn>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220612035641.1161945-1-sunliming@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/12/2022 11:56 AM, sunliming wrote:
> The variable 'type' in split_page_type() is set but not used, so remove
> it.
> 
> Fixes the following w1 warning:
> 
> arch/x86/kvm/mmu/mmu.c:982:28: warning: variable 'type' set but not used [-Wunused-but-set-variable]

Please note, the code doesn't get into upstream yet.

The fix shouldn't be sent to upstream maillist.

> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: sunliming <sunliming@kylinos.cn>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7b3df91a93cf..f4d577335f94 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -979,14 +979,12 @@ static void split_page_type(gfn_t gfn, struct kvm_memory_slot *slot,
>   			    enum pg_level level)
>   {
>   	struct kvm_page_attr *page_attr = page_attr_slot(gfn, slot, level);
> -	enum kvm_page_type type;
>   	gfn_t base_gfn;
>   
>   	if (WARN_ON_ONCE(!kvm_page_type_valid(page_attr) || level <= PG_LEVEL_4K))
>   		return;
>   
>   	base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
> -	type = page_attr->type;
>   
>   	/*
>   	 * Set the type to KVM_PAGE_TYPE_MIXED in advance since when a large

