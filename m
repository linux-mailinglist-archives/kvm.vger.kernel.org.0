Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3208F391072
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhEZGNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:13:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:9993 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhEZGNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 02:13:31 -0400
IronPort-SDR: NGRhW1Bu98CWIBXWKNp4zUjX2MCJq0ul8zlEZO6w5rBL7zzp/CCF7oMjOyEJHQf9CFHcwIrZyd
 lPiGTPaD+r7w==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="202427906"
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="202427906"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 23:12:00 -0700
IronPort-SDR: HXzVmDFmx9YLRavm+0HGn3TbVDMu+xTUzDV+jZmKfV/9Ex232tslEmWG004A1DePsLC1+B4Ij0
 BRGP3VJZaCbg==
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="476776700"
Received: from unknown (HELO [10.238.130.158]) ([10.238.130.158])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 23:11:58 -0700
Subject: Re: [PATCH RFC 4/7] kvm: x86: Add new ioctls for XSAVE extension
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-5-jing2.liu@linux.intel.com>
 <CALMp9eT8SoD0X=RZNv+o4LJLZZioTaPPXBnT199AGJKAwJ=W7Q@mail.gmail.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <645508cb-abf5-350d-f0ae-6044ecc3ceb8@linux.intel.com>
Date:   Wed, 26 May 2021 14:11:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eT8SoD0X=RZNv+o4LJLZZioTaPPXBnT199AGJKAwJ=W7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2021 6:06 AM, Jim Mattson wrote:
> On Sat, Feb 6, 2021 at 11:00 PM Jing Liu <jing2.liu@linux.intel.com> wrote:
>> The static xstate buffer kvm_xsave contains the extended register
>> states, but it is not enough for dynamic features with large state.
>>
>> Introduce a new capability called KVM_CAP_X86_XSAVE_EXTENSION to
>> detect if hardware has XSAVE extension (XFD). Meanwhile, add two
>> new ioctl interfaces to get/set the whole xstate using struct
>> kvm_xsave_extension buffer containing both static and dynamic
>> xfeatures. Reuse fill_xsave and load_xsave for both cases.
>>
>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>> ---
>> +#define KVM_GET_XSAVE_EXTENSION   _IOW(KVMIO,  0xa4, struct kvm_xsave_extension)
>> +#define KVM_SET_XSAVE_EXTENSION   _IOW(KVMIO,  0xa5, struct kvm_xsave_extension)
> Isn't the convention to call these KVM_GET_XSAVE2 and KVM_SET_XSAVE2?
>
> Do you have any documentation to add to Documentation/virt/kvm/api.rst?
Thanks for reviewing the patch.
I'll change the name as convention and add documentation if new apis are 
needed.

BRs,
Jing
