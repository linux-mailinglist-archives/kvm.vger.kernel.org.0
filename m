Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B828C12AE
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 03:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfI2BaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 21:30:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:43547 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfI2BaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 21:30:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Sep 2019 18:30:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,561,1559545200"; 
   d="scan'208";a="390424450"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.82]) ([10.239.196.82])
  by fmsmga005.fm.intel.com with ESMTP; 28 Sep 2019 18:30:08 -0700
Subject: Re: [PATCH RESEND v4 1/2] x86/cpu: Add support for
 UMONITOR/UMWAIT/TPAUSE
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Jingqi" <jingqi.liu@intel.com>
References: <20190918072329.1911-1-tao3.xu@intel.com>
 <20190918072329.1911-2-tao3.xu@intel.com>
 <a1156a86-3ec3-da72-306b-1fafa0c369d7@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <705e50fa-2d98-52ac-cdb7-1d68ca8f4b5d@intel.com>
Date:   Sun, 29 Sep 2019 09:30:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a1156a86-3ec3-da72-306b-1fafa0c369d7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/2019 4:22 AM, Paolo Bonzini wrote:
> On 18/09/19 09:23, Tao Xu wrote:
>> +    } else if (function == 7 && index == 0 && reg == R_ECX) {
>> +        if (enable_cpu_pm) {
>> +            ret |= CPUID_7_0_ECX_WAITPKG;
>> +        }
> 
> This should be the opposite; remove the bit if enable_cpu_pm is not set.
> 
> Paolo
> 
Thanks, I will improve it.
