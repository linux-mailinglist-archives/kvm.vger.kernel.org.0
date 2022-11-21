Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567BB6318BB
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 03:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiKUCw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 21:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKUCw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 21:52:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6531B2D1C8;
        Sun, 20 Nov 2022 18:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668999175; x=1700535175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SZbXR0jnSRpjiZuLVZqtvWf/Wyu6UQpYVOi2XkaiVXc=;
  b=VQlyAF9pnCUSJR1QvXeg6ILLxzCoh6ZE8PbY4sQeUWAF8NPDKeNzMtK2
   pkZZhD5bxBAIuIvTkUyOP8uLnjZz+OvRM+AB5SYSxjAlydScpEd83FJ5D
   ClZIy4q6+cMNXnsWZ+QJDkkVbWiMp4ZkRg0/duxgL/QCAvmgU9M8n0Ojz
   K6LjokEtW5QAMKH7rfWaeFokLExFjRsQ91CLyRog6lQRk3yf5NgPtZsub
   67X2JnXLS5cWJhFRcALgAwIGKMCdZ1L1eGXhEDNcHhClqLkp4dUejDZAS
   2Rbe/H97H9d2odLF64aH991Kx+U+i+JlVhBQWlbg7JEMBI+80GRc7V1Wn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399747984"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399747984"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 18:52:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="969908459"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="969908459"
Received: from mjcardon-mobl.amr.corp.intel.com (HELO [10.209.57.10]) ([10.209.57.10])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 18:52:53 -0800
Message-ID: <2eedfcff-e8c1-79af-63f4-c852af7b7e77@linux.intel.com>
Date:   Sun, 20 Nov 2022 18:52:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/20/22 4:26 PM, Kai Huang wrote:
> +/*
> + * TDX supported page sizes (4K/2M/1G).
> + *
> + * Those values are part of the TDX module ABI.  Do not change them.

It would be better if you include specification version and section
title.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
