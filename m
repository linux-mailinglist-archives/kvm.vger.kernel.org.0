Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2EC1C72C0
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 16:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgEFO0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 10:26:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728854AbgEFO0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 10:26:44 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046EALXD006592;
        Wed, 6 May 2020 10:26:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v9adkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 10:26:42 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 046EB8gK011746;
        Wed, 6 May 2020 10:26:42 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v9adjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 10:26:42 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 046EPOxw005125;
        Wed, 6 May 2020 14:26:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5scam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 14:26:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 046EQbvQ54264202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 14:26:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21E1F11C05E;
        Wed,  6 May 2020 14:26:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4B1A11C050;
        Wed,  6 May 2020 14:26:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.51.179])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 14:26:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests RFC] s390x: Add Protected VM support
To:     David Hildenbrand <david@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
References: <20200506124636.21876-1-mhartmay@linux.ibm.com>
 <ad0d5c9d-bde2-2143-0440-d47d6e28bb29@linux.ibm.com>
 <9d13ba18-fede-20fc-7b04-b6b0933971d1@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2021f2d0-be0d-7ff9-d493-58bb7136d68e@linux.ibm.com>
Date:   Wed, 6 May 2020 16:26:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9d13ba18-fede-20fc-7b04-b6b0933971d1@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X5ireeRFu3YW5kh2IIHsykcP81Yxw5UtW"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_07:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X5ireeRFu3YW5kh2IIHsykcP81Yxw5UtW
Content-Type: multipart/mixed; boundary="qD4vhBbivWIZmbGPbSnNIPynlruS7KG3C"

--qD4vhBbivWIZmbGPbSnNIPynlruS7KG3C
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/6/20 4:05 PM, David Hildenbrand wrote:
> On 06.05.20 16:03, Janosch Frank wrote:
>> On 5/6/20 2:46 PM, Marc Hartmayer wrote:
>>> Add support for Protected Virtual Machine (PVM) tests. For starting a=

>>> PVM guest we must be able to generate a PVM image by using the
>>> `genprotimg` tool from the s390-tools collection. This requires the
>>> ability to pass a machine-specific host-key document, so the option
>>> `--host-key-document` is added to the configure script.
>>>
>>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>>> ---
>>>  .gitignore          |  1 +
>>>  configure           |  8 ++++++++
>>>  s390x/Makefile      | 16 +++++++++++++---
>>>  s390x/unittests.cfg | 20 ++++++++++++++++++++
>>>  scripts/common.bash | 30 +++++++++++++++++++++++++++++-
>>>  5 files changed, 71 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/.gitignore b/.gitignore
>>> index 784cb2ddbcb8..1fa5c0c0ea76 100644
>>> --- a/.gitignore
>>> +++ b/.gitignore
>>> @@ -4,6 +4,7 @@
>>>  *.o
>>>  *.flat
>>>  *.elf
>>> +*.img
>>>  .pc
>>>  patches
>>>  .stgit-*
>>> diff --git a/configure b/configure
>>> index 5d2cd90cd180..29191f4b0994 100755
>>> --- a/configure
>>> +++ b/configure
>>> @@ -18,6 +18,7 @@ u32_long=3D
>>>  vmm=3D"qemu"
>>>  errata_force=3D0
>>>  erratatxt=3D"errata.txt"
>>> +host_key_document=3D
>>> =20
>>>  usage() {
>>>      cat <<-EOF
>>> @@ -40,6 +41,8 @@ usage() {
>>>  	                           no environ is provided by the user (enab=
led by default)
>>>  	    --erratatxt=3DFILE       specify a file to use instead of errat=
a.txt. Use
>>>  	                           '--erratatxt=3D' to ensure no file is us=
ed.
>>> +	    --host-key-document=3DHOST_KEY_DOCUMENT
>>> +	                           host-key-document to use (s390x only)
>>>  EOF
>>>      exit 1
>>>  }
>>> @@ -91,6 +94,9 @@ while [[ "$1" =3D -* ]]; do
>>>  	--erratatxt)
>>>  	    erratatxt=3D"$arg"
>>>  	    ;;
>>> +	--host-key-document)
>>> +	    host_key_document=3D"$arg"
>>> +	    ;;
>>>  	--help)
>>>  	    usage
>>>  	    ;;
>>> @@ -207,6 +213,8 @@ PRETTY_PRINT_STACKS=3D$pretty_print_stacks
>>>  ENVIRON_DEFAULT=3D$environ_default
>>>  ERRATATXT=3D$erratatxt
>>>  U32_LONG_FMT=3D$u32_long
>>> +GENPROTIMG=3Dgenprotimg
>>> +HOST_KEY_DOCUMENT=3D$host_key_document
>>>  EOF
>>> =20
>>>  cat <<EOF > lib/config.h
>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>> index ddb4b48ecbf9..a57655dcce10 100644
>>> --- a/s390x/Makefile
>>> +++ b/s390x/Makefile
>>> @@ -17,12 +17,19 @@ tests +=3D $(TEST_DIR)/stsi.elf
>>>  tests +=3D $(TEST_DIR)/skrf.elf
>>>  tests +=3D $(TEST_DIR)/smp.elf
>>>  tests +=3D $(TEST_DIR)/sclp.elf
>>> -tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>>> =20
>>> -all: directories test_cases test_cases_binary
>>> +tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>>> +ifneq ($(HOST_KEY_DOCUMENT),)
>>> +tests_pv_img =3D $(patsubst %.elf,%.pv.img,$(tests))
>>> +else
>>> +tests_pv_img =3D
>>> +endif
>>> +
>>> +all: directories test_cases test_cases_binary test_cases_pv
>>> =20
>>>  test_cases: $(tests)
>>>  test_cases_binary: $(tests_binary)
>>> +test_cases_pv: $(tests_pv_img)
>>> =20
>>>  CFLAGS +=3D -std=3Dgnu99
>>>  CFLAGS +=3D -ffreestanding
>>> @@ -68,8 +75,11 @@ FLATLIBS =3D $(libcflat)
>>>  %.bin: %.elf
>>>  	$(OBJCOPY) -O binary  $< $@
>>> =20
>>> +%.pv.img: %.bin $(HOST_KEY_DOCUMENT)
>>> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify =
--image $< -o $@
>>> +
>>>  arch_clean: asm_offsets_clean
>>> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
>>> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,img} $(TEST_DIR)/.*.d lib/s390x/.*.d=

