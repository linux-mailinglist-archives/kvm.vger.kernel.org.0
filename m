Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F442FE6C8
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbhAUJxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:53:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728483AbhAUJwt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:52:49 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L9Vahm031273;
        Thu, 21 Jan 2021 04:52:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=USeiuk13pu2ozLN7lSAIwh3zzXATv/EH8tJPO0i7SwA=;
 b=lUTfacRckCrzDLoTsRTyHk7EjL3BhHAxfvNYHg/HrG4T1ruflDeXSRl6fQ4N2Kk4Pvz0
 EH8wN412Irs1W9zuUykJ6TnVhvBGSrlA5YB0FNBW7CiRbPzFhXuOQnOBvmq0gzdstNS/
 BHBJcPbT382Q0rZ90dhCG3+hg8GGBfGjhS3mnPW+tJ9BxQNcX+zimih1w/amp9IFvbse
 wjseaOVNapRcQ9wWoYFz8LAq2beK9xy1Jf/yhKuYPhRrlp6wDSpznerIoWsWrXGu5OMe
 MMwPFpJlh04TQO/nBvvoC3+kw3xvHAjaOr/o9Zw0HcouUybqC8jc2U4yiNnzffo7FohW BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3676h322er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:52:05 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L9Vh4o032123;
        Thu, 21 Jan 2021 04:52:05 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3676h322e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:52:05 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L9bTVA006339;
        Thu, 21 Jan 2021 09:52:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwsgxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:52:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L9psC420644178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:51:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B95E9A4053;
        Thu, 21 Jan 2021 09:52:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5461CA4040;
        Thu, 21 Jan 2021 09:52:00 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:52:00 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 1/3] s390x: pv: implement routine to
 share/unshare memory
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-2-git-send-email-pmorel@linux.ibm.com>
 <a4ad5c0f-2e77-4ea9-9efd-f4d000f17b72@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <27a07988-ab93-a482-3d60-cf76bf460b20@linux.ibm.com>
Date:   Thu, 21 Jan 2021 10:52:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a4ad5c0f-2e77-4ea9-9efd-f4d000f17b72@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 10:20 AM, Janosch Frank wrote:
> On 1/21/21 10:13 AM, Pierre Morel wrote:
>> When communicating with the host we need to share part of
>> the memory.
>>
>> Let's implement the ultravisor calls for this.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Suggested-by: Janosch Frank <frankja@linux.ibm.com>
>> Acked-by: Cornelia Huck <cohuck@redhat.com>
>> Acked-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   lib/s390x/asm/uv.h | 38 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 4c2fc48..8400026 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -71,4 +71,42 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>>   	return cc;
>>   }
>>   
>> +static inline int share(unsigned long addr, u16 cmd)
>> +{
>> +	struct uv_cb_share uvcb = {
>> +		.header.cmd = cmd,
>> +		.header.len = sizeof(uvcb),
>> +		.paddr = addr
>> +	};
>> +	int cc;
>> +
>> +	cc = uv_call(0, (u64)&uvcb);
>> +	if (!cc && uvcb.header.rc == 0x0001)
> 
> s/0x0001/UVC_RC_EXECUTED/

OK

> 
> 
>> +		return 0;
>> +
>> +	report_info("cc %d response code: %04x", cc, uvcb.header.rc);
> 
> Will the print have the string UV in it or will I need to guess that a
> UV call failed?

I will change for a more explicit

> 
> I'm wondering if an assert would make more sense, if callers are
> interested in the uv rc they will need to write an own share function
> anyway.

No need (reported OOB by Janosch)

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
