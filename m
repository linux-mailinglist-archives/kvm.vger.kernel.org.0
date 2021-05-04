Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DC7372C13
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 16:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhEDOeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 10:34:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:49590 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhEDOeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 10:34:07 -0400
IronPort-SDR: sS3H1eAljI/truIkXtfEcPwYoytB1VgwbCvj5u4SX2M/qLBNJWQc5Icovh26iQb2sqe9R6r7iL
 z/ANqylusADw==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="198047900"
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="198047900"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 07:33:12 -0700
IronPort-SDR: cVvDn2szgAQHaN0DbtCoMOq03Ddby5nmZsvDo9sBc3EqePZpjjpuC2Ltx4pZMAphxVKqlm6H2b
 YdZUjYpurGow==
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="406133022"
Received: from rdbrim-mobl3.amr.corp.intel.com (HELO [10.209.10.46]) ([10.209.10.46])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 07:33:12 -0700
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        Thomas.Lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
References: <9e3e4331-2933-7ae6-31d9-5fb73fce4353@amd.com>
 <40C2457E-C2A3-4DF7-BD16-829D927CC17C@amacapital.net>
 <1c98a55a-d4d5-866e-dcad-81caa09a495d@amd.com>
 <b723e0dd-7af1-37b3-6553-e9ef4802dac8@intel.com>
 <af581395-1322-a668-d5f3-3784bbfd6c9b@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <ea839e63-3374-5ff6-92ee-da6f1f714972@intel.com>
Date:   Tue, 4 May 2021 07:33:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <af581395-1322-a668-d5f3-3784bbfd6c9b@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/21 5:31 AM, Brijesh Singh wrote:
> On 5/3/21 2:43 PM, Dave Hansen wrote:
>> On 5/3/21 12:41 PM, Brijesh Singh wrote:
>>> Sure, I will look into all the drivers which do a walk plus kmap to make
>>> sure that they fail instead of going into the fault path. Should I drop
>>> this patch or keep it just in the case we miss something?
>> I think you should drop it, and just ensure that the existing page fault
>> oops code can produce a coherent, descriptive error message about what
>> went wrong.
> 
> A malicious guest could still trick the host into accessing a guest
> private page unless we make sure that host kernel *never* does kmap() on
> GPA. The example I was thinking is:
> 
> 1. Guest provides a GPA to host.
> 
> 2. Host queries the RMP table and finds that GPA is shared and allows
> the kmap() to happen.
> 
> 3. Guest later changes the page to private.

This literally isn't possible in the SEV-SNP architecture.  I really
wish you would stop stating it.  It's horribly confusing.

The guest can not directly change the page to private.  Only the host
can change the page to private.  The guest must _ask_ the host to do it.
 That's *CRITICALLY* important because what you need to do later is
prevent specific *HOST* behavior.

When those guest requests come it, the host has to ensure that the
request is refused or stalled until there is no chance that the host
will write to the page.  That means that the host needs some locks and
some metadata.

It's also why Andy has been suggesting that you need something along the
lines of copy_to/from_guest().  Those functions would take and release
locks to ensure that shared->private guest page transitions are
impossible while host access to the memory is in flight.

> 4. Host write to mapped address will trigger a page-fault.
> 
> KVM provides kvm_map_gfn(), kvm_vcpu_map() to map a GPA; these APIs will
> no longer be safe to be used.

Yes, it sounds like there is some missing KVM infrastructure that needs
to accompany this series.

> In addition, some shared pages are registered once by the guest and
> KVM updates the contents of the page on vcpu enter (e.g, CPU steal
> time).
Are you suggesting that the host would honor a guest request to convert
to private the shared page used for communicating CPU steal time?  That
seems like a bug to me.

> IMHO, we should add the RMP table check before kmap'ing GPA but still
> keep this patch to mitigate the cases where a malicious guest changes
> the page state after the kmap().

I much prefer a solution where guest requests are placed under
sufficient scrutiny and not blindly followed by the host.
