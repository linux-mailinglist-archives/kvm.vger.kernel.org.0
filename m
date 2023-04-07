Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E7E6DA98C
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 09:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjDGHtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 03:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjDGHtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 03:49:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0705B83
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 00:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680853780; x=1712389780;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YUlw50DNql738M5Rm8yWNCkAccb7d+/Qlmh0Mm+dits=;
  b=NZgsVzTYchUydUaHnF614aWxTbRyLNYVZAnHeaNi4Z6NC5/tttVpkUgr
   f16dyYm1/rjyKgJKsIGP4XY1SJh76ATmzryn4iphWBskUoh0+EixhpyYI
   gBgprbJtypjoyLva3uzMd8HCoHEYpJ6SYTWMC+Y+MbAvaFJV4QOWPsCmQ
   qgr3KZG6GImX0PPVtx0EMqRgT0TMaWF1Bp3SmEfsYCyDUF3PqOfx+BNKS
   pv9Nz7vxqP/fjGffjoFaxkqL3s5gMdfgsPXmT3rxsgNCsnNtuPcbnwWR5
   GcAVNJojZ9onKK7mitP7EYH5Ijs58HV4y3/U5yQ3zON1UF+z53thPlRAD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="408071688"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="408071688"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 00:49:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="861719702"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="861719702"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.212.181]) ([10.254.212.181])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 00:49:37 -0700
Message-ID: <684ad799-8247-9d2a-2eed-c8cb08e96633@intel.com>
Date:   Fri, 7 Apr 2023 15:49:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Content-Language: en-US
To:     "Li, Xin3" <xin3.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/2023 5:34 PM, Li, Xin3 wrote:
> The VMCS IDT vectoring information field is used to report basic information
> associated with the event that was being delivered when a VM exit occurred.
> such an event itself doesn't trigger a VM exit, however, a condition to deliver
> the event is not met, e.g., EPT violation.
> 
> When the IDT vectoring information field reports a maskable external interrupt,
> KVM reinjects this external interrupt after handling the VM exit. Otherwise,
> the external interrupt is lost.
> 
> KVM handles a hardware exception reported in the IDT vectoring information
> field in the same way, which makes nothing wrong. This piece of code is in
> __vmx_complete_interrupts():
> 
>          case INTR_TYPE_SOFT_EXCEPTION:
>                  vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
>                  fallthrough;
>          case INTR_TYPE_HARD_EXCEPTION:
>                  if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
>                          u32 err = vmcs_read32(error_code_field);
>                          kvm_requeue_exception_e(vcpu, vector, err);
>                  } else
>                          kvm_requeue_exception(vcpu, vector);
>                  break;
> 
> But if KVM just ignores any hardware exception in such a case, the CPU will
> re-generate it once it resumes guest execution, which looks cleaner.
> 
> The question is, must KVM inject a hardware exception from the IDT vectoring
> information field? Is there any correctness issue if KVM does not?

Say there is a case that, a virtual interrupt arrives when an exception 
is delivering but hit EPT VIOLATION. The interrupt is pending and 
recorded in RVI.
- If KVM re-injects the exception on next VM entry, IDT vectoring first 
vectors exception handler and at the instruction boundary (before the 
first instruction of exception handler) to deliver the virtual interrupt 
(if allowed)
- If KVM doesn't re-inject the exception but relies on the re-execution 
of the instruction, then the virtual interrupt can be recognized and 
delivered before the instruction causes the exception.

I'm not sure if the order of events matters or not.

