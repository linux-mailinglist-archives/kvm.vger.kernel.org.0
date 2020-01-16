Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694EF13D162
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 02:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAPBIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 20:08:35 -0500
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:39119 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbgAPBIf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 20:08:35 -0500
Received: from MTA-06-3.privateemail.com (mta-06.privateemail.com [68.65.122.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 4F27880821
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 20:08:34 -0500 (EST)
Received: from MTA-06.privateemail.com (localhost [127.0.0.1])
        by MTA-06.privateemail.com (Postfix) with ESMTP id 3007E6003D;
        Wed, 15 Jan 2020 20:08:33 -0500 (EST)
Received: from zetta.local (unknown [10.20.151.220])
        by MTA-06.privateemail.com (Postfix) with ESMTPA id BD0B860043;
        Thu, 16 Jan 2020 01:08:32 +0000 (UTC)
Subject: Re: [Bug 206215] New: QEMU guest crash due to random 'general
 protection fault' since kernel 5.2.5 on i7-3517UE
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        bugzilla-daemon@bugzilla.kernel.org
Cc:     kvm@vger.kernel.org
References: <bug-206215-28872@https.bugzilla.kernel.org/>
 <20200115215256.GE30449@linux.intel.com>
From:   Derek Yerger <derek@djy.llc>
Message-ID: <e6ec4418-4ac1-e619-7402-18c085bc340d@djy.llc>
Date:   Wed, 15 Jan 2020 20:08:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200115215256.GE30449@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/20 4:52 PM, Sean Christopherson wrote:
> +cc Derek, who is hitting the same thing.
>
> On Wed, Jan 15, 2020 at 09:18:56PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=206215
> *snip*
> that's a big smoking gun pointing at commit ca7e6b286333 ("KVM: X86: Fix
> fpu state crash in kvm guest"), which is commit e751732486eb upstream.
>
> 1. Can you verify reverting ca7e6b286333 (or e751732486eb in upstream)
>     solves the issue?
>
> 2. Assuming the answer is yes, on a buggy kernel, can you run with the
>     attached patch to try get debug info?
I did these out of order since I had 5.3.11 built with the patch, ready to go 
for weeks now, waiting for an opportunity to test.

Win10 guest immediately BSOD'ed with:

WARNING: CPU: 2 PID: 9296 at include/linux/thread_info.h:55 
kernel_fpu_begin+0x6b/0xc0

Then stashed the patch, reverted ca7e6b286333, compile, reboot.

Guest is running stable now on 5.3.11. Did test my CAD under the guest, did not 
experience the crashes that had me stuck at 5.1.
