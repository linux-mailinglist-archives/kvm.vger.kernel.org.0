Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF39C13D065
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 00:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgAOW71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 17:59:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgAOW70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 17:59:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FMwaLk144134;
        Wed, 15 Jan 2020 22:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=erIdwvqHP5opuqomRifTvRAQFoHWWnD94iMZxHl4l4M=;
 b=cBfN8j6PP9zT7fC44njLC+iLGExFQy5xA7DTrGCNihsN361v0pKPC37cglrQcjIqG8ik
 waKd1T8QKvk8NVMi88QSRHeWahBWY5lbDurQgGqGczG3RcCOIhqKZY/SYHHnwS8mABDJ
 OkFmIPGgMWhbNeqpkTGCgopmqQkVyIXLy5eJ3sqDR6/Pj7Nd16gON1PMEWxsLv1XtDrR
 caVAMwdZZd5ZCqWxsSVRZO0uXpvniLYZIW4OV0Cams7BlNietHv8hbf9KdvtEf2csvlt
 TL4kwUOhCan9rq1kVTYgsSD8gKBUf81lbRJtP2ps5MvMIp9Yk0w3u6NH6EqKJKLk+bNu HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sf7te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:59:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FMwvfv127336;
        Wed, 15 Jan 2020 22:59:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1arjcvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:59:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FMxJms019906;
        Wed, 15 Jan 2020 22:59:19 GMT
Received: from [192.168.14.112] (/109.66.225.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 14:59:19 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH RFC 3/3] x86/kvm/hyper-v: don't allow to turn on
 unsupported VMX controls for nested guests
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200115171014.56405-4-vkuznets@redhat.com>
Date:   Thu, 16 Jan 2020 00:59:15 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CF37ED31-4ED0-45C2-A309-3E1E2C2E54F8@oracle.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-4-vkuznets@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150173
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 15 Jan 2020, at 19:10, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Sane L1 hypervisors are not supposed to turn any of the unsupported =
VMX
> controls on for its guests and nested_vmx_check_controls() checks for
> that. This is, however, not the case for the controls which are =
supported
> on the host but are missing in enlightened VMCS and when eVMCS is in =
use.
>=20
> It would certainly be possible to add these missing checks to
> nested_check_vm_execution_controls()/_vm_exit_controls()/.. but it =
seems
> preferable to keep eVMCS-specific stuff in eVMCS and reduce the impact =
on
> non-eVMCS guests by doing less unrelated checks. Create a separate
> nested_evmcs_check_controls() for this purpose.
>=20
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> arch/x86/kvm/vmx/evmcs.c  | 56 ++++++++++++++++++++++++++++++++++++++-
> arch/x86/kvm/vmx/evmcs.h  |  1 +
> arch/x86/kvm/vmx/nested.c |  3 +++
> 3 files changed, 59 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index b5d6582ba589..88f462866396 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -4,9 +4,11 @@
> #include <linux/smp.h>
>=20
> #include "../hyperv.h"
> -#include "evmcs.h"
> #include "vmcs.h"
> +#include "vmcs12.h"
> +#include "evmcs.h"
> #include "vmx.h"
> +#include "trace.h"
>=20
> DEFINE_STATIC_KEY_FALSE(enable_evmcs);
>=20
> @@ -378,6 +380,58 @@ void nested_evmcs_filter_control_msr(u32 =
msr_index, u64 *pdata)
> 	*pdata =3D ctl_low | ((u64)ctl_high << 32);
> }
>=20
> +int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
> +{
> +	int ret =3D 0;
> +	u32 unsupp_ctl;
> +
> +	unsupp_ctl =3D vmcs12->pin_based_vm_exec_control &
> +		EVMCS1_UNSUPPORTED_PINCTRL;
> +	if (unsupp_ctl) {
> +		trace_kvm_nested_vmenter_failed(
> +			"eVMCS: unsupported pin-based VM-execution =
controls",
> +			unsupp_ctl);

Why not move "CC=E2=80=9D macro from nested.c to nested.h and use it =
here as-well instead of replicating it=E2=80=99s logic?

-Liran

