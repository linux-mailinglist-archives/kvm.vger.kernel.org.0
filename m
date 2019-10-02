Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8842EC44E4
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 02:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfJBATr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 20:19:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbfJBATr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 20:19:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9208shh016370;
        Wed, 2 Oct 2019 00:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=3w1n3fSGXh5Nr55mDEeekoWceCLFCijH6fXqZilZAyA=;
 b=ZdMhnzjFzngDBtGLXIgfN2heZeo6xmvI3Y2jJ4vadBJPCFG/QEuQEFdK6r/vaydroOqb
 Ls798rp1wPc0PvQwdrzi8aIZ4PJoJPuV/0jBmaLQRmTIRv1En0vFxPPwcKPHYhsAW0+L
 JRp2afgsfaXI+HDbLhHFo0Gv0TR4BlGSM2xqTRXSUsU7wy0agYnIcwAuP/uzbkxRjsMh
 XgdEQixNlEUzPsdXagS/p7CdEYy1m80UmevEFhZZbujVke70Vuuv8CDTMRDa8jrmy2Ni
 BCbyz6c+raLxpRjCdg62tfo8IRFwC74fjFqY5tZkzkKAOZp6vQEcELeWKilrIXHS9RRR iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rsk3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 00:19:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9208dpW123983;
        Wed, 2 Oct 2019 00:19:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vbqd1rnb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 00:19:21 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x920JKHM002310;
        Wed, 2 Oct 2019 00:19:20 GMT
Received: from [192.168.14.112] (/79.180.244.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 17:19:20 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191001184034.GC27090@linux.intel.com>
Date:   Wed, 2 Oct 2019 03:19:16 +0300
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4070354D-B66E-44A8-98E4-0118669047EE@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
 <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
 <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
 <86619DAE-C601-4162-9622-E3DE8CB1C295@gmail.com>
 <20191001184034.GC27090@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=893
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=967 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010207
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 1 Oct 2019, at 21:40, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Mon, Sep 30, 2019 at 06:29:52PM -0700, Nadav Amit wrote:
>>> On Sep 30, 2019, at 6:23 PM, Liran Alon <liran.alon@oracle.com> =
wrote:
>>>=20
>>> If INIT signal won=E2=80=99t be kept pending until exiting VMX =
operation, target
>>> CPU which was sent with INIT signal when it was running guest, =
basically
>>> lost INIT signal forever and just received an exit-reason it cannot =
do much
>>> with.  That=E2=80=99s why I thought Intel designed this mechanism =
like I specified
>>> above.
>>=20
>> Well, the host can always issue an INIT using an IPI.
>=20
> And conversely, if the INIT persisted then the host would be forced to =
do
> VMXOFF, otherwise it effectively couldn't do VM-Enter on that logical =
CPU.

The way I grasped it previously is that hypervisor have 2 different =
options to respond to an INIT-signal exit-reason:
1) Interpret INIT signal as suppose to be delivered to host (e.g. KVM =
use-case). i.e. Allow other CPU which send INIT signal to reset it. By =
just exiting VMX operation with VMXOFF.
2) Interpet INIT signal as suppose to be delivered to guest (e.g. A =
=E2=80=9Cpassthrough=E2=80=9D security hypervisor loaded during =
boot-chain). In this case, hypervisor would reset vCPU context and then =
enter guest with wait-for-SIPI activity-state. That blocks pending INIT =
signal from being delivered and exiting from non-root mode. Then next =
physical SIPI delivered to CPU will be consumed properly.

Anyway, just wanted to layout my previous thoughts on the matter.
I think Intel SDM phrasing on this regard is very confusing=E2=80=A6

-Liran

