Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC795D28F
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGBPSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:18:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfGBPSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 11:18:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62F4PWd048269;
        Tue, 2 Jul 2019 15:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=jGSbUs7FIHXwxbfP/yiIGA4fScXA5B57jJTxHagWnSQ=;
 b=xrnsTtp08YAW7MGxGpFDsUof05DvMBaTIVanDhMgMBUP/Afvewjlxkm2kGeTPgzZ52B5
 CeyPMpVZVsNyaufycPL9QNpvM9l1X96nHiRxu5JKNAaj4/G0zMkrq1aTzkOCjfgrUmE0
 gMUZt88WAfE5y1fx5a2PxZgIGh8Hfss5ycTiK2CbTknIzdBSN3iDEw+IqMS8wVGWU1e+
 XxHLM+scgGRqZ17grw+IksA83FGtXOeBgclZMwxMZ0WWQoHusulCttxVhGEJG5/IBDXp
 cynEIcnP2Y9vjOOSURBI90Z6AqawjVAP6mGuBR7beIqh7suuByEzMHfsiyfS2bDTMuSC MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2te61pva23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 15:17:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62F38Ro120833;
        Tue, 2 Jul 2019 15:17:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tebaktxyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 15:17:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x62FHeNR018150;
        Tue, 2 Jul 2019 15:17:40 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 08:17:40 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/3] KVM: nVMX: include conditional controls in /dev/kvm
 KVM_GET_MSRS
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1562079876-20756-2-git-send-email-pbonzini@redhat.com>
Date:   Tue, 2 Jul 2019 18:17:33 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8EF461F9-3243-446F-9AF7-C8FFDC58B467@oracle.com>
References: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
 <1562079876-20756-2-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 2 Jul 2019, at 18:04, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> Some secondary controls are automatically enabled/disabled based on =
the CPUID
> values that are set for the guest.  However, they are still available =
at a
> global level and therefore should be present when KVM_GET_MSRS is sent =
to
> /dev/kvm.
>=20
> Fixes: 1389309c811 ("KVM: nVMX: expose VMX capabilities for nested =
hypervisors to userspace", 2018-02-26)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/kvm/vmx/nested.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 990e543f4531..c4e29ef0b21e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5750,10 +5750,15 @@ void nested_vmx_setup_ctls_msrs(struct =
nested_vmx_msrs *msrs, u32 ept_caps,
> 	msrs->secondary_ctls_low =3D 0;
> 	msrs->secondary_ctls_high &=3D
> 		SECONDARY_EXEC_DESC |
> +		SECONDARY_EXEC_RDTSCP |
> 		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
> +		SECONDARY_EXEC_WBINVD_EXITING |
> 		SECONDARY_EXEC_APIC_REGISTER_VIRT |
> 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
> -		SECONDARY_EXEC_WBINVD_EXITING;
> +		SECONDARY_EXEC_RDRAND_EXITING |
> +		SECONDARY_EXEC_ENABLE_INVPCID |
> +		SECONDARY_EXEC_RDSEED_EXITING |
> +		SECONDARY_EXEC_XSAVES;
>=20
> 	/*
> 	 * We can emulate "VMCS shadowing," even if the hardware
> --=20
> 1.8.3.1
>=20
>=20

