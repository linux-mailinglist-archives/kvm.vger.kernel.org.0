Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477A56330F6
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 00:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiKUXsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 18:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiKUXsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 18:48:32 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A762E2;
        Mon, 21 Nov 2022 15:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669074498; x=1700610498;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3QFhYCGVIFGfzM0P2JRBlzSrAHp6vmlTph1ySfJVank=;
  b=MZf/0dZzLa/x0luX+z1YUY2W9qnTQtUPQ1cjbBuD39IpJcCyWSrdeMzr
   3e2Z0Eu9VHnfwD6Jp/b9s7FNtjktJhv7SfN5DsdKYzX4Vms/88QKArQeC
   ClKYnLZUyBKUzQAsTuKgeLYL3SJr7EzNQZp27H5xOPMMYYe/9YLgkaNJQ
   lkBanKPR1Vcd0MkmdGLwCvKmJU6WTuN6CtsHd/Ku9QAyQ0SvVLPkzoMVl
   mh46HB421z0AofApVhNv3uJ1Kol/lPWrlYo4Uz43UUyUOSK2oeaNPPqP/
   ntmfKCltp1mh6smkam1GUQ+V/gsEBLfoWHyLeGs+v4HedYMoYQZKXGfUm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="301236422"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="301236422"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:48:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="747109675"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="747109675"
Received: from ticela-or-327.amr.corp.intel.com (HELO [10.209.6.63]) ([10.209.6.63])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:48:10 -0800
Message-ID: <6260c853-3c6c-7302-677e-1910918c69b7@intel.com>
Date:   Mon, 21 Nov 2022 15:48:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> +/*
> + * TDX supported page sizes (4K/2M/1G).
> + *
> + * Those values are part of the TDX module ABI.  Do not change them.
> + */
> +#define TDX_PS_4K	0
> +#define TDX_PS_2M	1
> +#define TDX_PS_1G	2

That comment can just be:

/* TDX supported page sizes from the TDX module ABI. */

I think folks understand that the kernel can't willy nilly change ABI
values.
