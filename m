Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28373E4775
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 16:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhHIOXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 10:23:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234995AbhHIOXa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 10:23:30 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179ELmVr106418;
        Mon, 9 Aug 2021 10:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4f/Mzii8bLQiR3ZK8eC0Tg/FO5FSlYOqDJga+TxX1Pw=;
 b=Ikrzf5UIrEO+XhAl19n1pm+zXCdbILAyGZku++ly8IqjVo58X06L220+czj4hs47igzx
 8+jq/dTK3KOfHtQozZhuibpAKm9UTibVFT3PXjS8mU+4JVfqleR3usipdYd+L045fBnp
 js0orlzDm4fd3hWY8xdg+oBgNwiasdH8VNivZY+VFZY6qAb1HxVFPvGTbSE/LxeVNFHw
 d/i+2m/2NPsTy/rzekl4cfQOC1hGiCZbq4bOI57/Fu5D7D/srTZ1VvZMj/SkprR4DYgw
 0va7Ka4fe8+ClDwJpxBWHUFf/4cnJiBeYtRI0dn+eMHCIMDePtB5SLPGyUG8PRnFB4Ou xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab3rtmvpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:23:09 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179EMJch108048;
        Mon, 9 Aug 2021 10:23:09 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab3rtmvn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:23:09 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179EI8ZZ022208;
        Mon, 9 Aug 2021 14:23:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a9hehc4xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 14:23:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179EJrrK53477732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 14:19:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49CB3AE057;
        Mon,  9 Aug 2021 14:23:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E79EFAE061;
        Mon,  9 Aug 2021 14:23:02 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 14:23:02 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 2/4] s390x: lib: Move stsi_get_fc to
 library
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
 <1628498934-20735-3-git-send-email-pmorel@linux.ibm.com>
 <d8740bcd-19e0-c5d0-9f31-ba63e4471e4b@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <44413246-aa14-0e03-1094-17a14394ee76@linux.ibm.com>
Date:   Mon, 9 Aug 2021 16:23:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d8740bcd-19e0-c5d0-9f31-ba63e4471e4b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i4CRFupX-hOI5D90Ki3xLwAVnoiJmDCx
X-Proofpoint-ORIG-GUID: hcrRtz-ljw_cNmNz6RAIvU49cnta8lOY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_05:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/21 12:16 PM, Janosch Frank wrote:
> On 8/9/21 10:48 AM, Pierre Morel wrote:
>> It's needed in multiple tests now.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
>>   s390x/stsi.c             | 16 ----------------
>>   2 files changed, 16 insertions(+), 16 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 15cf7d48..57d7ddac 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -328,6 +328,22 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
>>   	return cc;
>>   }
>>   
>> +static inline unsigned long stsi_get_fc(void *addr)
> 
> We don't need an address for fc == 0. You can remove that and fix the
> s390x/stsi.c call.

OK, I do that.
Thanks,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
