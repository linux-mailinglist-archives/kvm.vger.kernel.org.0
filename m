Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32172D3CB
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 04:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfE2C1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 22:27:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:41957 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfE2C1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 22:27:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 19:27:35 -0700
X-ExtLoop1: 1
Received: from shzintpr04.sh.intel.com (HELO [0.0.0.0]) ([10.239.4.101])
  by orsmga001.jf.intel.com with ESMTP; 28 May 2019 19:27:32 -0700
Subject: Re: [PATCH v2 3/3] KVM: vmx: handle vm-exit for UMWAIT and TPAUSE
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-4-tao3.xu@intel.com>
 <b0958339-b23c-dd9d-8673-aae098769738@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <a2b463ee-c032-555e-b012-184e4f4753f1@intel.com>
Date:   Wed, 29 May 2019 10:25:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b0958339-b23c-dd9d-8673-aae098769738@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/2019 09:28, Paolo Bonzini wrote:
> On 24/05/19 09:56, Tao Xu wrote:
>> As the latest Intel 64 and IA-32 Architectures Software Developer's
>> Manual, UMWAIT and TPAUSE instructions cause a VM exit if the
>> “RDTSC exiting” and “enable user wait and pause” VM-execution controls
>> are both 1.
>>
>> This patch is to handle the vm-exit for UMWAIT and TPAUSE as invalid_op.
> 
> KVM never enables RDTSC exiting, so this is not necessary.
> 
> Paolo
> 
OK, but should we just drop this patch?
Or add the VMX_EXIT_REASONS bits of UMWAIT and TPAUSE and handle like 
XSAVES/XRSTORS:
"kvm_skip_emulated_instruction(vcpu);"
"WARN(1, "this should never happen\n");"

Looking forward to your reply.

Tao
