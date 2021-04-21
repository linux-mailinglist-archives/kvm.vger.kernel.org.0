Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2133669C1
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 13:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238627AbhDULQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 07:16:32 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42908 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbhDULQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 07:16:30 -0400
Received: from [192.168.86.31] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id DC78B20B8001;
        Wed, 21 Apr 2021 04:15:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC78B20B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1619003757;
        bh=0lGPWgCWxMY7QAIfAJHFkFTAYipH0FMtf/PdmxPyrUw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gudX5C8+viqc/m58ZbDfBIGMK5DF+vGWywf/UQuUq+w1S+fUI8PZmcpVYd9Zhl71G
         7V5SefAQZ34ieq6v2Vd8FjSDLntWCzHUMWa3sIdlqQpijXqElS6Ied6EMj3YoGLLjf
         JG9H08F28TC64nZMQQiYrs63e9IN3gNQlH1Xp1o0=
Subject: Re: [PATCH v2 2/7] hyperv: SVM enlightened TLB flush support flag
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, viremana@linux.microsoft.com
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <3fd0cdfb9a4164a3fb90351db4dc10f52a7c4819.1618492553.git.viremana@linux.microsoft.com>
 <20210421100026.4hcgrxeri444if45@liuwe-devbox-debian-v2>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <4a57cd2b-43b5-2625-3663-449ffa715b51@linux.microsoft.com>
Date:   Wed, 21 Apr 2021 07:15:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210421100026.4hcgrxeri444if45@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/21 6:00 AM, Wei Liu wrote:
> On Thu, Apr 15, 2021 at 01:43:37PM +0000, Vineeth Pillai wrote:
>>   
>> +/*
>> + * This is specific to AMD and specifies that enlightened TLB flush is
>> + * supported. If guest opts in to this feature, ASID invalidations only
>> + * flushes gva -> hpa mapping entries. To flush the TLB entries derived
>> + * from NPT, hypercalls should be used (HvFlushGuestPhysicalAddressSpace
>> + * or HvFlushGuestPhysicalAddressList).
>> + */
>> +#define HV_X64_NESTED_ENLIGHTENED_TLB			BIT(22)
>> +
> c
> This is not yet documented in TLFS, right? I can't find this bit in the
> latest edition (6.0b).
This would be documented in the TLFS update which is soon to be
released.

>
> My first thought is the comment says this is AMD specific but the name
> is rather generic. That looks a bit odd to begin with.
I thought of of keeping the name generic to avoid renaming Intel
specific ones also. If I understand correctly, the TLFS would also
be having generic name for this and just translated the generic
name here in this header.

Thanks,
Vineeth

