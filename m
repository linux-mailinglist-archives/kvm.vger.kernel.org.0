Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632A13420FB
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 16:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCSPas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 11:30:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbhCSPaT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 11:30:19 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JF3xOA137411
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zYbz8F1bZiHLvNqEwtYp1YMOxUNgxY+D4veVdJ4Wu6w=;
 b=jBl6Glkp9Hd5gvJU4/kieF5U+sCghiwqiEm+f4fFiI7jq7v/8aY+eJGLmiDjIcgvTzh3
 na06VoR6r4vsw8utKkRRBUjqIHYAXHglD4VwjvUu4LhP9UaNYXBalHFYDHPaSc54gJug
 sF0INeSkBFllWO6CJPlJqudaqA1YUSiS8ySaLDkLxdK9oGSf4vSNzOq715WsH1v/6iFm
 l4ZYH2VYa8osrqciigB4LgVCgQZxSLDNqXT2kEc840vHOj8/N4TykkOZVmLoDTvrYFXo
 83YuEjNIP5CdYfqSWNdY+/FcwDa39BFkyb4kMWIWnnwBRkrrqZlcZZB21uRpViaEjKGy 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37cw5ajxrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:30:18 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JF4JaS143166
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:30:18 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37cw5ajxqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 11:30:18 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JFNHIt012990;
        Fri, 19 Mar 2021 15:30:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 378n18b463-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:30:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JFUDs040108346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 15:30:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BDDC11C050;
        Fri, 19 Mar 2021 15:30:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87FF211C052;
        Fri, 19 Mar 2021 15:30:12 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.3.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 15:30:12 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 2/6] s390x: lib: css: SCSW bit
 definitions
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-3-git-send-email-pmorel@linux.ibm.com>
 <20210319111626.20b9cd72.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d39a43c1-4640-1175-31d8-28d90133e63e@linux.ibm.com>
Date:   Fri, 19 Mar 2021 16:30:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319111626.20b9cd72.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_06:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103190107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 11:16 AM, Cornelia Huck wrote:
> On Thu, 18 Mar 2021 14:26:24 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We need the SCSW definitions to test clear and halt subchannel.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h | 23 +++++++++++++++++++++++
>>   1 file changed, 23 insertions(+)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index b0de3a3..460b0bd 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -67,6 +67,29 @@ struct scsw {
>>   #define SCSW_SC_PRIMARY		0x00000004
>>   #define SCSW_SC_INTERMEDIATE	0x00000008
>>   #define SCSW_SC_ALERT		0x00000010
>> +#define SCSW_AC_SUSPEND_PEND	0x00000020
>> +#define SCSW_AC_DEVICE_PEND	0x00000040
>> +#define SCSW_AC_SUBCHANNEL_PEND	0x00000080
> 
> Naming: aren't these two rather "active", not "pending"? So maybe
> SCSW_AC_DEVICE_ACTIVE and SCSW_AC_SUBCH_ACTIVE?

right, I modify this

> 
>> +#define SCSW_AC_CLEAR_PEND	0x00000100
>> +#define SCSW_AC_HALT_PEND	0x00000200
>> +#define SCSW_AC_START_PEND	0x00000400
>> +#define SCSW_AC_RESUME_PEND	0x00000800
>> +#define SCSW_FC_CLEAR		0x00001000
>> +#define SCSW_FC_HALT		0x00002000
>> +#define SCSW_FC_START		0x00004000
>> +#define SCSW_QDIO_RESERVED	0x00008000
>> +#define SCSW_PATH_NON_OP	0x00010000
>> +#define SCSW_EXTENDED_CTRL	0x00020000
>> +#define SCSW_ZERO_COND		0x00040000
>> +#define SCSW_SUPPRESS_SUSP_INT	0x00080000
>> +#define SCSW_IRB_FMT_CTRL	0x00100000
>> +#define SCSW_INITIAL_IRQ_STATUS	0x00200000
>> +#define SCSW_PREFETCH		0x00400000
>> +#define SCSW_CCW_FORMAT		0x00800000
>> +#define SCSW_DEFERED_CC		0x03000000
>> +#define SCSW_ESW_FORMAT		0x04000000
>> +#define SCSW_SUSPEND_CTRL	0x08000000
>> +#define SCSW_KEY		0xf0000000
>>   	uint32_t ctrl;
>>   	uint32_t ccw_addr;
>>   #define SCSW_DEVS_DEV_END	0x04
> 

-- 
Pierre Morel
IBM Lab Boeblingen
