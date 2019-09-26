Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D6BF1DF
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 13:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfIZLk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 07:40:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49288 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfIZLk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 07:40:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QBdJRK118388;
        Thu, 26 Sep 2019 11:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=3ZDzS392YsOx3P3FXR8hI5rxh/lrDiequFKu9SGfspI=;
 b=HpTiezE6bMuX8zCjnOjoq7tPzxgSBfdM8GHrggwn8BJb1w9JlBeTr95cZNJszb5Kqrwe
 6pMTPfXyprtu6DrX7ldLH5UQdsXKOlzhrt1yBN1U0UtjxAJS1IfONisXxEzERomIIXNB
 zQkxQ1+8vEKdi69i8hhjQ+cxU4PRhbg7LINgOEMXGpg+nxyoaaOoLB4PGNvbvzULmNvt
 pyKujQlj3KDwl78uWYZTopsWDhrJsYVr8X3Xe/BGRNwzkps0QyeJtxQzNe3ithOzIlLB
 m4sluANeX4WmrIDmcc5zuzydANDVj7PDtxScXFWxuc0QAPhvvMvJ9l5Hgtj6IN6Ig6XK lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgrb06m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 11:40:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QBdOv0131034;
        Thu, 26 Sep 2019 11:40:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qc47ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 11:40:23 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8QBeMKu028999;
        Thu, 26 Sep 2019 11:40:23 GMT
Received: from [192.168.14.112] (/79.179.213.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 04:40:22 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v3] kvm: nvmx: limit atomic switch MSRs
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190917185057.224221-1-marcorr@google.com>
Date:   Thu, 26 Sep 2019 14:40:20 +0300
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8B36D2F5-470C-48E7-A53B-EC7E2AF4E1BF@oracle.com>
References: <20190917185057.224221-1-marcorr@google.com>
To:     Marc Orr <marcorr@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 17 Sep 2019, at 21:50, Marc Orr <marcorr@google.com> wrote:
>=20
> Allowing an unlimited number of MSRs to be specified via the VMX
> load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> reasons. First, a guest can specify an unreasonable number of MSRs,
> forcing KVM to process all of them in software. Second, the SDM bounds
> the number of MSRs allowed to be packed into the atomic switch MSR =
lists.
> Quoting the "Miscellaneous Data" section in the "VMX Capability
> Reporting Facility" appendix:
>=20
> "Bits 27:25 is used to compute the recommended maximum number of MSRs
> that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
> list, or the VM-entry MSR-load list. Specifically, if the value bits
> 27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
> maximum number of MSRs to be included in each list. If the limit is
> exceeded, undefined processor behavior may result (including a machine
> check during the VMX transition)."
>=20
> Because KVM needs to protect itself and can't model "undefined =
processor
> behavior", arbitrarily force a VM-entry to fail due to MSR loading =
when
> the MSR load list is too large. Similarly, trigger an abort during a =
VM
> exit that encounters an MSR load list or MSR store list that is too =
large.
>=20
> The MSR list size is intentionally not pre-checked so as to maintain
> compatibility with hardware inasmuch as possible.
>=20
> Test these new checks with the kvm-unit-test "x86: nvmx: test max =
atomic
> switch MSRs".
>=20
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> =E2=80=94

Reviewed-by: Liran Alon <liran.alon@oracle.com>


