Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8297B6B012
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfGPTuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:50:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36032 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbfGPTuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:50:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJnUhS084189;
        Tue, 16 Jul 2019 19:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=fGVX0iNdBSTKYACkEnFYFyiC4PoU/iZi/JPgHQjskf0=;
 b=3kRv4C9ddZpTj/e6U2+0yMTCr7Ov+d3kdC8iNVZZe7kofMq4+vgQuw4gRLXIggwYf6J5
 9qc6nnv9C4YmJHgE42eWKDWcsC3njvVLqQ8fU/37YgEtpcHdV5+je4fPiClemJeuL8qf
 VaUAJcgqdJIzh9nh4Gny1vcJ8wC1GWnxcxFkTjDl7sT6CMMBP9nn8FRGY9hcqi4QTX7k
 ot99n3IMOBLndCC4jLyhtj9rgd5dkxOnY2n/PJvRzFVe2kmRTkGWlA4eMgqOb1UxqYvg
 f1NzJGpwz4ai1OgDR1Sinq4ZItX1qoPOx9/vig7FKKVWmVUHdogdnfCV+7OvZBsh3fwf 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tq78ppk7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:50:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJmFWQ147561;
        Tue, 16 Jul 2019 19:50:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tq5bckny8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:50:17 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GJoFJt001928;
        Tue, 16 Jul 2019 19:50:16 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 19:50:15 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190716194535.GB28096@linux.intel.com>
Date:   Tue, 16 Jul 2019 22:50:11 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AAA25F54-FFB6-41F9-98A1-BC07E8B99288@oracle.com>
References: <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
 <3cdd12c4-c3fa-5157-1a91-69e333750152@redhat.com>
 <20190716194535.GB28096@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=671
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160242
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=716 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 22:45, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Jul 16, 2019 at 09:39:48PM +0200, Paolo Bonzini wrote:
>> On 16/07/19 21:34, Liran Alon wrote:
>>>> When this errata is hit, the CPU will be at CPL3. =46rom hardware
>>>> point-of-view the below sequence happens:
>>>>=20
>>>> 1. CPL3 guest hits reserved bit NPT fault (MMIO access)
>>> Why CPU needs to be at CPL3?
>>> The requirement for SMAP should be that this page is user-accessible =
in guest page-tables.
>>> Think on a case where guest have CR4.SMAP=3D1 and CR4.SMEP=3D0.
>>>=20
>>=20
>> If you are not at CPL3, you'd get a SMAP NPF, not a RSVD NPF.
>=20
> I think Liran is right.  When software is executing, the %rip access =
is
> a code fetch (SMEP), but the ucode assist is a data access (SMAP).
>=20
> This likely has only been observed in a CPL3 scenario because no sane =
OS
> exercises the case of the kernel executing from a user page with =
SMAP=3D1
> and SMEP=3D0.

True. I=E2=80=99m trying to be pedantic and accurate here. :)
I think we should just remove the vCPU CPL check and remain only with =
the CR4.SMAP check.
Don=E2=80=99t you agree that having a #NPF that returns 0 instruction =
bytes with DecodeAssist enabled and CR4.SMAP=3D1
is sufficient for finger-printing this Errata? With which other use-case =
it=E2=80=99s expected to collide?

-Liran=
