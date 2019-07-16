Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30046ADC1
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 19:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388246AbfGPRgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 13:36:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38480 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGPRgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 13:36:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GHXcoL078133;
        Tue, 16 Jul 2019 17:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=2mElrphvMKxNoSqvZMtPGRqepiFkKg3RMUqph0Aywy4=;
 b=iwCVnmzcwr4b0cjiG27fVD+fZslTCsYpcfdLx9+61E6PmoLVGiRsfhTnuYbyhtqdCZmA
 tmL7jNU/lpJ2IxTLhmvxOhVd+gVN+13NFuwi+1LNAQbFsyWJ0GfGIA94jTQ3r8K0n7Nj
 B7S8ENmSzG6qOVL+2fYnW+8RJLnMHPmPnwOyfgjSXyZCiPCkW3LGE7cWNeCxT6dwGAuk
 WnFiFJKxGl35rDEGad+oCy7u+ZP9nsUDiC8nbLYV7tzTzHfM7kL/MZNdyE61GZqixkyd
 WC28JKMQISbNMZi5Z/sWECM6VQMjovYpyxFDDsd16j9ro95mXTQqRoHngxhhBfCN87Lm iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tq6qtp2h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 17:36:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GHWxiC133654;
        Tue, 16 Jul 2019 17:36:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tq4du29sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 17:36:01 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GHZvTG006048;
        Tue, 16 Jul 2019 17:35:58 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 17:35:57 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
Date:   Tue, 16 Jul 2019 20:35:54 +0300
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160216
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160216
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 20:27, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 16/07/19 18:56, Liran Alon wrote:
>> If the CPU performs the VMExit transition of state before doing the =
data read for DecodeAssist,
>> then I agree that CPL will be 0 on data-access regardless of vCPU =
CPL. But this also means that SMAP
>> violation should be raised based on host CR4.SMAP value and not vCPU =
CR4.SMAP value as KVM code checks.
>>=20
>> Furthermore, vCPU CPL of guest doesn=E2=80=99t need to be 3 in order =
to trigger this Errata.
>=20
> Under the conditions in the code, if CPL were <3 then the SMAP fault
> would have been sent to the guest.
> But I agree that if we need to
> change it to check host CR4, then the CPL of the guest should not be
> checked.

Yep.
Well it all depends on how AMD CPU actually works.
We need some clarification from AMD but for sure the current code in KVM =
is not only wrong, but probably have never been tested. :P

Looking for further clarifications from AMD before submitting v2=E2=80=A6

-Liran

>=20
> Paolo
>=20
>> It=E2=80=99s only important that guest page-tables maps the guest RIP =
as user-accessible. i.e. U/S bit in PTE set to 1.
>=20

