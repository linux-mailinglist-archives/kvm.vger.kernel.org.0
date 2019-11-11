Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04BF7944
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKKQ4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:56:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726910AbfKKQ4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 11:56:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xABGowgD018936
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 11:56:41 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w79ae71jt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 11:56:40 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 11 Nov 2019 16:56:35 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 11 Nov 2019 16:56:33 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xABGuVw927263038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 16:56:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD885A4040;
        Mon, 11 Nov 2019 16:56:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DCB1A4053;
        Mon, 11 Nov 2019 16:56:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.179.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Nov 2019 16:56:31 +0000 (GMT)
Subject: Re: [RFC 06/37] s390: UV: Add import and export to UV library
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-7-frankja@linux.ibm.com>
 <20191111174039.608f53fb.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 11 Nov 2019 17:56:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191111174039.608f53fb.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0nTGA8CHE8faN0oyoJiSW5szDC9RLyPTi"
X-TM-AS-GCONF: 00
x-cbid: 19111116-0012-0000-0000-00000362B5B4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111116-0013-0000-0000-0000219E21D1
Message-Id: <ab6770e6-ac73-5f39-e7fd-3edc92de740e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-11_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911110153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0nTGA8CHE8faN0oyoJiSW5szDC9RLyPTi
Content-Type: multipart/mixed; boundary="5WgNiv6Tw8pPL0mTJ83PVrl33ENyuIVdH"

--5WgNiv6Tw8pPL0mTJ83PVrl33ENyuIVdH
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/11/19 5:40 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:28 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> The convert to/from secure (or also "import/export") ultravisor calls
>> are need for page management, i.e. paging, of secure execution VM.
>>
>> Export encrypts a secure guest's page and makes it accessible to the
>> guest for paging.
>>
>> Import makes a page accessible to a secure guest.
>> On the first import of that page, the page will be cleared by the
>> Ultravisor before it is given to the guest.
>>
>> All following imports will decrypt a exported page and verify
>> integrity before giving the page to the guest.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/uv.h | 51 +++++++++++++++++++++++++++++++++++++=
+
>>  1 file changed, 51 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 0bfbafcca136..99cdd2034503 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -15,6 +15,7 @@
>>  #include <linux/errno.h>
>>  #include <linux/bug.h>
>>  #include <asm/page.h>
>> +#include <asm/gmap.h>
>> =20
>>  #define UVC_RC_EXECUTED		0x0001
>>  #define UVC_RC_INV_CMD		0x0002
>> @@ -279,6 +280,54 @@ static inline int uv_cmd_nodata(u64 handle, u16 c=
md, u32 *ret)
>>  	return rc ? -EINVAL : 0;
>>  }
>> =20
>> +/*
>> + * Requests the Ultravisor to encrypt a guest page and make it
>> + * accessible to the host for paging (export).
>> + *
>> + * @paddr: Absolute host address of page to be exported
>> + */
>> +static inline int uv_convert_from_secure(unsigned long paddr)
>> +{
>> +	struct uv_cb_cfs uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_CONV_FROM_SEC_STOR,
>> +		.header.len =3D sizeof(uvcb),
>> +		.paddr =3D paddr
>> +	};
>> +	if (!uv_call(0, (u64)&uvcb))
>> +		return 0;
>> +	return -EINVAL;
>=20
> No possibility for other return codes here (e.g. -EFAULT)? (Asking
> because you look at a rc in the control block in the reverse function.)=


Notice the "paddr" variable?
We work on physical memory for this UV call, all error codes that are
defined are either input errors (not possible via the exception
handlers), a KVM management error or an attack on the VM.

>=20
>> +}
>> +
>> +/*
>> + * Requests the Ultravisor to make a page accessible to a guest
>> + * (import). If it's brought in the first time, it will be cleared. I=
f
>> + * it has been exported before, it will be decrypted and integrity
>> + * checked.
>> + *
>> + * @handle: Ultravisor guest handle
>> + * @gaddr: Guest 2 absolute address to be imported
>> + */
>> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned lo=
ng gaddr)
>> +{
>> +	int cc;
>> +	struct uv_cb_cts uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
>> +		.header.len =3D sizeof(uvcb),
>> +		.guest_handle =3D gmap->se_handle,
>> +		.gaddr =3D gaddr
>> +	};
>> +
>> +	cc =3D uv_call(0, (u64)&uvcb);
>> +
>> +	if (!cc)
>> +		return 0;
>> +	if (uvcb.header.rc =3D=3D 0x104)
>> +		return -EEXIST;
>> +	if (uvcb.header.rc =3D=3D 0x10a)
>> +		return -EFAULT;
>> +	return -EINVAL;
>> +}
>> +
>>  void setup_uv(void);
>>  void adjust_to_uv_max(unsigned long *vmax);
>>  #else
>> @@ -286,6 +335,8 @@ void adjust_to_uv_max(unsigned long *vmax);
>>  static inline void setup_uv(void) {}
>>  static inline void adjust_to_uv_max(unsigned long *vmax) {}
>>  static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret) { retu=
rn 0; }
>> +static inline int uv_convert_from_secure(unsigned long paddr) { retur=
n 0; }
>> +static inline int uv_convert_to_secure(unsigned long handle, unsigned=
 long gaddr) { return 0; }
>>  #endif
>> =20
>>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                =
          \
>=20



--5WgNiv6Tw8pPL0mTJ83PVrl33ENyuIVdH--

--0nTGA8CHE8faN0oyoJiSW5szDC9RLyPTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3Jkr4ACgkQ41TmuOI4
ufiEfQ/+P+6yIyw4Q5NdNUelojjFpQIKL1U0ecCYSnsRVazQhSihM2KJhKYJXI3p
+BJXvA1tcygaXY8ridIn98/Lw60SoAtgMi3p/plbRL5uv+c1E98irlMpX6V3uc3Z
fk3kBPaTecJMDDTcZQ7JiuCNqhIA7GjLb2hsKgZFYt28IgsBk2eMyxBDEEyynOc7
k51ZSfKvIlOhKoLL1f2o2PbZXgFimdeb+Ve1ZXXLrPp3CHLZ+96WnShA4LbLMuu2
4H6tUcRpm+mUcN8CyS8xfC3zpWB7RC9wsAm5zJAcWWld3k+pAqBI922ypN3feAKa
u1tB7Lwoaoa6XQFOR90pfWuc+7LFV1R96fTca+mxMywOPPh9ip/4/5BYCia+9ynd
97Mw8Y2ktG7Jk34uNzXjSolRr5Qen4PsmlIqjtTaawWi+4RIxYUpbY0l6IwRZrb8
p+Pdp/x/jByaT11SJDJUXEf49dc5GYo40Qg7wNgMn2nRYomWFv+eIChB+XwwDUjx
nYd5GSCU2W0tAwLKmkSQsgKXvYLLBjGVUvOnbEExTCZ4Kp6HL2iQCMCdS4FZFRx1
vYa8sq+DMjzDeNNMX/LBaBc34+FaHjYdIpA6dsKDnDEhO64fDrMk+pPNRnAuKSdQ
XmX4610Ag+nxPssDvTPUMYGkvywzVdTLur1B9VC0wvY+k3hb81Y=
=+gWa
-----END PGP SIGNATURE-----

--0nTGA8CHE8faN0oyoJiSW5szDC9RLyPTi--

