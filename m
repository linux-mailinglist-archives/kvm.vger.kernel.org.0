Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD2D1EDEB4
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 09:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgFDHmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 03:42:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727881AbgFDHmm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 03:42:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0547bodk115467;
        Thu, 4 Jun 2020 03:42:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31d2u3gt8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 03:42:41 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0547e413119657;
        Thu, 4 Jun 2020 03:42:40 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31d2u3gt83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 03:42:40 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0547ZE2t024916;
        Thu, 4 Jun 2020 07:42:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 31bf483vb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:42:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0547gaqt51511396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 07:42:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8769E5204E;
        Thu,  4 Jun 2020 07:42:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.167.22])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 392A55204F;
        Thu,  4 Jun 2020 07:42:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 07/12] s390x: Library resources for CSS
 tests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-8-git-send-email-pmorel@linux.ibm.com>
 <20200526183005.76fc9124.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <1920d8a8-76fb-dc0c-3d40-0db69dc7e207@linux.ibm.com>
Date:   Thu, 4 Jun 2020 09:42:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526183005.76fc9124.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_04:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006040047
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-26 18:30, Cornelia Huck wrote:
> On Mon, 18 May 2020 18:07:26 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Provide some definitions and library routines that can be used by
>> tests targeting the channel subsystem.
>>
>> Debug function can be activated by defining DEBUG_CSS before the
>> inclusion of the css.h header file.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h      | 259 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_dump.c | 157 ++++++++++++++++++++++++++
>>   s390x/Makefile       |   1 +
>>   3 files changed, 417 insertions(+)
>>   create mode 100644 lib/s390x/css.h
>>   create mode 100644 lib/s390x/css_dump.c
>>
> 
> (...)
> 
>> +struct ccw1 {
>> +	unsigned char code;
>> +	unsigned char flags;
>> +	unsigned short count;
> 
> I'm wondering why you're using unsigned {char,short} here, instead of
> the uint*_t types everywhere else? It's not wrong, but probably better
> to be consistent?
> 
>> +	uint32_t data_address;
>> +} __attribute__ ((aligned(4)));
>> +
>> +#define SID_ONE		0x00010000
>> +
> 
> I think it would be beneficial for the names to somewhat match the
> naming in Linux and/or QEMU -- or more speaking names (as you do for
> some), which is also good.
> 
>> +#define ORB_M_KEY	0xf0000000
>> +#define ORB_F_SUSPEND	0x08000000
>> +#define ORB_F_STREAMING	0x04000000
>> +#define ORB_F_MODIFCTRL	0x02000000
>> +#define ORB_F_SYNC	0x01000000
>> +#define ORB_F_FORMAT	0x00800000
>> +#define ORB_F_PREFETCH	0x00400000
>> +#define ORB_F_INIT_IRQ	0x00200000
> 
> ORB_F_ISIC? (As it does not refer to 'initialization', but 'initial'.)
> 
>> +#define ORB_F_ADDRLIMIT	0x00100000
>> +#define ORB_F_SUSP_IRQ	0x00080000
> 
> ORB_F_SSIC? (As it deals with suppression.)
> 
>> +#define ORB_F_TRANSPORT	0x00040000
>> +#define ORB_F_IDAW2	0x00020000
> 
> ORB_F_IDAW_FMT2?
> 
> Or following Linux/QEMU, use ORB_F_C64 for a certain retro appeal :)
> 
>> +#define ORB_F_IDAW_2K	0x00010000
>> +#define ORB_M_LPM	0x0000ff00
>> +#define ORB_F_LPM_DFLT	0x00008000
> 
> That's a default lpm of 0x80, right? It's a bit buried between the orb
> definitions, and it also seems to be more of a implementation choice --
> move it out from the flags here?
> 
>> +#define ORB_F_ILSM	0x00000080
> 
> ORB_F_ILS?
> 
>> +#define ORB_F_CCW_IND	0x00000040
> 
> ORB_F_MIDAW? I had a hard time figuring out that one :)
> 
>> +#define ORB_F_ORB_EXT	0x00000001
> 
> (...)
> 
>> +/*
>> + * Try o have a more human representation of the PMCW flags
> 
> s/o/to/
> 
>> + * each letter in the string represent the first
> 
> s/represent/represents/
> 
>> + * letter of the associated bit in the flag fields.
>> + */
> 
> (...)
> 
> Generally, looks good to me.
> 

Thanks a lot,
I take all your remarks and will update the names for better ones as you 
suggest.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
