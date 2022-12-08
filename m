Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF866472B4
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 16:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiLHPUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 10:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiLHPT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 10:19:56 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F7370B88;
        Thu,  8 Dec 2022 07:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670512650; x=1702048650;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sjIdGJ3dFJPHY95KafrCNYiB0J29f+N6H9kF/DT80ck=;
  b=b7a2xtL/fHY+OsZioh8IbWWuGRh6b5to7ztv211HqXj8Nx4yQDUf46gO
   t4p3mf0PopqAeiz/CYNlad+TyXAO+4fk4OJnVWL0d1RMofcOf5tK5K0/A
   qAcI0OrSyK+6p9z7EXxkNIGVFajnEUux6zr4dDGw//EHmiDfeLO+c1brO
   cSywAJnPg5oaIGRRD2KHVlMuvlEwgc31Pz+N9gF8Ty1ceNg/FSWC7deKi
   4JQy2hoQdjtOgiPz5mEGf4lKpXkSSwBIjS2NuNNPwwGwN0f1pQtlWpFlV
   Uvte9jPMWphaoZuQ21HTcWXp3SCk4P9sCILs72Jz32mLX7AAA/cKJaU6F
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="300621622"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="300621622"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 06:58:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="771505225"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="771505225"
Received: from mbielby-mobl.amr.corp.intel.com (HELO [10.209.7.219]) ([10.209.7.219])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 06:58:11 -0800
Message-ID: <d04b3a83-5797-b061-f315-07f84278d961@intel.com>
Date:   Thu, 8 Dec 2022 06:58:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
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
 <e49829fc-e488-3a65-b6fd-f02e964bdb4a@intel.com>
 <02d2a49cbd319814a7afdf57ca3cc9809123952a.camel@intel.com>
 <98935273b05feb55fc52c69a48d31018e0124e58.camel@intel.com>
 <702c11db9820a074aee31c2958a565b21299607f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <702c11db9820a074aee31c2958a565b21299607f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 04:56, Huang, Kai wrote:
> I haven't looked into the reason yet but I suspect the address isn't aligned (I
> used __pa() to get the physical address).  I'll take a look and report back.
> 
> In the meantime, do you have any comments?  Should I still pursue to keep them
> as local variable on the stack?

Yes, you should investigate the reason for the failure and try to
understand both the success and the failure cases.
