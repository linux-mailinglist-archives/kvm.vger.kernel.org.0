Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDD433D1C4
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhCPK1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:27:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236390AbhCPK1N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 06:27:13 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GA6lLq123685
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ENE+7sp7PHTyvX7ZjhEunaTZbJHePz0DvaSlf7Lhg30=;
 b=RV+1Ngrbg80Zwi6/zDzQ9d7gmg617KoGz6aKYYl4t4VylziZ+HyG7f7EtvqiRGb1P2c9
 WGZLazh7LOzXbB2umKJ2jb/xgJPrii+ZSAuKV1X7d05T5aZmt7EwW460b4j9gKCW4o1C
 EkdwV8r5ZC8C6ocKEGDbxr2xIYC0MRUlr9+2W5jv7SVhsEZxg6URB48XR/tgEPAjQed4
 7jY9rS/YYVhynnDZHKBHW195XvcW647VD5/qhMhHGVPN6b85fhV8+ekgt0Gka8BK5YL8
 cK3Th2g7dZDjSr9HswGpsuj6bGvjG3fw8iHTLZUSvHepsUqe48c83rxFigav0YY8Kx/o Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37adjsk8w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:27:13 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12GA6wM5124941
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:27:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37adjsk8v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 06:27:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12GAMxvS009505;
        Tue, 16 Mar 2021 10:27:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 378n18jqun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 10:27:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12GAR7wY21365036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 10:27:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B70B35204F;
        Tue, 16 Mar 2021 10:27:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 790C85204E;
        Tue, 16 Mar 2021 10:27:07 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 2/6] s390x: css: simplifications of the
 tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <1615545714-13747-3-git-send-email-pmorel@linux.ibm.com>
 <2429a22a-a1f1-a995-0ca8-4f13373abb13@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <1b12bff2-0bed-acc1-9585-8a8fd45b3fb1@linux.ibm.com>
Date:   Tue, 16 Mar 2021 11:27:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <2429a22a-a1f1-a995-0ca8-4f13373abb13@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=935 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/15/21 11:48 AM, Janosch Frank wrote:
> On 3/12/21 11:41 AM, Pierre Morel wrote:
>> In order to ease the writing of tests based on:
>> - interrupt
>> - enabling a subchannel
>> - using multiple I/O on a channel without disabling it
>>
>> We do the following simplifications:
>> - the I/O interrupt handler is registered on CSS initialization
>> - We do not enable again a subchannel in senseid if it is already
>>    enabled
>> - we add a css_enabled() function to test if a subchannel is enabled
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 

thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
