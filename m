Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7D37045BF
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 09:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjEPHDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 03:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjEPHD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 03:03:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992B340D3;
        Tue, 16 May 2023 00:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684220602; x=1715756602;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0YBeOqwQM7fdN0SRIBcYBPydumc4yHW+M1js/Xg9k0s=;
  b=iZtd4zVUk86eEEWaG7WDbX83L98rerLUJH/P7zrfirCPjJ0O4W0sDoTl
   AKXQhNS+k0wktlHL/6P+Neo2rOmPUsV9qjhGAQy3e9DIGLF1IwmhzvqbY
   Paf+uJYHjbMnGxiIFyR6yPnV+A1dTHM9uWYi8kCBu1X+duEQTy/yKnJLa
   HZA8hgNurr71ZBsxRaAgKmD4dPAeMyGpASfpe7ireEAalWtZhuSRk+qhs
   BWdBCHmXlBXjVRQ6fcj2KQ2Rp5TImI1ka4dJjx5f8/8sv5rhF2dX5GUZV
   XFBuKT2KdAKG9wivvcOWoSibQ4KwcBheJo0isgPtXoE6IdTaLylL7A5yp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331762932"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331762932"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:03:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="678733675"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="678733675"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.11]) ([10.255.31.11])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:03:17 -0700
Message-ID: <11b515b3-bb5a-bea1-ad01-caffdd151bf6@intel.com>
Date:   Tue, 16 May 2023 15:03:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
 <a88b2504-b79b-83d6-383e-a948f9da662b@intel.com>
 <ZGLkvlx5W0JStTjD@chao-email>
 <9c75663c-6363-34e7-8341-d8f719365768@intel.com>
 <ZGLyEhKH+MoCY/R4@chao-email>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZGLyEhKH+MoCY/R4@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/2023 11:01 AM, Chao Gao wrote:
> On Tue, May 16, 2023 at 10:22:22AM +0800, Xiaoyao Li wrote:
>>>> I think we need to fix this bug at first.
>>>
>>> I have no idea how to fix the "bug" without intercepting the MSR. The
>>> performance penalty makes me think intercepting the MSR is not a viable
>>> solution.
>>
>> I thought correctness always takes higher priority over performance.
> 
> It is generally true. however, there are situations where we should make
> trade-offs between correctness and other factors (like performance):
> 
> E.g., instructions without control bits, to be 100% compliant with CPU
> spec, in theory, VMMs can trap/decode every instruction and inject #UD
> if a guest tries to use some instructions it shouldn't.

This is the virtualization hole. IMHO, they are different things.

Pass through MSR_IA32_SPEC_CTRL was introduced in commit d28b387fb74d 
("KVM/VMX: Allow direct access to MSR_IA32_SPEC_CTRL"). At that time 
there was only a few bits defined, and the changelog called out that

   No attempt is made to handle STIBP here, intentionally. Filtering
   STIBP may be added in a future patch, which may require trapping all
   writes if we don't want to pass it through directly to the guest.

Per my undesrstanding, it implied that we need to re-visit it when more 
bits added instead of following the pass-through design siliently.
