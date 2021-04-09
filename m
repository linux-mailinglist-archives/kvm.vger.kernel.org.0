Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3A5359E90
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 14:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhDIMZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 08:25:01 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42622 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhDIMY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 08:24:56 -0400
Received: from [192.168.86.30] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6CFEC20B5680;
        Fri,  9 Apr 2021 05:24:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6CFEC20B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617971083;
        bh=cvjSlEqzE0r8jbTTyah78wK4atQEFVQUPgjPXKTu3zo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=boTUERpFwM/5ek3yZAirRhWiEIv4atHr3NyIxPiLghR3L906gPgsOPZMTnnRzLI6Q
         eBPVWrM6W3FUgzbon1UIyIPMdKgHXQCQxcMVQhXxr2nXopMv5oF9QX7Z2+o69HXQD0
         h3qpKMYq6kkGejCBKExVadsJB12fEt2vmuGT2z6k=
Subject: Re: [PATCH 4/7] KVM: SVM: hyper-v: Nested enlightenments in VMCB
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, viremana@linux.microsoft.com
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <e9de12a81ab31613fb55d5c1308ca0ca050ced4c.1617804573.git.viremana@linux.microsoft.com>
 <5927967d-c5a2-6df9-9aff-4b92c207df09@redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <1ae328de-718c-dfa3-f5af-e765d953d841@linux.microsoft.com>
Date:   Fri, 9 Apr 2021 08:24:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <5927967d-c5a2-6df9-9aff-4b92c207df09@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/21 11:44 AM, Paolo Bonzini wrote:
> On 07/04/21 16:41, Vineeth Pillai wrote:
>> +#define VMCB_ALL_CLEAN_MASK (__CLEAN_MASK | (1U << 
>> VMCB_HV_NESTED_ENLIGHTENMENTS))
>> +#else
>> +#define VMCB_ALL_CLEAN_MASK __CLEAN_MASK
>> +#endif
>
> I think this should depend on whether KVM is running on top of 
> Hyper-V; not on whether KVM is *compiled* with Hyper-V support.
>
> So you should turn VMCB_ALL_CLEAN_MASK into a __read_mostly variable.
Will do.

Thanks,
Vineeth

