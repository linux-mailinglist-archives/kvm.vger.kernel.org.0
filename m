Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0465092F1
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382873AbiDTWlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiDTWlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:41:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF54E424A8;
        Wed, 20 Apr 2022 15:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650494298; x=1682030298;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ho/cMTQiPie+cEb9mhXTfWgaA1Fjhpv3W5caAD0EYLM=;
  b=lw/v06KTnfVT+95h1c8gjS02aYyV0oOcviwP+j1YSxw+085NgJyMPb5G
   HUrorwqmSR/DGK7/06tGDYq0fM3CW7SSI1q7XiC0TF7t2x+F0on/2AMQP
   cBUBQy6tWLbGgKerNtvYnT5ofwvqwr/mTrc/XuxZi2yVPpfVcQNiLjEg9
   J3VRX2fWaDGIMQcjI26D4gPMheQydCiL+Im8KSxJncyu1eBun101Z2hk1
   K5R2gQrllgdcKVXVwqurkgxsPIK9WwFHzqfeG7Cb/HLdhifVc7rwRVhH7
   8RCT3Wgy/O6De+lLMmmepVZO6gkPaLleNUpi3vPh0b6z1l20qAXyBaIA0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="327066063"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="327066063"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:38:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="647859043"
Received: from ssharm9-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.30.148])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 15:38:14 -0700
Message-ID: <adde60b836de0e802926ec03467dd498e1cb2f53.camel@intel.com>
Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all
 system RAM as TDX memory
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 21 Apr 2022 10:38:13 +1200
In-Reply-To: <20220420204826.GA2789321@ls.amr.corp.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
         <20220420204826.GA2789321@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-20 at 13:48 -0700, Isaku Yamahata wrote:
> > Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all
> > system RAM as TDX memory
> 
> Nitpick: coveret => convert
> 
> Thanks,

Thanks!

-- 
Thanks,
-Kai


