Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D415745B79
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 13:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjGCLqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 07:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjGCLqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 07:46:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45AC115;
        Mon,  3 Jul 2023 04:46:36 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 363Bio7h016406;
        Mon, 3 Jul 2023 11:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Gx986Wx9N6PQFi+l1t8o+GvS8oQAiGW8JgR15r3dF5Y=;
 b=llpPX6GKj6sqcmgPUvWgbEwf81vSo2hvS5MD9nUVljgMoxUk4Cm6YTBAEzEOBafhlEfW
 VBkQpQZrAWaHc61wUDi3TljAJkdJftcKeArCSHZW0Om2tCm0TIe0f+j2Y5k4Sey3kRF1
 RIMx3rYmmAuRA2jG0zEyjl3xWLaVl7a/0ZudALWLYKug5aH56M71jWc7b6Qj6MPUXK9O
 uVeGPUw5eDtNRydhKU69kXfUs29zwoJyN9agD5TWQU1Por9K4j/5wyx9aX6AC+is65Tt
 VVVNi/K9ihOEDwr0fh69bE4xT1c//m88qWjATzemz+5Gd3zdK0P4P/nLyKvXiNDn/cHi eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkwqmr28c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:46:35 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 363Bj8lu018403;
        Mon, 3 Jul 2023 11:46:35 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rkwqmr27f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:46:35 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3632htoW025774;
        Mon, 3 Jul 2023 11:46:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rjbs50y1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jul 2023 11:46:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 363BkTGS28771038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jul 2023 11:46:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD24C20040;
        Mon,  3 Jul 2023 11:46:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 811332004E;
        Mon,  3 Jul 2023 11:46:29 +0000 (GMT)
Received: from [9.171.11.162] (unknown [9.171.11.162])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jul 2023 11:46:29 +0000 (GMT)
Message-ID: <6ad06172-ad8e-4615-ad20-d254dcb3f380@linux.ibm.com>
Date:   Mon, 3 Jul 2023 13:46:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
References: <20230630145449.2312-1-frankja@linux.ibm.com>
 <20230630145449.2312-2-frankja@linux.ibm.com>
 <20230630171226.3e77e0eb@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests RFC 1/3] lib: s390x: sclp: Add carriage return to
 line feed
In-Reply-To: <20230630171226.3e77e0eb@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _gXzoDjdnMbNKYnce2iGt43Ga4NciVjJ
X-Proofpoint-GUID: -jVKqwFDnpVqEYbdiBc7Agtt6wJ6uwhi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-03_09,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307030104
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/23 17:12, Claudio Imbrenda wrote:
> On Fri, 30 Jun 2023 14:54:47 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Without the \r the output of the ASCII console takes a lot of
>> additional effort to read in comparison to the line mode console.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/sclp-console.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
>> index 19c74e46..384080b0 100644
>> --- a/lib/s390x/sclp-console.c
>> +++ b/lib/s390x/sclp-console.c
>> @@ -97,14 +97,27 @@ static void sclp_print_ascii(const char *str)
>>   {
>>   	int len = strlen(str);
>>   	WriteEventData *sccb = (void *)_sccb;
>> +	char *str_dest = (char *)&sccb->msg;
>> +	int i = 0;
>>   
>>   	sclp_mark_busy();
>>   	memset(sccb, 0, sizeof(*sccb));
>> +
>> +	for (; i < len; i++) {
>> +		*str_dest = str[i];
>> +		str_dest++;
>> +		/* Add a \r to the \n */
>> +		if (str[i] == '\n') {
>> +			*str_dest = '\r';
>> +			str_dest++;
>> +		}
>> +	}
>> +
>> +	len = (uintptr_t)str_dest - (uintptr_t)&sccb->msg;
> 
> some strings will therefore potentially overflow the SCCB
> 
> sclp_print() refuses to print more than 2kB, with this patch that limit
> could potentially be crossed
> 
> can you please briefly explain in a comment why that is ok? (or maybe
> that is not ok? then fix it somehow :) )

I'd like to see someone find a useful application for printing 2kb in a 
single printf() call.

Anyway, I could truncate the ASCII after the 2KB limit when adding the \r.

I'm wondering how the line-mode console interprets the \r. If it ignores 
it, then we could also convert to \n\r for both consoles and check for 
2kb when converting.
