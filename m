Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EF712E6DF
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgABNmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:42:36 -0500
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:49954 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728344AbgABNmg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jan 2020 08:42:36 -0500
Received: from MTA-09-4.privateemail.com (mta-09.privateemail.com [198.54.127.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id A21CF80099
        for <kvm@vger.kernel.org>; Thu,  2 Jan 2020 08:42:35 -0500 (EST)
Received: from MTA-09.privateemail.com (localhost [127.0.0.1])
        by MTA-09.privateemail.com (Postfix) with ESMTP id 727A76003F;
        Thu,  2 Jan 2020 08:42:34 -0500 (EST)
Received: from zetta.local (unknown [10.20.151.201])
        by MTA-09.privateemail.com (Postfix) with ESMTPA id BABEC60034;
        Thu,  2 Jan 2020 13:42:33 +0000 (UTC)
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
References: <20191120181913.GA11521@linux.intel.com>
 <7F99D4CD-272D-43FD-9CEE-E45C0F7C7910@djy.llc>
 <20191120192843.GA2341@linux.intel.com>
 <20191127152409.GC18530@linux.intel.com>
 <20191217231133.GG11771@linux.intel.com>
From:   Derek Yerger <derek@djy.llc>
Message-ID: <17a119f9-fc94-ca6b-1eb7-66bca4d7c7a1@djy.llc>
Date:   Thu, 2 Jan 2020 08:42:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217231133.GG11771@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/19 6:11 PM, Sean Christopherson wrote:
> On Wed, Nov 27, 2019 at 07:24:09AM -0800, Sean Christopherson wrote:
>> On Wed, Nov 20, 2019 at 11:28:43AM -0800, Sean Christopherson wrote:
>>> On Wed, Nov 20, 2019 at 02:04:38PM -0500, Derek Yerger wrote:
>>>>> Debug patch attached.  Hopefully it finds something, it took me an
>>>>> embarassing number of attempts to get correct, I kept screwing up checking
>>>>> a bit number versus checking a bit mask...
>>>>> <0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch>
>>>> Should this still be tested despite Wanpeng Li’s comments that the issue may
>>>> have been fixed in a 5.3 release candidate?
>>> Yes.
>>>
>>> The actual bug fix, commit e751732486eb3 (KVM: X86: Fix fpu state crash in
>>> kvm guest), is present in v5.2.7.
>>>
>>> Unless there's a subtlety I'm missing, commit d9a710e5fc4941 (KVM: X86:
>>> Dynamically allocate user_fpu) is purely an optimization and should not
>>> have a functional impact.
> Any update on this?  Syzkaller also appears to be hitting this[*], but it
> hasn't been able to generate a reproducer.
>
> [*] https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
>
Still working on it. Not sure why but now my initrd images have quadrupled in 
size with the latest kernel, so I'm at an impasse and stuck at 5.2 until I can 
size up my /boot

Will try to fix this week.
