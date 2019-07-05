Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7553B60609
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 14:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfGEMiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 08:38:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43556 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbfGEMiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 08:38:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65CYv72145639;
        Fri, 5 Jul 2019 12:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=hDZS8NepIVBu8bg1NY03gacxVRGi0CbKxoDzNFuSWc0=;
 b=uCyHlwcaZRUfA/NANNfyBMUlW/oA94JLegRRn+EdBeZWQdOKB502ZuXkKPwtHzqE06Hw
 LoZ5AWM8SckPFtOUgWP6BEUGVY1M5H45M83OQPfqU5e/iic3LVX2/jvCQyJOSUuUDX/K
 l5T9dqrzSEyD7KIhxTQxQEu5LXBFfHEdXbQDnDPJneznmWf4U3zTOVvQEpELFn+tkDxw
 7bTb26XfJllOMY8jSE0z2/6QdT8sLhGXZcYnBnhe2Sk98sEh6TO00WjtQB+SMBJZqtbC
 TqEy0TCGCQaOqms9hnaDbWOyU38x1R+cY2FDLXOP6TBtYAkLTe6WhU60IhlBfu0f9fCG Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2te61ejsvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 12:37:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65CbYtL144430;
        Fri, 5 Jul 2019 12:37:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2th5qmr2r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 12:37:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65Cbjx1027536;
        Fri, 5 Jul 2019 12:37:45 GMT
Received: from [192.168.14.112] (/79.180.242.82)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 05:37:45 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: LAPIC: ARBPRI is a reserved register for x2APIC
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1562328872-27659-1-git-send-email-pbonzini@redhat.com>
Date:   Fri, 5 Jul 2019 15:37:41 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D76638DF-1934-4B1C-84CD-FFCE11AA175F@oracle.com>
References: <1562328872-27659-1-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9308 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9308 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Jul 2019, at 15:14, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> kvm-unit-tests were adjusted to match bare metal behavior, but KVM
> itself was not doing what bare metal does; fix that.
>=20
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> arch/x86/kvm/lapic.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d6ca5c4f29f1..2e4470f2685a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1318,7 +1318,7 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, =
u32 offset, int len,
> 	unsigned char alignment =3D offset & 0xf;
> 	u32 result;
> 	/* this bitmask has a bit cleared for each reserved register */
> -	static const u64 rmask =3D 0x43ff01ffffffe70cULL;
> +	u64 rmask =3D 0x43ff01ffffffe70cULL;

Why not rename this to =E2=80=9Cused_bits_mask=E2=80=9D and calculate it =
properly by macros?
It seems a lot nicer than having a pre-calculated magic.

-Liran

>=20
> 	if ((alignment + len) > 4) {
> 		apic_debug("KVM_APIC_READ: alignment error %x %d\n",
> @@ -1326,6 +1326,10 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, =
u32 offset, int len,
> 		return 1;
> 	}
>=20
> +	/* ARBPRI is also reserved on x2APIC */
> +	if (apic_x2apic_mode(apic))
> +		rmask &=3D ~(1 << (APIC_ARBPRI >> 4));
> +
> 	if (offset > 0x3f0 || !(rmask & (1ULL << (offset >> 4)))) {
> 		apic_debug("KVM_APIC_READ: read reserved register %x\n",
> 			   offset);
> --=20
> 1.8.3.1
>=20

