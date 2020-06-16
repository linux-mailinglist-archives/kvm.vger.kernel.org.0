Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0C21FBA11
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732091AbgFPQIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:08:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731390AbgFPQIW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 12:08:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GG7YI1088169;
        Tue, 16 Jun 2020 12:08:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q0qj9dww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 12:08:21 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GG7dEA088753;
        Tue, 16 Jun 2020 12:08:21 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q0qj9duq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 12:08:20 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GG1lMD029595;
        Tue, 16 Jun 2020 16:08:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 31mpe828y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 16:08:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GG6wFN65405328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 16:06:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F16D4C052;
        Tue, 16 Jun 2020 16:08:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FD524C04A;
        Tue, 16 Jun 2020 16:08:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.26.88])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jun 2020 16:08:14 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 01/12] s390x: Use PSW bits definitions
 in cstart
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-2-git-send-email-pmorel@linux.ibm.com>
 <f160d328-694a-4476-4863-c49a1d0e5349@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <eebf1927-f1b2-cca0-529a-9a97c761345d@linux.ibm.com>
Date:   Tue, 16 Jun 2020 18:08:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f160d328-694a-4476-4863-c49a1d0e5349@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_07:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 cotscore=-2147483648 mlxlogscore=867
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006160110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-16 15:13, Thomas Huth wrote:
> On 15/06/2020 11.31, Pierre Morel wrote:
>> This patch defines the PSW bits EA/BA used to initialize the PSW masks
>> for exceptions.

...snip...

>>   svc_int_psw:
>> -	.quad	0x0000000180000000, svc_int
>> +	.quad	PSW_MASK_ON_EXCEPTION, svc_int
>>   initial_cr0:
>>   	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
>>   	.quad	0x0000000000040000
>>
> 
> I'm afraid, by when I compile this on RHEL7, the toolchain complains:
> 
> s390x/cstart64.S: Assembler messages:
> s390x/cstart64.S:239: Error: found 'L', expected: ')'
> s390x/cstart64.S:239: Error: junk at end of line, first unrecognized
...snip...
> character is `L'
> s390x/cstart64.S:254: Error: junk at end of line, first unrecognized
> character is `L'
> 
> Shall we skip the update to the assembler file for now?

I think it is the best to do to go rapidly forward.

alternative:
I propose a local macro for the PSW_MASK_ON_EXCEPTION and 
PSW_MASK_SHORT_PSW inside the assembler in the respin, put it at the end 
of the serie and we choose if we keep the changes of csstart.S

this would not slow us.

Should I keep your RB for the arch_def.h ?

thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
