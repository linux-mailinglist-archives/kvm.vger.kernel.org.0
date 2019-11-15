Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCDFFD205
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 01:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKOAft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 19:35:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfKOAft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 19:35:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAF0OJvS189525;
        Fri, 15 Nov 2019 00:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=OM92G6+QhtOrbjNmBneGgXHLF/pVj3xj3ROAY4CXFBI=;
 b=meby9SNq/4SNsgmfTqR4UyKObKng6/DxL84dt7HSegHifCzwlM/IWeqpK/N7+8KNl746
 x4yYiUAU8nw39/zHPc68aIot51T8QGGauWOY+97r5Y0w5CcBrpwCbMW+9pqSSIVnkpra
 zcC7Lbuk1YSB8oY0Njw/+HVyjB1R8n9fEdPSiT2VY3lhJbwKGqjR082ZG/LoBLzCialN
 NVskILHo/PHow+lDBLH6DHR9dH3WJwziD4zzQH1BIZ2sGsL906qmtd0A80RmiR0bQe7R
 b9GEnxv/fGfUbpDp6eK0T4wUAeitZJCrtNGeKyk7AEKcKkjrNfZq3kAB4lqrhmBlFBWM 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w9gxpg440-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 00:35:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAF0TBA8006722;
        Fri, 15 Nov 2019 00:35:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w9h171hkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 00:35:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAF0ZjYh031201;
        Fri, 15 Nov 2019 00:35:45 GMT
Received: from [192.168.14.112] (/109.64.206.233)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 16:35:44 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: KVM_GET_MSR_INDEX_LIST vs KVM_GET_MSR_FEATURE_INDEX_LIST
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALMp9eRbSL+y6-LV8YSRpOBa+t0dnEG5=tc91EZy1_CZRvMYiw@mail.gmail.com>
Date:   Fri, 15 Nov 2019 02:35:42 +0200
Cc:     kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C9723F4E-01AA-4739-B93B-7F49477A15AF@oracle.com>
References: <CALMp9eTT6oJMibHh0OTXgj83LXmjGt7CQ22Tr6NM4NRB_bfA8Q@mail.gmail.com>
 <CB679B0C-00FF-400E-B760-4AC8641252AC@oracle.com>
 <CALMp9eRbSL+y6-LV8YSRpOBa+t0dnEG5=tc91EZy1_CZRvMYiw@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 15 Nov 2019, at 0:07, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Sat, Sep 8, 2018 at 5:58 PM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>> On 7 Sep 2018, at 21:37, Jim Mattson <jmattson@google.com> wrote:
>>>=20
>>> Are these two lists intended to be disjoint? Is it a bug that
>>> IA32_ARCH_CAPABILITIES appears in both?
>=20
> Here's a more basic question: Should any MSR that can be read and
> written by a guest appear in KVM_GET_MSR_INDEX_LIST? If not, what's
> the point of this ioctl?

I think the point of KVM_GET_MSR_INDEX_LIST ioctl is for userspace to =
know what are all the MSR values it needs to save/restore on migration.
Therefore, any MSR that is exposed to guest read/write and isn=E2=80=99t =
determined on VM provisioning time, should be returned from this ioctl.

In contrast, KVM_GET_MSR_FEATURE_INDEX_LIST ioctl is meant to be used by =
userspace to query KVM capabilities based on host MSRs and KVM support =
and use that information to validate the CPU features that the user have =
requested to expose to guest.

For example, MSR_IA32_UCODE_REV is specified only in =
KVM_GET_MSR_FEATURE_INDEX_LIST. This is because it is determined by =
userspace on provisioning time (No need to save/restore on migration) =
and userspace may require to know it=E2=80=99s host value to define =
guest value appropriately. MSR_IA32_PERF_STATUS is not specified in =
neither ioctls because KVM returns constant value for it (not required =
to be saved/restored).

However, I=E2=80=99m also not sure about above mentioned definitions=E2=80=
=A6 As they are some bizarre things that seems to contradict it:
1) MSR_IA32_ARCH_CAPABILITIES is specified in =
KVM_GET_MSR_FEATURE_INDEX_LIST to allow userspace to know which =
vulnerabilities apply to CPU. By default, vCPU =
MSR_IA32_ARCH_CAPABILITIES value will be set by host value (See =
kvm_arch_vcpu_setup()) but it=E2=80=99s possible for host userspace to =
override value exposed to guest (See kvm_set_msr_common()). *However*, =
it seems to me to be wrong that this MSR is specified in =
KVM_GET_MSR_INDEX_LIST as it should be determined in VM provisioning =
time and thus not need to be saved/restore on migration. i.e. How is it =
different from MSR_IA32_UCODE_REV?
2) MSR_EFER should be saved/restored and thus returned by =
KVM_GET_MSR_INDEX_LIST. But it=E2=80=99s not. Probably because it can be =
saved/restored via KVM_{GET,SET}_SREGS but this is inconsistent with =
semantic definitions of KVM_GET_MSR_INDEX_LIST ioctl...
3) MSR_AMD64_OSVW_ID_LENGTH & MSR_AMD64_OSVW_STATUS can be set by guest =
but it doesn=E2=80=99t seem to be specified in emulated_msrs[] and =
therefore not returned by KVM_GET_MSR_INDEX_LIST ioctl. I think this is =
a migration bug...

Unless someone disagrees, I think I will submit a patch for (1) and (3).

-Liran





