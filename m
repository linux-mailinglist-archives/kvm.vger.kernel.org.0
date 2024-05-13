Return-Path: <kvm+bounces-17299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD148C3B70
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0812F1F214B0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BD0145B19;
	Mon, 13 May 2024 06:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BjPthugY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2E014265
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 06:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715582285; cv=none; b=VoUcM/1HEbiKuwU1EyADfj0A5ZDcm7ayrHAgPYTtMLJd0hzLsPB3TcJmFpdix/cUJVULx9rpF//X/Hnlu79YzlAeEXyHbg912KS8rXJ4qbSdpBzkbut0jOo/F7EcLldBr75y9rz+75ozqsaF4yeqpj62AeGcZv8IauRhB6Xcfcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715582285; c=relaxed/simple;
	bh=zNTZwvBDmX+sT3qmwN7yy8aF9Vt4yfZqmuSijXDvB14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xu1YuzZXJOwhU26ebfr3zMGL1fGM785+gBbJO2YU4QAg1X8LnOsueBnQKWHE+VvwxX3KU3vgkFRXpMcbQfVJBS57GJxe1Zcr7E2/VJztXEUdZylsbjonTqKrpel6uFGYivNCovVRDrNTU5HC5n8xo1MpIIrmT5J+ybVjCPnOltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BjPthugY; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715582283; x=1747118283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zNTZwvBDmX+sT3qmwN7yy8aF9Vt4yfZqmuSijXDvB14=;
  b=BjPthugYxwVBTYYqxJFNFAK0genmylMBuWja7MG48rxnq5LgQLVE/m4R
   Lb/8ANZHkYLirC84VqmhHsdvfyV9jOjpQcZEQi1t9uyWabHx3JLol79w9
   OMwtoEAd0IiKIXbGD20qvA5gVtAZK6HESF1cRy2F8trq7k/Ek2q/SSpV5
   8938fU7gvVkLMxH+z9tqNYZME8U2uLreB2RNJ13+Q/6sc3afyQBlONy4o
   WiWaYJFu/V3+xg6Nc4f3nPVlvyp215MW4lxfFtSdnjvG4b3w3tIXnEsBQ
   epPQ3A+rOvTfd8AGCEPviL4k7wv9G3PD3orQB+72SvPebhq8ZFhfsswBn
   A==;
X-CSE-ConnectionGUID: elmLng4GQ0ytT6TMR5al1A==
X-CSE-MsgGUID: oHH2zueQTNqTasu07fEnPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="11625816"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="11625816"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:38:03 -0700
X-CSE-ConnectionGUID: LHlwyNm/SG6aO/vBA/VsJA==
X-CSE-MsgGUID: hNjwTF5uRYeX7W54AvK6cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30269659"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 12 May 2024 23:37:59 -0700
Date: Mon, 13 May 2024 14:52:14 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Message-ID: <ZkG4nlwRnvz9oUXX@intel.com>
References: <20240409024940.180107-1-shahuang@redhat.com>
 <Zh1j9b92UGPzr1-a@redhat.com>
 <Zjyb43JqMZA+bO4r@intel.com>
 <ZjyZ1ZV7BGME_bY9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjyZ1ZV7BGME_bY9@redhat.com>

Hi Daniel,

> Please describe it in terms of a QAPI definition, as that's what we're
> striving for with all QEMU public interfaces. Once the QAPI design is
> agreed, then the -object mapping is trivial, as -object's JSON format
> supports arbitrary QAPI structures.

Thank you for your guidance!

I rethought and and modified my previous proposal:

Let me show the command examples firstly:
  * Add a single event:
    (x86) -object kvm-pmu-event,id=e0,action=allow,format=x86-default,\
                  select=0x3c,umask=0x00
    (arm or general) -object kvm-pmu-event,id=e1,action=deny,\
                             format=raw,code=0x01
 
  * Add a counter bitmap:
    (x86) -object kvm-pmu-counter,id=cnt,action=allow,type=x86-fixed,\
                  bitmap=0xffff0000
 
  * Add an event list (must use Json syntax format):
   (x86) -object '{"qom-type":"kvm-pmu-event-list","id"="filter0","action"="allow","format"="x86-default","events=[{"select"=0x3c,"umask"=0x00},{"select"=0x2e,"umask"=0x4f}]'
   (arm) -object '{"qom-type":"kvm-pmu-event-list","id"="filter1","action"="allow","format"="raw","events"=[{"code"=0x01},{"code"=0x02}]'


