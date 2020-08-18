Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654FC2485F1
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 15:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHRNUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 09:20:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726513AbgHRNU2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 09:20:28 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ID0VUi126184;
        Tue, 18 Aug 2020 09:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=+66YEWfV9N6Hx4ObsPkq81y32C103b1EJaIc7uoBcK8=;
 b=GvprVj/Id1u7XXgZvTkdKrSs+VI5tJUrYvosaMzxyUObELxyDLVQHih4v19axZYe44sH
 KC0NfZdNyNlyP3lpua/mqurdBzj3URXlzkM2QgaRFiVVMBJA5E/RirL5+MQbs6QuuIkW
 K1xL3v0dVEOmXX2VbliSykliRW5bPpVItcTv9XLUMaaj7BaY54BkH8S+SC+5uTVkPdsk
 GSjxekTFbNpMcnsFR23pm4dW3XMcBDjGbcXLQS4NKPrNQVtEJOJ4G3OA+PDfnme502w4
 na9C2AwhjjPIsXWhh+P+E09cc+kaFsz/qHwMhJTym00ZK+/6SJjWAmJZVLWeiGjgP8pI LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3304t1htkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:20:25 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07ID4n37145672;
        Tue, 18 Aug 2020 09:20:25 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3304t1htk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:20:25 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07IDKBVB031793;
        Tue, 18 Aug 2020 13:20:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3304bbrdr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 13:20:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07IDKKXI26280432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 13:20:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD3B3AE058;
        Tue, 18 Aug 2020 13:20:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54333AE051;
        Tue, 18 Aug 2020 13:20:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.189.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 13:20:20 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: add Protected VM support
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
 <20200818130424.20522-5-mhartmay@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ad9ded3b-c593-16cb-2077-978c773d43e6@linux.ibm.com>
Date:   Tue, 18 Aug 2020 15:20:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200818130424.20522-5-mhartmay@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="z5yMgHqUQCHUKRJV3dHuBiMKqPXckBF0D"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--z5yMgHqUQCHUKRJV3dHuBiMKqPXckBF0D
Content-Type: multipart/mixed; boundary="3dwu7McOiRDNFOoe5xnUyLMciYoHny5AL"

--3dwu7McOiRDNFOoe5xnUyLMciYoHny5AL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/18/20 3:04 PM, Marc Hartmayer wrote:
> Add support for Protected Virtual Machine (PVM) tests. For starting a
> PVM guest we must be able to generate a PVM image by using the
> `genprotimg` tool from the s390-tools collection. This requires the
> ability to pass a machine-specific host-key document, so the option
> `--host-key-document` is added to the configure script.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

