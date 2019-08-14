Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBADE8CC29
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 09:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfHNHAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 03:00:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHNHAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 03:00:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7E6xCLV093441;
        Wed, 14 Aug 2019 07:00:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=YWCJXT19KfIhlvHyDiGaUoPIBhFKqzbrCOFwgJGFBwc=;
 b=AHTznshD3th01vDZnKEPwAl1mNy36z+hOH4JEkQ5uPMQZfQ5OAGnW0LNuTvTEmqdr42+
 RQrzGDgDPBpNGwJkddSjcI+mhweCDYrSzPZif3Df5qwAp6ueMP1n/BxetsqA/I9GSvaX
 ZHiW0qBAx/hDeqkvF/s4BTsLuBKdhYk1goOKL3HqFeu2cpBytSvSTVrIV3w75DkKawEi
 Iq8kq+licMWeHDFeO14zTY4jVpbrHLM4zjz2qrRNL4UFL0Jbt3jig5nF7Jk6jBC83cZS
 eKPrqwh5oVADNbJQGYLEGA+N3I2JD86JISXBNlua+ZX+rLthZR2WMXcSbeThJvITGtQb Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtjv2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 07:00:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7E6xO1N192122;
        Wed, 14 Aug 2019 07:00:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ubwrs9xs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 07:00:01 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7E7007W002024;
        Wed, 14 Aug 2019 07:00:00 GMT
Received: from [10.0.0.5] (/79.183.109.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 00:00:00 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH] KVM: nVMX: Check that HLT activity state is supported
From:   Nikita Leshenko <nikita.leshchenko@oracle.com>
In-Reply-To: <20190813143501.GA13991@linux.intel.com>
Date:   Wed, 14 Aug 2019 09:59:57 +0300
Cc:     kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AD04DDAB-9655-4B41-A9D8-95DA62767C11@oracle.com>
References: <20190813131303.137684-1-nikita.leshchenko@oracle.com>
 <20190813143501.GA13991@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908140066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908140066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 Aug 2019, at 17:35, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Aug 13, 2019 at 04:13:03PM +0300, Nikita Leshenko wrote:
>> Fail VM entry if GUEST_ACTIVITY_HLT is unsupported. According to "SDM =
A.6 -
>> Miscellaneous Data", VM entry should fail if the HLT activity is not =
marked as
>> supported on IA32_VMX_MISC MSR.
>>=20
>> Usermode might disable GUEST_ACTIVITY_HLT support in the vCPU with
>> vmx_restore_vmx_misc(). Before this commit VM entries would have =
succeeded
>> anyway.
>=20
> Is there a use case for disabling GUEST_ACTIVITY_HLT?  Or can we =
simply
> disallow writes to IA32_VMX_MISC that disable GUEST_ACTIVITY_HLT?

I don't have a specific case for disabling it. Disallowing turning it =
off in IA32_VMX_MISC
is also possible. Because of what you said below I will submit a =
different patch that does
so.

Nikita

>=20
> To disable GUEST_ACTIVITY_HLT, userspace also has to make
> CPU_BASED_HLT_EXITING a "must be 1" control, otherwise KVM will be
> presenting a bogus model to L1.
>=20
> The bad model is visible to L1 if CPU_BASED_HLT_EXITING is set by L0,
> i.e. KVM is running without kvm_hlt_in_guest(), and cleared by L1.  In
> that case, a HLT from L2 will be handled in L0.  L0 will set the state =
to
> KVM_MP_STATE_HALTED and report to L1 (on a nested VM-Exit, e.g. INTR),
> that the activity state is GUEST_ACTIVITY_HLT, which from L1's =
perspective
> doesn't exist.
>=20
>> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
>> ---
>> arch/x86/kvm/vmx/nested.c | 16 ++++++++++++----
>> arch/x86/kvm/vmx/nested.h |  5 +++++
>> 2 files changed, 17 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 46af3a5e9209..3165e2f7992f 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2656,11 +2656,19 @@ static int =
nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
>> /*
>>  * Checks related to Guest Non-register State
>>  */
>> -static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
>> +static int nested_check_guest_non_reg_state(struct kvm_vcpu *vcpu, =
struct vmcs12 *vmcs12)
>> {
>> -	if (vmcs12->guest_activity_state !=3D GUEST_ACTIVITY_ACTIVE &&
>> -	    vmcs12->guest_activity_state !=3D GUEST_ACTIVITY_HLT)
>> +	switch (vmcs12->guest_activity_state) {
>> +	case GUEST_ACTIVITY_ACTIVE:
>> +		/* Always supported */
>> +		break;
>> +	case GUEST_ACTIVITY_HLT:
>> +		if (!nested_cpu_has_activity_state_hlt(vcpu))
>> +			return -EINVAL;
>> +		break;
>> +	default:
>> 		return -EINVAL;
>> +	}
>>=20
>> 	return 0;
>> }
>> @@ -2710,7 +2718,7 @@ static int nested_vmx_check_guest_state(struct =
kvm_vcpu *vcpu,
>> 	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
>> 		return -EINVAL;
>>=20
>> -	if (nested_check_guest_non_reg_state(vmcs12))
>> +	if (nested_check_guest_non_reg_state(vcpu, vmcs12))
>> 		return -EINVAL;
>>=20
>> 	return 0;
>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>> index e847ff1019a2..4a294d3ff820 100644
>> --- a/arch/x86/kvm/vmx/nested.h
>> +++ b/arch/x86/kvm/vmx/nested.h
>> @@ -123,6 +123,11 @@ static inline bool =
nested_cpu_has_zero_length_injection(struct kvm_vcpu *vcpu)
>> 	return to_vmx(vcpu)->nested.msrs.misc_low & =
VMX_MISC_ZERO_LEN_INS;
>> }
>>=20
>> +static inline bool nested_cpu_has_activity_state_hlt(struct kvm_vcpu =
*vcpu)
>> +{
>> +	return to_vmx(vcpu)->nested.msrs.misc_low & =
VMX_MISC_ACTIVITY_HLT;
>> +}
>> +
>> static inline bool nested_cpu_supports_monitor_trap_flag(struct =
kvm_vcpu *vcpu)
>> {
>> 	return to_vmx(vcpu)->nested.msrs.procbased_ctls_high &
>> --=20
>> 2.20.1
>>=20

