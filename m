Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCEAD0981
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfJIIVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 04:21:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:56676 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJIIVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 04:21:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 01:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="205678883"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.191]) ([10.239.196.191])
  by orsmga002.jf.intel.com with ESMTP; 09 Oct 2019 01:21:36 -0700
Subject: Re: [PATCH v5 1/2] x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Jingqi" <jingqi.liu@intel.com>
References: <20190929015718.19562-1-tao3.xu@intel.com>
 <20190929015718.19562-2-tao3.xu@intel.com>
 <6762960d-80a6-be31-399d-f62e33b31f28@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <7e43e268-d94e-a66f-9254-3de03313a064@intel.com>
Date:   Wed, 9 Oct 2019 16:21:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <6762960d-80a6-be31-399d-f62e33b31f28@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/9/2019 4:06 PM, Paolo Bonzini wrote:
> On 29/09/19 03:57, Tao Xu wrote:
>> +    } else if (function == 7 && index == 0 && reg == R_ECX) {
>> +        if (enable_cpu_pm) {
>> +            ret |= CPUID_7_0_ECX_WAITPKG;
> 
> This is incorrect.  You should disable WAITPKG if !enable_cpu_pm, but
> you should not enable it forcefully if enable_cpu_pm is true.
> 
> Paolo
> 
>> +        } else {
>> +            ret &= ~CPUID_7_0_ECX_WAITPKG;
>> +        }
> 

Got it, thank you.
