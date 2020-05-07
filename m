Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3521C8BD9
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 15:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgEGNPC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 7 May 2020 09:15:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGNPC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 09:15:02 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 047D3jDq179160;
        Thu, 7 May 2020 09:15:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2g59kfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 09:15:00 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 047D9f2e024464;
        Thu, 7 May 2020 09:15:00 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2g59kew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 09:15:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 047DA4Hp027080;
        Thu, 7 May 2020 13:14:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5ud0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 13:14:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 047DEtFl65339848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 May 2020 13:14:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07767AE045;
        Thu,  7 May 2020 13:14:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 899B8AE053;
        Thu,  7 May 2020 13:14:54 +0000 (GMT)
Received: from marcibm (unknown [9.145.33.209])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 May 2020 13:14:54 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC] s390x: Add Protected VM support
In-Reply-To: <20200506135016.ml3k73siokhltyl5@kamzik.brq.redhat.com>
References: <20200506124636.21876-1-mhartmay@linux.ibm.com> <20200506135016.ml3k73siokhltyl5@kamzik.brq.redhat.com>
Date:   Thu, 07 May 2020 15:14:53 +0200
Message-ID: <871rnv7upe.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_07:2020-05-07,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=1 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 03:50 PM +0200, Andrew Jones <drjones@redhat.com> wrote:
> On Wed, May 06, 2020 at 02:46:36PM +0200, Marc Hartmayer wrote:
>> Add support for Protected Virtual Machine (PVM) tests. For starting a
>> PVM guest we must be able to generate a PVM image by using the
>> `genprotimg` tool from the s390-tools collection. This requires the
>> ability to pass a machine-specific host-key document, so the option
>> `--host-key-document` is added to the configure script.
>> 
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>> @@ -16,6 +16,8 @@
>>  #			 # a test. The check line can contain multiple files
>>  #			 # to check separated by a space but each check
>>  #			 # parameter needs to be of the form <path>=<value>
>> +# pv_support = 0|1       # Optionally specify whether a test supports the
>> +#                        # execution as a PV guest.
>
> Maybe pv_supported vs. pv_support?

pv_supported is better, thanks.

>>  
>>  	exec {fd}<"$unittests"
>>  
>>  	while read -r -u $fd line; do
>>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>> -			"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"

This line was accidentally removed.

>> +			if [ "${pv_support}" == 1 ]; then
>> +				pv_cmd "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>> +			fi
>> +
>>  			testname=${BASH_REMATCH[1]}
>>  			smp=1
>>  			kernel=""
>> @@ -27,6 +48,7 @@ function for_each_unittest()
>>  			check=""
>>  			accel=""
>>  			timeout=""
>> +			pv_support=""
>>  		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
>>  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
>> @@ -43,8 +65,14 @@ function for_each_unittest()
>>  			accel=${BASH_REMATCH[1]}
>>  		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
>>  			timeout=${BASH_REMATCH[1]}
>> +		elif [[ $line =~ ^pv_support\ *=\ *(.*)$ ]]; then
>> +			pv_support=${BASH_REMATCH[1]}
>>  		fi
>>  	done
>> +
>>  	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>> +	if [ "${pv_support}" == 1 ]; then
>> +		pv_cmd "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>> +	fi
>>  	exec {fd}<&-
>>  }
>> -- 
>> 2.17.0
>>
>
> I don't think making the changes to scripts/common.bash will work for
> standalone tests.

With the fix above it works (tested on x86 and s390x).

$ make standalone
Written tests/selftest-setup.
Written tests/intercept.
Written tests/intercept_PV.
Written tests/emulator.
Written tests/emulator_PV.
Written tests/sieve.
Written tests/sieve_PV.
…

> Why not do this stuff in s390x/run instead?

I will try.

> Also,
> do you need the pv_support[ed] parameter? You could just do a
> [ -f "${kernel%.elf}.pv.img" ] to decide if you should run again
> with PV, right?

AFAIK, for the other test cases the kernel file is also not checked, but
this would be an option - thanks.

>
> Thanks,
> drew
>

Thanks for the feedback!

-- 
Kind regards / Beste Grüße
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen 
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
