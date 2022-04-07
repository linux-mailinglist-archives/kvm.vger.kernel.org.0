Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3404F7036
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiDGBUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240527AbiDGBUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:20:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F7EB98;
        Wed,  6 Apr 2022 18:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649294279; x=1680830279;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2JbrfSY6uP2wUo1/4/a1W0qsDUA/7Yo093jm6g0+yKI=;
  b=lzwmhFuyQLK+HOAfj8NPae5JzUBo1sFrAY+KjQIZ3qJyVVzz4XHmqO9d
   tlKnnGcsG2cpdxvlHh3CvfmpCytHlIXsYCCDS9lmO0QN0vebVRJTSrc1r
   sD9Z1GHql3NYLW92Inv/CNzDjn1qdL3ZzBDE+DhdcDFgY8Z+/mRRvilE4
   AZ0CKi0XGWDlSmxOgGIz3kVnIawzLzlZi/ibUbbocVMCabp94eoEK2BSf
   tkUQt/nzbkmylsPJFQZJbhPLl7idEZ7n5gLbgn9nT6yjqtHhstez9Q949
   ozRs7ddVUg03iuIUFGb5TUzKWOb/z1hvlRGM6PkMvPb0XOVqo3n07SJSb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="260035421"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="260035421"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:17:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="722746220"
Received: from zitianwa-mobl.ccr.corp.intel.com (HELO [10.255.28.125]) ([10.255.28.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:17:54 -0700
Message-ID: <8aa0cf5b-bfda-bcf8-45f9-dc5113532caa@intel.com>
Date:   Thu, 7 Apr 2022 09:17:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 026/104] KVM: TDX: x86: Add vm ioctl to get TDX
 systemwide parameters
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5ff08ce32be458581afe59caa05d813d0e4a1ef0.1646422845.git.isaku.yamahata@intel.com>
 <586be87a-4f81-ea43-2078-a6004b4aba08@redhat.com>
 <17981a2e-03e3-81df-0654-5ccb29f43546@intel.com>
 <bf3e61bcc2096e72a02f56b70524928e6c3cfa3e.camel@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <bf3e61bcc2096e72a02f56b70524928e6c3cfa3e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/2022 9:07 AM, Kai Huang wrote:
> On Wed, 2022-04-06 at 09:54 +0800, Xiaoyao Li wrote:
>> On 4/5/2022 8:52 PM, Paolo Bonzini wrote:
>>> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
>>>> Implement a VM-scoped subcomment to get system-wide parameters.  Although
>>>> this is system-wide parameters not per-VM, this subcomand is VM-scoped
>>>> because
>>>> - Device model needs TDX system-wide parameters after creating KVM VM.
>>>> - This subcommands requires to initialize TDX module.  For lazy
>>>>     initialization of the TDX module, vm-scope ioctl is better.
>>>
>>> Since there was agreement to install the TDX module on load, please
>>> place this ioctl on the /dev/kvm file descriptor.
>>>
>>> At least for SEV, there were cases where the system-wide parameters are
>>> needed outside KVM, so it's better to avoid requiring a VM file descriptor.
>>
>> I don't have strong preference on KVM-scope ioctl or VM-scope.
>>
>> Initially, we made it KVM-scope and change it to VM-scope in this
>> version. Yes, it returns the info from TDX module, which doesn't vary
>> per VM. However, what if we want to return different capabilities
>> (software controlled capabilities) per VM?
>>
> 
> In this case, you don't return different capabilities, instead, you return the
> same capabilities but control the capabilities on per-VM basis.

yes, so I'm not arguing it or insisting on per-VM.

I just speak out my concern since it's user ABI.

>> Part of the TDX capabilities
>> serves like get_supported_cpuid, making it KVM wide lacks the
>> flexibility to return differentiated capabilities for different TDs.
>>
>>
>>> Thanks,
>>>
>>> Paolo
>>>
>>
> 

