Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999181B025
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 08:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfEMGFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 02:05:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:16103 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfEMGFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 02:05:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 May 2019 23:05:04 -0700
X-ExtLoop1: 1
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga004.jf.intel.com with ESMTP; 12 May 2019 23:05:03 -0700
Subject: Re: [PATCH] x86: Halt on exit
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190509195023.11933-1-nadav.amit@gmail.com>
 <6A5B897E-FF0F-4CD9-85D8-2C071CEF59CC@gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <493fe8e3-e6d3-72ce-4cbf-b17898f1b0b7@intel.com>
Date:   Mon, 13 May 2019 14:05:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6A5B897E-FF0F-4CD9-85D8-2C071CEF59CC@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/2019 11:34 AM, Nadav Amit wrote:
> Err… kvm-unit-tests patch if there is any doubt.
>
you should contain kvm-unit-tests in the subject as
[kvm-unit-tests PATCH]

otherwise, we don't know it's a kvm-unit-tests patch.

>> On May 9, 2019, at 12:50 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>>
>> In some cases, shutdown through the test device and Bochs might fail.
>> Just hang in a loop that executes halt in such cases.
>>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> lib/x86/io.c | 4 ++++
>> 1 file changed, 4 insertions(+)
>>
>> diff --git a/lib/x86/io.c b/lib/x86/io.c
>> index f3e01f7..e6372c6 100644
>> --- a/lib/x86/io.c
>> +++ b/lib/x86/io.c
>> @@ -99,6 +99,10 @@ void exit(int code)
>> #else
>>          asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
>> #endif
>> +	/* Fallback */
>> +	while (1) {
>> +		asm volatile ("hlt" ::: "memory");
>> +	}
>> 	__builtin_unreachable();
>> }
>>
>> -- 
>> 2.17.1
> 
> 
