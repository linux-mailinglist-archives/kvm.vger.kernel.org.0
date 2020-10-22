Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58729600C
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 15:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900123AbgJVNba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 09:31:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:7583 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895506AbgJVNb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 09:31:29 -0400
IronPort-SDR: /XPzOjJ6zcEjLKA50NUOXgl7YiY9L10KIPrAlG66/C4JYocoRM3gzJ3F9ITvouTeF2rFm/J5cN
 q7+Tg4caHcOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="155311058"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="155311058"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 06:31:27 -0700
IronPort-SDR: ZtHX9vEE2nOZ4DgE3j62VO+vKT9O38aAHAtNNns8UiGdYTeYIXIJKbYDsIEkE3P8KdPxr+zMvO
 YohhWF1xuGEw==
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="533968088"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.254.213.210]) ([10.254.213.210])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 06:31:25 -0700
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in
 KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
 <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <6ad94df6-9ecd-e364-296a-34ba41e938b1@intel.com>
Date:   Thu, 22 Oct 2020 21:31:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/2020 9:02 PM, Paolo Bonzini wrote:
> On 22/10/20 03:34, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> Per KVM_GET_SUPPORTED_CPUID ioctl documentation:
>>
>> This ioctl returns x86 cpuid features which are supported by both the
>> hardware and kvm in its default configuration.
>>
>> A well-behaved userspace should not set the bit if it is not supported.
>>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> 
> It's common for userspace to copy all supported CPUID bits to
> KVM_SET_CPUID2, I don't think this is the right behavior for
> KVM_HINTS_REALTIME.

It reminds of X86_FEATURE_WAITPKG, which is added to supported CPUID 
recently as a fix but QEMU exposes it to guest only when "-overcommit 
cpu-pm"

> (But maybe this was discussed already; if so, please point me to the
> previous discussion).
> 
> Paolo
> 

