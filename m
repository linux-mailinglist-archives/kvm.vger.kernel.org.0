Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22F24A7640
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 17:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbiBBQ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 11:56:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15472 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231706AbiBBQz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 11:55:57 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 212GfjR7003030
        for <kvm@vger.kernel.org>; Wed, 2 Feb 2022 16:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sLaCRg6njF31FyxFS839F50tMWOJ0lJKIcdJUCFMsTI=;
 b=dWIAuqOEbVgMFPjyKduYqC2lUFS3cKN3aP875T2PZgKODtf0U8FzAJZDantBjAPCVmY4
 91GuzTztagGH/7Nn6g6dpy7wWgu+RZr1oRBjb4cOwySZw4GS4S1W8Abv9N94Z1f+3kQ6
 xzXBvSCM7UUmjLj66nDLxEEoO1A1JdgHiIE378UCzhSJGdaHZ5zwe9ScRNLjE21ROMfe
 LaQUL1fjbFZ3/klBoqtsbmirLlNSJM2hiOqMGTOSVqLbuosR425U7fYgLsfvpDb4rsnB
 CF5/+gEu7nCPL6fxplM5Du9Qd1nkh1w0VvDLbfDYZgZ0wSDZN6uiMeh8aBFk/GkiFG4z 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dysradufb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:55:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 212Ghg2I006571
        for <kvm@vger.kernel.org>; Wed, 2 Feb 2022 16:55:55 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dysraduem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 16:55:55 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 212GrHI5014473;
        Wed, 2 Feb 2022 16:55:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3dvvujdp43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 16:55:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 212GtoK844827116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Feb 2022 16:55:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA962A404D;
        Wed,  2 Feb 2022 16:55:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B8D9A4051;
        Wed,  2 Feb 2022 16:55:50 +0000 (GMT)
Received: from [9.145.171.63] (unknown [9.145.171.63])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Feb 2022 16:55:50 +0000 (GMT)
Message-ID: <a9a4f77b-1c70-478c-1389-f243fa485159@linux.ibm.com>
Date:   Wed, 2 Feb 2022 17:55:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v1 1/5] lib: s390x: smp: add functions to
 work with CPU indexes
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
 <20220128185449.64936-2-imbrenda@linux.ibm.com>
 <defe074e-0215-cb9a-39e7-cc4dcbf75785@redhat.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <defe074e-0215-cb9a-39e7-cc4dcbf75785@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DdDG5Eu_bechvxDNwkPbWDIjitsa7tXS
X-Proofpoint-GUID: MS6SRH9SOSD9LcHic4O5hsKoFI1r5ZoQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-02_08,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202020092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/31/22 14:50, David Hildenbrand wrote:
> On 28.01.22 19:54, Claudio Imbrenda wrote:
>> Knowing the number of active CPUs is not enough to know which ones are
>> active. This patch adds 2 new functions:
>>
>> * smp_cpu_addr_from_idx to get the CPU address from the index
>> * smp_cpu_from_idx allows to retrieve the struct cpu from the index
>>
>> This makes it possible for tests to avoid hardcoding the CPU addresses.
>> It is useful in cases where the address and the index might not match.
>>
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
With Davids nit
Reviewed-by Steffen Eiden <seiden@linux.ibm.com>
>> ---
>>   lib/s390x/smp.h |  2 ++
>>   lib/s390x/smp.c | 12 ++++++++++++
>>   2 files changed, 14 insertions(+)
>>
>> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
>> index a2609f11..69aa4003 100644
>> --- a/lib/s390x/smp.h
>> +++ b/lib/s390x/smp.h
>> @@ -37,6 +37,7 @@ struct cpu_status {
>>   
>>   int smp_query_num_cpus(void);
>>   struct cpu *smp_cpu_from_addr(uint16_t addr);
>> +struct cpu *smp_cpu_from_idx(uint16_t addr);
> 
> s/addr/idx/
> 
> 
