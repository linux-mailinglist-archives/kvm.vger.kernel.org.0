Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC32EF92D3
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 15:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKLOii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 09:38:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727093AbfKLOii (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 09:38:38 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xACEbUvt136701
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 09:38:36 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w7w3y4g07-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 09:38:36 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 12 Nov 2019 14:38:34 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 12 Nov 2019 14:38:31 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xACEcT9054198496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 14:38:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9B69A4051;
        Tue, 12 Nov 2019 14:38:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54132A404D;
        Tue, 12 Nov 2019 14:38:29 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Nov 2019 14:38:29 +0000 (GMT)
Subject: Re: [RFC 01/37] DOCUMENTATION: protvirt: Protected virtual machine
 introduction
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-2-frankja@linux.ibm.com>
 <20191104151815.6f11a274.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 12 Nov 2019 15:38:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104151815.6f11a274.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cFb54glxZkpSyYvJMawuK0AVQOlXL9nup"
X-TM-AS-GCONF: 00
x-cbid: 19111214-0016-0000-0000-000002C3033B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111214-0017-0000-0000-0000332499AD
Message-Id: <d83e9ac1-c211-872c-25b0-183a139bd11e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=760 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911120131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cFb54glxZkpSyYvJMawuK0AVQOlXL9nup
Content-Type: multipart/mixed; boundary="npGzRwObC5rRZWhNpuPXe8h81aIy10Z5e"

--npGzRwObC5rRZWhNpuPXe8h81aIy10Z5e
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/4/19 3:18 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:23 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Introduction to Protected VMs.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  Documentation/virtual/kvm/s390-pv.txt | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>  create mode 100644 Documentation/virtual/kvm/s390-pv.txt
>>
>> diff --git a/Documentation/virtual/kvm/s390-pv.txt b/Documentation/vir=
tual/kvm/s390-pv.txt
>> new file mode 100644
>> index 000000000000..86ed95f36759
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/s390-pv.txt
>=20
> This should be under /virt/, I think. Also, maybe start out with RST
> already for new files?
>=20
>> @@ -0,0 +1,23 @@
>> +Ultravisor and Protected VMs
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>> +
>> +Summary:
>> +
>> +Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's stat=
e
>> +like guest memory and guest registers anymore. Instead the PVMs are
>=20
> s/Instead/Instead,/

Fixed

>=20
>> +mostly managed by a new entity called Ultravisor (UV), which provides=

>> +an API, so KVM and the PVM can request management actions.
>=20
> Hm...
>=20
> "The UV provides an API (both for guests and hypervisors), where PVMs
> and KVM can request management actions." ?

I applied your proposal, but removed the part in the brace, as it is
obvious from the words that follow.

>=20
>> +
>> +Each guest starts in the non-protected mode and then transitions into=

>=20
> "and then may make a request to transition into protected mode" ?

Sure

>=20
>> +protected mode. On transition KVM registers the guest and its VCPUs
>> +with the Ultravisor and prepares everything for running it.
>> +
>> +The Ultravisor will secure and decrypt the guest's boot memory
>> +(i.e. kernel/initrd). It will safeguard state changes like VCPU
>> +starts/stops and injected interrupts while the guest is running.
>> +
>> +As access to the guest's state, like the SIE state description is
>=20
> "such as the SIE state description," ?
>=20
>> +normally needed to be able to run a VM, some changes have been made i=
n
>> +SIE behavior and fields have different meaning for a PVM. SIE exits
>> +are minimized as much as possible to improve speed and reduce exposed=

>> +guest state.
>=20



--npGzRwObC5rRZWhNpuPXe8h81aIy10Z5e--

--cFb54glxZkpSyYvJMawuK0AVQOlXL9nup
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3Kw+UACgkQ41TmuOI4
ufh60BAAmp939Ydj/z/C9ZcICBj1gqmNrhV+bHBpSYHP4hUBAsk0q03/5iupb1vE
XFZC9K4I4k2aqOM9h6hE8gJNgrHCOWls3K6e7TxWvxFktZXEfcln1zMVLwCrXA19
POF5AN3C/5Afwp91M7hJxCB5QI4t22haW0yIOe/yUq69/euJIf/sqwB8+wOmSWKG
dZ+uVVK1zYEqSkksCEKTa3pskp5yCqwCjmv5OU9YyXIPI09PfrXLwZ81A1Up6GVV
0hojCtbMovYg9XgmHnMwvBeeGh0NhNeZFt1E9sbMlprw22nMfku7Uq5W87svva3i
bCHHmCByKUhLEmMCKH6OuavqqOvD8pfeAoEFfcmECMq7v+5aE/mMBXx+eMnZKkVk
UboVqPBvU93kfYSK+RWRdDGT6gRqVQ+dUHq6s/4cnIJLXrj9tcw740TNlevT1Jl/
togPmNxV/UJVRa9809wfCLgG6nEoDiPA4wBRqD0BwJPr/LfP1ecLLxgIWrej6jZ6
Ii7JcyBtIidLquihR0IVRFP6a5cXlYdNYLXz71F01w8bXiusqB4p6zo3nlR9IfPq
EHV10C+9qGgoqJfFgmKCoGoDktdPrKtFkVRmwE38VgqCaslE3nDA8+i54qu7L4lj
5qBcORgJoxMYfu3ir5Gij+TVBP4jbxUTAaUYCAfITzs2WlJsM7k=
=InlW
-----END PGP SIGNATURE-----

--cFb54glxZkpSyYvJMawuK0AVQOlXL9nup--

