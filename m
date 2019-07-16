Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8596AC9A
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387773AbfGPQVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:21:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbfGPQVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:21:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GGJO1c020856;
        Tue, 16 Jul 2019 16:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=p40tqoyc/c5ON1KgsLf/b918olU1Gq0gReRgQp8e6uw=;
 b=miXLoPj3jpnX5ZoKkYZ6J1bkpt75Jz400AHiA8WGWEJuuf36AyYFQNfCadMwwcvLAFCn
 b0NhPXFt9a45ef31phEunSBWYjPYxNcZqQu95MRolWzKXF4lDtOI/2coAKs+/rS5Mo2x
 2B9AgnIDAm3wocDG2NqE7AjMKb90R/JkHwXxhAXL6vQTpNwFQVESyhSwIt7ujoqvFhff
 J5wDJCYE5HGnTECEu8Ug/HYhKblN1lYOOhncoka/td9WeJagI94R+dMjqzNb+bPvVxjk
 s/JU2hLouQ+2pObbbevv7TLTHR4qo1N2adAXcl37CHfWxioQuXeDK1kUFpUidetOI4k8 NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tq7xqwhh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:20:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GGIDtl045982;
        Tue, 16 Jul 2019 16:20:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tq6mmyydk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:20:50 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GGKnU9025352;
        Tue, 16 Jul 2019 16:20:49 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 16:20:49 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
Date:   Tue, 16 Jul 2019 19:20:42 +0300
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160201
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 19:10, Singh, Brijesh <brijesh.singh@amd.com> =
wrote:
>=20
>=20
>=20
> On 7/16/19 10:56 AM, Liran Alon wrote:
>>=20
>>=20
>>> On 16 Jul 2019, at 18:48, Singh, Brijesh <brijesh.singh@amd.com> =
wrote:
>>>=20
>>> On 7/15/19 3:30 PM, Liran Alon wrote:
>>>> According to AMD Errata 1096:
>>>> "On a nested data page fault when CR4.SMAP =3D 1 and the guest data =
read generates a SMAP violation, the
>>>> GuestInstrBytes field of the VMCB on a VMEXIT will incorrectly =
return 0h instead the correct guest instruction
>>>> bytes."
>>>>=20
>>>> As stated above, errata is encountered when guest read generates a =
SMAP violation. i.e. vCPU runs
>>>> with CPL<3 and CR4.SMAP=3D1. However, code have mistakenly checked =
if CPL=3D=3D3 and CR4.SMAP=3D=3D0.
>>>>=20
>>>=20
>>> The SMAP violation will occur from CPL3 so CPL=3D=3D3 is a valid =
check.
>>>=20
>>> See [1] for complete discussion
>>>=20
>>> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__patchwork.kernel.or=
g_patch_10808075_-2322479271&d=3DDwIGaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qIr=
MUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3DRAt8t8nB=
aCxUPy5OTDkO0n8BMQ5l9oSfLMiL0TLTu6c&s=3DNkwe8rTJhygBCIPz27LXrylptjnWyMwB-n=
JaiowWpWc&e=3D
>>=20
>> I still don=E2=80=99t understand. SMAP is a mechanism which is meant =
to protect a CPU running in CPL<3 from mistakenly referencing data =
controllable by CPL=3D=3D3.
>> Therefore, SMAP violation should be raised when CPL<3 and data =
referenced is mapped in page-tables with PTE with U/S bit set to 1. =
(i.e. User accessible).
>>=20
>> Thus, we should check if CPL<3 and CR4.SMAP=3D=3D1.
>>=20
>=20
> In this particular case we are dealing with NPF and not SMAP fault per
> say.
>=20
> What typically has happened here is:
>=20
> - user space does the MMIO access which causes a fault
> - hardware processes this as a VMEXIT
> - during processing, hardware attempts to read the instruction bytes =
to
> provide decode assist. This is typically done by data read request =
from
> the RIP that the guest was at. While doing so, we may hit SMAP fault

How can a SMAP fault occur when CPL=3D=3D3? One of the conditions for =
SMAP is that CPL<3.

I think the confusion is that I believe a code mapped as user-accessible =
in page-tables but runs with CPL<3
should be the one which does the MMIO. Rather then code running in =
CPL=3D=3D3.

The sequence of events I imagine to trigger the Errata is as follows:
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

BTW, this also means that in order to trigger this, CR4.SMEP should be =
set to 0. As otherwise, instruction couldn=E2=80=99t have been executed =
to raise #NPF in the first place. Maybe we can add this as another =
condition to recognise the Errata?

-Liran

> because internally CPU is doing a data read from the RIP to get those
> instruction bytes. Since it hit the SMAP fault hence it was not able
> to decode the instruction to provide the insn_len. So we are first
> checking if it was a fault caused from CPL=3D=3D3 and SMAP is enabled.
> If so, we are hitting this errata and it can be workaround.
>=20
> -Brijesh
>=20
>=20
>=20

