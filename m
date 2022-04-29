Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D26514DB0
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377593AbiD2Ooc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377951AbiD2OoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:44:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAD8D3443;
        Fri, 29 Apr 2022 07:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651243179; x=1682779179;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K5arLAYfSYDkrBf/hz/XwShI81HHiEcz3kuzcBSRsJU=;
  b=YUo1ZqkZfGucNv9LjOvupNtfciF5vQPqk6Kkg0pkkRl82eekQ9q6Isvm
   AUcL7DxFzzRiUn/OkHve0NKu+DVyy7uedsQVVYFvA9MIBsH0oEfl8Q+Rl
   630JVG2WlUlPklSjUOeLa7zjR/+h6THb3NwgKVfh+XEVZ3mi19z7ZpDoI
   2sNoteX7jJbD8Fdt72Zn7d26MmsSJfCNExKhfunSZBQDt5wlFI5lxUXmF
   EBjdejrEGWkuw0umSTnEC9yALxSVt/oGbzN/63TbbK/ohS/reoair+Se3
   AIUqfdyqOjokfUw0ob0t7S02tkcsUPk8NSRXD6Y+qjLS0X8jMkcL8zBed
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266478752"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="266478752"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 07:39:38 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582156648"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 07:39:37 -0700
Message-ID: <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com>
Date:   Fri, 29 Apr 2022 07:39:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/21] TDX host kernel support
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/22 19:58, Dan Williams wrote:
> That only seems possible if the kernel is given a TDX capable physical
> address map at the beginning of time.

TDX actually brings along its own memory map.  The "EAS"[1]. has a lot
of info on it, if you know where to find it.  Here's the relevant chunk:

CMR - Convertible Memory Range -
	A range of physical memory configured by BIOS and verified by
	MCHECK. MCHECK verificatio n is intended to help ensure that a
	CMR may be used to hold TDX memory pages encrypted with a
	private HKID.

So, the BIOS has the platform knowledge to enumerate this range.  It
stashes the information off somewhere that the TDX module can find it.
Then, during OS boot, the OS makes a SEAMCALL (TDH.SYS.CONFIG) to the
TDX module and gets the list of CMRs.

The OS then has to reconcile this CMR "memory map" against the regular
old BIOS-provided memory map, tossing out any memory regions which are
RAM, but not covered by a CMR, or disabling TDX entirely.

Fun, eh?

I'm still grappling with how this series handles the policy of what
memory to throw away when.

1.
https://www.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf
