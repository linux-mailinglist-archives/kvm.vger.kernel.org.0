Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378E75C5E5
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 01:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfGAXRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 19:17:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfGAXRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 19:17:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61NEHfk185532;
        Mon, 1 Jul 2019 23:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=7VyQuE4gHj74PtiPDgjcTu/bvClU4yb3B+z1KW7EEB4=;
 b=h9O914llJUHbaRrVQmH0UofduAOF4oo9A1E5t+/t7HDNX3n8o4w/x1PdxVBiWHeUr2YT
 Xo9W9kIo2+d3TB/n466ssWnClpEmzgACqAnIIzUUU1YWXvZ6WlVlo5JeEGlWYLMYYWGD
 QNQOOaZtY1Xj9mwkbUE1letBm4OGpvJcxVTSzWktt8dWKZOyaZhZ20b3nywDuxhpul9p
 8Z4ZnXJoQRL5cx0HvxaWE5bGdTGaX5ZJpsZcMWebVNUpSl+YKSxidmSlviCrSMXtyp2K
 MmTqfsYZTQmhU08g37k9pZfiXX9UHaShYuwrOWNES4CMYiqHj6zieAoWLO15FxyEsvCF ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tbga80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 23:16:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61NDK7g032640;
        Mon, 1 Jul 2019 23:16:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tebktxncq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 23:16:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61NGZOC021999;
        Mon, 1 Jul 2019 23:16:35 GMT
Received: from [192.168.14.112] (/79.183.235.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 16:16:34 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: Allow restore nested-state to enable eVMCS
 when vCPU in SMM
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <878stpern4.fsf@vitty.brq.redhat.com>
Date:   Tue, 2 Jul 2019 02:16:31 +0300
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <23369D92-B93B-4A96-84DA-55093234DA11@oracle.com>
References: <20190625112642.113460-1-liran.alon@oracle.com>
 <878stpern4.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=627
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010270
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=680 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010270
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping.

> On 25 Jun 2019, at 16:11, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Liran Alon <liran.alon@oracle.com> writes:
>=20
>> As comment in code specifies, SMM temporarily disables VMX so we =
cannot
>> be in guest mode, nor can VMLAUNCH/VMRESUME be pending.
>>=20
>> However, code currently assumes that these are the only flags that =
can be
>> set on kvm_state->flags. This is not true as KVM_STATE_NESTED_EVMCS
>> can also be set on this field to signal that eVMCS should be enabled.
>>=20
>> Therefore, fix code to check for guest-mode and pending =
VMLAUNCH/VMRESUME
>> explicitly.
>>=20
>> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>> arch/x86/kvm/vmx/nested.c | 5 ++++-
>> 1 file changed, 4 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 5c470db311f7..27ff04874f67 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -5373,7 +5373,10 @@ static int vmx_set_nested_state(struct =
kvm_vcpu *vcpu,
>> 	 * nor can VMLAUNCH/VMRESUME be pending.  Outside SMM, SMM flags
>> 	 * must be zero.
>> 	 */
>> -	if (is_smm(vcpu) ? kvm_state->flags : =
kvm_state->hdr.vmx.smm.flags)
>> +	if (is_smm(vcpu) ?
>> +		(kvm_state->flags &
>> +		 (KVM_STATE_NESTED_GUEST_MODE | =
KVM_STATE_NESTED_RUN_PENDING))
>> +		: kvm_state->hdr.vmx.smm.flags)
>> 		return -EINVAL;
>>=20
>> 	if ((kvm_state->hdr.vmx.smm.flags & =
KVM_STATE_NESTED_SMM_GUEST_MODE) &&
>=20
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>=20
> --=20
> Vitaly

