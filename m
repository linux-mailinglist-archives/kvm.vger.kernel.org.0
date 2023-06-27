Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576CE73FB2E
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjF0Lgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjF0Lgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:36:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1608326B8;
        Tue, 27 Jun 2023 04:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687865791; x=1719401791;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b60RLvgCgE69eplE2j+D0M1hJ0JYNceI2V64TdDSM24=;
  b=CSc+55OxcVET9qKusGJOdCQOvSjOXZv7/D0JoflxRXx9f8p4jZ0swpnq
   lxwhMpR3JvsLSdFQVCNSX0kBIpv/H42WQTJt0fX5tuQeODLrNu5OmHUxd
   TMPHeOmjtFTUVtjVLLBg4j6n7e2R0SC8q3tRVpioNscA3Vji8Ow9QZUgj
   35G9NCJDY8ibqZLyOVj/P15TzDgMFJIOVVCFlIO954n8N/E0Z1KgFmTGv
   WVwqBGGLGvYO4HieOCt4c/KC7h4d4i7UrZagmJ/zYOn1UZkJHKTLMuW2n
   mXbDm/AvqP+z2TjsF6Pmx7V33WNWWowBYc5BnlpuJ/gTmNrwTzDu8ogVM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="361586295"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="361586295"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 04:36:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="806445038"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="806445038"
Received: from rbhaumik-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.217.121])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 04:36:23 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id D57B0103738; Tue, 27 Jun 2023 14:36:20 +0300 (+03)
Date:   Tue, 27 Jun 2023 14:36:20 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230627113620.pnxqp7cel66zuldi@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
 <20230627094856.6udzuhzhygc4nzit@box.shutemov.name>
 <102e45dd81589625ed064a742508597e0d118375.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <102e45dd81589625ed064a742508597e0d118375.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 10:28:20AM +0000, Huang, Kai wrote:
> > Or is that wrapper only used for never-fail SEAMCALLs? If so, please
> > document it.
> > 
> 
> How about adding below?
> 
> 	Use __seamcall() directly in cases that printing error message isn't
> 	desired, e.g., when SEAMCALL can legally fail with BUSY and the caller
> 	wants to retry.
> 

Looks good to me.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
