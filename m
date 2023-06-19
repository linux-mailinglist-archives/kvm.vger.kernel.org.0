Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B377735A22
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjFSO4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 10:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjFSO4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 10:56:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18464AA;
        Mon, 19 Jun 2023 07:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687186592; x=1718722592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HukD5kUMPNH473OwrZ3/aKlQsAS1ptDXh1LdoJoOMcg=;
  b=YYLBDj/F3NcLHDa8lM9oQ2zGaGphUGqKlLylICZytB53eeBBDQh8Q7Vs
   LumC3obxkmVcMF1yCPUzILGGVS3q6xxtEhNque1zqsbdreKlsddEQZ12Y
   sluMdNI2MIuSvzqxh9OL82xcr4rXqyodZ6DGiNzjwJv1dikLVJfzGbqf0
   thneBY7NrfZ2l4N6m7y2jcVU58o9x+a1u2fuoca/Fio4HWLyLRsyVW9gR
   ooCsLUPu4k5N6T0lYNCcAnaRPQI1RgSXZoCljVwkM6iRnupEm7++tOfpK
   mQF+D6uvhq5LUWR86rwCXKRk+L73ADFewsEL1ZOGv2JxuXML581ykl6xX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="363073173"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="363073173"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 07:56:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="858245407"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="858245407"
Received: from leitchrx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.45.32])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 07:56:25 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 01FD210DD6D; Mon, 19 Jun 2023 17:56:22 +0300 (+03)
Date:   Mon, 19 Jun 2023 17:56:22 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 15/20] x86/virt/tdx: Configure global KeyID on all
 packages
Message-ID: <20230619145622.cjyis472geajrmnk@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <30358db4eff961c69783bbd4d9f3e50932a9a759.1685887183.git.kai.huang@intel.com>
 <49bd9f7f-9a2b-8b8c-f408-49b9b5982eb7@suse.com>
 <a60acb9be5bd5b0eb9b32ff11932fc019262dfe0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a60acb9be5bd5b0eb9b32ff11932fc019262dfe0.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 10:24:17PM +0000, Huang, Kai wrote:
> Hi Kirill/Dave,
> 
> Since I have received couple of tags from you, may I know which way do you
> prefer?

I agree with Nikolay, removing these "if (ret)" helps readability.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
