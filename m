Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7FD7335F2
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjFPQ0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 12:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjFPQ0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 12:26:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4451A3;
        Fri, 16 Jun 2023 09:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686932800; x=1718468800;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kJI27vN2p91Fu6uIkekhD7QZJBwp/dx6T6isHe7/eOM=;
  b=XMSlJd5QBu6M8J+FeL2kkQjl5dCOLpD676ujDbSJSY4+MSSRzfacXEXz
   1qvGhgNvQFCo1RtTO6NnnOKfTMThQMw2MEaZiNq6WPkdeV6U0+2T2Vw6m
   XnWIODbmXNl42DWkIUHSCMSXgCKxby19cKi1jlJyU10Ur1LawQRYVT05g
   SseA4X+sXRoum2qFBItc5tufvxYKgJqQvVdnMEZ6vQJRXkRaGSDJJEOfS
   fXyWWNDAQjyw77szgmphwHZIQBv4EX06jUH5kqLsuG3mKx5i31OVsbJBd
   jtXeWTWo2vnQhtbh0rVNHdXAFmU7WlBcns5a2HoXRAkl7giskeqgSKZEo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358126950"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="358126950"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:26:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="887144847"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="887144847"
Received: from fashta-mobl.amr.corp.intel.com (HELO [10.255.231.221]) ([10.255.231.221])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:26:39 -0700
Message-ID: <6655bcdc-e658-3ba1-ed7a-3fe1eadef48a@intel.com>
Date:   Fri, 16 Jun 2023 09:26:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 20/20] Documentation/x86: Add documentation for TDX
 host support
Content-Language: en-US
To:     Nikolay Borisov <nik.borisov@suse.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <34853e0f8f38ec2fda66b0ba480d4df63b8aab43.1685887183.git.kai.huang@intel.com>
 <14c2a806-05e4-a9f8-e85f-70b2081cd22f@suse.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <14c2a806-05e4-a9f8-e85f-70b2081cd22f@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/23 02:02, Nikolay Borisov wrote:
>>
>> +TDX reports a list of "Convertible Memory Region" (CMR) to tell the
> 
> nit: It might be worth mentioning that those CMRs ultimately come from
> the BIOS.  Because it's never mentioned here and in the "Physical Memory
> Hotplug" it's directly mentioned that bios shouldn't support hot-removal
> of memory. So the bios is a central component in a sense.

The BIOS is weird on TDX systems.  It's central, sure, but it's also
untrusted.  The TDX module generally has a kind of "trust but verify"
approach to the BIOS.

I guess the BIOS is the one poking at the memory controllers and getting
the DIMMs fired up.  But I _do_ think it's OK to say that CMRs come from
the TDX module.  The important thing is that they're trusted.
