Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F5AF235B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 01:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfKGAgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 19:36:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbfKGAgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 19:36:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA70XmLZ131648;
        Thu, 7 Nov 2019 00:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=/oKCMKfvPzOJzc8QUUfKkfYEpTjNXN7U/axW5QYOT58=;
 b=A4Dzt295TWpRD0xS1J10wX2FANkfovceu9i7FtaV//luiI2fzkeqCvKQe3WMbFOddAFk
 mR3iotDPFmgjFX5iNvlpVUJoKE5+VFSwsWPk0SFzHb8OBn5X+s5c2pppCsUAuB0nzqLY
 R7sKDfaNXrfYcqboVxyV/Jn2QokYjiqj3eLewlE99eupXyddsazCf1lCkxtGVmDnzxBG
 Lty/TUMgHxZS4D4/Y/KD75PylCZIstMDk6uEsODtLwIq6fWN80gdQolXUSVJHMlJ4F2y
 PvNf3ZAQV6m15dU1ly5wfwFWroI4lVPZjWP59r3zpv5xZ0RpLIfVbomXhfQNKP8W9Htw UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w0thqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 00:35:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA70XrD5067631;
        Thu, 7 Nov 2019 00:35:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w41w8c321-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 00:35:47 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA70Zk6B020623;
        Thu, 7 Nov 2019 00:35:46 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 16:35:45 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 3/4] kvm: vmx: Rename function find_msr() to
 vmx_find_msr_index()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALMp9eQ30WP1nxA5RsK0DzUXOzwsbEHCK8ek4sYuR04sEph5Rg@mail.gmail.com>
Date:   Thu, 7 Nov 2019 02:35:42 +0200
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5A103F65-CF4A-4C4D-B7E6-0CD2E78EC256@oracle.com>
References: <20191105191910.56505-1-aaronlewis@google.com>
 <20191105191910.56505-4-aaronlewis@google.com>
 <3BEC7F65-1EE2-446F-9AC2-15FB4ED342B0@oracle.com>
 <CALMp9eQ30WP1nxA5RsK0DzUXOzwsbEHCK8ek4sYuR04sEph5Rg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070004
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 7 Nov 2019, at 2:11, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Tue, Nov 5, 2019 at 1:31 PM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>=20
>>> On 5 Nov 2019, at 21:19, Aaron Lewis <aaronlewis@google.com> wrote:
>>>=20
>>> Rename function find_msr() to vmx_find_msr_index() to share
>>> implementations between vmx.c and nested.c in an upcoming change.
>>>=20
>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>> ---
>>> arch/x86/kvm/vmx/vmx.c | 10 +++++-----
>>> arch/x86/kvm/vmx/vmx.h |  1 +
>>> 2 files changed, 6 insertions(+), 5 deletions(-)
>>>=20
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index c0160ca9ddba..39c701730297 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -835,7 +835,7 @@ static void =
clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>>>      vm_exit_controls_clearbit(vmx, exit);
>>> }
>>>=20
>>> -static int find_msr(struct vmx_msrs *m, unsigned int msr)
>>> +int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
>>=20
>> The change from static to non-static should happen in the next patch =
instead of this rename patch.
>> Otherwise, if the next patch is reverted, compiling vmx.c will result =
in a warning.
>=20
> What warning are you anticipating?

Sorry right this doesn=E2=80=99t produce a warning.
However, comment still stands that function should change from static to =
non-static only once it=E2=80=99s needed outside of source file.
Which happens on next patch. Just as a good practice.

>=20
>> The rest of the patch looks fine.
>>=20
>> -Liran
>>=20
>>> {
>>>      unsigned int i;
>>>=20
>>> @@ -869,7 +869,7 @@ static void clear_atomic_switch_msr(struct =
vcpu_vmx *vmx, unsigned msr)
>>>              }
>>>              break;
>>>      }
>>> -     i =3D find_msr(&m->guest, msr);
>>> +     i =3D vmx_find_msr_index(&m->guest, msr);
>>>      if (i < 0)
>>>              goto skip_guest;
>>>      --m->guest.nr;
>>> @@ -877,7 +877,7 @@ static void clear_atomic_switch_msr(struct =
vcpu_vmx *vmx, unsigned msr)
>>>      vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
>>>=20
>>> skip_guest:
>>> -     i =3D find_msr(&m->host, msr);
>>> +     i =3D vmx_find_msr_index(&m->host, msr);
>>>      if (i < 0)
>>>              return;
>>>=20
>>> @@ -936,9 +936,9 @@ static void add_atomic_switch_msr(struct =
vcpu_vmx *vmx, unsigned msr,
>>>              wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
>>>      }
>>>=20
>>> -     i =3D find_msr(&m->guest, msr);
>>> +     i =3D vmx_find_msr_index(&m->guest, msr);
>>>      if (!entry_only)
>>> -             j =3D find_msr(&m->host, msr);
>>> +             j =3D vmx_find_msr_index(&m->host, msr);
>>>=20
>>>      if ((i < 0 && m->guest.nr =3D=3D NR_MSR_ENTRIES) ||
>>>              (j < 0 &&  m->host.nr =3D=3D NR_MSR_ENTRIES)) {
>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>> index 0c6835bd6945..34b5fef603d8 100644
>>> --- a/arch/x86/kvm/vmx/vmx.h
>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>> @@ -334,6 +334,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu =
*vcpu);
>>> struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 =
msr);
>>> void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
>>> void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long =
host_rsp);
>>> +int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
>>>=20
>>> #define POSTED_INTR_ON  0
>>> #define POSTED_INTR_SN  1
>>> --
>>> 2.24.0.rc1.363.gb1bccd3e3d-goog
>>>=20
>>=20

