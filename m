Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35A83FCEAF
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 22:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbhHaUke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 16:40:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:37312 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241119AbhHaUkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 16:40:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="218283982"
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="218283982"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 13:39:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,367,1620716400"; 
   d="scan'208";a="687867566"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.209.121.250]) ([10.209.121.250])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 13:39:33 -0700
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     David Hildenbrand <david@redhat.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <243bc6a3-b43b-cd18-9cbb-1f42a5de802f@redhat.com>
 <765e9bbe-2df5-3dcc-9329-347770dc091d@linux.intel.com>
 <4677f310-5987-0c13-5caf-fd3b625b4344@redhat.com>
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <cf24c39e-2e87-f596-4375-9368ed8ef813@linux.intel.com>
Date:   Tue, 31 Aug 2021 13:39:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4677f310-5987-0c13-5caf-fd3b625b4344@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/31/2021 1:15 PM, David Hildenbrand wrote:
> On 31.08.21 22:01, Andi Kleen wrote:
>>
>>>> Thanks a lot for this summary. A question about the requirement: do
>>>> we or
>>>> do we not have plan to support assigned device to the protected VM?
>>>
>>> Good question, I assume that is stuff for the far far future.
>>
>> It is in principle possible with the current TDX, but not secure. But
>> someone might decide to do it. So it would be good to have basic support
>> at least.
>
> Can you elaborate the "not secure" part? Do you mean, making the 
> device only access "shared" memory, not secure/encrypted/whatsoever?


Yes that's right. It can only access shared areas.


-Andi

