Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B05C3584A6
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhDHN0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:26:53 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36432 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhDHN0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 09:26:43 -0400
Received: from [192.168.86.30] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2CB1520B5680;
        Thu,  8 Apr 2021 06:26:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2CB1520B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617888392;
        bh=wa/VfR5dOq9tsZ2NtAO+T057gx0rVmV0HzZysz7VXi8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TW7JW8Wyus+vBCg0hJy+26qz6yQC5fsyw16IF5PLU6shEx2Nohc/PGyE/34NIUqzS
         CD7igVEMeyaA+xC82MpP/0cYC0klCU9B7pOqV1ZlDHIwmAsTbw39gwn/Ie3n7T7AtW
         yBmL0yX0TnGMoyIeR0jv2EVlXRkaHdSZ6Pp9qhWo=
Subject: Re: [PATCH 1/7] hyperv: Detect Nested virtualization support for SVM
To:     Sean Christopherson <seanjc@google.com>,
        Michael Kelley <mikelley@microsoft.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        KY Srinivasan <kys@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
 <MWHPR21MB159327E855DAC5BEE4B8A38DD7759@MWHPR21MB1593.namprd21.prod.outlook.com>
 <YG42zNYA9uCC25In@google.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <a548e5c9-e579-6b82-88ea-e90a3378a74e@linux.microsoft.com>
Date:   Thu, 8 Apr 2021 09:26:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YG42zNYA9uCC25In@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/21 6:48 PM, Sean Christopherson wrote:
> On Wed, Apr 07, 2021, Michael Kelley wrote:
>>
>>> +		pr_info("Hyper-V nested_features: 0x%x\n",
>> Nit:  Most other similar lines put the colon in a different place:
>>
>> 		pr_info("Hyper-V: nested features 0x%x\n",
>>
>> One of these days, I'm going to fix the ones that don't follow this
>> pattern. :-)
> Any reason not to use pr_fmt?
Yes, that would be the best way to go. As Michael suggested,
it would be better to fix the whole file as a cleanup patch.
I shall fix this one to conform to the previous style and use
pr_fmt as a separate fixup patch.

Thanks,
Vineeth

