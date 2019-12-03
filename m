Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A462C1104B6
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 20:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLCTHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 14:07:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39018 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCTHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 14:07:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3J4IaJ147884;
        Tue, 3 Dec 2019 19:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=2/LPmmhe+cyobmMhUdPzRfn6ciNHOIhR9e6hlpvCNTw=;
 b=KW4iOLrmLzC4TTPt9Px3mgcw8aQ1CpUveMDQoPdmbKNKhp/LzXZD08EtGHEZlxlYkKZO
 VgogKxGAycaUkCo0IyAde1s4Rhtnyrc8+pB4jGfrpXqKqvGg/Zc7HXNlLpKeUUS0+3Ih
 Lmeez3JaT//+2cXObr+cUzIZPDI21Sz27ftf6e2iVmSUwzCb+423JUlUjhdf2nr5cSOd
 eMDLZHDsgjRLQ/MXp1Z5AViwyf4Lh35xE9nmilKikHtBVKyc1ggzGfrN4Yliglr9Qmck
 IbO/QccEYuvVTV83Z2Kpp42rIWZLk3vy7xXRVRwF35KJntsCobCK4dlhMhjoG9gXLpN0 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wkgcq9tjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:07:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3J4Fk6004169;
        Tue, 3 Dec 2019 19:07:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wn8k34pdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:07:18 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB3J7InP010246;
        Tue, 3 Dec 2019 19:07:18 GMT
Received: from [192.168.14.112] (/109.66.202.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 11:07:17 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2] kvm: vmx: Pass through IA32_TSC_AUX for read iff guest
 has RDTSCP
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191203183512.146618-1-jmattson@google.com>
Date:   Tue, 3 Dec 2019 21:07:14 +0200
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F70BD53E-B24F-4CDE-893D-ED1A34047066@oracle.com>
References: <20191203183512.146618-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 3 Dec 2019, at 20:35, Jim Mattson <jmattson@google.com> wrote:
>=20
> If the guest supports RDTSCP, it already has read access to the
> hardware IA32_TSC_AUX MSR via RDTSCP, so we can allow it read access
> via the RDMSR instruction as well. If the guest doesn't support
> RDTSCP, intercept all accesses to the IA32_TSC_AUX MSR, so that kvm
> can synthesize a #GP.  (IA32_TSC_AUX exists iff RDTSCP is supported.)
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

>=20
> ---
> v1 -> v2: Rebased across vmx directory creation.
>          Modified commit message based on Sean's comments.
>=20
> arch/x86/kvm/vmx/vmx.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d175429c91b0..04a728976d96 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4070,6 +4070,10 @@ static void =
vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>=20
> 	if (vmx_rdtscp_supported()) {
> 		bool rdtscp_enabled =3D guest_cpuid_has(vcpu, =
X86_FEATURE_RDTSCP);
> +
> +		vmx_set_intercept_for_msr(vmx->vmcs01.msr_bitmap, =
MSR_TSC_AUX,
> +					  MSR_TYPE_R, !rdtscp_enabled);
> +
> 		if (!rdtscp_enabled)
> 			exec_control &=3D ~SECONDARY_EXEC_RDTSCP;
>=20
> --=20
> 2.24.0.393.g34dc348eaf-goog
>=20

