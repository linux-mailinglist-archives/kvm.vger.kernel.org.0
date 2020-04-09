Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B5D1A3759
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgDIPmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:42:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:8190 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgDIPmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 11:42:35 -0400
IronPort-SDR: 0bY1BgqMpbPTvxgmjAbr9nrccasK11NRf8xmtf1am51CXnJQ6K+R17gLFXtCzOTjxUolQy6Bw5
 H509rgbt7HqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 08:42:35 -0700
IronPort-SDR: GD7rrqF6BSKGj1Nh5FbRwI+/LMWVF6x3+wNqTyHlRttgN9ksxzTNHS69o7XLVIJKlzzo7BwqsP
 30jW7yc81rvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="275854924"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.170.160]) ([10.249.170.160])
  by fmsmga004.fm.intel.com with ESMTP; 09 Apr 2020 08:42:33 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
References: <20200409114926.1407442-1-ubizjak@gmail.com>
 <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
 <21e04917-d651-b50b-5ecf-dfe27aec6f0a@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <2a688724-f1da-627e-52cc-f0087d1aeba8@intel.com>
Date:   Thu, 9 Apr 2020 23:42:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <21e04917-d651-b50b-5ecf-dfe27aec6f0a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2020/4/9 23:18, Paolo Bonzini wrote:
> On 09/04/20 17:11, Xu, Like wrote:
>>>    -bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>> Just curious if __svm_vcpu_run() will fail to enter SVM guest mode,
>> and a return value could indicate that nothing went wrong rather than
>> blindly keeping silent.
> That's already available in the exit code (which is 0xffffffff when
> vmentry fails).
Yes, I assume the svm->vmcb->control.exit_code is referred.

What makes me confused is
why we need "vmx->exit_reason" and "vmx->fail"
for the same general purpose, but svm does not.

Thanks,
Like Xu
>
> Paolo
>

