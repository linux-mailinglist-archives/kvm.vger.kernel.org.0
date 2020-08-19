Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA05249BF7
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 13:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgHSLjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 07:39:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20378 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgHSLi6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 07:38:58 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JBVeu1195757;
        Wed, 19 Aug 2020 07:38:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=H/oelVxsYS6fc603BplK1hAr8NXSMDvKfY9BTGnGuxc=;
 b=PUsPN2DODj4/Rrxfzu1LeJ+atddYjxH8UKjOsrgtgBhrijrW6uIniu/secq9oir7Dz+k
 d+L3kKbbirrnhCpiqCYVz++XUBsd4YnM5Jmlh8+dqUR+aJGUJ5q+LuWTuKfHbVZOZ7St
 +kUGEYv2JWHyX7ZDt8jopOr/QFytVa+150iRw/6T7voQWcQHgaGgP3jpGQ+Aba+EKnH9
 mtojrsRRjr3HcD6fTL3gEUQxj3eAaHj9c/4hFBp8znGgQ3kYxeNIRGr3NjOyRONcozI0
 kEwy7Oe0GFMJtH2B/7ydv0yIjaQUQi6SBeo7S9OzKeGX1XSZfQ6COqWSAnuhWiM+mE1m Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304ru75fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 07:38:57 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07JBVc5H195555;
        Wed, 19 Aug 2020 07:38:56 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304ru75ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 07:38:56 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JBW6QA016829;
        Wed, 19 Aug 2020 11:38:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 330tbvrfsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 11:38:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JBcoBO24445288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 11:38:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCC70A405C;
        Wed, 19 Aug 2020 11:38:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 448B5A405B;
        Wed, 19 Aug 2020 11:38:50 +0000 (GMT)
Received: from marcibm (unknown [9.145.51.222])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Aug 2020 11:38:50 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: add Protected VM support
In-Reply-To: <20200819123443.2287abc3.cohuck@redhat.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com> <20200818130424.20522-5-mhartmay@linux.ibm.com> <20200819123443.2287abc3.cohuck@redhat.com>
Date:   Wed, 19 Aug 2020 13:38:49 +0200
Message-ID: <87r1s2sw52.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_04:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=2 phishscore=0 spamscore=0
 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 12:34 PM +0200, Cornelia Huck <cohuck@redhat.com> w=
rote:
> On Tue, 18 Aug 2020 15:04:24 +0200
> Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>
>> Add support for Protected Virtual Machine (PVM) tests. For starting a
>> PVM guest we must be able to generate a PVM image by using the
>> `genprotimg` tool from the s390-tools collection. This requires the
>> ability to pass a machine-specific host-key document, so the option
>> `--host-key-document` is added to the configure script.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  configure               |  9 +++++++++
>>  s390x/Makefile          | 17 +++++++++++++++--
>>  s390x/selftest.parmfile |  1 +
>>  s390x/unittests.cfg     |  1 +
>>  scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
>>  5 files changed, 61 insertions(+), 2 deletions(-)
>>  create mode 100644 s390x/selftest.parmfile
>>  create mode 100644 scripts/s390x/func.bash
>
> (...)
>
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
>> +	"$cmd" "${testname}" "$groups" "$smp" "$kernel" "$opts" "$arch" "$chec=
k" "$accel" "$timeout"
>> +
>> +	# run PV test case
>> +	kernel=3D${kernel%.elf}.pv.bin
>> +	if [ ! -f "${kernel}" ]; then
>> +		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
>> +			print_result 'SKIP' $testname '(no host-key document specified)'
>> +			return 2
>> +		fi
>> +
>> +		print_result 'SKIP' $testname '(PVM image was not created)'
>
> When can that happen? Don't we already fail earlier if we specified a
> host key document, but genprotimg does not work?

./configure
make -j
./configure --host-key-document=3D=E2=80=A6
./run_tests.sh

A contrived example, but=E2=80=A6

>
>> +		return 2
>> +	fi
>> +	"$cmd" "${testname}_PV" "$groups pv" "$smp" "$kernel" "$opts" "$arch" =
"$check" "$accel" "$timeout"
>> +}
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
