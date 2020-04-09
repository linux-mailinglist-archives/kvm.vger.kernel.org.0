Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB271A30F4
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 10:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDIIbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 04:31:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:49590 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgDIIbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 04:31:13 -0400
IronPort-SDR: nOqDb6T2s1w6AhsKscM/yqBf07EOA58wjdVRbfB+zluQABhA6kPltL0Fmx/D6noYlC2hMliJh8
 hd57sZtDuniA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 01:31:12 -0700
IronPort-SDR: UyzfwwvTxs91mk+/9umgbvC3ZhZEyS4H9wAa1h5xXq0N7/zcgPREo0I0IuEJqBS3YNu3OQg6go
 048/UpUhvkGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,362,1580803200"; 
   d="scan'208";a="275736772"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.236]) ([10.238.4.236])
  by fmsmga004.fm.intel.com with ESMTP; 09 Apr 2020 01:31:12 -0700
Reply-To: like.xu@intel.com
Subject: Re: Current mainline kernel FTBFS in KVM SEV
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <8079b118-1ff4-74a8-7010-0601d211a221@intel.com>
Date:   Thu, 9 Apr 2020 16:31:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bizjak,

would you mind telling us the top commit ID in your kernel tree ?
Or you may try the queue branch of 
https://git.kernel.org/pub/scm/virt/kvm/kvm.git
and check if this "undefined reference" issue gets fixed.

Thanks,
Like Xu

On 2020/4/9 16:20, Uros Bizjak wrote:
> Current mainline kernel fails to build (on Fedora 31) with:
>
>    GEN     .version
>    CHK     include/generated/compile.h
>    LD      vmlinux.o
>    MODPOST vmlinux.o
>    MODINFO modules.builtin.modinfo
>    GEN     modules.builtin
>    LD      .tmp_vmlinux.btf
> ld: arch/x86/kvm/svm/sev.o: in function `sev_flush_asids':
> /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:48: undefined reference to
> `sev_guest_df_flush'
> ld: arch/x86/kvm/svm/sev.o: in function `sev_hardware_setup':
> /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:1146: undefined reference
> to `sev_platform_status'
>    BTF     .btf.vmlinux.bin.o
>
> .config is attached.
>
> Uros.

