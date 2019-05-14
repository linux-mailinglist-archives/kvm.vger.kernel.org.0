Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75231D15A
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 23:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfENVe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 17:34:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfENVe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 17:34:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ELTuN4172625;
        Tue, 14 May 2019 21:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xP/1J7WtSjWfHwARbyhttwinIWyTQ+wkt13il4qJ3gI=;
 b=47ccYNEqQtVdANjxK2ZSYU7cWNuAlIz3aclJ+JlSKO3kyibmZMxV9F6hNHWk0nBOHcbb
 eWoQul25jc0gcFPtlbko4rrYqrREgGZxtpPLXG+i/YeKLpFuLDUeokwnqYBB2qCtSNz3
 n5GK/gjgh4cWNyP6cfMyo9WMLR6aQ7zSSgyJDUk8AJALjqOPZlLWOlQki9atZU9VDhr9
 Qn4ylmgTtHrOsereilhau+nW9/JOENdESqjcKGLL1qpoBBUHdB6RlPVmd1LTdTO3De5N
 ZVt/mvsOGNsVYibT/I71ekgHlRyFq9Psav9nBhMdCN+wxzdalYAQvQWL67Mg41xLS0di 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sdq1qgvua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 21:33:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ELVIfq134876;
        Tue, 14 May 2019 21:31:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sdmebbr4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 21:31:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4ELVR6l014023;
        Tue, 14 May 2019 21:31:32 GMT
Received: from tresor.us.oracle.com (/10.211.52.98)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 14:31:27 -0700
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
To:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com>
 <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
 <CALCETrXK8+tUxNA=iVDse31nFRZyiQYvcrQxV1JaidhnL4GC0w@mail.gmail.com>
 <20190514073738.GH2589@hirez.programming.kicks-ass.net>
From:   Jan Setje-Eilers <jan.setjeeilers@oracle.com>
Message-ID: <f0d218f1-076e-e8ce-ebf8-84712a126b32@oracle.com>
Date:   Tue, 14 May 2019 14:32:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514073738.GH2589@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9257 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=878
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140141
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9257 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=903 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/14/19 12:37 AM, Peter Zijlstra wrote:
> On Mon, May 13, 2019 at 07:07:36PM -0700, Andy Lutomirski wrote:
>> On Mon, May 13, 2019 at 2:09 PM Liran Alon <liran.alon@oracle.com> wrote:
>>> The hope is that the very vast majority of #VMExit handlers will be
>>> able to completely run without requiring to switch to full address
>>> space. Therefore, avoiding the performance hit of (2).
>>> However, for the very few #VMExits that does require to run in full
>>> kernel address space, we must first kick the sibling hyperthread
>>> outside of guest and only then switch to full kernel address space
>>> and only once all hyperthreads return to KVM address space, then
>>> allow then to enter into guest.
>> What exactly does "kick" mean in this context?  It sounds like you're
>> going to need to be able to kick sibling VMs from extremely atomic
>> contexts like NMI and MCE.
> Yeah, doing the full synchronous thing from NMI/MCE context sounds
> exceedingly dodgy, howver..
>
> Realistically they only need to send an IPI to the other sibling; they
> don't need to wait for the VMExit to complete or anything else.
>
> And that is something we can do from NMI context -- with a bit of care.
> See also arch_irq_work_raise(); specifically we need to ensure we leave
> the APIC in an idle state, such that if we interrupted an APIC sequence
> it will not suddenly fail/violate the APIC write/state etc.
>
  I've been experimenting with IPI'ing siblings on vmexit, primarily 
because we know we'll need it if ASI turns out to be viable, but also 
because I wanted to understand why previous experiments resulted in such 
poor performance.

  You're correct that you don't need to wait for the sibling to come out 
once you send the IPI. That hardware thread will not do anything other 
than process the IPI once it's sent. There is still some need for 
synchronization, at least for the every vmexit case, since you always 
want to make sure that one thread is actually doing work while the other 
one is held. I have this working for some cases, but not enough to call 
it a general solution. I'm not at all sure that the every vmexit case 
can be made to perform for the general case. Even the non-general case 
uses synchronization that I fear might be overly complex.

  For the cases I do have working, simply not pinning the sibling when 
we exit due to the quest idling is a big enough win to put performance 
into a much more reasonable range.

  Base on this, I believe that pining a sibling HT in a subset of cases, 
when we interact with full kernel address space, is almost certainly 
reasonable.

-jan

