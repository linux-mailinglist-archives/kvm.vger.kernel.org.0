Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF8A3D7505
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 14:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhG0M0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 08:26:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57242 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231945AbhG0M0X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 08:26:23 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RCA1nU112067;
        Tue, 27 Jul 2021 08:26:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6El7g2TSjD0AEc/u1X7g2qrGcACjAj8mtV94oT2TxSY=;
 b=ruZnAv8f8HECW5w7/MP9lZ9Q3bGB8YJA298T8vQyuyrCFIt5UMV5Byr+Ky5LtRQCLzdj
 Ukm8RcIqTtStRSQhVwNSlOzl5yM8Togep1yJFxqIxc4CRWW9NT+0XyviOEVasVOn6itG
 GVTzJ2NlDYIHZGmetixK6EloWa/nP7pVInPs+1ufrphu7IyD2nx3Nr/8z7nbf+Ovm/kg
 k1jnShFOSVLYDx5Ezts441sXSu6ungNy0+RRCaZzhzPM12VRvGGefILeAOCUuApNIkUb
 AXoBkKq5SVTmUHB3Pp7kOGZOQ3mx35ltp0PdV3v29gU6jfpe6m/8/VkTmDSIemFFaH/a iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hhns2uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:26:21 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16RCA77P113101;
        Tue, 27 Jul 2021 08:26:21 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hhns2u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:26:21 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16RCPWvD006723;
        Tue, 27 Jul 2021 12:26:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3a235pr8pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 12:26:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16RCNdhw21758408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 12:23:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20D7BAE045;
        Tue, 27 Jul 2021 12:26:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99457AE055;
        Tue, 27 Jul 2021 12:26:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.20.110])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 12:26:15 +0000 (GMT)
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20210706115459.372749-1-scgl@linux.ibm.com>
 <87v95jet9d.fsf@redhat.com>
 <e5a5fa4a-c5c4-e3f8-3229-9c8e70dffb45@linux.vnet.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception test
Message-ID: <70c1bf40-644d-dfa2-e256-2065ede545bb@linux.ibm.com>
Date:   Tue, 27 Jul 2021 14:26:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e5a5fa4a-c5c4-e3f8-3229-9c8e70dffb45@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q-ADN7C_kizON6UGCkGVoHhbHLJJFNdh
X-Proofpoint-ORIG-GUID: 0N51fKi8lMu8Pv8OULttBgGLVFhgNpyj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_07:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/9/21 4:22 PM, Janis Schoetterl-Glausch wrote:
> On 7/9/21 11:22 AM, Cornelia Huck wrote:
>> On Tue, Jul 06 2021, Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
>>
>>> Generate specification exceptions and check that they occur.
>>> Also generate specification exceptions during a transaction,
>>> which results in another interruption code.
>>> With the iterations argument one can check if specification
>>> exception interpretation occurs, e.g. by using a high value and
>>> checking that the debugfs counters are substantially lower.
>>> The argument is also useful for estimating the performance benefit
>>> of interpretation.
>>>
>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>> ---
>>>  s390x/Makefile           |   1 +
>>>  lib/s390x/asm/arch_def.h |   1 +
>>>  s390x/spec_ex.c          | 344 +++++++++++++++++++++++++++++++++++++++
>>>  s390x/unittests.cfg      |   3 +
>>>  4 files changed, 349 insertions(+)
>>>  create mode 100644 s390x/spec_ex.c
>>
>> (...)
>>
>>> +static void lpsw(uint64_t psw)
>>
>> Maybe call this load_psw(), as you do a bit more than a simple lpsw?
> 
> [...]
> 
>> The indentation looks a bit funny here.
> 
> [...]
> 
>> Here as well.
> 
> Ok, will fix.
>>
>>> +}
>>
>> (...)
>>
>>> +#define report_info_if(cond, fmt, ...)			\
>>> +	do {						\
>>> +		if (cond) {				\
>>> +			report_info(fmt, ##__VA_ARGS__);\
>>> +		}					\
>>> +	} while (0)
>>
>> I'm wondering whether such a wrapper function could be generally useful.
>>
> 
> I've found 9 occurrences with:
> find . -type f \( -name "*.c" -o -name "*.h" \) -exec awk '/if\s*\(.*/{i=2;f=$0} /report_info/ && i>0{print FILENAME, NR-1 ":" f;r=4} r>1{print FILENAME, NR ":" $0;r--} r==1{print "--";r=0} {i--}' '{}' \;
> 

Looking at the occurrences below most of those also do other things in
the conditional branches so for 90% we can't do a straight forward replace.

Nevertheless I see some value in it and the 6 lines won't hurt us, so
please create a separate patch for this and put the maintainers for the
other arches and Paolo on CC for that patch so they know the new wrapper
will be available.

Also I'd like having report_fail("Message"); and report_pass("Message");
functions instead of report(0, "Message"); and report(1, "Message"); ...
Those at least are straight forward replacements.


> ./lib/s390x/css_lib.c 177:      if (cc) {
> ./lib/s390x/css_lib.c 178:              report_info("stsch: updating sch %08x failed with cc=%d",
> ./lib/s390x/css_lib.c 179:                          schid, cc);
> ./lib/s390x/css_lib.c 180:              return false;
> --
> ./lib/s390x/css_lib.c 183:      if (!(pmcw->flags & PMCW_ENABLE)) {
> ./lib/s390x/css_lib.c 184:              report_info("stsch: sch %08x not enabled", schid);
> ./lib/s390x/css_lib.c 185:              return false;
> ./lib/s390x/css_lib.c 186:      }
> --
> ./lib/s390x/css_lib.c 207:      if (cc) {
> ./lib/s390x/css_lib.c 208:              report_info("stsch: sch %08x failed with cc=%d", schid, cc);
> ./lib/s390x/css_lib.c 209:              return cc;
> ./lib/s390x/css_lib.c 210:      }
> --
> ./lib/s390x/css_lib.c 213:      if ((pmcw->flags & (PMCW_ISC_MASK | PMCW_ENABLE)) == flags) {
> ./lib/s390x/css_lib.c 214:              report_info("stsch: sch %08x already enabled", schid);
> ./lib/s390x/css_lib.c 215:              return 0;
> ./lib/s390x/css_lib.c 216:      }
> --
> ./lib/s390x/css_lib.c 269:      if (cc) {
> ./lib/s390x/css_lib.c 270:              report_info("stsch: sch %08x failed with cc=%d", schid, cc);
> ./lib/s390x/css_lib.c 271:              return false;
> ./lib/s390x/css_lib.c 272:      }
> --
[...]