The specific JSON definitions are as follows (IIUC, this is "in terms of
a QAPI definition", right? ;-)): 
* Define PMU event and counter bitmap with JSON format:
  - basic filter action:

  { 'enum': 'KVMPMUFilterAction',
    'prefix': 'KVM_PMU_FILTER_ACTION',
    'data': ['deny', 'allow' ] }

  - PMU counter:

  { 'enum': 'KVMPMUCounterType',
    'prefix': 'KVM_PMU_COUNTER_TYPE',
    'data': [ 'x86-fixed' ] }

  { 'struct': 'KVMPMUX86FixedCounter',
    'data': { 'bitmap': 'uint32' } }

  - PMU events (total 3 formats):

  # 3 encoding formats: "raw" is compatible with shaoqin's ARM format as
  # well as the x86 raw format, and could support other architectures in
  # the future.
  { 'enum': 'KVMPMUEventEncodeFmt',
    'prefix': 'KVM_PMU_EVENT_ENCODE_FMT',
    'data': ['raw', 'x86-default', 'x86-masked-entry' ] }

  # A general format.
  { 'struct': 'KVMPMURawEvent',
    'data': { 'code': 'uint64' } }

  # x86-specific
  { 'struct': 'KVMPMUX86DefalutEvent',
    'data': { 'select': 'uint16',
              'umask': 'uint16' } }

  # another x86 specific
  { 'struct': 'KVMPMUX86MaskedEntry',
    'data': { 'select': 'uint16',
              'match': 'uint8',
              'mask': 'uint8',
              'exclude': 'bool' } }

  # And their list wrappers:
  { 'struct': 'KVMPMURawEventList',
    'data': { 'events': ['KVMPMURawEvent'] } }

  { 'struct': 'KVMPMUX86DefalutEventList',
    'data': { 'events': ['KVMPMUX86DefalutEvent'] } }

  { 'struct': 'KVMPMUX86MaskedEntryList',
    'data': { 'events': ['KVMPMUX86MaskedEntryList'] } }


Based on the above basic structs, we could provide 3 new more qom-types:
  - 'kvm-pmu-counter': 'KVMPMUFilterCounter'

  # This is a single object option to configure PMU counter
  # bitmap filter.
  { 'union': 'KVMPMUFilterCounter',
    'base': { 'action': 'KVMPMUFilterAction',
              'type': 'KVMPMUCounterType' },
    'discriminator': 'type',
    'data': { 'x86-fixed': 'KVMPMUX86FixedCounter' } }


  - 'kvm-pmu-counter': 'KVMPMUFilterCounter'

  # This option is used to configure a single PMU event for
  # PMU filter.
  { 'union': 'KVMPMUFilterEvent',
    'base': { 'action': 'KVMPMUFilterAction',
              'format': 'KVMPMUEventEncodeFmt' },
    'discriminator': 'format',
    'data': { 'raw': 'KVMPMURawEvent',
              'x86-default': 'KVMPMUX86DefalutEvent',
              'x86-masked-entry': 'KVMPMUX86MaskedEntry' } }


  - 'kvm-pmu-event-list': 'KVMPMUFilterEventList'

  # Used to configure multiple events.
  { 'union': 'KVMPMUFilterEventList',
    'base': { 'action': 'KVMPMUFilterAction',
              'format': 'KVMPMUEventEncodeFmt' },
    'discriminator': 'format',
    'data': { 'raw': 'KVMPMURawEventList',
              'x86-default': 'KVMPMUX86DefalutEventList',
              'x86-masked-entry': 'KVMPMUX86MaskedEntryList' } }


Compared to Shaoqin's original format, kvm-pmu-event-list is not able to
enumerate events continuously (similar to 0x00-0x30 before), and now
user must enumerate events one by one individually.

What do you think about the above 3 new commands?

Thanks and Best Regards,
Zhao


