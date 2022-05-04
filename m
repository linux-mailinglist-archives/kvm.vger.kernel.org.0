Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152EC5192C6
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 02:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244655AbiEDA2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 20:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244656AbiEDA2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 20:28:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609EC5F71;
        Tue,  3 May 2022 17:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651623917; x=1683159917;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZCzg68E9e6BqBao4oWRrx0n2MdE1MfcFFpx+KA+MVak=;
  b=n7yHHnSbciamEuX96JvhMtGmN3pbbfxFPoiyeXL4PSkndFhYIuq5F9ce
   3bTxW050PVXT7w566JDjwzFcE5eVxh9onga4VVcUQRCaO13N4PHclw4lt
   xUUBW5GHKggPuUf58+XvWg5zeiIlPaAuLcpce35FDiKJSb43yUh4WLAhB
   GTpaNUUIDU+iNpq0OFD/+HRaf5XM74PftP36+7m7n3AxOIaF/9f+Ba4R2
   UC8ImQSu0uVg5GXLJMFi2Uiq4PuhFmRXJ4EfOd+LO1ZX9C0t1uzNQX1oD
   vnru3/NkjZmPaH7nrcQE83QXz7V5FzPItMwcBzwBytS9uvsDvFhdKg3FE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="328169916"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="328169916"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 17:25:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="664215706"
Received: from dbandax-mobl2.amr.corp.intel.com (HELO [10.209.188.251]) ([10.209.188.251])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 17:25:15 -0700
Message-ID: <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com>
Date:   Tue, 3 May 2022 17:25:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/21] TDX host kernel support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
 <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
 <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
 <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/22 16:59, Kai Huang wrote:
> Should be:
> 
> 	// prevent racing with TDX module initialization */
> 	tdx_init_disable();
> 
> 	if (tdx_module_initialized()) {
> 		if (new_memory_resource in TDMRs)
> 			// allow memory hot-add
> 		else
> 			// reject memory hot-add
> 	} else if (new_memory_resource in CMR) {
> 		// add new memory to TDX memory so it can be
> 		// included into TDMRs
> 
> 		// allow memory hot-add
> 	}
> 	else
> 		// reject memory hot-add
> 	
> 	tdx_module_enable();
> 
> And when platform doesn't TDX, always allow memory hot-add.

I don't think it even needs to be *that* complicated.

It could just be winner take all: if TDX is initialized first, don't
allow memory hotplug.  If memory hotplug happens first, don't allow TDX
to be initialized.

That's fine at least for a minimal patch set.

What you have up above is probably where you want to go eventually, but
it means doing things like augmenting the e820 since it's the single
source of truth for creating the TMDRs right now.

