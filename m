Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1822F5153C6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379927AbiD2Shy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiD2Shx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:37:53 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CA4D5543;
        Fri, 29 Apr 2022 11:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651257274; x=1682793274;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LMD/xKUKZ25/S/WmOS4jXEEPVwy0dkFAu8aG3A2vSHY=;
  b=by1/H/rsOq2efLwZ7+Osj3/eKKyV52CKHWkyp3zoitWI5lq9xoFsC2hy
   2HfhcCXog4OneGZVVynbmgorxTSrvt7IwdIWn14svsjhNeCorv11X6Xf1
   2x9EW+qUN/1NmySUM2RMLiIiLmbZngvWheLsmkUWF5nUy0L5+c9YDp72Y
   shlUD9iIku2KzOrPmDLTsyVoA3Nwj1u7pRK3MdVB/X28F1hLGVoOEkmKA
   mdihpGxnXAMn6IJRa2lR8NedGaopTLSrvWvOMoXsmo3ENcwg/MjWKWn72
   o6K6IdgPMEpff93BXmWx2bPw3DGQAeMBBebiAfjs3r4/2T3UbnrNwOu5O
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="291911490"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="291911490"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 11:34:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582322897"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 11:34:33 -0700
Message-ID: <4d0c7316-3564-ef27-1113-042019d583dc@intel.com>
Date:   Fri, 29 Apr 2022 11:34:50 -0700
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAPcyv4i6X6ODNbOnT7+NEzpicLS4m9bNDybZLvN3gqXFTTf=mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 10:48, Dan Williams wrote:
>> But, neither of those really help with, say, a device-DAX mapping of
>> TDX-*IN*capable memory handed to KVM.  The "new syscall" would just
>> throw up its hands and leave users with the same result: TDX can't be
>> used.  The new sysfs ABI for NUMA nodes wouldn't clearly apply to
>> device-DAX because they don't respect the NUMA policy ABI.
> They do have "target_node" attributes to associate node specific
> metadata, and could certainly express target_node capabilities in its
> own ABI. Then it's just a matter of making pfn_to_nid() do the right
> thing so KVM kernel side can validate the capabilities of all inbound
> pfns.

Let's walk through how this would work with today's kernel on tomorrow's
hardware, without KVM validating PFNs:

1. daxaddr mmap("/dev/dax1234")
2. kvmfd = open("/dev/kvm")
3. ioctl(KVM_SET_USER_MEMORY_REGION, { daxaddr };
4. guest starts running
5. guest touches 'daxaddr'
6. Page fault handler maps 'daxaddr'
7. KVM finds new 'daxaddr' PTE
8. TDX code tries to add physical address to Secure-EPT
9. TDX "SEAMCALL" fails because page is not convertible
10. Guest dies

All we can do to improve on that is call something that pledges to only
map convertible memory at 'daxaddr'.  We can't *actually* validate the
physical addresses at mmap() time or even
KVM_SET_USER_MEMORY_REGION-time because the memory might not have been
allocated.

Those pledges are hard for anonymous memory though.  To fulfill the
pledge, we not only have to validate that the NUMA policy is compatible
at KVM_SET_USER_MEMORY_REGION, we also need to decline changes to the
policy that might undermine the pledge.
