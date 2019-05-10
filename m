Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4719BBA
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 12:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfEJKfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 06:35:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfEJKfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 06:35:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AAYa9p126159;
        Fri, 10 May 2019 10:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=t/s+wIIAcXBrllwFHw1Nlf5q2WnVld+E7xw+jJaYJsA=;
 b=FIvTQvdyzgY+8HpzJR2GlXlnohffxRzqeVEhqlqfQUr1DpARZjAEBpHzPGwT09gmOVxo
 biBAncXtppF4caFjMsgvGaKHV7IPo7IANgdTRtTfd08mr9C7rijvx+6a+4sa+CstEkLf
 mdANQlhpXRXBQCnKRe8+CG6mV2ViDzg0pXRopsn9vvRuykNvpSVFXrY9vcLL6XOWUotf
 mJZn3rhE/V/2oDvNhk5IcWRHJhQzmVrStZepvLm1SU+fxiNXwSq9tgUP95kxM7W3lI2E
 QqQxbHpqok/snZptMRI2B8/XL87QQAxh2SVwEs09Vt7K8RKUrITwpA8yAp6ByYVNICVQ wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2s94bgg6y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 10:34:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AAX863161712;
        Fri, 10 May 2019 10:34:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2schw0bnh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 10:34:45 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4AAYi0f013961;
        Fri, 10 May 2019 10:34:44 GMT
Received: from [10.175.174.208] (/10.175.174.208)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 03:34:44 -0700
Subject: Re: [PATCH] KVM: VMX: Nop emulation of MSR_IA32_POWER_CTL
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
References: <20190415154526.64709-1-liran.alon@oracle.com>
 <20190415181702.GH24010@linux.intel.com>
 <AD81166E-0C42-49FD-AC37-E6F385C23B13@oracle.com>
 <4848D424-F852-4E1C-8A86-6AA1A26D2E90@oracle.com>
 <2dad36e7-a0e5-9670-c902-819c5200466f@oracle.com>
 <CANRm+CyYkjFaLZMOHP3sMYVjFNo1P7uKbrRr7U3FfRHhG5jVkA@mail.gmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <d930e87a-fbe3-cf63-b8a0-26e9f012442a@oracle.com>
Date:   Fri, 10 May 2019 11:34:41 +0100
MIME-Version: 1.0
In-Reply-To: <CANRm+CyYkjFaLZMOHP3sMYVjFNo1P7uKbrRr7U3FfRHhG5jVkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100075
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/19 10:54 AM, Wanpeng Li wrote:
> Hi all,
> On Wed, 17 Apr 2019 at 03:18, Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> On 4/16/19 4:40 PM, Liran Alon wrote:
>>>> On 16 Apr 2019, at 18:21, Liran Alon <liran.alon@oracle.com> wrote:
>>>>> On 15 Apr 2019, at 21:17, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>>>> On Mon, Apr 15, 2019 at 06:45:26PM +0300, Liran Alon wrote:
>>>>>
>>>>> Technically, I think this is a Qemu bug.  KVM reports all zeros for
>>>>> CPUID_MWAIT_LEAF when userspace queries KVM_GET_SUPPORTED_CPUID and
>>>>> KVM_GET_EMULATED_CPUID.  And I think that's correct/desired, supporting
>>>>> MONITOR/MWAIT sub-features should be a separate enabling patch set.
>>>>
>>>> At some point in time Jim added commit df9cb9cc5bcd ("kvm: x86: Amend the KVM_GET_SUPPORTED_CPUID API documentation”)
>>>> which added the following paragraph to documentation:
>>>> "Note that certain capabilities, such as KVM_CAP_X86_DISABLE_EXITS, may
>>>> expose cpuid features (e.g. MONITOR) which are not supported by kvm in
>>>> its default configuration. If userspace enables such capabilities, it
>>>> is responsible for modifying the results of this ioctl appropriately.”
>>>>
>>>> It’s indeed not clear what it means to “modify the results of this ioctl *appropriately*” right?
>>>> It can either mean you just expose in CPUID[EAX=1].ECX support for MONITOR/MWAIT
>>>> or that you also expose CPUID_MWAIT_LEAF (CPUID[EAX=5]).
>>>> Both regardless of the value returned from KVM_GET_SUPPORTED_CPUID ioctl.
>>>>
>>>> Having said that, I tend to agree with you.
>>>> Instead of emulating this MSR in KVM, I think it it preferred to change QEMU to expose MONITOR/MWAIT support in CPUID[EAX=1].ECX
>>>> but in CPUID[EAX=5] init everything as in host besides ECX[0] which will be set to 0 to report we don’t support extensions.
>>>> (We still want to support range of monitor line size, whether we can treat interrupts as break-events for MWAIT and the supported C substates).
>>>> I will create this patch for QEMU.
>>>
>>> Actually on second thought, I will just remain with the KVM patch (that Paolo was nice enough to already queue).
>>> and not do this QEMU patch. This is because why will we want to prevent guest from specifying target C-State if he is exposed with MWAIT?
>>> I don’t see a reason we should prevent that. Do you?
>>>
>> One reason it is a good idea to prevent the guest from entering deeper
>> C-states (e.g. deeper than C2) is to allow preemption timer to be used again
>> when guests are exposed with MWAIT (currently we can't do that).
> 
> It is weird that we can observe intel_idle driver in the guest
> executes mwait eax=0x20, and the corresponding pCPU enters C3 on HSW
> server, however, we can't observe this on SKX/CLX server, it just
> enters maximal C1. 

I assume you refer to the case where you pass the host mwait substates to the
guests as is, right? Or are you zeroing/filtering out the mwait cpuid leaf EDX
like my patch (attached in the previous message) suggests?

Interestingly, hints set to 0x20 actually corresponds to C6 on HSW (based on
intel_idle driver). IIUC From the SDM (see Vol 2B, "MWAIT for Power Management"
in instruction set reference M-U) the hints register, doesn't necessarily
guarantee the specified C-state depicted in the hints will be used. The manual
makes it sound like it is tentative, and implementation-specific condition may
either ignore it or enter a different one. It appears to be only guaranteed that
it won't enter a C-{sub,}state deeper than the one depicted.

> All the setups between HSW and SKX/CLX are the
> same. Sean and Liran, any opinions?
> 
> Regards,
> Wanpeng Li
> 
