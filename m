Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B7DFD271
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 02:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKOB1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 20:27:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKOB1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 20:27:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAF1ODT0032931;
        Fri, 15 Nov 2019 01:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=Nlz0RFMqI5VfmWTDtDRv9BsTOZNBMUAsYpkdP8gnNdQ=;
 b=I86C86pghjbP7FmpwnjcjLYJVxi5F2BOxYPSub5oQD4uWYxynVNLsxIZYEiB171u/8mv
 bHOraORAG3+GKigKjk8hobl/3iG+MdJk9yGsosZ31X/bNQTIyOO5Y+HwZP/pMx5uhdt5
 T3jJFilqrszeB2NRCHcDectfPBXEF0TeG1hF4YLgtqEg0s5SmV32fWNGtQSbTxP1ZII3
 pFXj6H9VgDEk/p6UmrAJdFBSVcCPmjg1sSg5j/zLHvzUYPYERwpxq0TD0+9qdp90ApHs
 A325RAwKfiGXvGFW37K8iM4SoTWiaMXnvXuuyMAJ5pEgWZesmWU4f2ywBwaBE19SszwL Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w9gxpg87b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 01:27:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAF1Ns53132468;
        Fri, 15 Nov 2019 01:27:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w9h173jkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 01:27:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAF1RVG2024515;
        Fri, 15 Nov 2019 01:27:31 GMT
