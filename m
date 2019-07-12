Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3999E66C00
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 14:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfGLMD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 08:03:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44902 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfGLMD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 08:03:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CBwsI5088850;
        Fri, 12 Jul 2019 12:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=UvA9Jh+08UHDvAGbwH3rBrV64pox2kQExiFizxg0YeE=;
 b=5ejc6Na9HF23eUHz+BoYzKJNXXd5vAuVzCPuho38k/IyFL2csYS3SnWEb0UPapmo3HIU
 FOyNU6a1xSXya3VSdARvmmJgK1gVPPhnhBeYTTY1XqSVE5wPiZz7Vxi3BILLWQfRD/uk
 pLnasU/FZ9+nUE9wrA2dDC9QvY/wHPA0f16WZM4KL+KUBsfjC8k4Tj0708t/dquhPxOj
 okn7O5zqJaxn2XSMGdjKjtmnVvSosskbXQlfvyI1JTpXGnfmZrmDSca/+jGntCvFNtOg
 D/fz27Rhl3WQqSev+OZcy4Ux7WTKtZkORZlyxZRANEuwnmxRdbZEpYG7GlnbyHSFAURi Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tjkkq56p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 12:01:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CBvj2w033926;
        Fri, 12 Jul 2019 12:01:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tn1j23x9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 12:01:53 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6CC1mo3030245;
        Fri, 12 Jul 2019 12:01:48 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 04:56:48 -0700
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
Date:   Fri, 12 Jul 2019 13:56:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/12/19 12:44 PM, Thomas Gleixner wrote:
> On Thu, 11 Jul 2019, Dave Hansen wrote:
> 
>> On 7/11/19 7:25 AM, Alexandre Chartre wrote:
>>> - Kernel code mapped to the ASI page-table has been reduced to:
>>>    . the entire kernel (I still need to test with only the kernel text)
>>>    . the cpu entry area (because we need the GDT to be mapped)
>>>    . the cpu ASI session (for managing ASI)
>>>    . the current stack
>>>
>>> - Optionally, an ASI can request the following kernel mapping to be added:
>>>    . the stack canary
>>>    . the cpu offsets (this_cpu_off)
>>>    . the current task
>>>    . RCU data (rcu_data)
>>>    . CPU HW events (cpu_hw_events).
>>
>> I don't see the per-cpu areas in here.  But, the ASI macros in
>> entry_64.S (and asi_start_abort()) use per-cpu data.
>>
>> Also, this stuff seems to do naughty stuff (calling C code, touching
>> per-cpu data) before the PTI CR3 writes have been done.  But, I don't
>> see anything excluding PTI and this code from coexisting.
> 
> That ASI thing is just PTI on steroids.
> 
> So why do we need two versions of the same thing? That's absolutely bonkers
> and will just introduce subtle bugs and conflicting decisions all over the
> place.
> 
> The need for ASI is very tightly coupled to the need for PTI and there is
> absolutely no point in keeping them separate.
>
> The only difference vs. interrupts and exceptions is that the PTI logic
> cares whether they enter from user or from kernel space while ASI only
> cares about the kernel entry.

I think that's precisely what makes ASI and PTI different and independent.
PTI is just about switching between userland and kernel page-tables, while
ASI is about switching page-table inside the kernel. You can have ASI without
having PTI. You can also use ASI for kernel threads so for code that won't
be triggered from userland and so which won't involve PTI.

> But most exceptions/interrupts transitions do not require to be handled at
> the entry code level because on VMEXIT the exit reason clearly tells
> whether a switch to the kernel CR3 is necessary or not. So this has to be
> handled at the VMM level already in a very clean and simple way.
> 
> I'm not a virt wizard, but according to code inspection and instrumentation
> even the NMI on the host is actually reinjected manually into the host via
> 'int $2' after the VMEXIT and for MCE it looks like manual handling as
> well. So why do we need to sprinkle that muck all over the entry code?
> 
>  From a semantical perspective VMENTER/VMEXIT are very similar to the return
> to user / enter to user mechanics. Just that the transition happens in the
> VMM code and not at the regular user/kernel transition points.

VMExit returns to the kernel, and ASI is used to run the VMExit handler with
a limited kernel address space instead of using the full kernel address space.
Change in entry code is required to handle any interrupt/exception which
can happen while running code with ASI (like KVM VMExit handler).

Note that KVM is an example of an ASI consumer, but ASI is generic and can be
used to run (mostly) any kernel code if you want to run code with a reduced
kernel address space.

> So why do you want ot treat that differently? There is absolutely zero
> reason to do so. And there is no reason to create a pointlessly different
> version of PTI which introduces yet another variant of a restricted page
> table instead of just reusing and extending what's there already.
> 

As I've tried to explain, to me PTI and ASI are different and independent.
PTI manages switching between userland and kernel page-table, and ASI manages
switching between kernel and a reduced-kernel page-table.


Thanks,

alex.
