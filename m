Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8506C69E3
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjCWNto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWNtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:49:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03B11BF3;
        Thu, 23 Mar 2023 06:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679579381; x=1711115381;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GKZ5Q6PC9RVV67Um5+ppCnF8L4AO5uGcX7XeCD3ye9c=;
  b=RB8eocesOl/0Oo1a9HN/kEKReuarZ4OKCGNwovYwaPJkK49EtPxzNfaE
   Y5YurbwQ4HzkXF7VKb6HPYRjG2PKHnOdDgQnzWZJRI36xmao159sfxmGK
   lrroeTkFcdBlTfdTY1Z99/95pjThI8Rsrn5eKwZcrVRrqddcqtdWJ1Oe/
   bYGLj3dB5IJzwX57pt83Ky6FvIrLMhOpaIlX3rs4BodF1vY2WwX3KkViK
   rM9ce/qdZ2YJPxDjKh0UDqb5vcTULrALUgb9iixuVjnpzEARqVbyq5W60
   lLd+BJyDcNr6sNKlTcFccyJMbzQtcrMklhRSVSwzxXWVM1Yr8t0lOUJap
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425770759"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="425770759"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 06:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="682317493"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="682317493"
Received: from jball6-mobl.amr.corp.intel.com (HELO [10.209.105.116]) ([10.209.105.116])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 06:49:29 -0700
Message-ID: <141def31-dcbb-70ae-2935-4fb06a986036@intel.com>
Date:   Thu, 23 Mar 2023 06:49:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
 <20230308222738.GA3419702@ls.amr.corp.intel.com>
 <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
 <20230313234916.GC3922605@ls.amr.corp.intel.com>
 <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
 <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
 <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/23 04:10, Huang, Kai wrote:
> I can do.  Just want to make sure do you want to retry TDX_SYS_BUSY, or retry
> TDX_RND_NO_ENTROPY (if we want to ask TDX module guys to change to return this
> value)?

I'll put it this way:

	Linux is going to treat TDX_SYS_BUSY like a Linux bug and assume
	Linux is doing something wrong.  It'll mostly mean that
	users will see something nasty and may even cause Linux to give
	up on TDX.  In other words, the TDX module shouldn't use
	TDX_SYS_BUSY for things that aren't Linux's fault.

> Also, even we retry either TDX_SYS_BUSY or TDX_RND_NO_ENTROPY in common
> seamcall() code, it doesn't handle the TDH.SYS.KEY.CONFIG, because sadly this
> SEAMCALL returns a different error code:
> 
> TDX_KEY_GENERATION_FAILED       Failed to generate a random key. This is
>                                 typically caused by an entropy error of the
>                                 CPU's random number generator, and may
>                                 be impacted by RDSEED, RDRAND or PCONFIG
>                                 executing on other LPs. The operation should be
>                                 retried.

Sounds like we should just replace TDX_KEY_GENERATION_FAILED with
TDX_RND_NO_ENTROPY in cases where key generation fails because of a lack
of entropy.
