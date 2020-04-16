Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C501AB5C5
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 04:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgDPCMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 22:12:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:20682 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731407AbgDPCMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 22:12:30 -0400
IronPort-SDR: 8mGLUT/4SaB8AsMc5GOv+brypk4a3x6EP57p0QeW/E9ip031U3o0DWYfebj4mV70OInmgaJ7wW
 0KTy96t5yyHw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 19:12:30 -0700
IronPort-SDR: q3hLULqDtfpxH+QDcFiAQ6zuroNMCHhoiahSIbgbXUV1+hEpmQWFpazK47KGvDPv8pY/9OXoHv
 LngJ5mHV+QHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="271922934"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.241]) ([10.255.29.241])
  by orsmga002.jf.intel.com with ESMTP; 15 Apr 2020 19:12:27 -0700
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
References: <20200414063129.133630-1-xiaoyao.li@intel.com>
 <20200414063129.133630-5-xiaoyao.li@intel.com>
 <87y2qwmszt.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <906dd919-3ae5-5279-b706-168e509ce953@intel.com>
Date:   Thu, 16 Apr 2020 10:12:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87y2qwmszt.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/16/2020 3:47 AM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Due to the fact that TEST_CTRL MSR is per-core scope, i.e., the sibling
>> threads in the same physical CPU core share the same MSR, only
>> advertising feature split lock detection to guest when SMT is disabled
>> or unsupported, for simplicitly.
> 
> That's not for simplicity. It's for correctness because you cannot
> provide consistent state to a guest.
> 

I'll correct it.

Thanks!
-Xiaoyao

