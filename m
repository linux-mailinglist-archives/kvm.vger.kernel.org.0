Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1134527ADDA
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 14:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgI1Mdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 08:33:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20024 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgI1Mdm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 08:33:42 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08SCVdQt160300;
        Mon, 28 Sep 2020 08:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=G1DVJXFr4WvHlpOTlONUSxd1ko/r6djkXT5zeYuTE84=;
 b=d3gb2gesgNxdky5zHWBWTeT0pcaXyfkp5HaOwKUkN+r2KbpE6vJ2shCowiRMLAEHdomW
 tGiqKMEv/9hgo8FzhQb7IlFFeD6PZir8pK3CamjzCf3N1MQd+X6EvUHVGDtolkrZrmMW
 2wHxYyR7XuDlkrjC5eprhyVX9xHrfmAyONgG82umqO9Nhb3S9NtzBD9Y0XDuG695M4O6
 2jb7mS+jxWI/iN5tL4Ab9YBpM2BDQK9Tifl2TuAQ34uNRIUAnoumT8KI2A+lVyAqwpJ+
 6QeRZRA5aku1B+Uw05wujGNSuswVAkDICOcBpJxu+edXyRtEFFCnogpb2T6Xr2yOMIWe 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ufvnr2bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 08:33:40 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08SCXeFr166099;
        Mon, 28 Sep 2020 08:33:40 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ufvnr2b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 08:33:40 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08SCSaEo019958;
        Mon, 28 Sep 2020 12:33:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 33sw98137c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 12:33:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08SCXZmt7864704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 12:33:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 517B84204B;
        Mon, 28 Sep 2020 12:33:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD1F642042;
        Mon, 28 Sep 2020 12:33:34 +0000 (GMT)
Received: from marcibm (unknown [9.145.5.185])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Sep 2020 12:33:34 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v2 4/4] s390x: add Protected VM support
In-Reply-To: <bb13ff8d-de62-4da6-3f99-4ccc5d7386a8@redhat.com>
References: <20200923134758.19354-1-mhartmay@linux.ibm.com>
 <20200923134758.19354-5-mhartmay@linux.ibm.com>
 <bb13ff8d-de62-4da6-3f99-4ccc5d7386a8@redhat.com>
