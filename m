Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988DDF0858
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 22:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfKEV3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 16:29:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbfKEV3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 16:29:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5LTd1N153304;
        Tue, 5 Nov 2019 21:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=5yhVejoHF8kE0kkkT56KSiD9oyvzyII2Nowc/FEjwXw=;
 b=QB5T3Gpbb39hJWoGVPhK2CiMe1IIMLN3B9HBQ9m7D6ekxhpD1LWTCVFISjTjalK3Bg0s
 fgArLqX6ckUMcQjoRuINuEjDdAep0oL1J7a9oipW2Lyt9v728cg8A+pWelZIqNt0lLsw
 O8blfxi4/Mn0TjrBM4xhyZc9s+hMdbOz6lwbM7aFATCGz/JHU6bs6A/H+OjfYfUMhYFx
 XhvTiBTJdO1uC0bLNmd7HTde6k7gy4iaDCiZsUe6vKK+qhZlqCQldhNbm6UzfiE+q6zL
 ZoUSFckcyi8oH5wmTUo2xkzOlMcLRQi8RErxTVGUUsyvq1TnSiTNsY+RPpZEUaMHM6sQ Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12er9db8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 21:29:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5LSpc9018620;
        Tue, 5 Nov 2019 21:29:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w31623adj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 21:29:31 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA5LSrHO018009;
        Tue, 5 Nov 2019 21:28:53 GMT
Received: from [192.168.14.112] (/79.180.234.250)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 13:28:52 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 2/4] kvm: vmx: Rename NR_AUTOLOAD_MSRS to
 NR_MSR_ENTRIES
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191105191910.56505-3-aaronlewis@google.com>
Date:   Tue, 5 Nov 2019 23:28:49 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <32A62E45-2C2A-436B-85E9-5A15C03EFB2E@oracle.com>
References: <20191105191910.56505-1-aaronlewis@google.com>
 <20191105191910.56505-3-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050175
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Nov 2019, at 21:19, Aaron Lewis <aaronlewis@google.com> wrote:
>=20
> Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES.  This needs to be done
> due to the addition of the MSR-autostore area that will be added later
> in this series.  After that the name AUTOLOAD will no longer make =
sense.
>=20
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

NR_MSR_ENTRIES is a bit too generic in my opinion.
I would prefer to rename to NR_AUTO_LOADSTORE_MSRS.
The change itself is fine.

-Liran

> ---
> arch/x86/kvm/vmx/vmx.c | 4 ++--
> arch/x86/kvm/vmx/vmx.h | 4 ++--
> 2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e7970a2e8eae..c0160ca9ddba 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -940,8 +940,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx =
*vmx, unsigned msr,
> 	if (!entry_only)
> 		j =3D find_msr(&m->host, msr);
>=20
> -	if ((i < 0 && m->guest.nr =3D=3D NR_AUTOLOAD_MSRS) ||
> -		(j < 0 &&  m->host.nr =3D=3D NR_AUTOLOAD_MSRS)) {
> +	if ((i < 0 && m->guest.nr =3D=3D NR_MSR_ENTRIES) ||
> +		(j < 0 &&  m->host.nr =3D=3D NR_MSR_ENTRIES)) {
> 		printk_once(KERN_WARNING "Not enough msr switch entries. =
"
> 				"Can't add msr %x\n", msr);
> 		return;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index bee16687dc0b..0c6835bd6945 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -22,11 +22,11 @@ extern u32 get_umwait_control_msr(void);
>=20
> #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
>=20
> -#define NR_AUTOLOAD_MSRS 8
> +#define NR_MSR_ENTRIES 8
>=20
> struct vmx_msrs {
> 	unsigned int		nr;
> -	struct vmx_msr_entry	val[NR_AUTOLOAD_MSRS];
> +	struct vmx_msr_entry	val[NR_MSR_ENTRIES];
> };
>=20
> struct shared_msr_entry {
> --
> 2.24.0.rc1.363.gb1bccd3e3d-goog
>=20

