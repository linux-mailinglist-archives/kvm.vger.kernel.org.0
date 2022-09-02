Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066055AA5EE
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiIBCdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIBCdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:33:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0164BD0A
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 19:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085998; x=1693621998;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r8zeg1tyZGMcF3UMzs+ZwZWbgreiiSaM+r6CEBdUuzU=;
  b=VE30bOt1ja9GQ+BWCay8Bt0Kql46QdoBfkN9ci4WlVMIhFwhbMSf+0EI
   EX+Zpk+gYjh8oH1P4nJSkabpZj07NsjOi5XH8iT0sr9yXiYjONJG9zb0q
   Jmq4U7mnr6vb0cvrNoO9obQAj6W4DgokiVNhdB9r8F/hohNOPS/i6b92w
   RSMqdlnt8IPFyrFol3I1wj4+86kF/KJBXK0/E8gjezPwQJIVA8zIqfNWz
   wqBqYnQ0VMsQZIPvNxBrAYFck0wNoAXrVi1Sc6JxBiwwDhbs1JojYIbkk
   /x6hvyBzcjwFWgPrX65JNkoB8jCqCaaJYvLUinzM3JNdIHPUVVhbhUILH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="282862058"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="282862058"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:33:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="642698192"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.28]) ([10.249.171.28])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:33:12 -0700
Message-ID: <a700a0c6-7f25-dc45-4c49-f61709808f29@intel.com>
Date:   Fri, 2 Sep 2022 10:33:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH v1 15/40] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-16-xiaoyao.li@intel.com>
 <20220825113636.qlqmflxcxemh2lmf@sirius.home.kraxel.org>
 <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
 <20220826055711.vbw2oovti2qevzzx@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220826055711.vbw2oovti2qevzzx@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2022 1:57 PM, Gerd Hoffmann wrote:
>    Hi,
>   
>> For TD guest kernel, it has its own reason to turn SEPT_VE on or off. E.g.,
>> linux TD guest requires SEPT_VE to be disabled to avoid #VE on syscall gap
>> [1].
> 
> Why is that a problem for a TD guest kernel?  Installing exception
> handlers is done quite early in the boot process, certainly before any
> userspace code runs.  So I think we should never see a syscall without
> a #VE handler being installed.  /me is confused.
> 
> Or do you want tell me linux has no #VE handler?

The problem is not "no #VE handler" and Linux does have #VE handler. The 
problem is Linux doesn't want any (or certain) exception occurrence in 
syscall gap, it's not specific to #VE. Frankly, I don't understand the 
reason clearly, it's something related to IST used in x86 Linux kernel.

>> Frankly speaking, this bit is better to be configured by TD guest
>> kernel, however current TDX architecture makes the design to let VMM
>> configure.
> 
> Indeed.  Requiring users to know guest kernel capabilities and manually
> configuring the vmm accordingly looks fragile to me.
> 
> Even better would be to not have that bit in the first place and require
> TD guests properly handle #VE exceptions.
> 
>> This can cause problems with the "system call gap": a malicious
>> hypervisor might trigger a #VE for example on the system call entry
>> code, and when a user process does a system call it would trigger a
>> and SYSCALL relies on the kernel code to switch to the kernel stack,
>> this would lead to kernel code running on the ring 3 stack.
> 
> Hmm?  Exceptions switch to kernel context too ...
> 
> take care,
>    Gerd
> 