>>> =20
>>>  generated-files =3D $(asm-offsets)
>>>  $(tests:.elf=3D.o) $(cstart.o) $(cflatobjs): $(generated-files)
>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>>> index b307329354f6..6beaca45fb20 100644
>>> --- a/s390x/unittests.cfg
>>> +++ b/s390x/unittests.cfg
>>> @@ -16,6 +16,8 @@
>>>  #			 # a test. The check line can contain multiple files
>>>  #			 # to check separated by a space but each check
>>>  #			 # parameter needs to be of the form <path>=3D<value>
>>> +# pv_support =3D 0|1       # Optionally specify whether a test suppo=
rts the
>>> +#                        # execution as a PV guest.
>>>  ####################################################################=
##########
>>> =20
>>>  [selftest-setup]
>>> @@ -25,62 +27,80 @@ extra_params =3D -append 'test 123'
>>> =20
>>>  [intercept]
>>>  file =3D intercept.elf
>>> +pv_support =3D 1
>>
>> So, let's do this discussion once more:
>> Why would we need a opt-in for something which works on all our curren=
t
>> tests? I'd much rather have a opt-out or just a bail-out when running
>> the test like I already implemented for the storage key related tests.=
=2E.
>>
>> I don't see any benefit for this right now other than forcing me to ad=
d
>> another line to this file that was not needed before..
>>
>=20
> Exactly my thought. I would assume that most tests that properly test
> for feature availability should just work?
>=20

Yes
At the beginning of firmware development it was sometimes necessary to
blacklist some tests, but now all of them run or bail-out.


--qD4vhBbivWIZmbGPbSnNIPynlruS7KG3C--

--X5ireeRFu3YW5kh2IIHsykcP81Yxw5UtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6yyRwACgkQ41TmuOI4
ufhhvRAAsEIklpgCpzdsxZv7XrUPz+OQeERqMrtcbP9q+f8PHDWeC2sKEhS8KK/+
qWS1vlcA1Ak8xOdqKF8hGVF8Gkc6Gw9rm5QneKuVYCaUoTp+MrO6TkEQaZEXWCNF
TemKC5A4ueXhljfJN/wR/d0IFA/zSO/1wKNU8H150vEshXWf3Nn/o4gXekHPqXnx
HeoKtGx1Kqj+u8iZEdyhLK8hxqR7CArPzRGS0zdcOrrgO21U9AQeM3/L7LyzikjK
91CWgyW49yZANzUwNNfHPGKFm7OKnWJXcyybSMs08tokhEZ/UdVeO2/IAMUn/qZV
n+WXxccKH1aMn4RV16R7aGDauE6O/0mXTZirwqCU4xdzYbl9elicnSJ02omRjjIl
KYn+pgv8vGjACR6BUc9cYFiuIwycPo13Vt0YXw1+xKYybpX0OqHUH1O/p+eLrDeR
hxRm0kcpQPjZ195ZLmy8JaOleHWTnzo1iVl11R0QEj35bOZNoZ8uAxL5pzI5+3OC
najSBXHqHE61crCo/hn8HNjKm7Q8EkQ9Fgz52v8DnRT23zLjUxdwN+7Q7meKiMNe
VxkHGJ31Q8y8zRj9b+AXe7qu3PZ2uXnVrxjbEgYbE2jpBgwDu0zU1NKJb5BWVxEM
C3cgdPjVkrqOZsZBPgDLdwQj0JUJbUeASrf2oFnqb6BAw/bGMAw=
=iY7/
-----END PGP SIGNATURE-----

--X5ireeRFu3YW5kh2IIHsykcP81Yxw5UtW--

