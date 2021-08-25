Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65BA3F749B
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 13:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbhHYLyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 07:54:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:16989 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239257AbhHYLyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 07:54:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="197749106"
X-IronPort-AV: E=Sophos;i="5.84,350,1620716400"; 
   d="scan'208";a="197749106"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 04:53:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,350,1620716400"; 
   d="scan'208";a="527231434"
Received: from um.fi.intel.com (HELO um) ([10.237.72.62])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Aug 2021 04:53:05 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        alexander.shishkin@linux.intel.com
Subject: Re: [PATCH 3/5] KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on
 other CPUID bit
In-Reply-To: <ed18e08f-1ea6-4ffa-91a7-9d8706a1b781@intel.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-4-xiaoyao.li@intel.com>
 <711265db-f634-36ac-40d2-c09cea825df6@gmail.com>
 <b80a91db-cb35-ba6d-ab36-a0fa1ca051e7@intel.com>
 <6dddf3c0-fa8f-f70c-bd5d-b43c7140ed9a@gmail.com>
 <ed18e08f-1ea6-4ffa-91a7-9d8706a1b781@intel.com>
Date:   Wed, 25 Aug 2021 14:53:04 +0300
Message-ID: <87pmu1ivvj.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 8/25/2021 2:08 PM, Like Xu wrote:
>> On 25/8/2021 12:19 pm, Xiaoyao Li wrote:
>>> On 8/25/2021 11:30 AM, Like Xu wrote:
>>> BranchEn should be always supported if PT is available. Per "31.2.7.2 
>> 
>> Check d35869ba348d3f1ff3e6d8214fe0f674bb0e404e.
>
> This commit shows BranchEn is supported on BDW, and must be enabled on 
> BDW. This doesn't conflict the description above that BranchEn should be 
> always supported.

It's the *not* setting BranchEn that's not supported on BDW. The point
of BranchEn is to allow the user to not set it and filter out all the
branch trace related packets. The main point of PT, however, is the
branch trace, so in the first implementation BranchEn was reserved as
1.

IOW, it's always available, doesn't depend on CPUID, but on BDW,
BranchEn==0 should throw a #GP, if I remember right. Check BDM106 for
details.

Regards,
--
Alex
