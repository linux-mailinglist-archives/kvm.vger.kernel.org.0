Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6598D65922
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfGKOhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:37:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49214 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfGKOhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:37:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEXPaO109047;
        Thu, 11 Jul 2019 14:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=meQva7YGms0tG4Q6QMMUtuF4lVynQfHfO/MQm1qhbKo=;
 b=bgaPR4zWJ3zc7EYKx49zn/FUF98Ysc6L1YzZgKVcc+TnCKSB6di8gQbEuY/O1GkpJ3zb
 Ab01dc12eHizmfoLT1pbAxDZtb33Q4XT8EEAd9MHi88Hbh/AXEGAcX/lBLJ5BpSbh1Lh
 e0uBF4KqigPPwy4Dws6ZMwNcsqLU7/rdcNewYhq+LMDJa8VGSM/CuW2+tSvp2FDyppcG
 BEym+xSm7Os0i5tha9uf9kIpc39U4Hpux4EOCS3Lz6LsrcH6v6dRK2b72nIWOU/TKJ5W
 Ktcy3KBckiKbWOYaoUSSjSo63XOpj6Lgp6rICFQ1G3Sbd8bKzC+o+8Y6Pe0St51G3QhL 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0e9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:36:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEWduD021651;
        Thu, 11 Jul 2019 14:36:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tmmh46kt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:36:22 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6BEaLPD027306;
        Thu, 11 Jul 2019 14:36:21 GMT
Received: from [192.168.14.112] (/109.66.236.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jul 2019 07:36:20 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [Qemu-devel] [PATCH 1/4] target/i386: kvm: Init nested-state for
 VMX when vCPU expose VMX
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <805d7eb5-e171-60bb-94c2-574180f5c44c@redhat.com>
Date:   Thu, 11 Jul 2019 17:36:17 +0300
Cc:     qemu-devel@nongnu.org, Joao Martins <joao.m.martins@oracle.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <901DE868-40A4-4668-8E10-D14B1E97BAE0@oracle.com>
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-2-liran.alon@oracle.com>
 <805d7eb5-e171-60bb-94c2-574180f5c44c@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907110164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Jul 2019, at 16:45, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 05/07/19 23:06, Liran Alon wrote:
>> -        if (IS_INTEL_CPU(env)) {
>> +        if (cpu_has_vmx(env)) {
>>             struct kvm_vmx_nested_state_hdr *vmx_hdr =3D
>>                 &env->nested_state->hdr.vmx;
>>=20
>=20
> I am not sure this is enough, because kvm_get_nested_state and =
kvm_put_nested_state would run anyway later.  If we want to cull them =
completely for a non-VMX virtual machine, I'd do something like this:
>=20
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 5035092..73ab102 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1748,14 +1748,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>     max_nested_state_len =3D kvm_max_nested_state_length();
>     if (max_nested_state_len > 0) {
>         assert(max_nested_state_len >=3D offsetof(struct =
kvm_nested_state, data));
> -        env->nested_state =3D g_malloc0(max_nested_state_len);
>=20
> -        env->nested_state->size =3D max_nested_state_len;
> -
> -        if (IS_INTEL_CPU(env)) {
> +        if (cpu_has_vmx(env)) {
>             struct kvm_vmx_nested_state_hdr *vmx_hdr =3D
>                 &env->nested_state->hdr.vmx;
>=20
> +            env->nested_state =3D g_malloc0(max_nested_state_len);
> +            env->nested_state->size =3D max_nested_state_len;
>             env->nested_state->format =3D KVM_STATE_NESTED_FORMAT_VMX;
>             vmx_hdr->vmxon_pa =3D -1ull;
>             vmx_hdr->vmcs12_pa =3D -1ull;
> @@ -3682,7 +3681,7 @@ static int kvm_put_nested_state(X86CPU *cpu)
>     CPUX86State *env =3D &cpu->env;
>     int max_nested_state_len =3D kvm_max_nested_state_length();
>=20
> -    if (max_nested_state_len <=3D 0) {
> +    if (!env->nested_state) {
>         return 0;
>     }
>=20
> @@ -3696,7 +3695,7 @@ static int kvm_get_nested_state(X86CPU *cpu)
>     int max_nested_state_len =3D kvm_max_nested_state_length();
>     int ret;
>=20
> -    if (max_nested_state_len <=3D 0) {
> +    if (!env->nested_state) {
>         return 0;
>     }
>=20
>=20
> What do you think?  (As a side effect, this completely disables
> KVM_GET/SET_NESTED_STATE on SVM, which I think is safer since it
> will have to save at least the NPT root and the paging mode.  So we
> could remove vmstate_svm_nested_state as well).
>=20
> Paolo

I like your suggestion better than my commit. It is indeed more elegant =
and correct. :)
The code change above looks good to me as nested_state_needed() will =
return false anyway if env->nested_state is false.
Will you submit a new patch or should I?

-Liran


