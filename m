Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0862358511
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhDHNp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:45:29 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38928 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhDHNp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 09:45:28 -0400
Received: from [192.168.86.30] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0C8D620B5680;
        Thu,  8 Apr 2021 06:45:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0C8D620B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617889516;
        bh=Yjl2ONg/hsAPuB8vE8frwvpHGc3vbwAmkdEQC+KpHT4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HHiA9g/+zaBctBpUyc+f5bDMKgQd2j3gvdzrctqOPXMlEFq5MJv1F9x1Oyq9AnVOX
         5el4lwxdAmEmKs38+CT7AfVeyhhvB+9Axj2dUJDMrTPH2LJSqduvJQxgZbXf2NMxO0
         7VC2VBITKPl3jNwIUGuVhvYVDYH/MSRQrqk5/bdY=
Subject: Re: [PATCH 2/7] hyperv: SVM enlightened TLB flush support flag
To:     Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        vkuznets <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        KY Srinivasan <kys@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        viremana@linux.microsoft.com
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <2f896dc4e83197f4fe40c08c45e38bbdcc5c0dbe.1617804573.git.viremana@linux.microsoft.com>
 <MWHPR21MB159384D7BF8D845AE8085573D7759@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <22693445-d33c-d9c7-10fc-0c77573ffec4@linux.microsoft.com>
Date:   Thu, 8 Apr 2021 09:45:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB159384D7BF8D845AE8085573D7759@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/21 3:56 PM, Michael Kelley wrote:
> From: Vineeth Pillai <viremana@linux.microsoft.com> Sent: Wednesday, April 7, 2021 7:41 AM
>> Bit 22 of HYPERV_CPUID_FEATURES.EDX is specific to SVM and specifies
>> support for enlightened TLB flush. With this enligtenment enabled,
> s/enligtenment/enlightenment/
Thanks for catching this, will fix.

Thanks,
Vineeth