Date:   Mon, 28 Sep 2020 14:33:33 +0200
Message-ID: <871rimjd2a.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_11:2020-09-24,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 01:44 PM +0200, Thomas Huth <thuth@redhat.com> wrot=
e:
> On 23/09/2020 15.47, Marc Hartmayer wrote:
>> Add support for Protected Virtual Machine (PVM) tests. For starting a
>> PVM guest we must be able to generate a PVM image by using the
>> `genprotimg` tool from the s390-tools collection. This requires the
>> ability to pass a machine-specific host-key document, so the option
>> `--host-key-document` is added to the configure script.
>>=20
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  configure               |  9 +++++++++
>>  s390x/Makefile          | 17 +++++++++++++++--
>>  s390x/selftest.parmfile |  1 +
>>  s390x/unittests.cfg     |  1 +
>>  scripts/s390x/func.bash | 36 ++++++++++++++++++++++++++++++++++++
>>  5 files changed, 62 insertions(+), 2 deletions(-)
>>  create mode 100644 s390x/selftest.parmfile
>>  create mode 100644 scripts/s390x/func.bash
>>=20
>> diff --git a/configure b/configure
>> index f9305431a9cb..fe319233eb50 100755
>> --- a/configure
>> +++ b/configure
>> @@ -19,6 +19,7 @@ wa_divide=3D
>>  vmm=3D"qemu"
>>  errata_force=3D0
>>  erratatxt=3D"$srcdir/errata.txt"
>> +host_key_document=3D
>>=20=20
>>  usage() {
>>      cat <<-EOF
>> @@ -41,6 +42,9 @@ usage() {
>>  	                           no environ is provided by the user (enabled=
 by default)
>>  	    --erratatxt=3DFILE       specify a file to use instead of errata.t=
xt. Use
>>  	                           '--erratatxt=3D' to ensure no file is used.
>> +	    --host-key-document=3DHOST_KEY_DOCUMENT
>> +	                           Specify the machine-specific host-key docum=
ent for creating
>> +	                           a PVM image with 'genprotimg' (s390x only)
>>  EOF
>>      exit 1
>>  }
>> @@ -93,6 +97,9 @@ while [[ "$1" =3D -* ]]; do
>>  	    erratatxt=3D
>>  	    [ "$arg" ] && erratatxt=3D$(eval realpath "$arg")
>>  	    ;;
>> +	--host-key-document)
>> +	    host_key_document=3D"$arg"
>> +	    ;;
>>  	--help)
>>  	    usage
>>  	    ;;
>> @@ -224,6 +231,8 @@ ENVIRON_DEFAULT=3D$environ_default
>>  ERRATATXT=3D$erratatxt
>>  U32_LONG_FMT=3D$u32_long
>>  WA_DIVIDE=3D$wa_divide
>> +GENPROTIMG=3D${GENPROTIMG-genprotimg}
>> +HOST_KEY_DOCUMENT=3D$host_key_document
>>  EOF
>>=20=20
>>  cat <<EOF > lib/config.h
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index c2213ad92e0d..b079a26dffb7 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -19,12 +19,19 @@ tests +=3D $(TEST_DIR)/smp.elf
>>  tests +=3D $(TEST_DIR)/sclp.elf
>>  tests +=3D $(TEST_DIR)/css.elf
>>  tests +=3D $(TEST_DIR)/uv-guest.elf
>> -tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>>=20=20
>> -all: directories test_cases test_cases_binary
>> +tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>> +ifneq ($(HOST_KEY_DOCUMENT),)
>> +tests_pv_binary =3D $(patsubst %.bin,%.pv.bin,$(tests_binary))
>> +else
>> +tests_pv_binary =3D
>> +endif
>> +
>> +all: directories test_cases test_cases_binary test_cases_pv
>>=20=20
>>  test_cases: $(tests)
>>  test_cases_binary: $(tests_binary)
>> +test_cases_pv: $(tests_pv_binary)
>>=20=20
>>  CFLAGS +=3D -std=3Dgnu99
>>  CFLAGS +=3D -ffreestanding
>> @@ -73,6 +80,12 @@ FLATLIBS =3D $(libcflat)
>>  %.bin: %.elf
>>  	$(OBJCOPY) -O binary  $< $@
>>=20=20
>> +%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bi=
n,%.parmfile,$@)
>> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(pa=
tsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
>> +
>> +%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
>> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --i=
mage $< -o $@
>> +
>>  arch_clean: asm_offsets_clean
>>  	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
>>=20=20
>> diff --git a/s390x/selftest.parmfile b/s390x/selftest.parmfile
>> new file mode 100644
>> index 000000000000..5613931aa5c6
>> --- /dev/null
>> +++ b/s390x/selftest.parmfile
>> @@ -0,0 +1 @@
>> +test 123
>> \ No newline at end of file
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 6d50c634770f..3feb8bcaa13d 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -21,6 +21,7 @@
>>  [selftest-setup]
>>  file =3D selftest.elf
>>  groups =3D selftest
>> +# please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parm=
file
>>  extra_params =3D -append 'test 123'
>>=20=20
>>  [intercept]
>> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
>> new file mode 100644
>> index 000000000000..4eae5e916c61
>> --- /dev/null
>> +++ b/scripts/s390x/func.bash
>> @@ -0,0 +1,36 @@
>> +# The file scripts/common.bash has to be the only file sourcing this
>> +# arch helper file
>> +source config.mak
>> +
>> +ARCH_CMD=3Darch_cmd_s390x
>> +
>> +function arch_cmd_s390x()
>> +{
>> +	local cmd=3D$1
>> +	local testname=3D$2
>> +	local groups=3D$3
>> +	local smp=3D$4
>> +	local kernel=3D$5
>> +	local opts=3D$6
>> +	local arch=3D$7
>> +	local check=3D$8
>> +	local accel=3D$9
>> +	local timeout=3D${10}
>> +
>> +	# run the normal test case
>> +	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check"=
 "$accel" "$timeout"
>> +
>> +	# run PV test case
>> +	kernel=3D${kernel%.elf}.pv.bin
>> +	testname=3D${testname}_PV
>> +	if [ ! -f "${kernel}" ]; then
>> +		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
>> +			print_result 'SKIP' $testname '' 'no host-key document specified'
>
> I wonder whether we should not simply stay silent here ... ? Currently
> the output gets quite spoiled with a lot of these "no host-key document
> specified" messages when PV is not in use.
> If you agree, I could drop this line when picking up the patch (no need
> to respin just because of this).

Right=E2=80=A6 yes, please remove it - thanks!

>
>  Thomas
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
