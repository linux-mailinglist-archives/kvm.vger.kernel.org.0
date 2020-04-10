Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAF71A4341
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 10:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgDJIB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 04:01:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60214 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgDJIB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 04:01:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03A7x6eB075611;
        Fri, 10 Apr 2020 07:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=corp-2020-01-29;
 bh=Vn77qQ/QtYjjjSJLX26c89JaXFFW6kj4kfyV1dn80ek=;
 b=Iy/P563WEWlNAwggjq9YimbljE/IPyWi/pnOOfOXuQEOrrMEDAy8F7JZ9WeDBzgvZ6UP
 aI+tyITemHYTKTsxxiRSGKPQ41lPflujP3sN29iKpW4AfW5vvhbWEmmcocJSQy6ZPcvd
 cjorJkufOuTAt49DEwW+YR3nZDIEMa7ci21E8nmrDlESch9p8mfCbdrbwDqAQ0Is3wrS
 J3KUec6u/5xJ/MRrl56eECyLcCWz63ac3bVxrbPp08jpBs0LgPz0pyHyW4cAN44QwSx8
 x/hxsN7ou0rIZV3iOkkGmXnS9B9eqVCoJ4IofaKu3SsWvPYAORsH79wFp7XSdswoZ0es fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 309gw4h696-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 07:59:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03A7upq3153841;
        Fri, 10 Apr 2020 07:57:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 309ag713n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 07:57:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03A7usJ4026272;
        Fri, 10 Apr 2020 07:56:54 GMT
