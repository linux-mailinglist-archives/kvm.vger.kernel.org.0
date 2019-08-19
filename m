Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472DE9510A
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 00:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfHSWo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 18:44:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfHSWo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 18:44:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JMi2iC195245
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 22:44:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=IicR5m0csDRmanowDiAwkbhNpjtPmu0dEBWE8obYDyo=;
 b=nIAimbNxkY0HVXNRPuq/X0Ejo/UZvlLrPa0ORsu7IcwYq9go819mrCboGNyD8RU0EyV2
 QSJ+mo7Dq/LJ3YwNvgz4UlFWrSOB5XhoeZLy+A3IwBbFKkQJK0qOfdbe1tHXLB3vZXqD
 0xx3p8VK9df6HTUGA/2POO1aWDfWBW4x/G4bo/M8UlAGR8DwTYlWTcb1JFRxhj8jYgig
 K5X+cCis2FXZG6VlAR+ZNybE8wCdmmdjh/IXxCBddxCWwviS8MNvWdp5zDUy6sqqWrCe
 aE+LhowSHAQn4aLfwtNHoYlqVM/3ndOxOearAJhFshEbNXenzaUsA5CWos6BW7x4SNzH GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uea7qjaar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 22:44:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JMhVIs137723
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 22:44:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ug267w72w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 22:44:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7JMiPdf011074
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 22:44:25 GMT
Received: from [192.168.14.112] (/79.176.245.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 15:44:25 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: nVMX: Check guest activity state on vmentry of
 nested guests
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190819214650.41991-3-nikita.leshchenko@oracle.com>
Date:   Tue, 20 Aug 2019 01:44:21 +0300
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1227879D-AD99-4EC3-9400-95517729189B@oracle.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-3-nikita.leshchenko@oracle.com>
To:     Nikita Leshenko <nikita.leshchenko@oracle.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190225
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908190226
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 20 Aug 2019, at 0:46, Nikita Leshenko =
<nikita.leshchenko@oracle.com> wrote:
>=20
> The checks are written in the same order and structure as they appear =
in "SDM
> 26.3.1.5 - Checks on Guest Non-Register State", to ease verification.
>=20
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> ---
> arch/x86/kvm/vmx/nested.c | 24 ++++++++++++++++++++++++
> arch/x86/kvm/vmx/vmcs.h   | 13 +++++++++++++
> 2 files changed, 37 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 24734946ec75..e2ee217f8ffe 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2666,10 +2666,34 @@ static int =
nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
>  */
> static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
> {
> +	/* Activity state must contain supported value */
> 	if (vmcs12->guest_activity_state !=3D GUEST_ACTIVITY_ACTIVE &&
> 	    vmcs12->guest_activity_state !=3D GUEST_ACTIVITY_HLT)
> 		return -EINVAL;
>=20
> +	/* Must not be HLT if SS DPL is not 0 */
> +	if (VMX_AR_DPL(vmcs12->guest_ss_ar_bytes) !=3D 0 &&
> +	    vmcs12->guest_activity_state =3D=3D GUEST_ACTIVITY_HLT)
> +		return -EINVAL;
> +
> +	/* Must be active if blocking by MOV-SS or STI */
> +	if ((vmcs12->guest_interruptibility_info &
> +	    (GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI)) &&
> +	    vmcs12->guest_activity_state !=3D GUEST_ACTIVITY_ACTIVE)
> +		return -EINVAL;
> +
> +	/* In HLT, only some interruptions are allowed */
> +	if (vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK &&
> +	    vmcs12->guest_activity_state =3D=3D GUEST_ACTIVITY_HLT) {
> +		u32 intr_info =3D vmcs12->vm_entry_intr_info_field;
> +		if (!is_ext_interrupt(intr_info) &&
> +		    !is_nmi(intr_info) &&
> +		    !is_debug(intr_info) &&
> +		    !is_machine_check(intr_info) &&
> +		    !is_mtf(intr_info))
> +		    return -EINVAL;
> +	}
> +
> 	return 0;
> }
>=20
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index cb6079f8a227..c5577c40b19d 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -102,6 +102,13 @@ static inline bool is_machine_check(u32 =
intr_info)
> 		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | =
INTR_INFO_VALID_MASK);
> }
>=20
> +static inline bool is_mtf(u32 intr_info)
> +{
> +	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | =
INTR_INFO_VECTOR_MASK |
> +			     INTR_INFO_VALID_MASK)) =3D=3D
> +		(INTR_TYPE_OTHER_EVENT | 0 | INTR_INFO_VALID_MASK);
> +}
> +
> /* Undocumented: icebp/int1 */
> static inline bool is_icebp(u32 intr_info)
> {
> @@ -115,6 +122,12 @@ static inline bool is_nmi(u32 intr_info)
> 		=3D=3D (INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK);
> }
>=20
> +static inline bool is_ext_interrupt(u32 intr_info)
> +{
> +	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | =
INTR_INFO_VALID_MASK))
> +		=3D=3D (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
> +}

is_external_intr() already exists. You should just use that.

> +
> enum vmcs_field_width {
> 	VMCS_FIELD_WIDTH_U16 =3D 0,
> 	VMCS_FIELD_WIDTH_U64 =3D 1,
> --=20
> 2.20.1
>=20

