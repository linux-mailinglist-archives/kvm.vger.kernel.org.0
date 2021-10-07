Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554B4425162
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhJGKqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 06:46:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232776AbhJGKqS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 06:46:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19795NVF029404;
        Thu, 7 Oct 2021 06:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Vmf87/rbttjw1pyP74MoOtWffHF5Sp6YMPKysch8ysI=;
 b=lZZSewTRHms3AkraOBIqDIzPlyAfHimPZbq7aI7iPhGd29DgWPB9uQNHW1wyyMC7V8YN
 AlB7Ri8YHfTLOQBVpIQLLpl1Y2e4iptVjRosNQGEsl5T33OCwSFLL+y03vcUpsbaWsTm
 xzlAvPcDgzh6C3gIHvVVpKfNrgY4aB8UcXZNjukwTblYsVo0G3l61VIJLNcPNb7a0Rze
 TrXc/b/xP/xuvbj3q0BYoxGp2AFAUSqQuVdPKmx8A+wjNw2WiapvT1TpvCcr2w9gc4vN
 2vi/1RRYqafB+UF2xkTxE/91JQhR4MX1wCKYrtSkSwTy6qSRoBIvMeSUaPUfUcQ07h5V vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh8cb15sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 06:44:23 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1979QKmV012936;
        Thu, 7 Oct 2021 06:44:23 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh8cb15rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 06:44:23 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 197AgLmD015734;
        Thu, 7 Oct 2021 10:44:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3bef2abq6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 10:44:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 197AiFiD56689150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 10:44:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69701A407B;
        Thu,  7 Oct 2021 10:44:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECE2EA4059;
        Thu,  7 Oct 2021 10:44:14 +0000 (GMT)
Received: from [9.145.66.140] (unknown [9.145.66.140])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 10:44:14 +0000 (GMT)
Message-ID: <8c1cac56-3f4b-5f00-4e62-d14aebbb537d@linux.ibm.com>
Date:   Thu, 7 Oct 2021 12:44:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 9/9] s390x: snippets: Define all things
 that are needed to link the lib
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-10-frankja@linux.ibm.com>
 <c3bed287-5c4c-a54b-4276-391c6cdb37f4@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <c3bed287-5c4c-a54b-4276-391c6cdb37f4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aAoJ_SPYk03dvUsaCdgN1RfoYYFItPok
X-Proofpoint-ORIG-GUID: 4StDcdYuFUcQi9jj34ve399kJQ3lQTVU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_01,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 mlxscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/21 11:44, Thomas Huth wrote:
> On 07/10/2021 10.50, Janosch Frank wrote:
>> Let's just define all of the needed things so we can link libcflat.
>>
>> A significant portion of the lib won't work, like printing and
>> allocation but we can still use things like memset() which already
>> improves our lives significantly.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/snippets/c/cstart.S | 14 ++++++++++++++
>>    1 file changed, 14 insertions(+)
>>
>> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
>> index 031a6b83..2d397669 100644
>> --- a/s390x/snippets/c/cstart.S
>> +++ b/s390x/snippets/c/cstart.S
>> @@ -20,6 +20,20 @@ start:
>>    	lghi	%r15, stackptr
>>    	sam64
>>    	brasl	%r14, main
>> +/*
>> + * Defining things that the linker needs to link in libcflat and make
>> + * them result in sigp stop if called.
>> + */
>> +.globl sie_exit
>> +.globl sie_entry
>> +.globl smp_cpu_setup_state
>> +.globl ipl_args
>> +.globl auxinfo
>> +sie_exit:
>> +sie_entry:
>> +smp_cpu_setup_state:
>> +ipl_args:
>> +auxinfo:
> 
> I think this likely could be done in a somewhat nicer way, e.g. by moving

Definitely, as I said, it's a simple fix

> mem_init() and sclp_memory_setup() into a separate .c file in the lib, and
> by moving expect_pgm_int(), fixup_pgm_int() and friends into another
> separate .c file, too, so that we e.g. do not need to link against the code
> that uses sie_entry and sie_exit ... but that's a major rework on its own,
> so for the time being:
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 
Thanks
