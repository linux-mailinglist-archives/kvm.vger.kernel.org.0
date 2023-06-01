Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECA1719CFD
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbjFANKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 09:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjFANKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 09:10:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F6197;
        Thu,  1 Jun 2023 06:10:42 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351D27Gp010106;
        Thu, 1 Jun 2023 13:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=50iAErLBd9QkQaSNiM4jwwvCR5hnChu042Oo89biMpQ=;
 b=FK3ppwQ8D+ILlmn13uVqUEdn8JQ53zT95G9R2++WT7qoE2E/aQ6EuL54gzTukcz4ezIN
 NHL9ayy2cc85Kp/a1k1WywEyQJPe1Hrr3t7AXKhl7+9gPjyHlL2y3ILANoWOnxVJLbFd
 YJqXYi2YmZtS+I/ePkXcJ7I6oQ2IREdUkeAg69BO6sTN16Cvlqzn3kpnsb7yhGcAURh+
 tTuboi1Sx2DcWvnbdjxH5tzLNF5jBwOy0P9V73qRPNrSGsQ4Emqlq2l3MTDMNjKF6Oyr
 eO7/4Uy74kpfbnzsDcBNjGWsda6foseQI/vE7NAsHl3M7dsKWuMGE+JsP6Vs9yxs7Jft bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxuuvrqj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 13:10:40 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351D3E29016939;
        Thu, 1 Jun 2023 13:08:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxuuvr9yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 13:08:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 351AaE5s014487;
        Thu, 1 Jun 2023 12:32:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5ah1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:32:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351CWVdu62063008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 12:32:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CE9E20043;
        Thu,  1 Jun 2023 12:32:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F068920040;
        Thu,  1 Jun 2023 12:32:30 +0000 (GMT)
Received: from [9.171.12.131] (unknown [9.171.12.131])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  1 Jun 2023 12:32:30 +0000 (GMT)
Message-ID: <29237160-ca30-7f46-f7dc-9226726c8800@linux.ibm.com>
Date:   Thu, 1 Jun 2023 14:32:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: sclp: consider monoprocessor
 on read_info error
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com,
        cohuck@redhat.com
References: <20230530124056.18332-1-pmorel@linux.ibm.com>
 <20230530124056.18332-2-pmorel@linux.ibm.com>
 <168562035629.164254.14237878033396575782@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168562035629.164254.14237878033396575782@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cyLyX7Y4UsguViWNiaOguY3ePgK083Sy
X-Proofpoint-GUID: i8TthFd7Glb-s5eZSLNNH7QoTQyDnaq0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/23 13:52, Nico Boehr wrote:
> Quoting Pierre Morel (2023-05-30 14:40:55)
>> A kvm-unit-test would hang if an abort happens before SCLP Read SCP
>> Information has completed if sclp_get_cpu_num() does not report at
>> least one CPU.
>> Since we obviously have one, report it.
> Sorry for complaining again, in a discussion with Janosch we found that the
> description and commit below can be easily misunderstood. I suggest the
> following wording in the commit description:
>
> s390x: sclp: treat system as single processor when read_info is NULL
>
> When a test abort()s before SCLP read info is completed, the assertion on
> read_info in sclp_read_info() will fail. Since abort() eventually calls
> smp_teardown() which in turn calls sclp_get_cpu_num(), this will cause an
> infinite abort() chain, causing the test to hang.
>
> Fix this by considering the system single processor when read_info is missing.
>
> [...]

better, I take it

thx



>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 12919ca..34a31da 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -121,6 +121,12 @@ int sclp_get_cpu_num(void)
>>   {
>>          if (read_info)
>>                  return read_info->entries_cpu;
>> +       /*
>> +        * If we fail here and read_info has not being set,
>> +        * it means we failed early and we try to abort the test.
>> +        * We need to return at least one CPU, and obviously we have
>> +        * at least one, for the smp_teardown to correctly work.
>> +        */
> Please make this:
>
> Don't abort here if read_info is NULL since abort() calls smp_teardown() which
> eventually calls this function and thus causes an infinite abort() chain,
> causing the test to hang. Since we obviously have at least one CPU, just return
> one.
>
> With these changes:
>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>
> Sorry for the back and forth.
