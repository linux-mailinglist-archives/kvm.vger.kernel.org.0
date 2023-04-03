Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBF56D3C35
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 05:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjDCDqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 23:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjDCDqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 23:46:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A848693D1;
        Sun,  2 Apr 2023 20:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680493581; x=1712029581;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wnzNf0gd51fOt3CJV4bjBBkYPO54QFZwipzBf7ePuCc=;
  b=PmNTtrMNF4GXeRFoXnJVwmWFdP94x+rhyl67se0QCLPzHevAIc9UA7XW
   dUjPsQnUZrfdcefI62PCYNcE6Xc62Re0oFUqkbloCSByQpnJNk5zoO+gl
   xD1fLc5bO0E1GCBAtpufqZgM9uXKB4UmhNgnccNT8gxvd4132gDaQGsh+
   wA1YtvBEC0/jpY1gJ0Qak4A+dhKEOUPeapNH377mTIY+Gnwh8iakZxqnV
   6pzorqVBna+3Kf9x/QTQwTgMhx1CGOKUpTbe1EnnWfiv3R6SUVHY1vwxQ
   zjUI3w7PD1951HULVx8fg2lb1qQj5BeueHQEoX3Pzi8AQwkKNW+7u/Vfi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="325800919"
X-IronPort-AV: E=Sophos;i="5.98,313,1673942400"; 
   d="scan'208";a="325800919"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 20:46:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="829407306"
X-IronPort-AV: E=Sophos;i="5.98,313,1673942400"; 
   d="scan'208";a="829407306"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.225]) ([10.249.175.225])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 20:46:17 -0700
Message-ID: <24ddf589-34a4-b312-72c1-8176ee3e8b35@intel.com>
Date:   Mon, 3 Apr 2023 11:46:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH v13 016/113] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
 <20230325104306.00004585@gmail.com>
 <20230329231722.GA1108448@ls.amr.corp.intel.com>
 <20230331001803.GE1112017@ls.amr.corp.intel.com>
 <20230331154432.00001373@gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230331154432.00001373@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/31/2023 8:44 PM, Zhi Wang wrote:
> On Thu, 30 Mar 2023 17:18:03 -0700
> Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> 
>> On Wed, Mar 29, 2023 at 04:17:22PM -0700,
>> Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
>>
>>> On Sat, Mar 25, 2023 at 10:43:06AM +0200,
>>> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
>>>
>>>> On Sun, 12 Mar 2023 10:55:40 -0700
>>>> isaku.yamahata@intel.com wrote:
>>>>
>>>> Does this have to be a new generic ioctl with a dedicated new x86_ops? SNP
>>>> does not use it at all and all the system-scoped ioctl of SNP going through
>>>> the CCP driver. So getting system-scope information of TDX/SNP will end up
>>>> differently.
>>>>
>>>> Any thought, Sean? Moving getting SNP system-wide information to
>>>> KVM dev ioctl seems not ideal and TDX does not have a dedicated driver like
>>>> CCP. Maybe make this ioctl TDX-specific? KVM_TDX_DEV_OP?
>>>
>>> We only need global parameters of the TDX module, and we don't interact with TDX
>>> module at this point.  One alternative is to export those parameters via sysfs.
>>> Also the existence of the sysfs node indicates that the TDX module is
>>> loaded(initialized?) or not in addition to boot log.  Thus we can drop system
>>> scope one.
>>> What do you think?
>>>
> 
> I like this idea and the patch below, it feels right for me now. It would be nice
> if more folks can chime in and comment.

SYSFS option requires CONFIG_SYSFS, which reqiures CONFIG_KVM_TDX to 
select CONFIG_SYSFS.

>>> Regarding to other TDX KVM specific ioctls (KVM_TDX_INIT_VM, KVM_TDX_INIT_VCPU,
>>> KVM_TDX_INIT_MEM_REGION, and KVM_TDX_FINALIZE_VM), they are specific to KVM.  So
>>> I don't think it can be split out to independent driver.
>>
> 
> They can stay in KVM as they are KVM-specific. SNP also has KVM-specific ioctls
> which wraps the SEV driver calls. At this level, both TDX and SNP go their specific
> implementation without more abstraction other than KVM_ENCRYPT_MEMORY_OP. Their
> strategies are aligned.
> 
> The problem of the previous approach was the abstraction that no other implementation
> is using it. It is like, TDX wants a higher abstraction to cover both TDX and SNP,
> but SNP is not using it, which makes the abstraction looks strange.

Note, before this TDX enabling series, KVM_MEMORY_ENCRYPT_OP is a VM 
scope ioctl, that only serves for SEV and no other implementation uses 
it. I see no reason why cannot introduce a new IOCTL in x86 KVM that 
serves only one vendor.

We choose KVM_MEMORY_ENCRYPT_OP for TDX platform scope, just because we 
reuse KVM_MEMORY_ENCRYPT_OP for TDX VM-scope and extend it to TDX vcpu 
scope. It's just to avoid defining a new IOCTL number.

We can rename it to KVM_GET_CC_CAPABILITIES, and even return different 
capabilities based on VM type. And even, if SNP wants to use it, I think 
it can wrap SNP driver calls inside this IOCTL?

kvm.ko is special that it needs to serve two vendors. Sometime it's 
unaviodable that an interface is only used by one vendor.
