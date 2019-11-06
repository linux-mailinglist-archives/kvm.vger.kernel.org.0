Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEBDFF1C0F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbfKFRFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:05:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728340AbfKFRFc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Nov 2019 12:05:32 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA6H5DVu068067
        for <kvm@vger.kernel.org>; Wed, 6 Nov 2019 12:05:32 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w41wtgpgk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 12:05:31 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 6 Nov 2019 17:05:29 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 6 Nov 2019 17:05:26 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA6H5NBL42467522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 17:05:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 970A152065;
        Wed,  6 Nov 2019 17:05:23 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 411C95204E;
        Wed,  6 Nov 2019 17:05:23 +0000 (GMT)
Subject: Re: [RFC 30/37] DOCUMENTATION: protvirt: Diag 308 IPL
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-31-frankja@linux.ibm.com>
 <20191106174855.13a50f42.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 6 Nov 2019 18:05:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191106174855.13a50f42.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UkpeVgq64Ns7zUX2ap7pO00Qotpwdfnwg"
X-TM-AS-GCONF: 00
x-cbid: 19110617-0008-0000-0000-0000032C246E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110617-0009-0000-0000-00004A4B268F
Message-Id: <6dd98dfe-63ce-374c-9b04-00cdeceee905@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911060163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UkpeVgq64Ns7zUX2ap7pO00Qotpwdfnwg
Content-Type: multipart/mixed; boundary="0eaqKIZJY7E4vhohX80bisHlpRH7k8C1r"

--0eaqKIZJY7E4vhohX80bisHlpRH7k8C1r
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/6/19 5:48 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:52 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Description of changes that are necessary to move a KVM VM into
>> Protected Virtualization mode.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  Documentation/virtual/kvm/s390-pv-boot.txt | 62 +++++++++++++++++++++=
+
>>  1 file changed, 62 insertions(+)
>>  create mode 100644 Documentation/virtual/kvm/s390-pv-boot.txt
>>
>> diff --git a/Documentation/virtual/kvm/s390-pv-boot.txt b/Documentatio=
n/virtual/kvm/s390-pv-boot.txt
>> new file mode 100644
>> index 000000000000..af883c928c08
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/s390-pv-boot.txt
>> @@ -0,0 +1,62 @@
>> +Boot/IPL of Protected VMs
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> +
>> +Summary:
>> +
>> +Protected VMs are encrypted while not running. On IPL a small
>> +plaintext bootloader is started which provides information about the
>> +encrypted components and necessary metadata to KVM to decrypt it.
>> +
>> +Based on this data, KVM will make the PV known to the Ultravisor and
>> +instruct it to secure its memory, decrypt the components and verify
>> +the data and address list hashes, to ensure integrity. Afterwards KVM=

>> +can run the PV via SIE which the UV will intercept and execute on
>> +KVM's behalf.
>> +
>> +The switch into PV mode lets us load encrypted guest executables and
>> +data via every available method (network, dasd, scsi, direct kernel,
>> +...) without the need to change the boot process.
>> +
>> +
>> +Diag308:
>> +
>> +This diagnose instruction is the basis vor VM IPL. The VM can set and=

>=20
> s/vor/for/
>=20
>> +retrieve IPL information blocks, that specify the IPL method/devices
>> +and request VM memory and subsystem resets, as well as IPLs.
>> +
>> +For PVs this concept has been continued with new subcodes:
>> +
>> +Subcode 8: Set an IPL Information Block of type 5.
>> +Subcode 9: Store the saved block in guest memory
>> +Subcode 10: Move into Protected Virtualization mode
>> +
>> +The new PV load-device-specific-parameters field specifies all data,
>> +that is necessary to move into PV mode.
>> +
>> +* PV Header origin
>> +* PV Header length
>> +* List of Components composed of:
>> +  * AES-XTS Tweak prefix
>> +  * Origin
>> +  * Size
>> +
>> +The PV header contains the keys and hashes, which the UV will use to
>> +decrypt and verify the PV, as well as control flags and a start PSW.
>> +
>> +The components are for instance an encrypted kernel, kernel cmd and
>> +initrd. The components are decrypted by the UV.
>> +
>> +All non-decrypted data of the non-PV guest instance are zero on first=

>> +access of the PV.
>> +
>> +
>> +When running in a protected mode some subcodes will result in
>> +exceptions or return error codes.
>> +
>> +Subcodes 4 and 7 will result in specification exceptions.
>> +When removing a secure VM, the UV will clear all memory, so we can't
>> +have non-clearing IPL subcodes.
>> +
>> +Subcodes 8, 9, 10 will result in specification exceptions.
>> +Re-IPL into a protected mode is only possible via a detour into non
>> +protected mode.
>=20
> So... what do we IPL from? Is there still a need for the bios?
>=20
> (Sorry, I'm a bit confused here.)
>=20

We load a blob via the bios (all methods are supported) and that blob
moves itself into protected mode. I.e. it has a small unprotected stub,
the rest is an encrypted kernel.


--0eaqKIZJY7E4vhohX80bisHlpRH7k8C1r--

--UkpeVgq64Ns7zUX2ap7pO00Qotpwdfnwg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3C/VIACgkQ41TmuOI4
ufjACRAAn4Hi4ahrXID5AM+f3hiLUL//qDnl9PPan5AhmPYoTWGeiZzntLmKGJ6s
n6YAUT5tEWB3z3oCpQuAGs1h+AdNMSv98jYEQ0FweJjQTHKfesa2nqMaLKV8DOaH
rHXLzdGv0lXhdNsgwvH2nFQ5ukTboSjs8NY5BazYDkGl6wfcvaHpjDJcXavalNP/
+YRKSKJVI/XDtLH0PTZlk1oismSx8X+Alh7rteHhfvmvfa6DBRICqi7KYMhIpndV
tlcIqBtBwvDWdFvJi5FNmPvyZVS3flPa7/C8VXEZJAG+cDDfye3hXyfIwpmJqATn
KQ89o/CcekLYcJ0+KESad7+/qwoUjfl+hUJg/qcUSLiwNrWaikHZUUfIGPwk+Eor
zSbdvMw90P5b43hJVWJEKMk8xeUQDMQrmcLR1YQ88T1pvR5+us7XIqR3fOf13khp
HtFbYL/q8PztHlGppTFu8Td+StDEZD9oDulr3Vdr43MSAwulyUQpAYsEj+0Qvgxr
MOupSjJu4RlUevQOCnLyG/nBIiNbOe+0GkWjfaNXBCTMApRWRfCHKiC7+vxqS+0n
7514Ay+FNBSJUdugGQbe60Av3nyy7DoXDwenG44YHdxY6ylRzDWhZ1Wyc6BIeApX
+PiigDuBfCR3DDJ8kqp1HlJbAv6DBt5OXDrK6uM5CrUwyxA1h0o=
=0+ZY
-----END PGP SIGNATURE-----

--UkpeVgq64Ns7zUX2ap7pO00Qotpwdfnwg--

