Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807756AC78
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbfGPQII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:08:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387773AbfGPQII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:08:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GG4Mim000898;
        Tue, 16 Jul 2019 16:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=T3SerffEsQxhox/2M89h/swsltrA3SDsQVcULNE/SMY=;
 b=vFBu8ZXUt6PnnA+0NTKA48PVFeTF84fv2j9MA+HQnu2Lby4Z+Zb7LT2U6qJBms3oLFDk
 FYIhhAH7SiIOuBpv1/Jai7jSmLU5blvc1mfMdtzdA140sus7S1xDrZ7X4VJErHhvArtD
 R/phozCPa+anaws6tupEz+LDdKy9wPWM6NLEoqZqLKa+tJlefbbPmxfSFqoDey/ZM6R1
 CqqDmLC6BFmIs0vjqH57GK7a86qFFcea5Lum2Y2tK2FibwbUueZR7K6PgKMu4eAvPcgY
 jEZiVMeSXutNeUPJmfGVd6QaHHLXEyYKyWvbE/9gy+FwHElelZrKfZPoWXJUWfl037J1 Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tq6qtnkpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:07:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GG308L115533;
        Tue, 16 Jul 2019 16:07:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tq4du0xv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:07:47 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GG7k1V009702;
        Tue, 16 Jul 2019 16:07:46 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 16:07:46 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
Date:   Tue, 16 Jul 2019 19:07:42 +0300
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <34803405-FE5D-431A-B242-8B64D0A9EB5E@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160198
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 18:56, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 16 Jul 2019, at 18:48, Singh, Brijesh <brijesh.singh@amd.com> =
wrote:
>>=20
>> On 7/15/19 3:30 PM, Liran Alon wrote:
>>> According to AMD Errata 1096:
>>> "On a nested data page fault when CR4.SMAP =3D 1 and the guest data =
read generates a SMAP violation, the
>>> GuestInstrBytes field of the VMCB on a VMEXIT will incorrectly =
return 0h instead the correct guest instruction
>>> bytes."
>>>=20
>>> As stated above, errata is encountered when guest read generates a =
SMAP violation. i.e. vCPU runs
>>> with CPL<3 and CR4.SMAP=3D1. However, code have mistakenly checked =
if CPL=3D=3D3 and CR4.SMAP=3D=3D0.
>>>=20
>>=20
>> The SMAP violation will occur from CPL3 so CPL=3D=3D3 is a valid =
check.
>>=20
>> See [1] for complete discussion
>>=20
>> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__patchwork.kernel.or=
g_patch_10808075_-2322479271&d=3DDwIGaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qIr=
MUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3DRAt8t8nB=
aCxUPy5OTDkO0n8BMQ5l9oSfLMiL0TLTu6c&s=3DNkwe8rTJhygBCIPz27LXrylptjnWyMwB-n=
JaiowWpWc&e=3D=20
>=20
> I still don=E2=80=99t understand. SMAP is a mechanism which is meant =
to protect a CPU running in CPL<3 from mistakenly referencing data =
controllable by CPL=3D=3D3.
> Therefore, SMAP violation should be raised when CPL<3 and data =
referenced is mapped in page-tables with PTE with U/S bit set to 1. =
(i.e. User accessible).
>=20
> Thus, we should check if CPL<3 and CR4.SMAP=3D=3D1.
>=20
> -Liran
>=20

To clarify, I would assume that to simulate this Errata we should =
perform the following:
1) Guest maps code in page-tables as user-accessible (i.e. PTE with U/S =
bit set to 1).
2) Guest executes this code with CPL<3 (even though mapped as =
user-accessible which is a security vulnerability in itself=E2=80=A6) =
which access data that is not mapped or marked as reserved in NPT and =
therefore cause #NPF.
3) Physical CPU DecodeAssist feature attempts to fill-in guest =
instruction bytes. So it reads as data the guest instructions while CPU =
is currently with CPL<3, CR4.SMAP=3D1 and code is mapped as =
user-accessible. Therefore, this fill-in raise a SMAP violation which =
cause #NPF to be raised to KVM with 0 instruction bytes.

Am I mistaken in my analysis?

-Liran



