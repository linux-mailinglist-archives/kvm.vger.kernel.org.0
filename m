Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AFC515183
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379471AbiD2RVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377752AbiD2RVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:21:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205D68878E;
        Fri, 29 Apr 2022 10:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651252674; x=1682788674;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kvflxqM96jhZNLmg4d5WFE0pIbmtCjEb6LWVYafIRJQ=;
  b=MhRHtQ9hMyTv3MKPkVmCRnk2+lrUAzpNbE05hYpfwLSSepvpC0JigVFm
   oxP2DryITtvc8mbCzuj8ccjV7cm+fMoy0zKsExg1VTBwnnD5tJMSVXvi4
   4X+B5G8RQ6uxR7GR1xmJqWUb+AMHzSd/t0O3JouPyKN1HwP3MqeppEt18
   gp1BQr3RJUiZGDdd43axGUhSpf3Sm+GkD+2LtYzdcv3lYuHKx/MXW+a+K
   EPdFzCgUXym9nr/L3oN3ZMLzqx8unVt6aYOTAfKpZAwrSO8/g2MRsDZQh
   V3ck6ZHMvczjxS654/WhPfRXOZPaupbnzkOM2TZW8mzR3Cj+TjfrBVJ8B
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="246622967"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="246622967"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 10:17:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582273107"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 10:17:52 -0700
Message-ID: <4a5143cc-3102-5e30-08b4-c07e44f1a2fc@intel.com>
Date:   Fri, 29 Apr 2022 10:18:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/21] TDX host kernel support
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
 <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
 <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
 <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
 <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com>
 <CAPcyv4iG977DErCfYTqhVzuZqjtqFHK3smnaOpO3p+EbxfvXcQ@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAPcyv4iG977DErCfYTqhVzuZqjtqFHK3smnaOpO3p+EbxfvXcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 08:18, Dan Williams wrote:
> Yes, I want to challenge the idea that all core-mm memory must be TDX
> capable. Instead, this feels more like something that wants a
> hugetlbfs / dax-device like capability to ask the kernel to gather /
> set-aside the enumerated TDX memory out of all the general purpose
> memory it knows about and then VMs use that ABI to get access to
> convertible memory. Trying to ensure that all page allocator memory is
> TDX capable feels too restrictive with all the different ways pfns can
> get into the allocator.

The KVM users are the problem here.  They use a variety of ABIs to get
memory and then hand it to KVM.  KVM basically just consumes the
physical addresses from the page tables.

Also, there's no _practical_ problem here today.  I can't actually think
of a case where any memory that ends up in the allocator on today's TDX
systems is not TDX capable.

Tomorrow's systems are going to be the problem.  They'll (presumably)
have a mix of CXL devices that will have varying capabilities.  Some
will surely lack the metadata storage for checksums and TD-owner bits.
TDX use will be *safe* on those systems: if you take this code and run
it on one tomorrow's systems, it will notice the TDX-incompatible memory
and will disable TDX.

The only way around this that I can see is to introduce ABI today that
anticipates the needs of the future systems.  We could require that all
the KVM memory be "validated" before handing it to TDX.  Maybe a new
syscall that says: "make sure this mapping works for TDX".  It could be
new sysfs ABI which specifies which NUMA nodes contain TDX-capable memory.

But, neither of those really help with, say, a device-DAX mapping of
TDX-*IN*capable memory handed to KVM.  The "new syscall" would just
throw up its hands and leave users with the same result: TDX can't be
used.  The new sysfs ABI for NUMA nodes wouldn't clearly apply to
device-DAX because they don't respect the NUMA policy ABI.

I'm open to ideas here.  If there's a viable ABI we can introduce to
train TDX users today that will work tomorrow too, I'm all for it.
