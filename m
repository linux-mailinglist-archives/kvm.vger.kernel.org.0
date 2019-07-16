Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406186AFEA
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfGPTem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:34:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbfGPTem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:34:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJYF5w072921;
        Tue, 16 Jul 2019 19:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=EFkSt7YWsoz0jv1qNWBWOWXp5GPZBLqMXYCwiK4QU/A=;
 b=HOLHjiH7pXBIE7Ql422wHTtrJdj5L0UMDYzIGp4rcpE6lg9L9DakvqdO1ZlDUoyijgRO
 jtIGnOG7XAGEJWFTmEX9Bh2VWtAEwmiFn2tldbMDvJEKcf2IsolBM92jA+wzVQuQ6e/J
 sfIhe4Rb/dS0kmXwCuL4FNbVPafIZVMcI3PSDOZbyKu7wdmYbq0sOjlbvTY37jOBvmWr
 1bOm4172hv5fqDoT5IzU09XhtE+dSm2yUno/+1Y7injvgt1VY/JPD5Qt2OX1TFQZqp/i
 juouHsU5M3hrFN/lhf4k6ZVsT8aGD9T5ZeL0zJ6s3F1oq5sq8rt3LluY+xcSAtGj6T7Y TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tq78pph7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:34:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJWoi9194135;
        Tue, 16 Jul 2019 19:34:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tq4du3vs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:34:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GJYDno013904;
        Tue, 16 Jul 2019 19:34:13 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 19:34:13 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
Date:   Tue, 16 Jul 2019 22:34:08 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160239
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160239
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 22:28, Singh, Brijesh <brijesh.singh@amd.com> =
wrote:
>=20
>=20
>=20
> On 7/16/19 12:35 PM, Liran Alon wrote:
>>=20
>>=20
>>> On 16 Jul 2019, at 20:27, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>=20
>>> On 16/07/19 18:56, Liran Alon wrote:
>>>> If the CPU performs the VMExit transition of state before doing the =
data read for DecodeAssist,
>>>> then I agree that CPL will be 0 on data-access regardless of vCPU =
CPL. But this also means that SMAP
>>>> violation should be raised based on host CR4.SMAP value and not =
vCPU CR4.SMAP value as KVM code checks.
>>>>=20
>>>> Furthermore, vCPU CPL of guest doesn=E2=80=99t need to be 3 in =
order to trigger this Errata.
>>>=20
>>> Under the conditions in the code, if CPL were <3 then the SMAP fault
>>> would have been sent to the guest.
>>> But I agree that if we need to
>>> change it to check host CR4, then the CPL of the guest should not be
>>> checked.
>>=20
>> Yep.
>> Well it all depends on how AMD CPU actually works.
>> We need some clarification from AMD but for sure the current code in =
KVM is not only wrong, but probably have never been tested. :P
>>=20
>> Looking for further clarifications from AMD before submitting v2=E2=80=A6=

>>=20
>=20
> When this errata is hit, the CPU will be at CPL3. =46rom hardware
> point-of-view the below sequence happens:
>=20
> 1. CPL3 guest hits reserved bit NPT fault (MMIO access)

Why CPU needs to be at CPL3?
The requirement for SMAP should be that this page is user-accessible in =
guest page-tables.
Think on a case where guest have CR4.SMAP=3D1 and CR4.SMEP=3D0.

>=20
> 2. Microcode uses special opcode which attempts to read data using the
> CPL0 privileges. The microcode read CS:RIP, when it hits SMAP fault,
> it gives up and returns no instruction bytes.
>=20
> (Note: vCPU is still at CPL3)

So at this point guest vCPU CR4.SMAP is what matters right? Not host =
CR4.SMAP.

>=20
> 3. CPU causes #VMEXIT for original fault address.
>=20
> The SMAP fault occurred while we are still in guest context. It will =
be
> nice to have code test example to triggers this errata.

I can write such code in kvm-unit-tests for you to run on relevant =
hardware if you have such a machine present.
I don=E2=80=99t have relevant machine with me and therefore I wrote a =
disclaimer I couldn=E2=80=99t test it in cover letter.

So to sum-up what KVM needs to do:
1) Check guest vCPU CR4.SMAP is set to 1. (As I fixed in this commit).
2) Remove the check for CPL=3D=3D3. If we really want to be pedantic, we =
can parse guest page-tables to see if PTE have U/S bit set to 1.
What do you think?

-Liran

>=20
>> -Liran
>>=20
>>>=20
>>> Paolo
>>>=20
>>>> It=E2=80=99s only important that guest page-tables maps the guest =
RIP as user-accessible. i.e. U/S bit in PTE set to 1.
>>>=20
>>=20

