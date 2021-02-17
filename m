Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1763F31DD9A
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhBQQrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:47:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60350 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233986AbhBQQrD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:47:03 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HGXifq029905;
        Wed, 17 Feb 2021 11:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qm4KK/xRpXnLHX8hdWM/BnjzFFuIgNTkaPz5F6Yh+Dc=;
 b=ggv6bcdVQ++Lrls6RSr1khq8Y6MmSivo9/cSrvz6jJxFbpUXPQq9cu862q6aYHUzKpaU
 5tn2xzOJrZPWnerCu3IOxuBApENDriRwz3+CS8Zr8doM28k4QYej+pdkaq2nhE9sEpbB
 mMYGWAjghqOvzGRinqI5AavgrdSueEeHO/vKYaJLeEAo6mfyoeuFUSJMPvHmbAS0LBGG
 i2vFcOG06japlKY9R9HttB5FvpAgLJ6BqvCESzM69/ABWxLf8MLAK7zAKAttsRC5EuAF
 APmTAGj4scqBltEaty9oE9ygSeFwJMionWHleL1x5xYh3ikPIRzDppRmbG51Qe/Yanjr aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s63t9m68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:46:22 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HGYdCI035198;
        Wed, 17 Feb 2021 11:46:21 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s63t9m53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:46:21 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HGRhAW011313;
        Wed, 17 Feb 2021 16:46:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 36p61hbv2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 16:46:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HGk4w335914218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 16:46:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3220C52050;
        Wed, 17 Feb 2021 16:46:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.64])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CCEBD52054;
        Wed, 17 Feb 2021 16:46:15 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-9-frankja@linux.ibm.com>
 <4fd224a2-1c4d-1663-6615-685eadcf81f6@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 8/8] s390x: Remove SAVE/RESTORE_stack
Message-ID: <bd386faf-c635-970a-6be8-659f5f6b4ba8@linux.ibm.com>
Date:   Wed, 17 Feb 2021 17:46:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <4fd224a2-1c4d-1663-6615-685eadcf81f6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_13:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/21 5:18 PM, Thomas Huth wrote:
> On 17/02/2021 15.41, Janosch Frank wrote:
>> There are no more users.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/macros.S | 29 -----------------------------
>>   1 file changed, 29 deletions(-)
>>
>> diff --git a/s390x/macros.S b/s390x/macros.S
>> index 212a3823..399a87c6 100644
>> --- a/s390x/macros.S
>> +++ b/s390x/macros.S
>> @@ -28,35 +28,6 @@
>>   	lpswe	\old_psw
>>   	.endm
>>   
>> -	.macro SAVE_REGS
>> -	/* save grs 0-15 */
>> -	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
>> -	/* save crs 0-15 */
>> -	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
>> -	/* load a cr0 that has the AFP control bit which enables all FPRs */
>> -	larl	%r1, initial_cr0
>> -	lctlg	%c0, %c0, 0(%r1)
>> -	/* save fprs 0-15 + fpc */
>> -	la	%r1, GEN_LC_SW_INT_FPRS
>> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> -	std	\i, \i * 8(%r1)
>> -	.endr
>> -	stfpc	GEN_LC_SW_INT_FPC
>> -	.endm
>> -
>> -	.macro RESTORE_REGS
>> -	/* restore fprs 0-15 + fpc */
>> -	la	%r1, GEN_LC_SW_INT_FPRS
>> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> -	ld	\i, \i * 8(%r1)
>> -	.endr
>> -	lfpc	GEN_LC_SW_INT_FPC
> 
> Could we now also remove the sw_int_fprs and sw_int_fpc from the lowcore?
> 
>   Thomas
> 

git grep tells me that we can.
Do you want to have both the offset macro and the struct member removed
or only the macro?

We'll still need the grs and crs for the cpu setup in lib/s390x/smp.c
