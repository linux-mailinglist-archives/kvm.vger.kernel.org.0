Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686DC2FD0C5
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbhATMwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388615AbhATMRl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:17:41 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KC3lJW185714;
        Wed, 20 Jan 2021 07:16:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8Ar74IVSOAuvU6roB2qUaQ8bVILetJ/P831ISCzDUh4=;
 b=ESlG/A7J+b6WWNYKjSfZja6291wRRY6k62e/oNugRaU/FlAj4IBHuqLGFk/K8JZBZ8ky
 /ONDeuCFebjPc7BPGF6jdcd+5+J0FnP4RnF2G9JSgsa/OxR4SCqBVZ/hcLHIrdCcQXXy
 By3FWcAzeFDlpiVueOESsZ2MqjzmEV9KTnLXljNAvMZsz5QAWr1FTwoGMrDZusTsuAnN
 z3EJhbeDRwE+1r7U6qp8iPvmvnVy/JwmHB4fdx6ZPRQ23TEuM6214JOXAcBHkk440EiI
 51pLG3PATND9dmrHF3w051mg2SHQAzmNz6u3VO2j0Tt/0EQ+hI0+MIJOH/olF5N/N5tK 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366kep9d6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:16:58 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KC3rXO186054;
        Wed, 20 Jan 2021 07:16:58 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366kep9d5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:16:58 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KCDCcQ019613;
        Wed, 20 Jan 2021 12:16:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3668ny09e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 12:16:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KCGqrx40501708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 12:16:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7C614C044;
        Wed, 20 Jan 2021 12:16:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 555C24C040;
        Wed, 20 Jan 2021 12:16:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.155])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 12:16:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 1/3] s390x: pv: implement routine to
 share/unshare memory
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
 <1611085944-21609-2-git-send-email-pmorel@linux.ibm.com>
 <211a4bd3-763a-f8fc-3c08-8d8d1809cc7c@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <eecc5b27-12b7-8a9a-febe-a98d2f8ec7b5@linux.ibm.com>
Date:   Wed, 20 Jan 2021 13:16:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <211a4bd3-763a-f8fc-3c08-8d8d1809cc7c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_05:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 impostorscore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101200068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/21 11:48 AM, Thomas Huth wrote:
> On 19/01/2021 20.52, Pierre Morel wrote:
>> When communicating with the host we need to share part of
>> the memory.
>>
>> Let's implement the ultravisor calls for this.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Suggested-by: Janosch Frank <frankja@linux.ibm.com>
>> Acked-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   lib/s390x/asm/uv.h | 38 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 4c2fc48..1242336 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -71,4 +71,42 @@ static inline int uv_call(unsigned long r1, 
>> unsigned long r2)
>>       return cc;
>>   }
>> +static inline int share(unsigned long addr, u16 cmd)
>> +{
>> +    struct uv_cb_share uvcb = {
>> +        .header.cmd = cmd,
>> +        .header.len = sizeof(uvcb),
>> +        .paddr = addr
>> +    };
>> +    int cc;
>> +
>> +    cc = uv_call(0, (u64)&uvcb);
>> +    if (!cc && (uvcb.header.rc == 0x0001))
> 
> You can drop the innermost parentheses.

OK.

> 
>> +        return 0;
>> +
>> +    report_info("cc %d response code: %04x", cc, uvcb.header.rc);
>> +    return -1;
>> +}
>> +
>> +/*
>> + * Guest 2 request to the Ultravisor to make a page shared with the
>> + * hypervisor for IO.
>> + *
>> + * @addr: Real or absolute address of the page to be shared
> 
> When is it real, and when is it absolute?

It only depends on the prefixing, the call can use both.

> 
>> + */
>> +static inline int uv_set_shared(unsigned long addr)
>> +{
>> +    return share(addr, UVC_CMD_SET_SHARED_ACCESS);
>> +}
>> +
>> +/*
>> + * Guest 2 request to the Ultravisor to make a page unshared.
>> + *
>> + * @addr: Real or absolute address of the page to be unshared
> 
> dito
> 
>> + */
>> +static inline int uv_remove_shared(unsigned long addr)
>> +{
>> +    return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>> +}
>> +
>>   #endif
> 
> Apart from the nits:
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks thomas for reviewing.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
