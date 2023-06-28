Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79222740C10
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbjF1I6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:58:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:49902 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232712AbjF1Ima (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687941750; x=1719477750;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9J5gR38+qfCPdwPoriwRdvlX7FhExR9b/qgLe8IrYhg=;
  b=cNrh/9EU7xLMyWYfrb+IWpeKal19p+VHhv/w4bDcO8GhkedNz/AXeAQT
   bJAggQy0aoxzY/LX7Aqcnhu2PTn5W0TeNw/k6M+9RCCgUdpiyLJQYyL+j
   urvcDb1ZjVBGK7AQGNAOsdbM172onBPWuAld2/XlfCxblNUXKSwsYpuox
   Fl3L9OVYXSIi+MFo+0CnhSsZAyclXRn0E1XJgVOBW7VBItkOestu+0Mfs
   XbkeucBs/pJBSlJ5cHnxytpnwLZ+BAxlY7ciRA4r2bYLNoXF+vsGSrlE7
   jC7k1dbnBN1mjdzXkYpva+s+dgMomj+vL9H9MIhS8xy2K7Da6XHFMeHWn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="448174213"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="448174213"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 01:42:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="1047308957"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="1047308957"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.2.33]) ([10.238.2.33])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 01:42:25 -0700
Message-ID: <2b5303c5-1798-72d1-237f-395029eea3ec@intel.com>
Date:   Wed, 28 Jun 2023 16:42:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v1 0/6] LASS KVM virtualization support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <ZJsXl6emfV2yr4rs@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZJsXl6emfV2yr4rs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/28/2023 1:08 AM, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Zeng Guang wrote:
>> This patch series provide a LASS KVM solution.
> ... and depends on kernel enabling that can be found at
>
> https://lore.kernel.org/all/20230609183632.48706-1-alexander.shishkin@linux.intel.com
OK. I will add the dependency statement in next version.
>> We tested the basic function of LASS virtualization including LASS
>> enumeration and enabling in non-root and nested environment. As KVM
>> unittest framework is not compatible to LASS rule, we use kernel module
>> and application test to emulate LASS violation instead. With KVM forced
>> emulation mechanism, we also verified the LASS functionality on some
>> emulation path with instruction fetch and data access to have same
>> behavior as hardware.
>>
>> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>> Chapter Linear Address Space Separation (LASS)

