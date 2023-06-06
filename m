Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F577237B8
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 08:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjFFGaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 02:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjFFGaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 02:30:23 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B13892
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 23:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686033022; x=1717569022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6ffaDhMt2DoNHPnh1BsAlR5cGI1f13RJhKdlXn4vdTE=;
  b=HpwDTJ2Hp6IUIVXjUvLpncLfHcbRbuGnENypaHRe3T2ywk7FGMr7G/ca
   q76BQ9P25921TFtQJdk9RnGhkUXd4WgTpI0kJKBqsXcAHW0vGdN3UMUOw
   xUxOsCWszV6p657+uR0BZ6+6nUWkV4Um8kmnEU16+lFQ9sF0IuyBVnyOh
   GVV2VsPm0/AbHsYeckLUzcebh3vyltvvChjPLU+xj87/rRY7b3IlBpWjc
   M5fT1T/nUNsUIJ6J4X63tF29SGGR0OaJFEt3biqH1HXWTPD4CEwbW+TNm
   v/431oQaeLZTnpXK79sgVh57LYXYwPSdthbw35izAj15bZazPm2fGFDXp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336202842"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336202842"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:30:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="742018917"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="742018917"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.170.159]) ([10.249.170.159])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:30:20 -0700
Message-ID: <fce55a35-2d18-f5fd-34c9-6214884fb7f9@linux.intel.com>
Date:   Tue, 6 Jun 2023 14:30:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 1/3] KVM: Fix comment for KVM_ENABLE_CAP
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
References: <20230518091339.1102-1-binbin.wu@linux.intel.com>
 <20230518091339.1102-2-binbin.wu@linux.intel.com>
 <ZH9BcFnv9yile92+@yilunxu-OptiPlex-7050>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZH9BcFnv9yile92+@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/6/2023 10:23 PM, Xu Yilun wrote:
> On 2023-05-18 at 17:13:37 +0800, Binbin Wu wrote:
>> Fix comment for vcpu ioctl version of KVM_ENABLE_CAP.
>>
>> KVM provides ioctl KVM_ENABLE_CAP to allow userspace to enable an
>> extension which is not enabled by default. For vcpu ioctl version,
>> it is available with the capability KVM_CAP_ENABLE_CAP. For vm ioctl
>> version, it is available with the capability KVM_CAP_ENABLE_CAP_VM.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>>   include/uapi/linux/kvm.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 737318b1c1d9..bddf2871db8f 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
> tools/include/uapi/linux/kvm.h also needs the change?
Sean suggested "never update KVM's uapi headers in tools/ in KVM's tree"
So I dropped the change to tools/include/uapi/linux/kvm.h

You can refer to the following links for detials:
https://lore.kernel.org/kvm/ZGVGkpvWQqLX2BrV@google.com/
https://lore.kernel.org/all/Y8bZ%2FJ98V5i3wG%2Fv@google.com/

>
> Thanks,
> Yilun
>
>> @@ -1613,7 +1613,7 @@ struct kvm_s390_ucas_mapping {
>>   #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
>>   #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
>>   /*
>> - * vcpu version available with KVM_ENABLE_CAP
>> + * vcpu version available with KVM_CAP_ENABLE_CAP
>>    * vm version available with KVM_CAP_ENABLE_CAP_VM
>>    */
>>   #define KVM_ENABLE_CAP            _IOW(KVMIO,  0xa3, struct kvm_enable_cap)
>> -- 
>> 2.25.1
>>

