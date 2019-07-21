Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFFE6F320
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 13:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfGUL6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 07:58:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfGUL6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 07:58:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LBsmVj015509;
        Sun, 21 Jul 2019 11:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=FhhAjUa/YjqqTecaGVY8xfCr8xgZul5zsCxLpjDRQ68=;
 b=buwHPKqN/Mk5Rm4Hhp7mhf3OK9O8Ra1Mcxjl/NrwS6mojn7O72x9TKFLsnk9R6f30mKG
 4eBEoPeOvf+5qPeEnDgnU3aWDmexuS7BrNFfeokn5l8WyWiORe+7reUACyu3V4N0mSYi
 iGq9Lc9djjT3WaaGfXWaOD7lEfWRDJjS/SlfM8Zpcuh0LvPtiZijVWBbcyHsOMvkz/s0
 hvdLWMG4Z7sEiqgzURPunHOQ36FfrTJUuJQ+vuNtywPg5h2KGjybTvhi6c+z+xvqKpvO
 TZ/83ggHuheWluJYo1HxwTvG4YHnvmis/wjAET4WTVWvVm0oIOfkZ+omlqe1avfzU7jU +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tutwp2nca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 11:57:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LBqVpw060445;
        Sun, 21 Jul 2019 11:57:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tur2tdaew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 11:57:55 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6LBvrR2023735;
        Sun, 21 Jul 2019 11:57:53 GMT
Received: from [10.74.124.22] (/10.74.124.22)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 21 Jul 2019 11:57:51 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when
 leaving nested
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
Date:   Sun, 21 Jul 2019 14:57:47 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A65A74C6-0F2D-4751-97CA-43CFC3A3CA63@oracle.com>
References: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
To:     Jan Kiszka <jan.kiszka@web.de>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9324 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907210144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9324 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907210145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 21 Jul 2019, at 14:52, Jan Kiszka <jan.kiszka@web.de> wrote:
>=20
> From: Jan Kiszka <jan.kiszka@siemens.com>
>=20
> Letting this pend may cause nested_get_vmcs12_pages to run against an
> invalid state, corrupting the effective vmcs of L1.
>=20
> This was triggerable in QEMU after a guest corruption in L2, followed =
by
> a L1 reset.
>=20
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Good catch.
Reviewed-by: Liran Alon <liran.alon@oracle.com>

This would have been more easily diagnosed in case free_nested() would =
NULL cached_vmcs12 and cached_shadow_vmcs12
after kfree() and add to get_vmcs12() & get_shadow_vmcs12() a relevant =
BUG_ON() call.

I would submit such a patch separately.

-Liran

> ---
>=20
> And another gremlin. I'm afraid there is at least one more because
> vmport access from L2 is still failing in QEMU. This is just another
> fallout from that. At least the host seems stable now.
>=20
> arch/x86/kvm/vmx/nested.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0f1378789bd0..4cdab4b4eff1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -220,6 +220,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
> 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
> 		return;
>=20
> +	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
> +
> 	vmx->nested.vmxon =3D false;
> 	vmx->nested.smm.vmxon =3D false;
> 	free_vpid(vmx->nested.vpid02);
> --
> 2.16.4

