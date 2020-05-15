Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79381D468A
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 08:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgEOG56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 02:57:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726623AbgEOG56 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 02:57:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F62Jpg066420;
        Fri, 15 May 2020 02:57:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310x56u0xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 02:57:56 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F6uoYT076327;
        Fri, 15 May 2020 02:57:56 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310x56u0wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 02:57:56 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F6tKXK011668;
        Fri, 15 May 2020 06:57:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3100ub22hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 06:57:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F6vq3Q53084174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 06:57:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FC96A405C;
        Fri, 15 May 2020 06:57:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBC8FA405B;
        Fri, 15 May 2020 06:57:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 06:57:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 04/10] s390x: interrupt registration
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-5-git-send-email-pmorel@linux.ibm.com>
 <20200514135805.77a7ae82.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <7da200e9-4cbe-0c77-833e-b4430cc2b80e@linux.ibm.com>
Date:   Fri, 15 May 2020 08:57:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514135805.77a7ae82.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_01:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=878 impostorscore=0
 adultscore=0 clxscore=1015 cotscore=-2147483648 lowpriorityscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150047
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-14 13:58, Cornelia Huck wrote:
> On Fri, 24 Apr 2020 12:45:46 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Let's make it possible to add and remove a custom io interrupt handler,
>> that can be used instead of the normal one.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
>>   lib/s390x/interrupt.h |  8 ++++++++
>>   2 files changed, 30 insertions(+), 1 deletion(-)
>>   create mode 100644 lib/s390x/interrupt.h
> 
> As the "normal one" means "no handler, just abort", is there any reason
> not simply to always provide one? What is the use case for multiple I/O
> interrupt handlers?
> 

I can only agree, I proposed this initially.
David asked for a registration.

-- 
Pierre Morel
IBM Lab Boeblingen
