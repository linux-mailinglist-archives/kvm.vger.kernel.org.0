Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289646AC50
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfGPP4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:56:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbfGPP4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:56:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GFsb6F187700;
        Tue, 16 Jul 2019 15:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=SbF2CDiMrf8qBoHLw8uV4VQK+h1sCUzzgJWK+xdh43A=;
 b=ChedkShQU2X06ZnUT66zaID+H8rrxZXunjdpCTaKMHBgBB2Xv3ZT7TgMZ9FabND5PVjz
 WTk3bfjQiSug/E4ghu1WvViutxdA8oOJGWZ0JLTDXn1I+Pe1Ia/wj4AuUbXQPYoqOLxc
 qnJZS+qAL8qQZXSKOt3vcbaOzLW36/L/18VEwBup94C50Bd4F/lRjTt5ZC8ndWDflhs4
 +qie+wV0H1o2620I699b9OJK86gQP3xbQiT6avO0MXihPzIGGtN/CHprPkJv4OzSZnsG
 pWoGsTzltkhpDPPCUruChUNKjCyz1iqUffhZIF1Xh9m60sC1xnfPS3gUYiJSfTWyhN81 pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tq6qtnhej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 15:56:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GFr4cL177825;
        Tue, 16 Jul 2019 15:56:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tq6mmyj3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 15:56:24 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GFuNwU001373;
        Tue, 16 Jul 2019 15:56:23 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 15:56:23 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
Date:   Tue, 16 Jul 2019 18:56:19 +0300
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160196
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jul 2019, at 18:48, Singh, Brijesh <brijesh.singh@amd.com> =
wrote:
>=20
> On 7/15/19 3:30 PM, Liran Alon wrote:
>> According to AMD Errata 1096:
>> "On a nested data page fault when CR4.SMAP =3D 1 and the guest data =
read generates a SMAP violation, the
>> GuestInstrBytes field of the VMCB on a VMEXIT will incorrectly return =
0h instead the correct guest instruction
>> bytes."
>>=20
>> As stated above, errata is encountered when guest read generates a =
SMAP violation. i.e. vCPU runs
>> with CPL<3 and CR4.SMAP=3D1. However, code have mistakenly checked if =
CPL=3D=3D3 and CR4.SMAP=3D=3D0.
>>=20
>=20
> The SMAP violation will occur from CPL3 so CPL=3D=3D3 is a valid =
check.
>=20
> See [1] for complete discussion
>=20
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__patchwork.kernel.or=
g_patch_10808075_-2322479271&d=3DDwIGaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qIr=
MUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3DRAt8t8nB=
aCxUPy5OTDkO0n8BMQ5l9oSfLMiL0TLTu6c&s=3DNkwe8rTJhygBCIPz27LXrylptjnWyMwB-n=
JaiowWpWc&e=3D=20

I still don=E2=80=99t understand. SMAP is a mechanism which is meant to =
protect a CPU running in CPL<3 from mistakenly referencing data =
controllable by CPL=3D=3D3.
Therefore, SMAP violation should be raised when CPL<3 and data =
referenced is mapped in page-tables with PTE with U/S bit set to 1. =
(i.e. User accessible).

Thus, we should check if CPL<3 and CR4.SMAP=3D=3D1.

-Liran

>=20
> However, code mistakenly checked CR4.SMAP=3D=3D0, it should be =
CR4.SMAP=3D=3D1
>=20
>> To avoid future confusion and improve code readbility, comment errata =
details in code and not
>> just in commit message.
>>=20
>> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len =
maybe zero on SMAP violation)")
>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>>  arch/x86/kvm/svm.c | 17 +++++++++++++----
>>  1 file changed, 13 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 735b8c01895e..79023a41f7a7 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -7123,10 +7123,19 @@ static bool =
svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>>  	bool is_user, smap;
>>=20
>>  	is_user =3D svm_get_cpl(vcpu) =3D=3D 3;
>> -	smap =3D !kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
>> +	smap =3D kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
>>=20
>=20
> Ah good catch. thank
>=20
>=20
>>  	/*
>> -	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh
>> +	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
>> +	 *
>> +	 * Errata:
>> +	 * On a nested page fault when CR4.SMAP=3D1 and the guest data =
read generates
>> +	 * a SMAP violation, GuestIntrBytes field of the VMCB on a =
VMEXIT will
>> +	 * incorrectly return 0 instead the correct guest instruction =
bytes.
>> +	 *
>> +	 * Workaround:
>> +	 * To determine what instruction the guest was executing, the =
hypervisor
>> +	 * will have to decode the instruction at the instruction =
pointer.
>>  	 *
>>  	 * In non SEV guest, hypervisor will be able to read the guest
>>  	 * memory to decode the instruction pointer when insn_len is =
zero
>> @@ -7137,11 +7146,11 @@ static bool =
svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>>  	 * instruction pointer so we will not able to workaround it. =
Lets
>>  	 * print the error and request to kill the guest.
>>  	 */
>> -	if (is_user && smap) {
>> +	if (!is_user && smap) {
>>  		if (!sev_guest(vcpu->kvm))
>>  			return true;
>>=20
>> -		pr_err_ratelimited("KVM: Guest triggered AMD Erratum =
1096\n");
>> +		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum =
1096\n");
>>  		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>>  	}
>>=20
>>=20

