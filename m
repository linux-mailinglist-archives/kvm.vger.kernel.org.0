Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E369C515462
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 21:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380329AbiD2TYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 15:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380278AbiD2TXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 15:23:44 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D646428;
        Fri, 29 Apr 2022 12:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651260024; x=1682796024;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cgLtOlQqQhDyaF67C74v6XD8hoopctzCMPzs3mVdX60=;
  b=lYJy37yYx/0FFnVU8lDCsiz3NFSqp8hA3tGiHNDQAcuT1srnUl4RQ0fF
   xqChoLdNHKVPp4929lmh6RD+CFfbjUX2babBXHyE/jOkGEPi0HEQzRDGT
   nakrY7t//ZDGjLyW55TVrxvNS+oskUHlR4UF+exX4Oh7+sVzrRP/vqnwE
   sac1i5ZMUQ39xttVyYu8STfh7hiv4OclHoghjc1dpdPRw6Z0C7btUuktT
   /KIJV7sT2nmeqkmlyzz01XrnOfR7VaTD7+j1sJF9GETnJXCrOgY8C+ZJ3
   hoDs697xrIiHgh5bYBSY3rBnHp3/ELg+OELwY7bwoXpfOVZDY+eG7BOLE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="265593809"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="265593809"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 12:20:24 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582344666"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 12:20:23 -0700
Message-ID: <73ed1e55-7e7c-2995-b411-8e26b711cc22@intel.com>
Date:   Fri, 29 Apr 2022 12:20:40 -0700
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
 <4a5143cc-3102-5e30-08b4-c07e44f1a2fc@intel.com>
 <CAPcyv4i6X6ODNbOnT7+NEzpicLS4m9bNDybZLvN3gqXFTTf=mg@mail.gmail.com>
 <4d0c7316-3564-ef27-1113-042019d583dc@intel.com>
 <CAPcyv4gYw3k4YMEV1E26fMx-GNCNCb+zJDERfhieCrROWv_Jxg@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAPcyv4gYw3k4YMEV1E26fMx-GNCNCb+zJDERfhieCrROWv_Jxg@mail.gmail.com>
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

On 4/29/22 11:47, Dan Williams wrote:
> On Fri, Apr 29, 2022 at 11:34 AM Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> On 4/29/22 10:48, Dan Williams wrote:
>>>> But, neither of those really help with, say, a device-DAX mapping of
>>>> TDX-*IN*capable memory handed to KVM.  The "new syscall" would just
>>>> throw up its hands and leave users with the same result: TDX can't be
>>>> used.  The new sysfs ABI for NUMA nodes wouldn't clearly apply to
>>>> device-DAX because they don't respect the NUMA policy ABI.
>>> They do have "target_node" attributes to associate node specific
>>> metadata, and could certainly express target_node capabilities in its
>>> own ABI. Then it's just a matter of making pfn_to_nid() do the right
>>> thing so KVM kernel side can validate the capabilities of all inbound
>>> pfns.
>>
>> Let's walk through how this would work with today's kernel on tomorrow's
>> hardware, without KVM validating PFNs:
>>
>> 1. daxaddr mmap("/dev/dax1234")
>> 2. kvmfd = open("/dev/kvm")
>> 3. ioctl(KVM_SET_USER_MEMORY_REGION, { daxaddr };
> 
> At least for a file backed mapping the capability lookup could be done
> here, no need to wait for the fault.

For DAX mappings, sure.  But, anything that's backed by page cache, you
can't know until the RAM is allocated.

...
>> Those pledges are hard for anonymous memory though.  To fulfill the
>> pledge, we not only have to validate that the NUMA policy is compatible
>> at KVM_SET_USER_MEMORY_REGION, we also need to decline changes to the
>> policy that might undermine the pledge.
> 
> I think it's less that the kernel needs to enforce a pledge and more
> that an interface is needed to communicate the guest death reason.
> I.e. "here is the impossible thing you asked for, next time set this
> policy to avoid this problem".

IF this code is booted on a system where non-TDX-capable memory is
discovered, do we:
1. Disable TDX, printk() some nasty message, then boot as normal
or,
2a. Boot normally with TDX enabled
2b. Add enhanced error messages in case of TDH.MEM.PAGE.AUG/ADD failure
    (the "SEAMCALLs" which are the last line of defense and will reject
     the request to add non-TDX-capable memory to a guest).  Or maybe
    an even earlier message.

For #1, if TDX is on, we are quite sure it will work.  But, it will
probably throw up its hands on tomorrow's hardware.  (This patch set).

For #2, TDX might break (guests get killed) at runtime on tomorrow's
hardware, but it also might be just fine.  Users might be able to work
around things by, for instance, figuring out a NUMA policy which
excludes TDX-incapable memory. (I think what Dan is looking for)

Is that a fair summary?
