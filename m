Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60EE69E12E
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 14:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbjBUNSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 08:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjBUNSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 08:18:48 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDB81C313
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 05:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676985527; x=1708521527;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y0MECfvL5TzapH7tto7LLF4HbnN9ecmndPHTzZ2bWjU=;
  b=ELxfFxLsjDHzpPEUETBtNA3l699nkhc/QXQGXyQh4oiVYWKUgAe+5FT0
   qkaRrmrx0NrzbCbrvzzWi+2aE8a2+O8ZcP1CQJ+GScACC2+HwHrR8WUmR
   pj0oXu/N4q7vZUIHNH4LantpLPWLdsz+MUx2FkBzduLxD0qawHjdSrRXY
   LTKlXVaHYP7UHUFQ7lLGNsYZ02KMSemLfMccnXygN2KSBuSbe74dJfdKc
   pgua2RQXksJp+6zsaB8kTE710y+ThAVjg21U1asmVR/zfy1iaNUg2DORO
   MdhOP5KJ6Q/ei7GpRkVzeVCNWe3aUrsiPruthKmkY3/1LzWc3wanoWFNN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="312998123"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="312998123"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 05:18:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="704027422"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="704027422"
Received: from liangqi1-mobl.ccr.corp.intel.com (HELO [10.254.208.124]) ([10.254.208.124])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 05:18:43 -0800
Message-ID: <ccf06c0d-8ca9-9693-c580-d832e162fbfa@linux.intel.com>
Date:   Tue, 21 Feb 2023 21:18:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-10-robert.hu@linux.intel.com>
 <2c7c4d73-810e-6c9c-0480-46d68dedadc8@linux.intel.com>
 <587054f9715283ef4414af64dd69cda1f7597380.camel@linux.intel.com>
 <fc84dd84-67c5-5565-b989-7e6bb9116c6e@linux.intel.com>
 <20230221111328.jaosfrcw2da7jx76@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230221111328.jaosfrcw2da7jx76@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/21/2023 7:13 PM, Yu Zhang wrote:
>> The special handling for LA57 is from the patch "kvm: x86: Return LA57
>> feature based on hardware capability".
>> https://lore.kernel.org/lkml/1548950983-18458-1-git-send-email-yu.c.zhang@linux.intel.com/
>>
>> The reason is host kernel may disable 5-level paging using cmdline parameter
>> 'no5lvl', and it will clear the feature bit for LA57 in boot_cpu_data.
>> boot_cpu_data is queried in kvm_set_cpu_caps to derive kvm cpu cap masks.
>>
>> " VMs can still benefit from extended linear address width, e.g. to enhance
>> features like ASLR" even when host  doesn't use 5-level paging.
>> So, the patch sets LA57 based on hardware capability.
>>
>> I was just wondering  whether LAM could be the similar case that the host
>> disabled the feature somehow (e.g via clearcpuid), and the guest still want
>> to use it.
> Paging modes in root & non-root are orthogonal, so should LAM.

Agree.


>
> B.R.
> Yu
