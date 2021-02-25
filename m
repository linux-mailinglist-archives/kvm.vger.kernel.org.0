Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32083248BD
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 03:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhBYCE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 21:04:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:11237 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236625AbhBYCEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 21:04:23 -0500
IronPort-SDR: dcHnqP8ZhpsSHKcqG9WVXhvJZs+6wCnLp8gM/A9G5oEwXV3N92N496jng/wFidZsB4RfnA5C9g
 +7dufUOt9nwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9905"; a="164600846"
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="164600846"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 18:02:31 -0800
IronPort-SDR: YOAAxv/VPQMb8k0UAuMjlTPE/mMIrCB9QshiZaeenDxclCZ5pjuacKNoquEI6xPOVIZ+CThEPL
 ykzEfnlEtBWA==
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="391885944"
Received: from unknown (HELO [10.238.130.200]) ([10.238.130.200])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 18:02:28 -0800
Subject: Re: [PATCH v1] kvm: x86: Revise guest_fpu xcomp_bv field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208161659.63020-1-jing2.liu@linux.intel.com>
 <4e4b37d1-e2f8-6757-003c-d19ae8184088@intel.com>
 <YCFzztFESzcnKRqQ@google.com>
 <c33335d3-abbe-04e0-2fa1-47f57ad154ac@linux.intel.com>
 <YDPWn70DTA64psQb@google.com>
 <9d23ae5b-9b85-88d7-a2d7-44fd75a068b9@linux.intel.com>
 <YDa5saYSU+Zrr8e+@google.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <acf225f2-5783-8a2d-a060-e58aad28e8de@linux.intel.com>
Date:   Thu, 25 Feb 2021 10:02:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YDa5saYSU+Zrr8e+@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/25/2021 4:40 AM, Sean Christopherson wrote:
> On Tue, Feb 23, 2021, Liu, Jing2 wrote:
>> XCOMP_BV[63] field indicates that the save area is in the
>> compacted format and XCOMP_BV[62:0] indicates the states that
>> have space allocated in the save area, including both XCR0
>> and XSS bits enable by the host kernel. Use xfeatures_mask_all
>> for calculating xcomp_bv and reuse XCOMP_BV_COMPACTED_FORMAT
>> defined by kernel.
> Works for me, just please wrap at ~73-75 chars, not ~64.
>
> Thanks!
Sure, let me update v2.

BRs,
Jing