Received: from [192.168.14.112] (/109.64.206.233)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 17:27:31 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: KVM_GET_MSR_INDEX_LIST vs KVM_GET_MSR_FEATURE_INDEX_LIST
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <F2E6BF05-7C82-4F07-9AF4-0A722102D87A@oracle.com>
Date:   Fri, 15 Nov 2019 03:27:28 +0200
Cc:     kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B0ED74B0-BA88-4552-907C-4A7C4A1F4571@oracle.com>
References: <CALMp9eTT6oJMibHh0OTXgj83LXmjGt7CQ22Tr6NM4NRB_bfA8Q@mail.gmail.com>
 <CB679B0C-00FF-400E-B760-4AC8641252AC@oracle.com>
 <CALMp9eRbSL+y6-LV8YSRpOBa+t0dnEG5=tc91EZy1_CZRvMYiw@mail.gmail.com>
 <C9723F4E-01AA-4739-B93B-7F49477A15AF@oracle.com>
 <CALMp9eSdm9cQamj3mMiyQHL1W+FXZ497AH_hZecmeHowjJoUxg@mail.gmail.com>
 <F2E6BF05-7C82-4F07-9AF4-0A722102D87A@oracle.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150008
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 15 Nov 2019, at 3:14, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 15 Nov 2019, at 3:05, Jim Mattson <jmattson@google.com> wrote:
>>=20
>> On Thu, Nov 14, 2019 at 4:35 PM Liran Alon <liran.alon@oracle.com> =
wrote:
>>>=20
>>>=20
>>>=20
>>>> On 15 Nov 2019, at 0:07, Jim Mattson <jmattson@google.com> wrote:
>>>>=20
>>>> On Sat, Sep 8, 2018 at 5:58 PM Liran Alon <liran.alon@oracle.com> =
wrote:
>>>>>=20
>>>>>=20
>>>>>> On 7 Sep 2018, at 21:37, Jim Mattson <jmattson@google.com> wrote:
>>>>>>=20
>>>>>> Are these two lists intended to be disjoint? Is it a bug that
>>>>>> IA32_ARCH_CAPABILITIES appears in both?
>>>>=20
>>>> Here's a more basic question: Should any MSR that can be read and
>>>> written by a guest appear in KVM_GET_MSR_INDEX_LIST? If not, what's
>>>> the point of this ioctl?
>>>=20
>>> I think the point of KVM_GET_MSR_INDEX_LIST ioctl is for userspace =
to know what are all the MSR values it needs to save/restore on =
migration.
>>> Therefore, any MSR that is exposed to guest read/write and isn=E2=80=99=
t determined on VM provisioning time, should be returned from this =
ioctl.
>>>=20
>>> In contrast, KVM_GET_MSR_FEATURE_INDEX_LIST ioctl is meant to be =
used by userspace to query KVM capabilities based on host MSRs and KVM =
support and use that information to validate the CPU features that the =
user have requested to expose to guest.
>>>=20
>>> For example, MSR_IA32_UCODE_REV is specified only in =
KVM_GET_MSR_FEATURE_INDEX_LIST. This is because it is determined by =
userspace on provisioning time (No need to save/restore on migration) =
and userspace may require to know it=E2=80=99s host value to define =
guest value appropriately. MSR_IA32_PERF_STATUS is not specified in =
neither ioctls because KVM returns constant value for it (not required =
to be saved/restored).
>>>=20
>>> However, I=E2=80=99m also not sure about above mentioned =
definitions=E2=80=A6 As they are some bizarre things that seems to =
contradict it:
>>> 1) MSR_IA32_ARCH_CAPABILITIES is specified in =
KVM_GET_MSR_FEATURE_INDEX_LIST to allow userspace to know which =
vulnerabilities apply to CPU. By default, vCPU =
MSR_IA32_ARCH_CAPABILITIES value will be set by host value (See =
kvm_arch_vcpu_setup()) but it=E2=80=99s possible for host userspace to =
override value exposed to guest (See kvm_set_msr_common()). *However*, =
it seems to me to be wrong that this MSR is specified in =
KVM_GET_MSR_INDEX_LIST as it should be determined in VM provisioning =
time and thus not need to be saved/restore on migration. i.e. How is it =
different from MSR_IA32_UCODE_REV?
>>> 2) MSR_EFER should be saved/restored and thus returned by =
KVM_GET_MSR_INDEX_LIST. But it=E2=80=99s not. Probably because it can be =
saved/restored via KVM_{GET,SET}_SREGS but this is inconsistent with =
semantic definitions of KVM_GET_MSR_INDEX_LIST ioctl...
>>> 3) MSR_AMD64_OSVW_ID_LENGTH & MSR_AMD64_OSVW_STATUS can be set by =
guest but it doesn=E2=80=99t seem to be specified in emulated_msrs[] and =
therefore not returned by KVM_GET_MSR_INDEX_LIST ioctl. I think this is =
a migration bug...
>>>=20
>>> Unless someone disagrees, I think I will submit a patch for (1) and =
(3).
>>=20
>> I assume that we're also skipping the x2APIC MSRs because they can be
>> read/modified with KVM_{GET,SET}_LAPIC. At least until you start
>> thinking about userspace instruction emulation.
>=20
> Probably...
>=20
>>=20
>> What about MSR_F15H_PERF_*, MSR_K7_EVNTSEL*, MSR_K7_PERFCTR*,
>> MSR_MTRR*, HV_X64_MSR_STIMER[12]_CONFIG,
>> HV_X64_MSR_STIMER[0123]_COUNT, MSR_VM_CR, and possibly others I'm
>> missing on the first pass?
>=20
> LOL, yes all of the above seem to be right...
> This is indeed extremely error-prone. :\
>=20
> -Liran
>=20

BTW=E2=80=A6 Looking at QEMU code, one can see the following:
* If kvm_get_supported_msrs(), which invoke KVM_GET_MSR_INDEX_LIST, sees =
HV_X64_MSR_STIMER0_CONFIG returned, it signals a flag to QEMU that also =
all the rest of HV_X86_MSR_STIMER[0123] exists and needs to be =
saved/restored.
* Similarly, MSR_MTRR* are saved/restored in case guest is exposed with =
MTRR in CPUID[1].EDX. Regardless of KVM_GET_MSR_INDEX_LIST ioctl.

These all seem to be rather arbitrary decisions and I agree with your =
observation that it seems that these IOCTLs interface semantics are not =
well-defined or abused.

Paolo, what do you think?
Should we submit patches to fix above mentioned issues in KVM and =
clarify IOCTLs documentation? Should we change the interface?

-Liran





