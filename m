Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E5163B4BC
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiK1WTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiK1WTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:19:52 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B6E30560;
        Mon, 28 Nov 2022 14:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669673992; x=1701209992;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DDlfWZUlARzDLRqCwElfV+jgzwGklKaNoE/QKHbN2sE=;
  b=FTFfwXrfIIAwejW8QcJhT2H6PKCKEx1ZXJFgDdFg3pfGYjHDPkAD2lO1
   YEa3limk+yQ7g4TiWedbXEAwlOt7bT/LMcyKhiGxLtCXq/Dwsrz6k6PLN
   JcSEkV0BPLxpuh65b5qJcHsSAOABUJDuvq14BL4n/wGM1SSUydZwUJd6m
   X3lB6kJUZwCp/PSpmXMpL3rEoKVgxd6lxUvXkL/Gx/RMMQ0gnJIKoCf++
   Pgtm96i+SRXairy86FlSC2z2xf8ud4D83fMAMtGXECO+J9T1LNYb8u5j6
   CdqctTisod37iOJQGWujm4gtZqrHK1E3Jb3j/wKblhWmVwBzF5/htOMHa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341879020"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="341879020"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:19:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="645662857"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="645662857"
Received: from nroy-mobl1.amr.corp.intel.com (HELO [10.212.209.4]) ([10.212.209.4])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:19:50 -0800
Message-ID: <e49829fc-e488-3a65-b6fd-f02e964bdb4a@intel.com>
Date:   Mon, 28 Nov 2022 14:19:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
 <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
 <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
 <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
 <60deb2ffe15e71bc91727aa04298c79f21a58c83.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <60deb2ffe15e71bc91727aa04298c79f21a58c83.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/28/22 14:13, Huang, Kai wrote:
> Apologize I am not entirely sure whether I fully got your point.  Do you mean
> something like below?
...

No, something like this:

static int init_tdx_module(void)
{
	static struct tdsysinfo_struct tdx_sysinfo; /* too rotund for the stack */
        ...
        tdx_get_sysinfo(&tdx_sysinfo, ...);
        ...

But, also, seriously, 3k on the stack is *fine* if you can shut up the
warnings.  This isn't going to be a deep call stack to begin with.