Received: from [10.159.135.41] (/10.159.135.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 00:56:54 -0700
Subject: Re: [RFC PATCH 00/26] Runtime paravirt patching
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, bp@alien8.de,
        vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
 <d7f8bff3-526a-6a84-2e81-677cfbac0111@suse.com>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <9e35c408-e294-ecb6-d927-ba5e9ca4f41e@oracle.com>
Date:   Fri, 10 Apr 2020 00:56:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d7f8bff3-526a-6a84-2e81-677cfbac0111@suse.com>
Content-Type: multipart/mixed;
 boundary="------------E32DC4ADFA44A8E05F9A4BBF"
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004100066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a multi-part message in MIME format.
--------------E32DC4ADFA44A8E05F9A4BBF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

So, first thanks for the quick comments even though some of my choices
were straight NAKs (or maybe because of that!)

Second, I clearly did a bad job of motivating the series. Let me try
to address the motivation comments first and then I can address the
technical concerns separately.

[ I'm collating all the motivation comments below. ]


>> A KVM host (or another hypervisor) might advertise paravirtualized
>> features and optimization hints (ex KVM_HINTS_REALTIME) which might
>> become stale over the lifetime of the guest. For instance, the 

Thomas> If your host changes his advertised behaviour then you want to
Thomas> fix the host setup or find a competent admin.

Juergen> Then this hint is wrong if it can't be guaranteed.

I agree, the hint behaviour is wrong and the host shouldn't be giving
hints it can only temporarily honor.
The host problem is hard to fix though: the behaviour change is
either because of a guest migration or in case of a hosted guest,
cloud economics -- customers want to go to a 2-1 or worse VCPU-CPU
ratio at times of low load.

I had an offline discussion with Paolo Bonzini where he agreed that
it makes sense to make KVM_HINTS_REALTIME a dynamic hint rather than
static as it is now. (That was really the starting point for this
series.)

>> host might go from being undersubscribed to being oversubscribed
>> (or the other way round) and it would make sense for the guest
>> switch pv-ops based on that.

Juergen> I think using pvops for such a feature change is just wrong.
Juergen> What comes next? Using pvops for being able to migrate a guest
Juergen> from an Intel to an AMD machine?

My statement about switching pv-ops was too broadly worded. What
I meant to say was that KVM guests choose pv_lock_ops to be native
or paravirt based on undersubscribed/oversubscribed hint at boot,
and this choice should be available at run-time as well.

KVM chooses between native/paravirt spinlocks at boot based on this
reasoning (from commit b2798ba0b8):
"Waiman Long mentioned that:
> Generally speaking, unfair lock performs well for VMs with a small
> number of vCPUs. Native qspinlock may perform better than pvqspinlock
> if there is vCPU pinning and there is no vCPU over-commitment.
"

PeterZ> So what, the paravirt spinlock stuff works just fine when
PeterZ> you're not oversubscribed.
Yeah, the paravirt spinlocks work fine for both under and oversubscribed
hosts, but they are more expensive and that extra cost provides no benefits
when CPUs are pinned.
For instance, pvqueued spin_unlock() is a call+locked cmpxchg as opposed
to just a movb $0, (%rdi).

This difference shows up in kernbench running on a KVM guest with native
and paravirt spinlocks. I ran with 8 and 64 CPU guests with CPUs pinned.

The native version performs same or better.

8 CPU       Native  (std-dev)  Paravirt (std-dev)
             -----------------  -----------------
-j  4: sys  151.89  ( 0.2462)  160.14   ( 4.8366)    +5.4%
-j 32: sys  162.715 (11.4129)  170.225  (11.1138)    +4.6%
-j  0: sys  164.193 ( 9.4063)  170.843  ( 8.9651)    +4.0%


64 CPU       Native  (std-dev)  Paravirt (std-dev)
             -----------------  -----------------
-j  32: sys 209.448 (0.37009)  210.976   (0.4245)    +0.7%
-j 256: sys 267.401 (61.0928)  285.73   (78.8021)    +6.8%
-j   0: sys 286.313 (56.5978)  307.721  (70.9758)    +7.4%

In all cases the pv_kick, pv_wait numbers were minimal as expected.
The lock_slowpath counts were higher with PV but AFAICS the native
and paravirt lock_slowpath are not directly comparable.

Detailed kernbench numbers attached.

Thanks
Ankur

--------------E32DC4ADFA44A8E05F9A4BBF
Content-Type: text/plain; charset=UTF-8;
 name="8-cpus.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="8-cpus.txt"

OC1jcHUtcGlubmVkLG5hdGl2ZQo9PT09PT09PT09PT09PT09PT0KCkF2ZXJhZ2UgSGFsZiBs
b2FkIC1qIDQgUnVuIChzdGQgZGV2aWF0aW9uKToKRWxhcHNlZCBUaW1lIDMwMy42ODYgKDAu
NzM3NjUyKQpVc2VyIFRpbWUgMTAzMi4yNCAoMi44MTMzKQpTeXN0ZW0gVGltZSAxNTEuODkg
KDAuMjQ2MjcyKQpQZXJjZW50IENQVSAzODkuMiAoMC40NDcyMTQpCkNvbnRleHQgU3dpdGNo
ZXMgMTkzNTAuNCAoODIuMTc4NSkKU2xlZXBzIDEyNTg4NSAoMTQ4LjMzOCkKCkF2ZXJhZ2Ug
T3B0aW1hbCBsb2FkIC1qIDMyIFJ1biAoc3RkIGRldmlhdGlvbik6CkVsYXBzZWQgVGltZSAx
ODcuMDY4ICgwLjM1ODQyNykKVXNlciBUaW1lIDExMzAuMzMgKDEwMy40MDUpClN5c3RlbSBU
aW1lIDE2Mi43MTUgKDExLjQxMjkpClBlcmNlbnQgQ1BVIDU2OS4xICgxODkuNjMzKQpDb250
ZXh0IFN3aXRjaGVzIDE0MzMwMSAoMTMwNjU2KQpTbGVlcHMgMTI2OTM4ICgxMTMyLjgzKQoK
QXZlcmFnZSBNYXhpbWFsIGxvYWQgLWogUnVuIChzdGQgZGV2aWF0aW9uKToKRWxhcHNlZCBU
aW1lIDE4OS4wOTggKDAuMzE2ODEyKQpVc2VyIFRpbWUgMTE2Ni41OSAoOTguNDQ1NCkKU3lz
dGVtIFRpbWUgMTY0LjE5MyAoOS40MDYzKQpQZXJjZW50IENQVSA2MjcuMTMzICgxNzQuMTY5
KQpDb250ZXh0IFN3aXRjaGVzIDIyMjI3MCAoMTU2MDA1KQpTbGVlcHMgMTIyNTYyICg2NDcw
LjkzKQoKOC1jcHUtcGlubmVkLCBwdgo9PT09PT09PT09PT09PT09CgpBdmVyYWdlIEhhbGYg
bG9hZCAtaiA0IFJ1biAoc3RkIGRldmlhdGlvbik6CkVsYXBzZWQgVGltZSAzMDkuODcyICg1
Ljg4MikKVXNlciBUaW1lIDEwNDUuOCAoMTguNTI5NSkKU3lzdGVtIFRpbWUgMTYwLjE0ICg0
LjgzNjY5KQpQZXJjZW50IENQVSAzODguOCAoMC40NDcyMTQpCkNvbnRleHQgU3dpdGNoZXMg
NDEyMTUuNCAoNjc5LjUyMikKU2xlZXBzIDEyMjM2OSAoNDc3LjU5MykKCkF2ZXJhZ2UgT3B0
aW1hbCBsb2FkIC1qIDMyIFJ1biAoc3RkIGRldmlhdGlvbik6CkVsYXBzZWQgVGltZSAxOTAu
MSAoMC4zNzc4MjMpClVzZXIgVGltZSAxMTQ0ICgxMDQuMjQ4KQpTeXN0ZW0gVGltZSAxNzAu
MjI1ICgxMS4xMTM4KQpQZXJjZW50IENQVSA1NjguMiAoMTg5LjEwNykKCkF2ZXJhZ2UgTWF4
aW1hbCBsb2FkIC1qIFJ1biAoc3RkIGRldmlhdGlvbik6CkVsYXBzZWQgVGltZSAxOTEuNjA2
ICgwLjEwODMwNSkKVXNlciBUaW1lIDExNzguODMgKDk3LjkwOCkKU3lzdGVtIFRpbWUgMTcw
Ljg0MyAoOC45NjUxKQpQZXJjZW50IENQVSA2MjUuOCAoMTczLjQ5KQpDb250ZXh0IFN3aXRj
aGVzIDIzNDg3OCAoMTQ5NDc5KQpTbGVlcHMgMTIwNTQyICg2MDczLjc5KQo=
--------------E32DC4ADFA44A8E05F9A4BBF
Content-Type: text/plain; charset=UTF-8;
 name="64-cpus.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="64-cpus.txt"

NjQtY3B1LXBpbm5lZCwgbmF0aXZlCj09PT09PT09PT09PT09PT09PT09PQoKQXZlcmFnZSBI
YWxmIGxvYWQgLWogMzIgUnVuIChzdGQgZGV2aWF0aW9uKToKRWxhcHNlZCBUaW1lIDU0LjMw
NiAoMC4xMzQ4MzMpClVzZXIgVGltZSAxMDcyLjc1ICgxLjM0NTk4KQpTeXN0ZW0gVGltZSAy
MDkuNDQ4ICgwLjM3MDA5NSkKUGVyY2VudCBDUFUgMjM2MC40ICg0LjAzNzMzKQpDb250ZXh0
IFN3aXRjaGVzIDI2OTk5ICg5OS41NDE0KQpTbGVlcHMgMTIyNDA4ICgxODQuODcpCgpBdmVy
YWdlIE9wdGltYWwgbG9hZCAtaiAyNTYgUnVuIChzdGQgZGV2aWF0aW9uKToKRWxhcHNlZCBU
aW1lIDM5LjQyNCAoMC4xNTA1OTkpClVzZXIgVGltZSAxMTQwLjkxICg3MS44NzIyKQpTeXN0
ZW0gVGltZSAyNjcuNDAxICg2MS4wOTI4KQpQZXJjZW50IENQVSAzMTI1LjkgKDgwNi45NikK
Q29udGV4dCBTd2l0Y2hlcyAxMjk2NjIgKDEwODIxNykKU2xlZXBzIDEyMTc2NyAoNjk5LjE5
OCkKCkF2ZXJhZ2UgTWF4aW1hbCBsb2FkIC1qIFJ1biAoc3RkIGRldmlhdGlvbik6CkVsYXBz
ZWQgVGltZSA0MS41NjIgKDAuMjA2MDgzKQpVc2VyIFRpbWUgMTE3NC42OCAoNzUuOTM0MikK
U3lzdGVtIFRpbWUgMjg2LjMxMyAoNTYuNTk3OCkKUGVyY2VudCBDUFUgMzMzOS44NyAoNzE5
LjA2MikKQ29udGV4dCBTd2l0Y2hlcyAyMDM0MjggKDEzODUzNikKU2xlZXBzIDExOTA2NiAo
Mzk5My41OCkKCjY0LWNwdS1waW5uZWQsIHB2Cj09PT09PT09PT09PT09PT0KQXZlcmFnZSBI
YWxmIGxvYWQgLWogMzIgUnVuIChzdGQgZGV2aWF0aW9uKToKRWxhcHNlZCBUaW1lIDU1LjE0
ICgwLjA4OTQ0MjcpClVzZXIgVGltZSAxMDcxLjk5ICgxLjQzMzM1KQpTeXN0ZW0gVGltZSAy
MTAuOTc2ICgwLjQyNDU5NCkKUGVyY2VudCBDUFUgMjMyNiAoNC41Mjc2OSkKQ29udGV4dCBT
d2l0Y2hlcyAzNzU0NC44ICgyMjAuOTY5KQpTbGVlcHMgMTE1NTI3ICg5NC43MTM4KQoKQXZl
cmFnZSBPcHRpbWFsIGxvYWQgLWogMjU2IFJ1biAoc3RkIGRldmlhdGlvbik6CkVsYXBzZWQg
VGltZSA0MC41NCAoMC4yNDY3NzkpClVzZXIgVGltZSAxMTM3LjQxICg2OC45NzczKQpTeXN0
ZW0gVGltZSAyODUuNzMgKDc4LjgwMjEpClBlcmNlbnQgQ1BVIDMwOTAuNyAoODA2LjIxOCkK
Q29udGV4dCBTd2l0Y2hlcyAxMzkwNTkgKDEwNzAwNikKU2xlZXBzIDExNjk2MiAoMTUxOC41
NikKCkF2ZXJhZ2UgTWF4aW1hbCBsb2FkIC1qIFJ1biAoc3RkIGRldmlhdGlvbik6CkVsYXBz
ZWQgVGltZSA0Mi42ODIgKDAuMTcwOTM5KQpVc2VyIFRpbWUgMTE3MS42NCAoNzQuNjY2MykK
U3lzdGVtIFRpbWUgMzA3LjcyMSAoNzAuOTc1OCkKUGVyY2VudCBDUFUgMzMwMy4yNyAoNzE3
LjQxOCkKQ29udGV4dCBTd2l0Y2hlcyAyMTM0MzAgKDEzODYxNikKU2xlZXBzIDExNTE0MyAo
MjkzMC4wMykKCg==
--------------E32DC4ADFA44A8E05F9A4BBF--
