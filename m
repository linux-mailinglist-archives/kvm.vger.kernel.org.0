Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA08388BE5
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 12:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349426AbhESKpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 06:45:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2386 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345943AbhESKpS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 06:45:18 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JAYXcF060700;
        Wed, 19 May 2021 06:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bNg9mK3wNCtgJ25V9But8U2yQTnQ388AQ3HdEUkwoJo=;
 b=aPOYEMvODxzKXiMvUPI7RoIKrUYnO4XY9P/OV69eBqLjw6DoKtCBoJEcynB3CFA/rmXg
 72YwMtWhEfCmKW0cwC2CRs0Vag5LL+XJImGmhKe6ibkV1HPcuu/qcIDMkc5ZYx9QIkA3
 MDm0hx4c93ganDUHV1hmNQgzlfeUJOxHPjO2x8vF9/Qqq5xcPDK3jxixYcrW7W9ZRyBt
 vTmCs8YEGc05bbPu1eRaBxc765iCkvi2HVgSaHzQgny+poDHYonABovR8Up3TxwBusYq
 ep012QX9n+UGae9O54loZuA9BCI0+id8pT1/ssBA+PTj6PUShUHKxgeGSFl3Fn2IzHCZ NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38n0cvshfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 06:43:58 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14JAZ7KV066169;
        Wed, 19 May 2021 06:43:57 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38n0cvshew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 06:43:57 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14JARJNI025074;
        Wed, 19 May 2021 10:43:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 38j5jgt1pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 10:43:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14JAhr8538666696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:43:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 460C111C050;
        Wed, 19 May 2021 10:43:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E211E11C04A;
        Wed, 19 May 2021 10:43:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.49.22])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 10:43:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib: s390x: sclp: Extend feature
 probing
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210519082648.46803-1-frankja@linux.ibm.com>
 <20210519082648.46803-3-frankja@linux.ibm.com>
 <20210519121711.22ed02ba.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <d0b1ee02-c956-e334-467a-7abb964382b2@linux.ibm.com>
Date:   Wed, 19 May 2021 12:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210519121711.22ed02ba.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HUw8HM5y4dapasOJOwHXxV3KuU8SkPWI
X-Proofpoint-ORIG-GUID: 0Qrt4-L66RIBRDxTMX9V2l2sEybOEDLr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/21 12:17 PM, Cornelia Huck wrote:
> On Wed, 19 May 2021 08:26:47 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Lets grab more of the feature bits from SCLP read info so we can use
> 
> s/Lets/Let's/ :)

Sigh

> 
>> them in the cpumodel tests.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  lib/s390x/sclp.c | 20 ++++++++++++++++++++
>>  lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
>>  2 files changed, 55 insertions(+), 3 deletions(-)
> 
> (...)
> 
> Maybe add
> 
> /* bit number within a certain byte */

Sure

> 
>> +#define SCLP_FEAT_85_BIT_GSLS		7
>> +#define SCLP_FEAT_98_BIT_KSS		0
>> +#define SCLP_FEAT_116_BIT_64BSCAO	7
>> +#define SCLP_FEAT_116_BIT_CMMA		6
>> +#define SCLP_FEAT_116_BIT_ESCA		3
>> +#define SCLP_FEAT_117_BIT_PFMFI		6
>> +#define SCLP_FEAT_117_BIT_IBS		5
>> +
>>  typedef struct ReadInfo {
>>  	SCCBHeader h;
>>  	uint16_t rnmax;
> 
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks!
