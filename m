Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385A530519D
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 06:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhA0EYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:24:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:60544 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbhA0A6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:58:42 -0500
IronPort-SDR: nG5/7a1OqjAzl8HxXVqySvZV3e2492H2q5RvcRLN4Q0irq88jhmWslUReZo31EiibRwfmHgfjK
 Ed7yncIhQE1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159171320"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="159171320"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:58:00 -0800
IronPort-SDR: HERo/2nPxJcwoL/hfz9pw9yFMx6/qooLiVBJOEBKP2YMX7Vy56oh2DaADE+W0i72SHmN/9dYx0
 KIjwcHAbPzhg==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388076994"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.32]) ([10.238.1.32])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:57:57 -0800
Subject: Re: [RESEND PATCH 2/2] KVM: X86: Expose bus lock debug exception to
 guest
To:     Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210108064924.1677-3-chenyi.qiang@intel.com>
 <202101090218.oqYcWXa4-lkp@intel.com>
 <cfc345ea-980d-821d-f3a6-cea1f8e7ba03@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <3c38f1be-47c3-e8f8-ee72-9642e99ac93f@intel.com>
Date:   Wed, 27 Jan 2021 08:57:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <cfc345ea-980d-821d-f3a6-cea1f8e7ba03@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/2021 12:33 AM, Paolo Bonzini wrote:
> On 08/01/21 19:16, kernel test robot wrote:
>> Hi Chenyi,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on kvm/linux-next]
>> [also build test ERROR on v5.11-rc2 next-20210108]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
> 
> What is the status of the patch to introduce X86_FEATURE_BUS_LOCK_DETECT 
> (I saw 
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2389369.html)?
> 
> Paolo

Fenghua sent the v4 patch and pinged x86 maintainers, but still no feedback.
https://lore.kernel.org/lkml/YA8bkmYjShKwmyXx@otcwcpicx3.sc.intel.com/

> 

