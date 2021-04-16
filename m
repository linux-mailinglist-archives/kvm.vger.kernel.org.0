Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938AC36253B
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbhDPQLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 12:11:02 -0400
Received: from linux.microsoft.com ([13.77.154.182]:46378 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhDPQK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 12:10:56 -0400
Received: from [192.168.86.23] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0378920B8001;
        Fri, 16 Apr 2021 09:10:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0378920B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618589431;
        bh=9MXNGr+OsMs3ZgwnW73MWJRCTLeAvuN7B4xa579GwLs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qq63LORblOaS7ZOylg8BPaRJrxFsJH4ALhgZg4EXBBxDzyX/HiLnpZQncAH56chNV
         gJbU+JREtUYqCHkoE/Nx2mAsemurEp4A0OlgpIrThG4eUwpscLCg7VbOX+pfh+QBzy
         jZMk27UwZrUCqJtIvt1lbj5hRk1tiYEotgHgO+Dc=
Subject: Re: [PATCH v2 1/7] hyperv: Detect Nested virtualization support for
 SVM
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        viremana@linux.microsoft.com
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <9d12558549bc0c6f179b26f5b16c751bdfab3f74.1618492553.git.viremana@linux.microsoft.com>
 <871rba8wjj.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <a50e0d90-d853-7195-56ce-42b85484a55e@linux.microsoft.com>
Date:   Fri, 16 Apr 2021 12:10:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <871rba8wjj.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> It may make sense to expand this a bit as it is probably unclear how the
> change is related to SVM.
>
> Something like:
>
> HYPERV_CPUID_NESTED_FEATURES CPUID leaf can be present on both Intel and
> AMD Hyper-V guests. Previously, the code was using
> HV_X64_ENLIGHTENED_VMCS_RECOMMENDED feature bit to determine the
> availability of nested features leaf and this complies to TLFS:
> "Recommend a nested hypervisor using the enlightened VMCS interface.
> Also indicates that additional nested enlightenments may be available
> (see leaf 0x4000000A)". Enlightened VMCS, however, is an Intel only
> feature so the detection method doesn't work for AMD. Use
> HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS.EAX CPUID information ("The
> maximum input value for hypervisor CPUID information.") instead, this
> works for both AMD and Intel.
Thanks for the input. Will update the commit message in next revision.

Thanks,
Vineeth
