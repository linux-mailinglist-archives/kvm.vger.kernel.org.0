Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314E455A226
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 21:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiFXTsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 15:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiFXTsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 15:48:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1087A184;
        Fri, 24 Jun 2022 12:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656100116; x=1687636116;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0E014tMEBmKUv8vgwUApz1bQxiczytPVlzeSP22jNd4=;
  b=CSMU01QvYGDbgjxmbYu8fsAaS4TcT7jEKuXwMPIVDUmg+8D6ETOQ9BnI
   dBayZE5RkUebyV2cT9seWqc6ESRKoH49Y9nWqWNxj0wBfv02zqePremHF
   mH4DbKqU8WDGIEVvvMacQ0KihYVp8Iwd6z7GeWjFjoH46yEbosvOpmNlK
   jQGWwiKHBSRqqlPjncxAMIP+97KrZRXlIHZpbv5r7xLljikn/7GtXS3Vk
   LA12lFE4PnYXayjg6K3lYXYFvioI2bl/uVJhGngdB4gze9SiVKrdE56yw
   /FUTcOwZ02EwajBLXaRwVHy0jRpAQxDQRroNjfzBIf8DXW9dL+xmT96BW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="279841043"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="279841043"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 12:48:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="731447076"
Received: from mdedeogl-mobl.amr.corp.intel.com (HELO [10.209.126.186]) ([10.209.126.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 12:48:31 -0700
Message-ID: <14e3d8cb-5e36-dc90-bfc8-b34a105749a3@intel.com>
Date:   Fri, 24 Jun 2022 12:47:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 00/22] TDX host kernel support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-acpi@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, akpm@linux-foundation.org,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        rdunlap@infradead.org, Jason@zx2c4.com, juri.lelli@redhat.com,
        mark.rutland@arm.com, frederic@kernel.org, yuehaibing@huawei.com,
        dongli.zhang@oracle.com
References: <cover.1655894131.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 04:15, Kai Huang wrote:
> Please kindly help to review, and I would appreciate reviewed-by or
> acked-by tags if the patches look good to you.

Serious question: Is *ANYONE* looking at these patches other than you
and the maintainers?  I first saw this code (inside Intel) in early
2020.  In that time, not a single review tag has been acquired?

$ egrep -ic 'acked-by:|reviewed-by:' kais-patches.mbox
0
