Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774326AD35
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388165AbfGPQ4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:56:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47722 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388117AbfGPQ4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:56:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GGsGLT133169;
        Tue, 16 Jul 2019 16:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=pL4D4pNb/6nVzEODlTlauX/fHtTcE2s2zNVvaJvEa8I=;
 b=r4nbBDlMUrT7LLI9eN42SsEpxo1bQRF4C/CGSht4tNAPsXoFroCTkVe0Cao79qCcX/kh
 EuOE5mH+ReONxR6Ac1ZLGpy9ldTnQfsmNaOSXg7v/GIWF9kzDv8ZLhEafqs6goT/P3Td
 CbLqMEsigVCUHGoM8fXLBUqYGBMgu5AY234RoUCVJZo18pPOJReIPSexZk/Pv363Uz6Z
 BxxuUU65LZvGOW6KW6MJMhXzLORNrCgv0u++KVnGVfpG7x9RCnAPatxSEpHkcq2ylCgJ
 iv6HqQh1/J6U/SuqzgpGIWeyY2rssb9Gsz1vFkPLLDKKpQnkwvGY5U003RcaeRjvinEg Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2tq78pnrbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:56:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GGrNQP126556;
        Tue, 16 Jul 2019 16:56:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tq6mn0g75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 16:56:36 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GGuZsu007615;
        Tue, 16 Jul 2019 16:56:35 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 16:56:34 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190716164151.GC1987@linux.intel.com>
Date:   Tue, 16 Jul 2019 19:56:31 +0300
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=567
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=611 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160208
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 19:41, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Jul 16, 2019 at 07:20:42PM +0300, Liran Alon wrote:
>> How can a SMAP fault occur when CPL=3D=3D3? One of the conditions for =
SMAP is
>> that CPL<3.
>=20
> The CPU is effectively at CPL0 when it does the decode assist, e.g.:
>=20
>  1. CPL3 guest hits reserved bit NPT fault (MMIO access)
>  2. CPU transitions to CPL0 on VM-Exit
>  3. CPU performs data access on **%rip**, encounters SMAP violation
>  4. CPU squashes SMAP violation, sets VMCB.insn_len=3D0
>  5. CPU delivers VM-Exit to software for original NPT fault
>=20
> The original NPT fault is due to a reserved bit (or not present) entry =
for
> a MMIO GPA, *not* the GPA corresponding to %rip.  The fault on the =
decode
> assist is never delivered to software, it simply results in having =
invalid
> info in the VMCB's insn_bytes and insn_len fields.

If the CPU performs the VMExit transition of state before doing the data =
read for DecodeAssist,
then I agree that CPL will be 0 on data-access regardless of vCPU CPL. =
But this also means that SMAP
violation should be raised based on host CR4.SMAP value and not vCPU =
CR4.SMAP value as KVM code checks.

Furthermore, vCPU CPL of guest doesn=E2=80=99t need to be 3 in order to =
trigger this Errata.
It=E2=80=99s only important that guest page-tables maps the guest RIP as =
user-accessible. i.e. U/S bit in PTE set to 1.

So I=E2=80=99m still left a bit confused rather the correctness of KVM =
code handling this Errata.

-Liran


