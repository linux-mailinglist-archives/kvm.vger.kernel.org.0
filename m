Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F671AF8B8
	for <lists+kvm@lfdr.de>; Sun, 19 Apr 2020 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgDSIYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Apr 2020 04:24:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:7687 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgDSIYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Apr 2020 04:24:30 -0400
IronPort-SDR: nfOT4gWQwHmRiLCWXHHmc4bxyWd/JtJzjEoU5XtLf1hgBEmlUjFNgK2T1a9EKL8jvohyuzXdIU
 P2DNdEU9haew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 01:24:28 -0700
IronPort-SDR: 5bTV3PMh/h/IpB7kLfIrzCg8Fo/mJzhnyaMGYARomkIW7rvbXCWMjVwZD/fKzDk1jnTpAU1Qxz
 1DLl94MlS5Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,402,1580803200"; 
   d="scan'208";a="456070012"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.120]) ([10.255.30.120])
  by fmsmga006.fm.intel.com with ESMTP; 19 Apr 2020 01:24:20 -0700
Subject: Re: [PATCH] KVM: X86: Fix compile error in svm/sev.c
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200419073047.14413-1-tianjia.zhang@linux.alibaba.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <82ce1798-1dab-d271-d084-e9a89bb44e71@intel.com>
Date:   Sun, 19 Apr 2020 16:24:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419073047.14413-1-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/2020 3:30 PM, Tianjia Zhang wrote:
> The compiler reported the following compilation errors:
> 
> arch/x86/kvm/svm/sev.c: In function ‘sev_pin_memory’:
> arch/x86/kvm/svm/sev.c:361:3: error: implicit declaration of function
> ‘release_pages’ [-Werror=implicit-function-declaration]
>     release_pages(pages, npinned);
>     ^~~~~~~~~~~~~
> 
> The reason is that the 'pagemap.h' header file is not included.
> 

FYI.

Boris has sent the Patch:
https://lkml.kernel.org/r/20200411160927.27954-1-bp@alien8.de

and it's already in kvm master/queue branch



