Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFD41B4D9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 13:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbfEMLW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 07:22:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfEMLW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 07:22:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DBIv4I013955;
        Mon, 13 May 2019 11:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : in-reply-to :
 references : mime-version : content-type : content-transfer-encoding :
 subject : to : cc : from : message-id; s=corp-2018-07-02;
 bh=YyOD4R+cUGXHIvSrSrImL/iUliwHRMLQcY1no+yZlE8=;
 b=epSkvtG+LfqG1AYO/SzU26NLtvuTHGba2tGUjmx9xEhmtGHPUvzB2qprakEG7MKwk+AK
 ZFzX0dppkViQK6SOrfziMdQl7qowZtX004IPvUItMfcVBt9/OL3iNEA53owUuLtlOTVv
 kpax/yfFcqLNa1M5PTiW9L7EejNq4oy439Lgf5IV/HURg/FmUgdCPjbSADFsODr0epM6
 rIMWLUPqUXcjypSPh4oydd1yFjmkSJyKcBrK+y5sNSXTX/ebNHbRa6kTVepx9LtBdMmw
 Uz3bWb6MgFgNIEs+sv43ZWOmmxa2DA2Qtk79LG/NtgjMNAu+FhBUSY7Z3ahQ7Ie8dvQN Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sdq1q6429-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 11:22:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DBLcU0093252;
        Mon, 13 May 2019 11:22:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sdnqhw8vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 11:22:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DBMbCG027340;
        Mon, 13 May 2019 11:22:37 GMT
Received: from galaxy-s9.lan (/209.6.36.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 04:22:37 -0700
Date:   Mon, 13 May 2019 07:22:32 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1557740799-5792-1-git-send-email-wanpengli@tencent.com>
References: <1557740799-5792-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] KVM: X86: Enable IA32_MSIC_ENABLE MONITOR bit when exposing mwait/monitor
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <0F74F27F-2403-441D-8702-373BDA21E3A7@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130082
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On May 13, 2019 5:46:39 AM EDT, Wanpeng Li <kernellwp@gmail=2Ecom> wrote:
>From: Wanpeng Li <wanpengli@tencent=2Ecom>
>
>MSR IA32_MSIC_ENABLE bit 18, according to SDM:
>

 MSIC? (Also the $subject)


>| When this bit is set to 0, the MONITOR feature flag is not set
>(CPUID=2E01H:ECX[bit 3] =3D 0)=2E=20
> | This indicates that MONITOR/MWAIT are not supported=2E
> |=20
>| Software attempts to execute MONITOR/MWAIT will cause #UD when this
>bit is 0=2E
> |=20
>| When this bit is set to 1 (default), MONITOR/MWAIT are supported
>(CPUID=2E01H:ECX[bit 3] =3D 1)=2E=20
>
>This bit should be set to 1, if BIOS enables MONITOR/MWAIT support on
>host and=20
>we intend to expose mwait/monitor to the guest=2E
>
>Cc: Paolo Bonzini <pbonzini@redhat=2Ecom>
>Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat=2Ecom>
>Cc: Sean Christopherson <sean=2Ej=2Echristopherson@intel=2Ecom>
>Cc: Liran Alon <liran=2Ealon@oracle=2Ecom>
>Signed-off-by: Wanpeng Li <wanpengli@tencent=2Ecom>
>---
> arch/x86/kvm/x86=2Ec | 16 +++++++++-------
> 1 file changed, 9 insertions(+), 7 deletions(-)
>
>diff --git a/arch/x86/kvm/x86=2Ec b/arch/x86/kvm/x86=2Ec
>index 1d89cb9=2E=2E664449e 100644
>--- a/arch/x86/kvm/x86=2Ec
>+++ b/arch/x86/kvm/x86=2Ec
>@@ -2723,6 +2723,13 @@ static int get_msr_mce(struct kvm_vcpu *vcpu,
>u32 msr, u64 *pdata, bool host)
> 	return 0;
> }
>=20
>+static inline bool kvm_can_mwait_in_guest(void)
>+{
>+	return boot_cpu_has(X86_FEATURE_MWAIT) &&
>+		!boot_cpu_has_bug(X86_BUG_MONITOR) &&
>+		boot_cpu_has(X86_FEATURE_ARAT);
>+}
>+
>int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data
>*msr_info)
> {
> 	switch (msr_info->index) {
>@@ -2801,6 +2808,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu,
>struct msr_data *msr_info)
> 		msr_info->data =3D (u64)vcpu->arch=2Eia32_tsc_adjust_msr;
> 		break;
> 	case MSR_IA32_MISC_ENABLE:
>+		if (kvm_can_mwait_in_guest() && kvm_mwait_in_guest(vcpu->kvm))
>+			vcpu->arch=2Eia32_misc_enable_msr |=3D MSR_IA32_MISC_ENABLE_MWAIT;
> 		msr_info->data =3D vcpu->arch=2Eia32_misc_enable_msr;
> 		break;
> 	case MSR_IA32_SMBASE:
>@@ -2984,13 +2993,6 @@ static int msr_io(struct kvm_vcpu *vcpu, struct
>kvm_msrs __user *user_msrs,
> 	return r;
> }
>=20
>-static inline bool kvm_can_mwait_in_guest(void)
>-{
>-	return boot_cpu_has(X86_FEATURE_MWAIT) &&
>-		!boot_cpu_has_bug(X86_BUG_MONITOR) &&
>-		boot_cpu_has(X86_FEATURE_ARAT);
>-}
>-
> int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> {
> 	int r =3D 0;

