Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2C641481E
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 13:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhIVLs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 07:48:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230171AbhIVLsx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 07:48:53 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MBYw1Q030178;
        Wed, 22 Sep 2021 07:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2xyInIEpJeIXBBL0cMhzPhwFEl+sbXx5dMRpNfiJJZg=;
 b=P67E8oP1lzgPNysM9liAIsqYYIKt6e5Bw33fWuJXeD2tK8J3obwMkznBNwBoo/xBaHrC
 SvOD70JcrEUfO2ezhH+kxX68iWGvq3sb56bFe2zTTQBx4I0IiSLi0J9QrK5Y6xIlQroN
 lvoWaTCg2V+zE/kS1Q97olpcItfaFpEGd6kPHbVDctYb1s+UfBSe1nzHVxBOz9Kv96nB
 ppqKjg6Xj9fVdjuUrQyTFlnbMK5vgBnvgcP739Qv8B2voSISJ6TFSAb6nN2BUYQEX3Tt
 7dHWip+41kAI4LQ5H9yYgYzOFhjvk/5CmuyTuytFYAmNy0Tqn3hR/alngXD85vUJD9Zd IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b83r6r7yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:47:23 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18MBaQ1W001259;
        Wed, 22 Sep 2021 07:47:22 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b83r6r7y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:47:22 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18MBfxAm026664;
        Wed, 22 Sep 2021 11:47:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3b7q6qx56p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 11:47:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18MBlHpd44892566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 11:47:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 774D54C059;
        Wed, 22 Sep 2021 11:47:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 163554C052;
        Wed, 22 Sep 2021 11:47:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.85.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 11:47:17 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-10-frankja@linux.ibm.com>
 <20210922113459.56737df3@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] s390x: skrf: Fix tprot assembly
Message-ID: <d645e4aa-1106-6971-e25c-4401a7d7cfdd@linux.ibm.com>
Date:   Wed, 22 Sep 2021 13:47:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922113459.56737df3@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QCCl6BIY-5Oo1LmAbpjBZrm4tGXPyG7F
X-Proofpoint-ORIG-GUID: ty77w63FPu3ZNdN5AwFu8tU_go1EpxKM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_04,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/21 11:34 AM, Claudio Imbrenda wrote:
> On Wed, 22 Sep 2021 07:18:11 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> It's a base + displacement address so we need to address it via 0(%[addr]).
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> but see comment below
> 
>> ---
>>  s390x/skrf.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/s390x/skrf.c b/s390x/skrf.c
>> index 8ca7588c..84fb762c 100644
>> --- a/s390x/skrf.c
>> +++ b/s390x/skrf.c
>> @@ -103,7 +103,7 @@ static void test_tprot(void)
>>  {
>>  	report_prefix_push("tprot");
>>  	expect_pgm_int();
>> -	asm volatile("tprot	%[addr],0xf0(0)\n"
>> +	asm volatile("tprot	0(%[addr]),0xf0(0)\n"
> 
> I think the displacement defaults to 0 if not specified?
> 
> did you get a warning, or why are you changing this now?

It fixes one of the ~18 clang warnings and making it explicit directly
tells you it's a B+D instruction i.e. it looks cleaner to me.

> 
>>  		     : : [addr] "a" (pagebuf) : );
>>  	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>>  	report_prefix_pop();
> 

