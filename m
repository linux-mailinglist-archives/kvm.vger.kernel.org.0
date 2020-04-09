Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208061A37B2
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 18:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgDIQFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 12:05:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:47681 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbgDIQFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 12:05:05 -0400
IronPort-SDR: qydzyIYOcE6Fr0ISPgf8h1Lej3rcGmIQqsq7x2PBCfJO9y4thDze0s6LoqPxW9U3tRc7UD+wCr
 UAA/IQET8+7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP; 09 Apr 2020 09:05:04 -0700
IronPort-SDR: PBeAJ0kz0ryLkcp6Ag/1owJBN9yxY1nqntG7YohU/Q0/H93ul6A/AF1BnjrCDA0JsK7EE7TD/f
 omjKBjmST8cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="275873793"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.170.160]) ([10.249.170.160])
  by fmsmga004.fm.intel.com with ESMTP; 09 Apr 2020 09:05:02 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
References: <20200409114926.1407442-1-ubizjak@gmail.com>
 <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
 <21e04917-d651-b50b-5ecf-dfe27aec6f0a@redhat.com>
 <2a688724-f1da-627e-52cc-f0087d1aeba8@intel.com>
 <6b042130-885b-6eb0-ffa0-86c4c6b3a899@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <410b7853-ca13-12b8-9f67-cc48300dcbcc@intel.com>
Date:   Fri, 10 Apr 2020 00:05:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6b042130-885b-6eb0-ffa0-86c4c6b3a899@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/4/9 23:55, Paolo Bonzini wrote:
> On 09/04/20 17:42, Xu, Like wrote:
>> Yes, I assume the svm->vmcb->control.exit_code is referred.
>>
>> What makes me confused is
>> why we need "vmx->exit_reason" and "vmx->fail"
>> for the same general purpose, but svm does not.
> Because VMLAUNCH/VMRESUME can also report vmFailValid and vmFailInvalid
> via the carry and zero flags, there is no equivalent of that for AMD
> virtualization extensions.
Oh, this makes sense to me. Thanks!
Let me confirm it from both specifications.
>
> Paolo
>

