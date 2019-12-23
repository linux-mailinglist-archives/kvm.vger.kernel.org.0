Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FDF12995D
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 18:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLWR3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 12:29:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfLWR3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 12:29:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNHP2ZJ102801;
        Mon, 23 Dec 2019 17:28:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=moISOd56NtpVL8zRNki9zqtAXCaGXiRk1XLrhSHfLvs=;
 b=BBcyJOJPQagl7ysF/j32lf9kxfKEgIyXcZzjMPLh1GKqCzvsGEB/IRv74rJEBfHvhcHM
 ciQrU4F2pV1ZF7WpdnyEN2w6wnLPVVN0BcYJfvrLL23DwBqdjpQU524Gp6fNqQHEPFK6
 xRB9lGdneIDu3ooYOw+m7RSId6JgldxnOrfAb0obapR6Pc62nnjYQPLUXWuhnmoXU92p
 5eSRNm2pkn9NBHI+ilRjJ/uDtHJi0JXY2sXeTlJZSKJNMAlK66vaLLaW6ANs6W0ttx+7
 6LopLaf3rw2RXKz2pnbFEbNgra4RC7jDgvL5EjL8sYwaRn+8SRTc8ehv/65N/mjGXA+k cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x1bbpr09v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 17:28:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNHJNR1150573;
        Mon, 23 Dec 2019 17:28:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x1wh3ku86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 17:28:19 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBNHSINB031195;
        Mon, 23 Dec 2019 17:28:18 GMT
Received: from [192.168.14.112] (/109.64.214.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Dec 2019 09:28:18 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <15b57d6b-0f46-01f5-1f75-b9b55db0611a@redhat.com>
Date:   Mon, 23 Dec 2019 19:28:13 +0200
Cc:     John Andersen <john.s.andersen@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <03F5FE31-E769-4497-922B-C8613F0951FA@oracle.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
 <15b57d6b-0f46-01f5-1f75-b9b55db0611a@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9479 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912230147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9480 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912230148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Dec 2019, at 19:09, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 23/12/19 15:48, Liran Alon wrote:
>>> Should userspace expose the CR pining CPUID feature bit, it must =
zero CR
>>> pinned MSRs on reboot. If it does not, it runs the risk of having =
the
>>> guest enable pinning and subsequently cause general protection =
faults on
>>> next boot due to early boot code setting control registers to values
>>> which do not contain the pinned bits.
>>=20
>> Why reset CR pinned MSRs by userspace instead of KVM INIT handling?
>=20
> Most MSRs are not reset by INIT, are they?
>=20
> Paolo
>=20

MSR_KVM_SYSTEM_TIME saved in vcpu->arch.time is reset at =
kvmclock_reset() which is called by kvm_vcpu_reset() (KVM INIT handler).
In addition, vmx_vcpu_reset(), called from kvm_vcpu_reset(), also resets =
multiple MSRs such as: MSR_IA32_SPEC_CTRL (vmx->spec_ctrl) and =
MSR_IA32_UMWAIT_CONTROL (msr_ia32_umwait_control).

Having said that, I see indeed that most of MSRs are being set by QEMU =
in kvm_put_msrs() when level >=3D KVM_PUT_RESET_STATE.
When is triggered by qemu_system_reset() -> =
cpu_synchronize_all_post_reset -> cpu_synchronize_post_reset() -> =
kvm_cpu_synchronize_post_reset().

So given current design, OK I agree with you that CR pinned MSRs should =
be zeroed by userspace VMM.

It does though seems kinda weird to me that part of CPU state is =
initialised on KVM INIT handler and part of it in userspace VMM.
It could lead to inconsistent (i.e. diverging from spec) CPU behaviour.

-Liran=
