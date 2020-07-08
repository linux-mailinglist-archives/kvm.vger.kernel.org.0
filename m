Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075A2218A0C
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 16:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgGHOWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 10:22:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:49688 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729468AbgGHOWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 10:22:38 -0400
IronPort-SDR: dCvA5WlVPBnTHtyexhzpKz9ZppxMClHr3vvCBWiVPVtkpRwDUwaCXiNo9WE/1nyasRqZTU4iCb
 EKhWoig0jCyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145903017"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="145903017"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 07:22:37 -0700
IronPort-SDR: ypnSgETFnURfOh2lY/Di1FrVtyy0tX6IzKv3i1woeeu6NNiCW0dbri/bMNjUS49QgLV/4alj1Y
 Sab66rb+t1oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="322949843"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.31.237]) ([10.255.31.237])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jul 2020 07:22:34 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] kvm: x86: limit the maximum number of vPMU fixed counters
 to 3
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20200624015928.118614-1-like.xu@linux.intel.com>
 <8de3f450-7efd-96ab-fdf8-169b3327e5ac@intel.com>
 <9b50db05-759e-c95c-35b2-99fba50e6997@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <3e849687-67f9-ac53-10ff-2b76d4881de4@intel.com>
Date:   Wed, 8 Jul 2020 22:22:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9b50db05-759e-c95c-35b2-99fba50e6997@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/7/8 19:09, Paolo Bonzini wrote:
> On 08/07/20 09:51, Xu, Like wrote:
>> Kindly ping.
>>
>> I think we may need this patch, as we limit the maximum vPMU version to 2:
>>      eax.split.version_id = min(cap.version, 2);
> I don't think this is a problem.  Are you planning to add support for
> the fourth counter?
Yes, we plan to provide this support on the KVM after fully enabling the fourth
counter (and an accompanying special counter) on the host perf side.

This may require one or two kernel cycles, so I have to prevent it from
being exposed to non-linux guest with this fix. Thanks for your support.

Thanks,
Like Xu
>
> Paolo
>

