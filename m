Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6B2D373
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 03:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfE2Bkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 21:40:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:31292 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfE2Bkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 21:40:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 18:40:34 -0700
X-ExtLoop1: 1
Received: from shzintpr02.sh.intel.com (HELO [0.0.0.0]) ([10.239.4.160])
  by orsmga001.jf.intel.com with ESMTP; 28 May 2019 18:40:32 -0700
Subject: Re: [PATCH v2 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-3-tao3.xu@intel.com>
 <c9f5050a-6144-adbc-25ef-8a7543176ac6@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <2922ac60-a22e-e22c-363a-04f3a2bb6838@intel.com>
Date:   Wed, 29 May 2019 09:38:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c9f5050a-6144-adbc-25ef-8a7543176ac6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/2019 09:29, Paolo Bonzini wrote:
> On 24/05/19 09:56, Tao Xu wrote:
>> +
>> +	if (rdmsrl_safe(MSR_IA32_UMWAIT_CONTROL, &host_umwait_control))
>> +		return;
>> +
> 
> Does the host value ever change?  If not, this can perhaps be read once
> when kvm_intel is loaded.  And if it changes often, it should be
> shadowed into a percpu variable.
> 
> Paolo
> 

Yes, the host value may change, we contact the host patch author Fenghua 
to add the shadow in host when the host msr value change. And we will 
improve this in the next version of patch.
