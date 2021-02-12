Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C084431A1D6
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 16:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhBLPht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 10:37:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbhBLPhU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 10:37:20 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CFZuIx077999;
        Fri, 12 Feb 2021 10:36:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=p2j/rfEQwg/vwsz9ViFXZX09qnVpxDTgglYANJJR680=;
 b=ohfaGPgfZtNJNmjtMalGnzKrA9zyec003bObSSNx9ZBY1sFSq8VXyfAJpqsnAddRvapa
 x5Q7nfgtRJAFcWbKdPRnpDXG+JQ+bDVyar/mx8yNm89Pmw9pU3j3+nrDzYnJ7kdg675c
 FdNvEId1V9NqSbRHLqx5QmxJZbUSjb/3teZNAx0FmPWAFhDIrNAc6a+F+yflHttaDJ3H
 cxvlkFi3NQ4WpxE+Cqw4JXcfSyxLOwItovMVm2Dm/7RmiriI4jKr5S0qfBTxkkSfzLUZ
 UeDdr/FHs2uZqIjExq8EW2Haq/4hc+buB+NbnS93Yf/O8tL5clAWi/q8LxqfHXKpFHvN Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nuny1fjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:36:38 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11CFZwlY078175;
        Fri, 12 Feb 2021 10:36:32 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nuny1f4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:36:32 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CFIO2N010606;
        Fri, 12 Feb 2021 15:36:22 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 36hjr8bjfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 15:36:22 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CFaJgP56099256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 15:36:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAF7942049;
        Fri, 12 Feb 2021 15:36:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8723A42047;
        Fri, 12 Feb 2021 15:36:19 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 15:36:19 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/5] s390x: css: simplifications of the
 tests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
 <1612963214-30397-3-git-send-email-pmorel@linux.ibm.com>
 <20210212113651.38a372f9.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a2f1e7a0-b76a-d88a-fcab-80f763514a0e@linux.ibm.com>
Date:   Fri, 12 Feb 2021 16:36:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212113651.38a372f9.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/21 11:36 AM, Cornelia Huck wrote:
> On Wed, 10 Feb 2021 14:20:11 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
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
>> ---
>>   lib/s390x/css.h     |  1 +
>>   lib/s390x/css_lib.c | 37 ++++++++++++++++++++++----------
>>   s390x/css.c         | 51 ++++++++++++++++++++++++++-------------------
>>   3 files changed, 56 insertions(+), 33 deletions(-)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
