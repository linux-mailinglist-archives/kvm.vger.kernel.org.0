Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4F7632BD0
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 19:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiKUSOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 13:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiKUSOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 13:14:40 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9723BBE863;
        Mon, 21 Nov 2022 10:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669054479; x=1700590479;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GAVtFtjbl2NQuREt3KtkaZtzB7KUOF9ZPwGqcocelO4=;
  b=EAgOPFt8t05ZlEHHa5tuOdSGWUeVASsITU8utQV0iVmAWHkRwQ1fD71D
   djh9/k9CLHK5hJkNjYgYPNUoAGJYRc2bbjXytKF/NBUbjFlHrUh/9Y0GL
   a7Bef3pLNtyg9a3t0eLikjPm96qAYU0yNT4zODQOIvHY8dukWsGkN2n1h
   UEhVSezz6uqkP27AM87usc10Gjtz8wZ2qUEbmjDaIlYzvXS9PJcWqddHy
   KTXtPHw45LHuj2pZ/Y9ms2fc9aXqjFUYcWTg9s8+5BEBhlom2vz9NRhpy
   xvBya5IRToB58Ecm0WapAP1xYGSWfDH87yVSyaVarYrGa0DKNi48XK4om
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313658028"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="313658028"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 10:12:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="709904648"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="709904648"
Received: from ticela-or-327.amr.corp.intel.com (HELO [10.209.6.63]) ([10.209.6.63])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 10:12:54 -0800
Message-ID: <805fb0fb-84e2-41ac-ed02-3470fd8c63fe@intel.com>
Date:   Mon, 21 Nov 2022 10:12:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 01/20] x86/tdx: Define TDX supported page sizes as
 macros
Content-Language: en-US
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <d6c6e664c445e9ccf1528625f0e21bbb8471d35f.1668988357.git.kai.huang@intel.com>
 <2eedfcff-e8c1-79af-63f4-c852af7b7e77@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <2eedfcff-e8c1-79af-63f4-c852af7b7e77@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 18:52, Sathyanarayanan Kuppuswamy wrote:
> On 11/20/22 4:26 PM, Kai Huang wrote:
>> +/*
>> + * TDX supported page sizes (4K/2M/1G).
>> + *
>> + * Those values are part of the TDX module ABI.  Do not change them.
> It would be better if you include specification version and section
> title.

I actually think TDX code, in general, spends way too much time quoting
and referring to the spec.

Also, why quote the version?  Do we quote the SDM version when we add
new SDM-defined architecture?

It's just busywork that bloats the kernel and adds noise.  Please focus
on adding value to the comments that came from your brain and not just
pasting boilerplate gunk over and over.
