Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3AD6B167
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 23:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbfGPVyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 17:54:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfGPVyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 17:54:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GL9Zrk058061;
        Tue, 16 Jul 2019 21:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=yDuVVohGdSRuWFhR5KpUOW2mednw+htZPQtBX8NGfTk=;
 b=y8X4V82nR1vsCcGcCSAqeOREkbWvYbv+w7ek6OrmiuhvI/MfRF6rAsBw0iyMy/xThQtw
 P74jdRrruMKXLD61uGKxvfOWjDWuJae7CK7cokgHGqUwhYiCalhfT/TDJQeQGE2BOU1k
 x8oxbs0erJzBVDusGCbg5i5iRAItyWPUWj310YwsiEYdNH8OK1Hn74ThXSAdnCIjSvSs
 8FyRHKrVZgFG93HsmP6zj2X/IwU1fMci8zQ51Qj9H5F5wp/4FON3hBpApwxHQtwtsviH
 2SpvxW1DNJNb/DmiBoq2MUg2M7hpBzHrK4IiOC9Aj6C6ACsvmLE0E80L6yXclOPdvUmJ 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tq6qtq648-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 21:54:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GL8MWT085957;
        Tue, 16 Jul 2019 21:54:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tsmcc25ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 21:54:00 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GLrx2R026778;
        Tue, 16 Jul 2019 21:53:59 GMT
Received: from [192.168.14.112] (/109.65.220.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 21:53:59 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190716205427.GD28096@linux.intel.com>
Date:   Wed, 17 Jul 2019 00:53:55 +0300
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8E46D1A6-12AE-441B-B5EF-566381733106@oracle.com>
References: <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
 <31926848-2cf3-caca-335d-5f3e32a25cd3@amd.com>
 <AAAE41B2-C920-46E5-A171-46428E53FB20@oracle.com>
 <17d102bd-74ef-64f8-0237-3a49d64ea344@amd.com>
 <20190716205427.GD28096@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=647
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160259
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=691 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160259
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 23:54, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Jul 16, 2019 at 08:27:12PM +0000, Singh, Brijesh wrote:
>>=20
>> On 7/16/19 3:09 PM, Liran Alon wrote:
>>>>=20
>>>> We are discussing reserved NPF so we need to be at CPL3.
>>>=20
>>> I don=E2=80=99t see the connection between a reserved #NPF and the =
need to be at
>>> CPL3.  A vCPU can execute at CPL<3 a page that is mapped =
user-accessible in
>>> guest page-tables in case CR4.SMEP=3D0 and then instruction will =
execute
>>> successfully and can dereference a page that is mapped in NPT using =
an
>>> entry with a reserved bit set.  Thus, reserved #NPF will be raised =
while
>>> vCPU is at CPL<3 and DecodeAssist microcode will still raise SMAP =
violation
>>> as CR4.SMAP=3D1 and microcode perform data-fetch with CPL<3. This =
leading
>>> exactly to Errata condition as far as I understand.
>>>=20
>>=20
>> Yes, vCPU at CPL<3 can raise the SMAP violation. When SMEP is =
disabled,
>> the guest kernel never should be executing from code in user-mode =
pages,
>> that'd be insecure. So I am not sure if kernel code can cause this
>> errata.
>=20
> =46rom KVM's perspective, it's not a question of what is *likely* to =
happen
> so much as it's a question of what *can* happen.  Architecturally =
there is
> nothing that prevents CPL<3 code from encountering the SMAP fault.

Exactly. :)
I will submit a v2 patch which also clarifies the details we understood =
in this email thread.

Thanks,
-Liran

