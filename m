Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A67C129A
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 02:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfI2A75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 20:59:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:24574 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbfI2A75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 20:59:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Sep 2019 17:59:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,561,1559545200"; 
   d="scan'208";a="193745716"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.82]) ([10.239.196.82])
  by orsmga003.jf.intel.com with ESMTP; 28 Sep 2019 17:59:55 -0700
Subject: Re: Suggest changing commit "KVM: vmx: Introduce
 handle_unexpected_vmexit and handle WAITPKG vmexit"
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <B57A2AAE-9F9F-4697-8EFE-5F1CF4D8F7BC@oracle.com>
 <8edd1d4c-03df-56e5-a5b1-aece3c85962a@intel.com>
 <9E41E337-A76D-4AE7-90A6-1CDD27AFC358@oracle.com>
 <fb780187-4507-600d-9467-4742e5fe9be9@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <9bea5a5e-714c-b7e3-1e37-0399761ff3c3@intel.com>
Date:   Sun, 29 Sep 2019 08:59:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fb780187-4507-600d-9467-4742e5fe9be9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/2019 11:21 PM, Paolo Bonzini wrote:
> On 27/09/19 16:55, Liran Alon wrote:
>> Why is it confusing? Any exit-reason not specified in
>> kvm_vmx_exit_handlers[] is an exit-reason KVM doesn’t expect to be
>> raised from hardware. Whether it’s because VMCS is configured to not
>> raise that exit-reason or because it’s a new exit-reason only
>> supported on newer CPUs. (Which is kinda the same. Because a new
>> exit-reason should be raised only if hypervisor opt-in some VMCS
>> feature).
> 
> I agree that it's a bug compared to how other unhandled vmexits are
> treated.  I didn't want to rewrite kvm/next or have a revert, so I have
> sent a pull request but this should be fixed.  I'll wait for Liran's
> patch or come up with one.
> 
> Paolo
> 

I got it. Thanks.

