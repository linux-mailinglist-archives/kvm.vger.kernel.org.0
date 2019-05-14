Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89741C50D
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 10:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfENIef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 04:34:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfENIef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 04:34:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E8TLGp056543;
        Tue, 14 May 2019 08:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Jt8E3lVLhJgEFEn3MWp6fWcs0kIahKV5qTQyv9mVy4Q=;
 b=qQ5fpl3RpL05hBrLUsIf1E+1aBvQCu2pudkdg7nNbgXKbiyQrs3rzMBl8DOqaVQHvlUo
 BEMxNYvh+HArNT8mJVSIONSMqsMK9XNYSZrJ6jhaDP2gpLbRtN/8Cfq3QYYSD/2QoUpN
 gY/xNBPRsOfaJO3Spebcq+HSYbB6hOT3UVOwvAYwWeOvBicWFXqngxnNbX9nmkLuRRBr
 kqTold+bwX7DdG8BDGFVbeoMJtAu5Szv1J4ICH0xH/ml/1B5RJ6ycOs5ilOrzToeBSDh
 opo8MwXBSHn7tq/EQfmSrfdI9mcEB23G40rmbZl4jGKA2UK2QMjkaCDlNwVn6Aphx8OT Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sdq1qc40q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 08:33:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E8Xaii012801;
        Tue, 14 May 2019 08:33:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sdnqje85m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 08:33:58 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4E8XtZr025473;
        Tue, 14 May 2019 08:33:56 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 08:33:55 +0000
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
To:     Liran Alon <liran.alon@oracle.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com>
 <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <d366fb99-16bc-30ef-71bd-ecd7d77c6c7c@oracle.com>
Date:   Tue, 14 May 2019 10:33:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140063
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/13/19 11:08 PM, Liran Alon wrote:
> 
> 
>> On 13 May 2019, at 21:17, Andy Lutomirski <luto@kernel.org> wrote:
>>
>>> I expect that the KVM address space can eventually be expanded to include
>>> the ioctl syscall entries. By doing so, and also adding the KVM page table
>>> to the process userland page table (which should be safe to do because the
>>> KVM address space doesn't have any secret), we could potentially handle the
>>> KVM ioctl without having to switch to the kernel pagetable (thus effectively
>>> eliminating KPTI for KVM). Then the only overhead would be if a VM-Exit has
>>> to be handled using the full kernel address space.
>>>
>>
>> In the hopefully common case where a VM exits and then gets re-entered
>> without needing to load full page tables, what code actually runs?
>> I'm trying to understand when the optimization of not switching is
>> actually useful.
>>
>> Allowing ioctl() without switching to kernel tables sounds...
>> extremely complicated.  It also makes the dubious assumption that user
>> memory contains no secrets.
> 
> Let me attempt to clarify what we were thinking when creating this patch series:
> 
> 1) It is never safe to execute one hyperthread inside guest while it’s sibling hyperthread runs in a virtual address space which contains secrets of host or other guests.
> This is because we assume that using some speculative gadget (such as half-Spectrev2 gadget), it will be possible to populate *some* CPU core resource which could then be *somehow* leaked by the hyperthread running inside guest. In case of L1TF, this would be data populated to the L1D cache.
> 
> 2) Because of (1), every time a hyperthread runs inside host kernel, we must make sure it’s sibling is not running inside guest. i.e. We must kick the sibling hyperthread outside of guest using IPI.
> 
> 3) From (2), we should have theoretically deduced that for every #VMExit, there is a need to kick the sibling hyperthread also outside of guest until the #VMExit is completed. Such a patch series was implemented at some point but it had (obviously) significant performance hit.
> 
> 4) The main goal of this patch series is to preserve (2), but to avoid the overhead specified in (3).
> 
> The way this patch series achieves (4) is by observing that during the run of a VM, most #VMExits can be handled rather quickly and locally inside KVM and doesn’t need to reference any data that is not relevant to this VM or KVM code. Therefore, if we will run these #VMExits in an isolated virtual address space (i.e. KVM isolated address space), there is no need to kick the sibling hyperthread from guest while these #VMExits handlers run.
> The hope is that the very vast majority of #VMExit handlers will be able to completely run without requiring to switch to full address space. Therefore, avoiding the performance hit of (2).
> However, for the very few #VMExits that does require to run in full kernel address space, we must first kick the sibling hyperthread outside of guest and only then switch to full kernel address space and only once all hyperthreads return to KVM address space, then allow then to enter into guest.
> 
>  From this reason, I think the above paragraph (that was added to my original cover letter) is incorrect.

Yes, I am wrong. The KVM page table can't be added to the process userland page
table because this can leak secrets from userland. I was only thinking about
performances to reduce the number of context switches. So just forget that
paragraph :-)

alex.


> I believe that we should by design treat all exits to userspace VMM (e.g. QEMU) as slow-path that should not be optimised and therefore ok to switch address space (and therefore also kick sibling hyperthread). Similarly, all IOCTLs handlers are also slow-path and therefore it should be ok for them to also not run in KVM isolated address space.
> 
> -Liran
> 
