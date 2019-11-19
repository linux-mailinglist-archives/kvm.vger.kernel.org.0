Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE01101B68
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 09:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfKSILV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 03:11:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbfKSILU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 03:11:20 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ87fGr115556
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 03:11:19 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2way21cy6d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 03:11:18 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 19 Nov 2019 08:11:17 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 19 Nov 2019 08:11:14 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJ8BCT836504060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 08:11:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA72252067;
        Tue, 19 Nov 2019 08:11:12 +0000 (GMT)
Received: from dyn-9-152-224-153.boeblingen.de.ibm.com (unknown [9.152.224.153])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6C78852050;
        Tue, 19 Nov 2019 08:11:12 +0000 (GMT)
Subject: Re: [RFC 23/37] KVM: s390: protvirt: Make sure prefix is always
 protected
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-24-frankja@linux.ibm.com>
 <20191118173942.0252b731.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 19 Nov 2019 09:11:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191118173942.0252b731.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dTiQux0JQ55Djpg2Rsgq8qTwZonfqEr3C"
X-TM-AS-GCONF: 00
x-cbid: 19111908-0028-0000-0000-000003BB040F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111908-0029-0000-0000-0000247E2036
Message-Id: <db54630b-8959-feba-168e-0afecc30d4b9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_01:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=525
 malwarescore=0 bulkscore=0 suspectscore=3 spamscore=0 adultscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dTiQux0JQ55Djpg2Rsgq8qTwZonfqEr3C
Content-Type: multipart/mixed; boundary="WXgCMtOkbkxdPBessyThRwbnTNXHfBbyq"

--WXgCMtOkbkxdPBessyThRwbnTNXHfBbyq
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/18/19 5:39 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:45 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
> Add at least a short sentence here?

For protected VMs the lowcore does not only need to be mapped, but also
needs to be protected memory, if not we'll get a validity interception
when trying to run it.

>=20
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index eddc9508c1b1..17a78774c617 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3646,6 +3646,15 @@ static int kvm_s390_handle_requests(struct kvm_=
vcpu *vcpu)
>>  		rc =3D gmap_mprotect_notify(vcpu->arch.gmap,
>>  					  kvm_s390_get_prefix(vcpu),
>>  					  PAGE_SIZE * 2, PROT_WRITE);
>> +		if (!rc && kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			rc =3D uv_convert_to_secure(vcpu->arch.gmap,
>> +						  kvm_s390_get_prefix(vcpu));
>> +			WARN_ON_ONCE(rc && rc !=3D -EEXIST);
>> +			rc =3D uv_convert_to_secure(vcpu->arch.gmap,
>> +						  kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
>> +			WARN_ON_ONCE(rc && rc !=3D -EEXIST);
>> +			rc =3D 0;
>=20
> So, what happens if we have an error other than -EEXIST (which
> presumably means that we already protected it) here? The page is not
> protected, and further accesses will get an error? (Another question:
> what can actually go wrong here?)

If KVM or QEMU write into a lowcore, we will fail the integrity check on
import and this cpu will never run again.

In retrospect a warn_on_once might be the wrong error handling here.

>=20
>> +		}
>>  		if (rc) {
>>  			kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
>>  			return rc;
>=20



--WXgCMtOkbkxdPBessyThRwbnTNXHfBbyq--

--dTiQux0JQ55Djpg2Rsgq8qTwZonfqEr3C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3To6AACgkQ41TmuOI4
ufjICBAArn8chPtOBdwPrGdyUqynbSUeN2sCnMJ71dvs+8V2AKXr1lM/uiGtz4v0
6WEbkZ3k0ZAMbrE+sBAlK/ghma9Vcn6FkFFTJPoBmUTlQXlMN3HTJntqIl279AcR
gyRSk2qJgF+VLxO4YexVw4nBz8Az6ez0tDyVYtftDAf+Q0Ha/1Aivq0F68C23MKZ
rzSCHsxjTmCBFZmr1fJxeK1ad6Pw6ra0HBWUocKiLnJxcUax3oBAFs9uPoDM/I/y
5ZV8o90TSVFIDBbQR0V2Ee32s0bOj409Il3hH7hyK4PKqEtvIxZDOBXYMjSJcuPZ
M7JP7wvImzUfwEJoZ8H27fTf4V0voHZJGDAgjI9xAioOTEBL3a7enHhHEwcFoCJY
pnc81zrKeOcrL3wn4eNgsqPl5FsZ654wpqq4oVugxgogpmFn3QLiH4DGYXMm6829
vPb1utkCOvKPHITj33yh0q8HYNAEfzFMvGcz/kriHrEuBEhJPIFxr9IqiTrE2efp
LDnXDsR81CKScNsE4iPMzfUVYkYV1worMJtQQqWoZCGcngsNKjMC63hnb+HPguh7
7KvnaPOpLkly/dS2IIC8vqFpweVIUQHM+ipQucBv/32QbOVcRu38IQGeExyWhAx3
St7cDHMEZ9+RyliVxTmxfuoJbrHBNiSecZXylob3RaraLBUIRqY=
=Gtoe
-----END PGP SIGNATURE-----

--dTiQux0JQ55Djpg2Rsgq8qTwZonfqEr3C--

