Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9879CDA1
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 12:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfHZKxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 06:53:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfHZKxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 06:53:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QAi7aj001375;
        Mon, 26 Aug 2019 10:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=Q6b26wkKpr6ij1s9q4AQE+RJMVAKYLHxBgAVfkQ8Ltk=;
 b=ra2lPCQMhCHeXq1pinUM3f+Kcl6cQklNgbdQxs92VhhLGKUuT/nPQNMPGE7b44cw6x9o
 gmYgO8OgWqyiubS1jMRktgRxf8Hv0RyryVYpPR79nwzyX9hBfQ/ebZYoUwc3ls6PyloJ
 ErE3WAGX91YHjK2X8+etl7rmublU42jF3FRRo9GZvVo+P7/nx1ZUeFqj7j8la6Vs5ooX
 nq8gRcEXlbJswsB/onmp5sB4CWVYrFdfY9zsgwUDZP0azCLLRynC6UBYPRAfAud9Rp9J
 kYPyfBEnjN9Pby5Dgzvs4YEqUsdq/Ge4nA/r++iU6b5jS/HjPVuR+TWVP/bVhRndOvbJ /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ujw7009vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:52:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QAmAlf167161;
        Mon, 26 Aug 2019 10:52:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ujw6hnhns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:52:50 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QAqnOT025977;
        Mon, 26 Aug 2019 10:52:49 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 03:52:49 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: x86: Return to userspace with internal error on
 unexpected exit reason
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <87wof0mc92.fsf@vitty.brq.redhat.com>
Date:   Mon, 26 Aug 2019 13:52:44 +0300
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5817677A-5DBC-48A5-8390-87DDC0B5840A@oracle.com>
References: <20190826101643.133750-1-liran.alon@oracle.com>
 <87wof0mc92.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 26 Aug 2019, at 13:50, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Liran Alon <liran.alon@oracle.com> writes:
>=20
>> Receiving an unexpected exit reason from hardware should be =
considered
>> as a severe bug in KVM. Therefore, instead of just injecting #UD to
>> guest and ignore it, exit to userspace on internal error so that
>> it could handle it properly (probably by terminating guest).
>=20
> While "this should never happen" on real hardware, it is a possible
> event for the case when KVM is running as a nested (L1)
> hypervisor. Misbehaving L0 can try to inject some weird (corrupted) =
exit
> reason.

True. :)
That=E2=80=99s true for any vCPU behaviour simulated by L0 to L1.

But in that case, I would prefer to terminate L2 guest instead of
injecting a bogus #UD to L2 guest...

>=20
>>=20
>> In addition, prefer to use vcpu_unimpl() instead of WARN_ONCE()
>> as handling unexpected exit reason should be a rare unexpected
>> event (that was expected to never happen) and we prefer to print
>> a message on it every time it occurs to guest.
>>=20
>> Furthermore, dump VMCS/VMCB to dmesg to assist diagnosing such cases.
>>=20
>> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
>> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
>> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>=20
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for the review,
-Liran

>=20
>> ---
>> arch/x86/kvm/svm.c       | 11 ++++++++---
>> arch/x86/kvm/vmx/vmx.c   |  9 +++++++--
>> include/uapi/linux/kvm.h |  2 ++
>> 3 files changed, 17 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index d685491fce4d..6462c386015d 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -5026,9 +5026,14 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>>=20
>> 	if (exit_code >=3D ARRAY_SIZE(svm_exit_handlers)
>> 	    || !svm_exit_handlers[exit_code]) {
>> -		WARN_ONCE(1, "svm: unexpected exit reason 0x%x\n", =
exit_code);
>> -		kvm_queue_exception(vcpu, UD_VECTOR);
>> -		return 1;
>> +		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", =
exit_code);
>> +		dump_vmcb(vcpu);
>> +		vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
>> +		vcpu->run->internal.suberror =3D
>> +			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>> +		vcpu->run->internal.ndata =3D 1;
>> +		vcpu->run->internal.data[0] =3D exit_code;
>> +		return 0;
>> 	}
>>=20
>> 	return svm_exit_handlers[exit_code](svm);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 42ed3faa6af8..b5b5b2e5dac5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5887,8 +5887,13 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
>> 	else {
>> 		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>> 				exit_reason);
>> -		kvm_queue_exception(vcpu, UD_VECTOR);
>> -		return 1;
>> +		dump_vmcs();
>> +		vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
>> +		vcpu->run->internal.suberror =3D
>> +			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>> +		vcpu->run->internal.ndata =3D 1;
>> +		vcpu->run->internal.data[0] =3D exit_reason;
>> +		return 0;
>> 	}
>> }
>>=20
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 5e3f12d5359e..42070aa5f4e6 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -243,6 +243,8 @@ struct kvm_hyperv_exit {
>> #define KVM_INTERNAL_ERROR_SIMUL_EX	2
>> /* Encounter unexpected vm-exit due to delivery event. */
>> #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
>> +/* Encounter unexpected vm-exit reason */
>> +#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>>=20
>> /* for KVM_RUN, returned by mmap(vcpu_fd, offset=3D0) */
>> struct kvm_run {
>=20
> --=20
> Vitaly

