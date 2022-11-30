Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27063D8FD
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 16:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiK3PN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 10:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiK3PNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 10:13:24 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47C52F65F;
        Wed, 30 Nov 2022 07:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669821203; x=1701357203;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t0g+VAX2SuLcI7520dAKthU0OO4VL8H7Rn6/w+sOkno=;
  b=FT9tDUKJfiM7NyOmarAFSAjxAF/cOFK9BBgv0Wam+6eU0521qH6eIoSz
   brYSQiXoVqTnHFNBh/fVTJ4b5kXmeXZCkidmQdhdKotwwLSU0IEF9ZBQr
   rqVhyo4fKyFZwQoOInl0omAOQnIwAvL3nCMQLk1Vc54OxvJp1InDLwgY+
   2LCv5OSFLj3VG+HjEe2728HV7JxA3DGTCDPUdtoAVZrjwxqOEGUBx9lC9
   moEiRwy89HWDBlCyEdVcPpwhFM5fxxSU/NWZltQyVviINfNQsvsakgksC
   CgiMusfondnydi6sJI8Evm7lELp6asbox+FxLZTozO9idGv8gPjY7AnLh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="377578171"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="377578171"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 07:13:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="712841768"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="712841768"
Received: from avintux-mobl1.amr.corp.intel.com (HELO [10.212.242.146]) ([10.212.242.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 07:13:19 -0800
Message-ID: <6b0980fc-74e7-3be5-c4a3-2583d6c26137@intel.com>
Date:   Wed, 30 Nov 2022 07:13:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
 <a537b97b-0bdc-5bcc-9ce7-470f8fc1245b@linux.intel.com>
 <3d19683cdc13b7a3884f1e9e75743e922d4630f3.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <3d19683cdc13b7a3884f1e9e75743e922d4630f3.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/22 00:34, Huang, Kai wrote:
> On Wed, 2022-11-30 at 11:35 +0800, Binbin Wu wrote:
>> On 11/21/2022 8:26 AM, Kai Huang wrote:
>>> After the array of TDMRs and the global KeyID are configured to the TDX
>>> module, use TDH.SYS.KEY.CONFIG to configure the key of the global KeyID
>>> on all packages.
>>>
>>> TDH.SYS.KEY.CONFIG must be done on one (any) cpu for each package.  And
>>> it cannot run concurrently on different CPUs.  Implement a helper to
>>> run SEAMCALL on one cpu for each package one by one, and use it to
>>> configure the global KeyID on all packages.
>>>
>>> Intel hardware doesn't guarantee cache coherency across different
>>> KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
>>> with KeyID 0) before the TDX module uses the global KeyID to access the
>>> PAMT.  Following the TDX module specification, flush cache before
>>> configuring the global KeyID on all packages.
>>>
>>> Given the PAMT size can be large (~1/256th of system RAM), just use
>>> WBINVD on all CPUs to flush.
>>>
>>> Note if any TDH.SYS.KEY.CONFIG fails, the TDX module may already have
>>> used the global KeyID to write any PAMT.  Therefore, need to use WBINVD
>>> to flush cache before freeing the PAMTs back to the kernel.  Note using
>>> MOVDIR64B (which changes the page's associated KeyID from the old TDX
>>> private KeyID back to KeyID 0, which is used by the kernel)
>>
>> It seems not accurate to say MOVDIR64B changes the page's associated KeyID.
>> It just uses the current KeyID for memory operations.
> 
> The "write" to the memory changes the page's associated KeyID to the KeyID that
> does the "write".  A more accurate expression perhaps should be MOVDIR64B +
> MFENSE, but I think it doesn't matter in changelog.

Just delete it from the changelog.  It's a distraction.  I'm not even
sure it's *necessary* to do any memory content conversion after the TDX
module has written gunk.

There won't be any integrity issues because integrity errors don't do
anything for KeyID-0 (no #MC).

I _think_ the reads of the page using KeyID-0 will see abort page
semantics.  That's *FINE*.

