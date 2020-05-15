Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09E41D46A6
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgEOHFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:05:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28162 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgEOHFQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 03:05:16 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F72edr149088;
        Fri, 15 May 2020 03:05:16 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ua8teej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:05:15 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F72hhW149159;
        Fri, 15 May 2020 03:05:14 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ua8tedv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:05:14 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F7546u029027;
        Fri, 15 May 2020 07:05:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3100ubd3sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 07:05:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F75AdT60358724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 07:05:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA761A4062;
        Fri, 15 May 2020 07:05:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A543A4064;
        Fri, 15 May 2020 07:05:10 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 07:05:10 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 06/10] s390x: css: stsch, enumeration
 test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-7-git-send-email-pmorel@linux.ibm.com>
 <20200514140552.107abbde.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <f6143792-3f35-529e-6eea-b59fa8393c72@linux.ibm.com>
Date:   Fri, 15 May 2020 09:05:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514140552.107abbde.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 priorityscore=1501 suspectscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-14 14:05, Cornelia Huck wrote:
> On Fri, 24 Apr 2020 12:45:48 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> First step for testing the channel subsystem is to enumerate the css and
>> retrieve the css devices.
>>
>> This tests the success of STSCH I/O instruction, we do not test the
> 
> s/of/of the/

Yes, zhanks.

> 
>> reaction of the VM for an instruction with wrong parameters.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   s390x/Makefile      |  2 +
>>   s390x/css.c         | 92 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |  4 ++
>>   4 files changed, 99 insertions(+)
>>   create mode 100644 s390x/css.c
>>
> 
> (...)
> 
>> +static void test_enumerate(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
...snip...
			goto out;
>> +		default:	/* 1 or 2 should never happened for STSCH */
> 
> s/happened/happen/

Yes, thanks.

> 
>> +			report(0, "Unexpected cc=%d on subchannel number 0x%x",
>> +			       cc, scn);
>> +			return;
>> +		}
> 

Thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
