Return-Path: <kvm+bounces-265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D5477DDAC7
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 02:59:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CF60281968
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 01:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4EBED1;
	Wed,  1 Nov 2023 01:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcU3Gxm6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EC8A35
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 01:59:34 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889F5ED;
	Tue, 31 Oct 2023 18:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698803970; x=1730339970;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hy+BaQYzelq4bNrPLUQer7B8U5ZvM3TM81vJ3Dtbimc=;
  b=KcU3Gxm6ncLm7JMJayPc4JBgTZlJ+CC/DJdY0Xzt6T9QfAK4S1QoL1MY
   jSCB5NqYNgCu1vdZ6O0AHsRDNG0eibZw3B3j4fNvAuIOoAC6MJ93ArVKG
   bwNexLcmLRXVFAThLl30DBCDWf+w+Wp/RlDPeIRaODh6FEl06nrXB0EEz
   CwNKN8bqPDMES75Z2b2YrQeuOkR4shhPQp3TcIqFA1s0gO0y+YKJKPqbN
   FoBUlRygGmrEE1EjN6pCk6uC8OxgMUoJwUrwSC8/rJeQqx5rTSvgKTzP0
   boqgoYqGxyKeckL2uCj6slln5G5m6FG18yMNvnB+l+Anmbdr95a6OUeoW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="367758528"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="367758528"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 18:59:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="8508070"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.12.33]) ([10.93.12.33])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 18:59:27 -0700
Message-ID: <c3f0e4ac-1790-40c1-a09e-209a09e3d230@linux.intel.com>
Date: Wed, 1 Nov 2023 09:59:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch 1/2] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots
 event
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Like Xu <likexu@tencent.com>
References: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com>
 <20231031090613.2872700-2-dapeng1.mi@linux.intel.com>
 <CALMp9eR_BFdNNTXhSpbuH66jXcRLVB8VvD8V+kY245NbusN2+g@mail.gmail.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eR_BFdNNTXhSpbuH66jXcRLVB8VvD8V+kY245NbusN2+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/2023 2:22 AM, Jim Mattson wrote:
> On Tue, Oct 31, 2023 at 1:58 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> This patch adds support for the architectural topdown slots event which
>> is hinted by CPUID.0AH.EBX.
> Can't a guest already program an event selector to count event select
> 0xa4, unit mask 1, unless the event is prohibited by
> KVM_SET_PMU_EVENT_FILTER?

Actually defining this new slots arch event is to do the sanity check 
for supported arch-events which is enumerated by CPUID.0AH.EBX. 
Currently vPMU would check if the arch event from guest is supported by 
KVM. If not, it would be rejected just like intel_hw_event_available() 
shows.

If we don't add the slots event in the intel_arch_events[] array, guest 
may program the slots event and pass the sanity check of KVM on a 
platform which actually doesn't support slots event and program the 
event on a real GP counter and got an invalid count. This is not correct.


>
> AFAICT, this change just enables event filtering based on
> CPUID.0AH:EBX[bit 7] (though it's not clear to me why two independent
> mechanisms are necessary for event filtering).


IMO, these are two different things. this change is just to enable the 
supported arch events check for slot events, the event filtering is 
another thing.


