Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4037F6B010
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfGPTsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:48:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33772 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGPTsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:48:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJiFGT080300;
        Tue, 16 Jul 2019 19:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=qHSC46VnqcC759iu1dhOveQZX/PgWAQQWSOviCZKjJg=;
 b=PvwIFuJ1FT+F0kpPYu3aiaPKB03tcYX/noBPzty1Zib4IIFMcvEx1P7xajhUV7qeAXfP
 phPO2yAvaehoDnaEA6Xm6YlAH+18kMEu4ZLdfSxpTkML7Y7/Cdk48pQkNXTrxFn20OsU
 5ZEomvHgb09+jfQJMJXrxgYh9P7LdYxvJQ7GZBFBk1Oq3UKOo8O3y/k90tHgmDSdNyNA
 wGMvj9H1VCdCUjXeYVCKnB7IDvSmiKcIMaO5AUX6w6py+EqzPZW0gVt3Iw6C3WTsnBvF
 Z20vGdUv1BhSb9J1tH3pZCLgWcdJkCInt34HuKv8OqBoW3Y8lLgfa26KHsTo1gr5HEME LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tq78ppjwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:47:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GJgtMG167700;
        Tue, 16 Jul 2019 19:47:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tsctwee4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 19:47:52 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GJloW1000576;
        Tue, 16 Jul 2019 19:47:51 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 19:47:50 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <3cdd12c4-c3fa-5157-1a91-69e333750152@redhat.com>
Date:   Tue, 16 Jul 2019 22:47:46 +0300
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E73AA180-9D11-4F74-83B2-1EF021F0951A@oracle.com>
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
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
 <3cdd12c4-c3fa-5157-1a91-69e333750152@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=863
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160241
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=919 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160241
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 22:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 16/07/19 21:34, Liran Alon wrote:
>>> When this errata is hit, the CPU will be at CPL3. =46rom hardware
>>> point-of-view the below sequence happens:
>>>=20
>>> 1. CPL3 guest hits reserved bit NPT fault (MMIO access)
>> Why CPU needs to be at CPL3?
>> The requirement for SMAP should be that this page is user-accessible =
in guest page-tables.
>> Think on a case where guest have CR4.SMAP=3D1 and CR4.SMEP=3D0.
>>=20
>=20
> If you are not at CPL3, you'd get a SMAP NPF, not a RSVD NPF.

If CR4.SMEP=3D0, guest vCPU can execute a user-accessible page in guest =
page-tables with CPL<3.
This instruction will successfully execute and can cause by the data it =
references any type of #NPF. Including RSVD #NPF.
When hardware DecodeAssist microcode will attempt to read guest RIP =
though, it will get a SMAP violation because
data read is done by microcode with CPL<3 and is accessing =
user-accessible page.

Therefore, I still don=E2=80=99t think that guest vCPU CPL matters at =
all. Only whether code page is mapped in guest page-tables as =
user-accessible or not.

-Liran=20

>=20
> Paolo

