Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A13A1C7D6F
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 00:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgEFWgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 18:36:18 -0400
Received: from ale.deltatee.com ([207.54.116.67]:33948 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgEFWgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 18:36:18 -0400
Received: from s0106602ad0811846.cg.shawcable.net ([68.147.191.165] helo=[192.168.0.12])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1jWSeG-0001RP-PL; Wed, 06 May 2020 16:36:17 -0600
To:     Dave Hansen <dave.hansen@intel.com>,
        Babu Moger <babu.moger@amd.com>, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
 <158880253347.11615.8499618616856685179.stgit@naples-babu.amd.com>
 <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <5081782d-bec2-b82c-8d3b-87fcb5d847ae@deltatee.com>
Date:   Wed, 6 May 2020 16:36:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 68.147.191.165
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, acme@redhat.com, sam@ravnborg.org, yamada.masahiro@socionext.com, vineela.tummalapalli@intel.com, fenghua.yu@intel.com, pawan.kumar.gupta@linux.intel.com, andrew.cooper3@citrix.com, jgross@suse.com, keescook@chromium.org, ira.weiny@intel.com, robin.murphy@arm.com, justin.he@arm.com, aarcange@redhat.com, thellstrom@vmware.com, arjunroy@google.com, dan.j.williams@intel.com, peterx@redhat.com, rppt@linux.vnet.ibm.com, steven.price@arm.com, akpm@linux-foundation.org, jan.kiszka@siemens.com, anshuman.khandual@arm.com, asteinhauser@google.com, yang.shi@linux.alibaba.com, bigeasy@linutronix.de, namit@vmware.com, changbin.du@intel.com, mchehab+samsung@kernel.org, peterz@infradead.org, luto@kernel.org, dave.hansen@linux.intel.com, joro@8bytes.org, jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com, x86@kernel.org, sean.j.christopherson@intel.com, pbonzini@redhat.com, hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, corbet@lwn.net, babu.moger@amd.com, dave.hansen@intel.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH 1/2] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-06 4:21 p.m., Dave Hansen wrote:
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 1197b5596d5a..8630b9fa06f5 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1886,11 +1886,11 @@ config X86_UMIP
>>  	  specific cases in protected and virtual-8086 modes. Emulated
>>  	  results are dummy.
>>  
>> -config X86_INTEL_MEMORY_PROTECTION_KEYS
>> -	prompt "Intel Memory Protection Keys"
>> +config X86_MEMORY_PROTECTION_KEYS
>> +	prompt "Memory Protection Keys"
>>  	def_bool y
>>  	# Note: only available in 64-bit mode
>> -	depends on CPU_SUP_INTEL && X86_64
>> +	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
>>  	select ARCH_USES_HIGH_VMA_FLAGS
>>  	select ARCH_HAS_PKEYS
>>  	---help---
> 
> It's a bit of a bummer that we're going to prompt everybody doing
> oldconfig's for this new option.  But, I don't know any way for Kconfig
> to suppress it if the name is changed.  Also, I guess the def_bool=y
> means that menuconfig and olddefconfig will tend to do the right thing.
> 
> Do we *really* need to change the Kconfig name?  The text prompt, sure.
>  End users see that and having Intel in there is massively confusing.
> 
> If I have to put up with seeing 'amd64' all over my Debian package
> names, you can put up with a Kconfig name. :P

Lol, isn't that just Intel's penance for Itanium?

Logan
