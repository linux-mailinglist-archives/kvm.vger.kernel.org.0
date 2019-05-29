Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB542DD11
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 14:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfE2M3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 08:29:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfE2M3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 08:29:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TCJCj6092062;
        Wed, 29 May 2019 12:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=jzu0gfRpeQr3lgZAMVrA/Jz6k5UK87AqDwjxA5c2LmQ=;
 b=1vaQKuyIXrl4Lavh2BCp1tqrAF5BiatSmm4JFgYdlAeaRhTGPPUaf3Al+g+zR7NbxlqK
 Ea4ZZTz3z2ZRpQL6BAb2F6J30EgBEYuj5W2Z/5xCrGRBvgLaMPRUG++Ahdp1Tujrmm0c
 bXxxEF8qIis/FR0ag9z3oxi5udUbhXMTwHi9C5w9fgDUpjf+f04UDTynvD+H+CWMJj6D
 UyLW9a4MrJ/L37GccUfCmwfKy6UUCFG6g6L+mJZe3r1vsgd+kBX6okbilh4tyIBMIvE6
 rIKcMi4n+6PFkSBnKb4m8wmvr2auITqsV6z888wn1Q7OiOrcTmTHOBWhrloUAZqHaBUA yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2spw4thb42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 12:28:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TCRqcG188755;
        Wed, 29 May 2019 12:28:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2srbdxc11q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 12:28:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TCSdpR030656;
        Wed, 29 May 2019 12:28:39 GMT
Received: from [192.168.14.112] (/79.183.226.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 05:28:39 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 2/3] KVM: X86: Implement PV sched yield hypercall
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
Date:   Wed, 29 May 2019 15:28:35 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D119BC9B-3097-4453-BC17-5AE532EDB995@oracle.com>
References: <1559004795-19927-1-git-send-email-wanpengli@tencent.com>
 <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 28 May 2019, at 3:53, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> From: Wanpeng Li <wanpengli@tencent.com>
>=20
> The target vCPUs are in runnable state after vcpu_kick and suitable=20
> as a yield target. This patch implements the sched yield hypercall.
>=20
> 17% performace increase of ebizzy benchmark can be observed in an=20
> over-subscribe environment. (w/ kvm-pv-tlb disabled, testing TLB flush=20=

> call-function IPI-many since call-function is not easy to be trigged=20=

> by userspace workload).
>=20
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> arch/x86/kvm/x86.c | 24 ++++++++++++++++++++++++
> 1 file changed, 24 insertions(+)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e7e57de..2ceef51 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7172,6 +7172,26 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu =
*vcpu)
> 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
> }
>=20
> +void kvm_sched_yield(struct kvm *kvm, u64 dest_id)
> +{
> +	struct kvm_vcpu *target;
> +	struct kvm_apic_map *map;
> +
> +	rcu_read_lock();
> +	map =3D rcu_dereference(kvm->arch.apic_map);
> +
> +	if (unlikely(!map))
> +		goto out;
> +

We should have a bounds-check here on =E2=80=9Cdest_id=E2=80=9D.

-Liran

> +	if (map->phys_map[dest_id]->vcpu) {
> +		target =3D map->phys_map[dest_id]->vcpu;
> +		kvm_vcpu_yield_to(target);
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +}
> +
> int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> {
> 	unsigned long nr, a0, a1, a2, a3, ret;
> @@ -7218,6 +7238,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu =
*vcpu)
> 	case KVM_HC_SEND_IPI:
> 		ret =3D kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, =
op_64_bit);
> 		break;
> +	case KVM_HC_SCHED_YIELD:
> +		kvm_sched_yield(vcpu->kvm, a0);
> +		ret =3D 0;
> +		break;
> 	default:
> 		ret =3D -KVM_ENOSYS;
> 		break;
> --=20
> 2.7.4
>=20

