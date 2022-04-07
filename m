Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8379B4F7D9F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 13:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiDGLME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 07:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244680AbiDGLMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 07:12:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C390D64E8;
        Thu,  7 Apr 2022 04:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649329793; x=1680865793;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EQGzKLPkMKM4S+AjnO1qx/YQtzyW0JHeQb2G2zJJxgA=;
  b=DAUufCwV31fU6M1MrDQHZzhX3+UYl+kKkdv+2OPhTRycEJydlRA9wN7o
   ziarUu7ao2t06Pyf5+HEzNZKnPzygeqlw7wBKmQxnGTL7LCramO1wVHu5
   uWUlffYwTkH8LZn5krzQJCehKL0oKsR5agDWwdpWDQ3e+pKBUk2U8K8ji
   cedfnFS/4EvbWWln4fcqsvAf9oKNJySgjN3lBKA2JI4gqzEJD1DJRYM3P
   k7pRae0XHnqjCPxKpUMqwoOrcjr5cZOyAeGTUpVnQffMIpS2WtxIZYOF6
   3bk8SKa4qfk1gWnC5w8PEs0hCdUfNHs7LoXsWrQMiVq81bGdx1MULnzQz
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="324455542"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="324455542"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 04:09:40 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="722919033"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.125]) ([10.255.28.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 04:09:38 -0700
Message-ID: <48ab3a81-a353-e6ee-7718-69c260c9ea17@intel.com>
Date:   Thu, 7 Apr 2022 19:09:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 101/104] KVM: TDX: Silently ignore INIT/SIPI
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d0eb8fa53e782a244397168df856f9f904e4d1cd.1646422845.git.isaku.yamahata@intel.com>
 <efbe06a7-3624-2a5a-c1c4-be86f63951e3@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <efbe06a7-3624-2a5a-c1c4-be86f63951e3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/2022 11:48 PM, Paolo Bonzini wrote:
> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
>> +        if (kvm_init_sipi_unsupported(vcpu->kvm))
>> +            /*
>> +             * TDX doesn't support INIT.  Ignore INIT event.  In the
>> +             * case of SIPI, the callback of
>> +             * vcpu_deliver_sipi_vector ignores it.
>> +             */
>>               vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>> -        else
>> -            vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>> +        else {
>> +            kvm_vcpu_reset(vcpu, true);
>> +            if (kvm_vcpu_is_bsp(apic->vcpu))
>> +                vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>> +            else
>> +                vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
>> +        }
> 
> Should you check vcpu->arch.guest_state_protected instead of 
> special-casing TDX? 

We cannot use vcpu->arch.guest_state_protected because TDX supports 
debug TD, of which the states are not protected.

At least we need another flag, I think.

> KVM_APIC_INIT is not valid for SEV-ES either, if I 
> remember correctly.
> 
> Paolo

