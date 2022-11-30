Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3132863D785
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiK3OEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiK3OEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:04:49 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CC83E0BF;
        Wed, 30 Nov 2022 06:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669817088; x=1701353088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L7Trwb2C5sPvmhlDk+PrNgcbJF8XVAhiKvoDPrIpHD8=;
  b=gABft9/eSinBQo6SN9ssluA7Fxmrdu9KJS5ILWEgYH/nq0rooZPZR6Ld
   pcsADcIB1+B7RHoyjwlM91lz4212CmH6823ohgYmjvgCxFtQXzIScDJgM
   pUkUnPYfAwbPQszCbb64jPuS3+9QxHfvN5Zp6UETLB1gMTs2kHTUY/zO/
   2qpDgnm8UU7EIv9d4N6V8UD9FH7Ke+Aqao0rUsfArX/zIhTvZLMCvaHRD
   sCCVCWlIRcv6teXQuAVVDQY5ajmMRFlIBqklphIKExoQkSuGxrkQDnfEO
   pe9czOiowkeQ7PIlreS6HSzTmmvhrimMFEeIyR2JeehDc5DpHnrJqs6XO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303002798"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="303002798"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 06:04:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="646339272"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="646339272"
Received: from bkalluri-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.35.191])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 06:04:31 -0800
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 78574109A09; Wed, 30 Nov 2022 17:04:28 +0300 (+03)
Date:   Wed, 30 Nov 2022 17:04:28 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
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
Subject: Re: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Message-ID: <20221130140428.pkejerx6u6alctyl@box.shutemov.name>
References: <cover.1668988357.git.kai.huang@intel.com>
 <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
 <a537b97b-0bdc-5bcc-9ce7-470f8fc1245b@linux.intel.com>
 <3d19683cdc13b7a3884f1e9e75743e922d4630f3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d19683cdc13b7a3884f1e9e75743e922d4630f3.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 08:34:46AM +0000, Huang, Kai wrote:
> On Wed, 2022-11-30 at 11:35 +0800, Binbin Wu wrote:
> > On 11/21/2022 8:26 AM, Kai Huang wrote:
> > > After the array of TDMRs and the global KeyID are configured to the TDX
> > > module, use TDH.SYS.KEY.CONFIG to configure the key of the global KeyID
> > > on all packages.
> > > 
> > > TDH.SYS.KEY.CONFIG must be done on one (any) cpu for each package.  And
> > > it cannot run concurrently on different CPUs.  Implement a helper to
> > > run SEAMCALL on one cpu for each package one by one, and use it to
> > > configure the global KeyID on all packages.
> > > 
> > > Intel hardware doesn't guarantee cache coherency across different
> > > KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
> > > with KeyID 0) before the TDX module uses the global KeyID to access the
> > > PAMT.  Following the TDX module specification, flush cache before
> > > configuring the global KeyID on all packages.
> > > 
> > > Given the PAMT size can be large (~1/256th of system RAM), just use
> > > WBINVD on all CPUs to flush.
> > > 
> > > Note if any TDH.SYS.KEY.CONFIG fails, the TDX module may already have
> > > used the global KeyID to write any PAMT.  Therefore, need to use WBINVD
> > > to flush cache before freeing the PAMTs back to the kernel.  Note using
> > > MOVDIR64B (which changes the page's associated KeyID from the old TDX
> > > private KeyID back to KeyID 0, which is used by the kernel)
> > 
> > It seems not accurate to say MOVDIR64B changes the page's associated KeyID.
> > It just uses the current KeyID for memory operations.
> 
> The "write" to the memory changes the page's associated KeyID to the KeyID that
> does the "write".  A more accurate expression perhaps should be MOVDIR64B +
> MFENSE, but I think it doesn't matter in changelog.

MOVDIR64B KeyID for the cache line, not the page. Integrity tracked on
per-cacheline basis.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
