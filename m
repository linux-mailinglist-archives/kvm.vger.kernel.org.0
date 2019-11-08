Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5E1F503E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 16:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKHPx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 10:53:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfKHPx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 10:53:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8FmvHs092969;
        Fri, 8 Nov 2019 15:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=78vl3npWJFMLe7zo3j14Ef2EAdUrVRh4A4J/0eq0k48=;
 b=CFSNTtfGlW/FJHQPQF4mMj76ADbG/xhRrnXCY6qjJhh4c/P4rx52friy823++LC9r0zn
 c5SxWOj/OlM2NAZ+C0ovvMcS/p9ML/LSNP0GGoGLdrUBK8s5VAYjCfIcJULwpjMNujDc
 KsdGYYLlF3Pr/7hTXW1iWz5h1YrYThROyeaqC2aIrPJT/SdIvAwL4664klMw2exJiq1b
 2qoeGfEa6gNxgzpH1thfuQw7UdsEXTxtABb+/OoyBtqcx5sUaKnPni9v4CjX7B2XwosF
 vZNfjbdo2KGZOLMGxMiMzBfSZBdT3Cfx0JzR+4UmpW2PxrVb40ldgPxgA+5VPW3Ri/ru jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w164sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 15:52:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8FmeF7142337;
        Fri, 8 Nov 2019 15:52:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w4k32x5bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 15:52:28 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8FqPmA025299;
        Fri, 8 Nov 2019 15:52:26 GMT
Received: from [10.74.127.144] (/10.74.127.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 07:52:25 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <E392C60C-A596-49DD-B604-8B3C473ACAA2@dinechin.org>
Date:   Fri, 8 Nov 2019 17:52:19 +0200
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        KVM list <kvm@vger.kernel.org>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B82FF2C-0309-4D67-85E2-646AFB77B2FD@oracle.com>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105193749.GA20225@linux.intel.com>
 <20191105232500.GA25887@linux.intel.com>
 <943488A8-2DD7-4471-B3C7-9F21A0B0BCF9@dinechin.org>
 <713ECF67-6A6C-4956-8AC6-7F4C05961328@oracle.com>
 <E392C60C-A596-49DD-B604-8B3C473ACAA2@dinechin.org>
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 8 Nov 2019, at 17:35, Christophe de Dinechin =
<christophe.de.dinechin@gmail.com> wrote:
>=20
>=20
>=20
>> On 7 Nov 2019, at 16:02, Liran Alon <liran.alon@oracle.com> wrote:
>>=20
>>=20
>>=20
>>> On 7 Nov 2019, at 16:00, Christophe de Dinechin =
<christophe.de.dinechin@gmail.com> wrote:
>>>=20
>>=20
>>>=20
>>> I share that concern about the naming, although I do see some
>>> value in exposing the cpu_smt_possible() result. I think it=E2=80=99s =
easier
>>> to state that something does not work than to state something does
>>> work.
>>>=20
>>> Also, with respect to mitigation, we may want to split the two cases
>>> that Paolo outlined, i.e. have KVM_HINTS_REALTIME,
>>> KVM_HINTS_CORES_CROSSTALK and
>>> KVM_HINTS_CORES_LEAKING,
>>> where CORES_CROSSTALKS indicates there may be some
>>> cross-talk between what the guest thinks are isolated cores,
>>> and CORES_LEAKING indicates that cores may leak data
>>> to some other guest.
>>>=20
>>> The problem with my approach is that it is shouting =E2=80=9Cdon=E2=80=
=99t trust me=E2=80=9D
>>> a bit too loudly.
>>=20
>> I don=E2=80=99t see a value in exposing CORES_LEAKING to guest. As =
guest have nothing to do with it.
>=20
> The guest could display / expose the information to guest sysadmins
> and admin tools (e.g. through /proc).
>=20
> While the kernel cannot mitigate, a higher-level product could for =
example
> have a policy about which workloads can be deployed on a system which
> may leak data to other VMs.
>=20
> Christophe

Honestly, I don=E2=80=99t think any sane cloud provider will schedule =
vCPUs of different guests on same physical CPU core and report this to =
guest.
Therefore, I think this is only relevant for use-cases where the guest =
owner is also the host/hypervisor owner. And therefore, doesn=E2=80=99t =
need this
information exposed in a CPUID bit.
I see your point regarding how in theory it could be used, but I think =
we should wait and see if such use-case exists before defining this =
interface.

-Liran


