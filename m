Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E9A4CF39
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 15:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfFTNoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 09:44:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFTNoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 09:44:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KDdcgd010527;
        Thu, 20 Jun 2019 13:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=9HdU2U+stuqNpmsAAx7ml3U2tP+4IG26hVrZ9/sPtWo=;
 b=P1iLvrOaBJEqAu9JdjXXyInm51Dlz4E00eAd8Z8qltDetyhWxGTI2YjCGD+DE4JPsYGJ
 B+MeJZf6/LsUXGs8e1VImGiKQtqScJr9XSh6QuWdORA0nxLTGo1TIzqIdQZee36btGem
 krCYMxbAD3AZcKPbQma82sGq+cjx2EGgYYVQbs7w4gNt89QKV9/rtaukldXvUGQsCQfd
 jt1W6RcrluerZ8T7Zet81Sr24/ygxL49ki2ipnb+2G2A/dBTd3ihnlKkLygT2SEUFCoV
 nwpmuEpysTiqxduDGN3fuiz1XlLqP95Y+8DoqYCfKDeSu6JI2twVv43FVVZTijYnJP7G wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t7809h6jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 13:42:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KDdHss071465;
        Thu, 20 Jun 2019 13:40:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t7rdx601n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 13:40:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KDen9l023209;
        Thu, 20 Jun 2019 13:40:49 GMT
Received: from [192.168.14.112] (/109.64.216.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 06:40:34 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [Qemu-devel] [QEMU PATCH v4 0/10]: target/i386: kvm: Add support
 for save and restore of nested state
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <D804B7FE-EB38-4D3E-A251-C69CC979D383@oracle.com>
Date:   Thu, 20 Jun 2019 16:40:30 +0300
Cc:     qemu-devel@nongnu.org, ehabkost@redhat.com, kvm@vger.kernel.org,
        maran.wilson@oracle.com, mtosatti@redhat.com, dgilbert@redhat.com,
        rth@twiddle.net, jmattson@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <04A2B953-177F-4EA3-98E0-0D141C97FCF4@oracle.com>
References: <20190619162140.133674-1-liran.alon@oracle.com>
 <bcb617b1-7d20-d2ff-81c5-9f165eae5683@redhat.com>
 <D804B7FE-EB38-4D3E-A251-C69CC979D383@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 20 Jun 2019, at 16:28, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 20 Jun 2019, at 15:38, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>=20
>> On 19/06/19 18:21, Liran Alon wrote:
>>> Hi,
>>>=20
>>> This series aims to add support for QEMU to be able to migrate VMs =
that
>>> are running nested hypervisors. In order to do so, it utilizes the =
new
>>> IOCTLs introduced in KVM commit 8fcc4b5923af ("kvm: nVMX: Introduce
>>> KVM_CAP_NESTED_STATE") which was created for this purpose.
>>=20
>> Applied with just three minor changes that should be uncontroversial:
>=20
> ACK. Where can I see the applied patches for review?
>=20
>>=20
>>> 6rd patch updates linux-headers to have updated struct =
kvm_nested_state.
>>> The updated struct now have explicit fields for the data portion.
>>=20
>> Changed patch title to "linux-headers: sync with latest KVM headers =
from
>> Linux 5.2=E2=80=9D
>=20
> ACK.
>=20
>>=20
>>> 7rd patch add vmstate support for saving/restoring kernel integer =
types (e.g. __u16).
>>>=20
>>> 8th patch adds support for saving and restoring nested state in =
order to migrate
>>> guests which run a nested hypervisor.
>>=20
>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> index e924663f32..f3cf6e1b27 100644
>> --- a/target/i386/kvm.c
>> +++ b/target/i386/kvm.c
>> @@ -1671,10 +1671,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>            struct kvm_vmx_nested_state_hdr *vmx_hdr =3D
>>                &env->nested_state->hdr.vmx;
>>=20
>> +            env->nested_state->format =3D =
KVM_STATE_NESTED_FORMAT_VMX;
>>            vmx_hdr->vmxon_pa =3D -1ull;
>>            vmx_hdr->vmcs12_pa =3D -1ull;
>>        }
>> -
>>    }
>>=20
>>    cpu->kvm_msr_buf =3D g_malloc0(MSR_BUF_SIZE);
>>=20
>> which is a no-op since KVM_STATE_NESTED_FORMAT_VMX is zero, but it's =
tidy.
>=20
> I agree. My bad. Thanks for adding this :)

Actually, I think it makes more sense to condition here on =
cpu_has_vmx(env) instead of IS_INTEL_CPU(env).
And also add an =E2=80=9Celse if (cpu_has_svm(env))=E2=80=9D that sets =
env->nested_state->format to KVM_STATE_NESTED_FORMAT_SVM.
If you can change that when applying. :)

-Liran

>=20
>>=20
>>> 9th patch add support for KVM_CAP_EXCEPTION_PAYLOAD. This new KVM =
capability
>>> allows userspace to properly distingiush between pending and =
injecting exceptions.
>>>=20
>>> 10th patch changes the nested virtualization migration blocker to =
only
>>> be added when kernel lack support for one of the capabilities =
required
>>> for correct nested migration. i.e. Either KVM_CAP_NESTED_STATE or
>>> KVM_CAP_EXCEPTION_PAYLOAD.
>>=20
>> Had to disable this for SVM unfortunately.
>=20
> For backwards compatibility I assume=E2=80=A6 Sounds reasonable to me =
so ACK.
>=20
> Even though I must say I would really like to hear your opinion about =
the thread I had with David Gilbert regarding QEMU=E2=80=99s migration =
backwards compatibility:
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.mail-2Darchive.=
com_qemu-2Ddevel-40nongnu.org_msg622274.html&d=3DDwIFaQ&c=3DRoP1YumCXCgaWH=
vlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbp=
Tx0&m=3DaPCucPqkbmosKyDNeWq6rNNJ4Ry4GCh4HlxnZcQvAS8&s=3DZnEgQlntxSZ2cZf9nn=
qJa74vM3cq_yPUlTEL1pwVpUs&e=3D
>=20
> Thanks for the assistance pushing this forward,
> -Liran
>=20
>=20

