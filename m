Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809CA5A1498
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 16:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242694AbiHYOnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 10:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242147AbiHYOne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 10:43:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57136BCBD
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 07:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661438561; x=1692974561;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZVTIjYVchpIcQqqc0ZaCjQcEwojmXfhbS+FFEpZPwJM=;
  b=lFqaUKdCZdf/WbE0M+pqxMy3w6rM3mAFk9pbXSAcpQ90k0yndIKYTLcN
   JEM/X2uDwR40Xz8Bpbi2KkppNg7rGo+9Q6lmLMpNFYP9edgfUvPMPJe6d
   w8tWVpOFQHrRiSXvkYOMPXtVDJCBzSUzCnAZZgX6dDcnyKVUz+Vnw3oAd
   GaERQhMzwf/TMWO0YTS3Vgq/gIbMxzeqXLdzTUBLswDVQ2MYTAX3ExT7U
   fyv8tESG0m2oy8HQhOd2sExIm05HeDL+knTty8IgTIxjCa5saSx6V0gLU
   x706pwkgyZ1tsx5DNjeykcLjnXWb6iPeEIdkWpFjRN//+5pyu5BuUDwB3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="355974937"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="355974937"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 07:42:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="671011415"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.55]) ([10.255.29.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 07:42:36 -0700
Message-ID: <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
Date:   Thu, 25 Aug 2022 22:42:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220825113636.qlqmflxcxemh2lmf@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 7:36 PM, Gerd Hoffmann wrote:
> On Tue, Aug 02, 2022 at 03:47:25PM +0800, Xiaoyao Li wrote:
>> Bit 28, named SEPT_VE_DISABLE, disables	EPT violation conversion to #VE
>> on guest TD access of PENDING pages when set to 1. Some guest OS (e.g.,
>> Linux TD guest) may require this bit set as 1. Otherwise refuse to boot.
> 
> --verbose please.  That somehow doesn't make sense to me.
> 
> A guest is either TDX-aware (which should be the case for linux 5.19+),
> or it is not.  My expectation would be that guests which are not
> TDX-aware will be disturbed by any #VE exception, not only the ones
> triggered by EPT violations.  So I'm wondering what this config bit
> actually is useful for ...

This bit, including other properties of tdx-guest object, are supposed 
to be configured for TD only. On VM creation phase, user needs to decide 
if it's a TD (TDX VM) or non-TD (previous normal VM) by attaching 
tdx-guest object or not.

If it's a TD when VM creation, but the guest kernel is not 
TDX-capable/-aware, it's doomed to fail booting.

For TD guest kernel, it has its own reason to turn SEPT_VE on or off. 
E.g., linux TD guest requires SEPT_VE to be disabled to avoid #VE on 
syscall gap [1]. Frankly speaking, this bit is better to be configured 
by TD guest kernel, however current TDX architecture makes the design to 
let VMM configure.


[1]: TD pages that are not accepted cause a #VE exception.
It is possible for a hypervisor to take away a guest page
and thus trigger a #VE the next time it is accessed.
Normally the guest would just panic in such a case, but
for that it first needs to execute the #VE handler
reliably.

This can cause problems with the "system call gap": a malicious
hypervisor might trigger a #VE for example on the system call entry
code, and when a user process does a system call it would trigger a
and SYSCALL relies on the kernel code to switch to the kernel stack,
this would lead to kernel code running on the ring 3 stack.  This could
be exploited by a combination of malicious host and malicious ring 3
program to attack the kernel.


> take care,
>    Gerd
> 