I like that solution a lot, it's easy to add the parmline, the host key
document is configured once and the tests are run as default if they
have been created. It's everything that I wished for.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  configure               |  9 +++++++++
>  s390x/Makefile          | 17 +++++++++++++++--
>  s390x/selftest.parmfile |  1 +
>  s390x/unittests.cfg     |  1 +
>  scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
>  5 files changed, 61 insertions(+), 2 deletions(-)
>  create mode 100644 s390x/selftest.parmfile
>  create mode 100644 scripts/s390x/func.bash
>=20
> diff --git a/configure b/configure
> index f9d030fd2f03..0e64af58b3c1 100755
> --- a/configure
> +++ b/configure
> @@ -18,6 +18,7 @@ u32_long=3D
>  vmm=3D"qemu"
>  errata_force=3D0
>  erratatxt=3D"$srcdir/errata.txt"
> +host_key_document=3D
> =20
>  usage() {
>      cat <<-EOF
> @@ -40,6 +41,9 @@ usage() {
>  	                           no environ is provided by the user (enable=
d by default)
>  	    --erratatxt=3DFILE       specify a file to use instead of errata.=
txt. Use
>  	                           '--erratatxt=3D' to ensure no file is used=
=2E
> +	    --host-key-document=3DHOST_KEY_DOCUMENT
> +	                           Specify the machine-specific host-key docu=
ment for creating
> +	                           a PVM image with 'genprotimg' (s390x only)=

>  EOF
>      exit 1
>  }
> @@ -92,6 +96,9 @@ while [[ "$1" =3D -* ]]; do
>  	    erratatxt=3D
>  	    [ "$arg" ] && erratatxt=3D$(eval realpath "$arg")
>  	    ;;
> +	--host-key-document)
> +	    host_key_document=3D"$arg"
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -205,6 +212,8 @@ PRETTY_PRINT_STACKS=3D$pretty_print_stacks
>  ENVIRON_DEFAULT=3D$environ_default
>  ERRATATXT=3D$erratatxt
>  U32_LONG_FMT=3D$u32_long
> +GENPROTIMG=3D${GENPROTIMG-genprotimg}
> +HOST_KEY_DOCUMENT=3D$host_key_document
>  EOF
> =20
>  cat <<EOF > lib/config.h
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 0f54bf43bfb7..cd4e270952ec 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -18,12 +18,19 @@ tests +=3D $(TEST_DIR)/skrf.elf
>  tests +=3D $(TEST_DIR)/smp.elf
>  tests +=3D $(TEST_DIR)/sclp.elf
>  tests +=3D $(TEST_DIR)/css.elf
> -tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
> =20
> -all: directories test_cases test_cases_binary
> +tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
> +ifneq ($(HOST_KEY_DOCUMENT),)
> +tests_pv_binary =3D $(patsubst %.bin,%.pv.bin,$(tests_binary))
> +else
> +tests_pv_binary =3D
> +endif
> +
> +all: directories test_cases test_cases_binary test_cases_pv
> =20
>  test_cases: $(tests)
>  test_cases_binary: $(tests_binary)
> +test_cases_pv: $(tests_pv_binary)
> =20
>  CFLAGS +=3D -std=3Dgnu99
>  CFLAGS +=3D -ffreestanding
> @@ -72,6 +79,12 @@ FLATLIBS =3D $(libcflat)
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
> =20
> +%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.b=
in,%.parmfile,$@)
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(p=
atsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
> +
> +%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --=
image $< -o $@
> +
>  arch_clean: asm_offsets_clean
>  	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
> =20
> diff --git a/s390x/selftest.parmfile b/s390x/selftest.parmfile
> new file mode 100644
> index 000000000000..5613931aa5c6
> --- /dev/null
> +++ b/s390x/selftest.parmfile
> @@ -0,0 +1 @@
> +test 123
> \ No newline at end of file
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 0f156afbe741..12f6fb613995 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -21,6 +21,7 @@
>  [selftest-setup]
>  file =3D selftest.elf
>  groups =3D selftest
> +# please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.par=
mfile
>  extra_params =3D -append 'test 123'
> =20
>  [intercept]
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> new file mode 100644
> index 000000000000..b2d59d0d6f25
> --- /dev/null
> +++ b/scripts/s390x/func.bash
> @@ -0,0 +1,35 @@
> +# The file scripts/common.bash has to be the only file sourcing this
> +# arch helper file
> +source config.mak
> +
> +ARCH_CMD=3Darch_cmd_s390x
> +
> +function arch_cmd_s390x()
> +{
> +	local cmd=3D$1
> +	local testname=3D$2
> +	local groups=3D$3
> +	local smp=3D$4
> +	local kernel=3D$5
> +	local opts=3D$6
> +	local arch=3D$7
> +	local check=3D$8
> +	local accel=3D$9
> +	local timeout=3D${10}
> +
> +	# run the normal test case
> +	"$cmd" "${testname}" "$groups" "$smp" "$kernel" "$opts" "$arch" "$che=
ck" "$accel" "$timeout"
> +
> +	# run PV test case
> +	kernel=3D${kernel%.elf}.pv.bin
> +	if [ ! -f "${kernel}" ]; then
> +		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
> +			print_result 'SKIP' $testname '(no host-key document specified)'
> +			return 2
> +		fi
> +
> +		print_result 'SKIP' $testname '(PVM image was not created)'
> +		return 2
> +	fi
> +	"$cmd" "${testname}_PV" "$groups pv" "$smp" "$kernel" "$opts" "$arch"=
 "$check" "$accel" "$timeout"
> +}
>=20



--3dwu7McOiRDNFOoe5xnUyLMciYoHny5AL--

--z5yMgHqUQCHUKRJV3dHuBiMKqPXckBF0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl871ZMACgkQ41TmuOI4
ufgNzQ/9HSYTWZUcCm1ExdB9iGryZ6PCHbXI2SN2YHDTQQToEy1+Mb/7LpcBTrec
bCsDII+0eRl7fT9ac7PdmJ5lGw/X8emI/YTeRysLWQUMQZz13wEo3Lha5LdH1q+5
l/HASa9BXiUGOYct0L997qWY5AYRlIc0hKsoHBBeixetSo6K7iRueiwXWY0x08xf
jLUv4FiggBHNIt5jCh3dV9JgABiu6JsYr1VcTfJzxAVsXwDcFZsiEArQBfnOgARG
LovN4iNq4jPMex4Sz0LAxpR6yEnkCcIHVYc5i1j3D5jhbe2FYOzRCAEaQipm2xBx
/aXPfFkg/33yZMVzgQN8fa2g6FP1ZA+50efBjLe1/yvAhf6BnwG1uOEB6Jou/xLp
QZSOxuG4PHSGX41mSxKVM29loEig36z8zc7Z5ARn7NtAqeWtAaCzuqKy4QCq275P
7iVBsFd/om2kDngMxUA1xppTh2P+XYo07aTisse29RgexzLUwFEv+8mNbQdCZkXZ
E/IE9s/kn1/t2ZtwHWxK0K60jf05JeJh5SB/KdM3RQloezAoCaQQ4mrS8L1fbGBg
rS/rP5Zld5ZXEAh9Tu6TWcomsURVZIBIc9/uEivK9xWuLO7MDArg8Rh5qFJIH5i0
azbTtzLtJEd4W/CdDdCHIcqgV4ZywHIqBOToi7P1E0Lsy23BCU0=
=QfBU
-----END PGP SIGNATURE-----

--z5yMgHqUQCHUKRJV3dHuBiMKqPXckBF0D--

