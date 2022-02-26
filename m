Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D926C4C539D
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 05:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiBZEII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 23:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiBZEIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 23:08:07 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F57918D;
        Fri, 25 Feb 2022 20:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645848453; x=1677384453;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2kX3LCnRH7cf3kJMyHw3mfXl9vIZg8ODs5GtpBfZt50=;
  b=gRT4BGTZ88Oq6jmOv8+G3BqCdeMs0NNnSm6BgpFIyyqOtjPUUNqMgnn1
   HcCwmtZCS+XDpvrZ3GWVw12ZZqw+eOKsPaybQ9BWh3i0hEoGksyvOi3xn
   DxEG9JkAZid6s7V2GyevMnHzFyBgBC1X7RFPBSBpJfEzgPXj24R9DcYcK
   fOIslHncxLHCdWbC3p9/h9sfIwWvr1iWnOt6BOMZ2EG0sYqFQcgIQyLEr
   QqgXNwFjiOMfWhKF/FQTJ44rKwlt8DyXZ4sQ5C09ZDTFvTBpggX2M/cY6
   gSn4xpjRfBnWpTda6Ae14qHqk4azRJzBObmUorNtx50gxcMmz+9uHOC/v
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10269"; a="252822964"
X-IronPort-AV: E=Sophos;i="5.90,138,1643702400"; 
   d="scan'208";a="252822964"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 20:07:32 -0800
X-IronPort-AV: E=Sophos;i="5.90,138,1643702400"; 
   d="scan'208";a="509483100"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.136]) ([10.255.28.136])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 20:07:28 -0800
Message-ID: <bcc83b3d-31fe-949a-6bbf-4615bb982f0c@intel.com>
Date:   Sat, 26 Feb 2022 12:07:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <CALMp9eT50LjXYSwfWENjmfg=XxT4Bx3RzOYubKty8kr_APXCEw@mail.gmail.com>
 <88eb9a9a-fbe3-8e2c-02bd-4bdfc855b67f@intel.com>
 <6a839b88-392d-886d-836d-ca04cf700dce@intel.com>
 <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <7859e03f-10fa-dbc2-ed3c-5c09e62f9016@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/2022 11:13 PM, Paolo Bonzini wrote:
> On 2/25/22 16:12, Xiaoyao Li wrote:
>>>>>
>>>>
>>>> I don't like the idea of making things up without notifying userspace
>>>> that this is fictional. How is my customer running nested VMs supposed
>>>> to know that L2 didn't actually shutdown, but L0 killed it because the
>>>> notify window was exceeded? If this information isn't reported to
>>>> userspace, I have no way of getting the information to the customer.
>>>
>>> Then, maybe a dedicated software define VM exit for it instead of 
>>> reusing triple fault?
>>>
>>
>> Second thought, we can even just return Notify VM exit to L1 to tell 
>> L2 causes Notify VM exit, even thought Notify VM exit is not exposed 
>> to L1.
> 
> That might cause NULL pointer dereferences or other nasty occurrences.

IMO, a well written VMM (in L1) should handle it correctly.

L0 KVM reports no Notify VM Exit support to L1, so L1 runs without 
setting Notify VM exit. If a L2 causes notify_vm_exit with 
invalid_vm_context, L0 just reflects it to L1. In L1's view, there is no 
support of Notify VM Exit from VMX MSR capability. Following L1 handler 
is possible:

a)	if (notify_vm_exit available & notify_vm_exit enabled) {
		handle in b)	
	} else {
		report unexpected vm exit reason to userspace;
	}

b) 	similar handler like we implement in KVM:
	if (!vm_context_invalid)
		re-enter guest;
	else
		report to userspace;

c)	no Notify VM Exit related code (e.g. old KVM), it's treated as 
unsupported exit reason

As long as it belongs to any case above, I think L1 can handle it 
correctly. Any nasty occurrence should be caused by incorrect handler in 
L1 VMM, in my opinion.

> Paolo
> 

