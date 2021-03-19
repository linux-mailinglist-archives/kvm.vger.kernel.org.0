Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEBA3420F6
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 16:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhCSP3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 11:29:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhCSP3J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 11:29:09 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JF3xm5095912
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bqcoAHtgbC7PZlWxYQkYpq6WS31CDeY98ASowVR4kp8=;
 b=Zlpjd6HQMy9EDM4HYb5rUf8bLRUvUDShDGa+o/srY2O0s+G6sW7FxTpv5yJ9yEIFWcpk
 irE+mGniKvrJAgKjE/9pzmZoBv8CtG8BxFMsrqcYXPzYlsJ0QROOqbBdGfrra18wYIC7
 fbUeZNPFWERaZrGsdMg2LVlTQVtMaX2QNRpcWnntDIs5Owvn19zuB5k/ZKDVZwl3UqMY
 6GvcM/iOwP9JWDrkxUrRHAaON0Y8+8d3bxYabV5UdyDwy5pK5DRv/7DX++YWcJ0FFv1B
 DfrUyXcDsKohtOlcrcE8VIyMDDVqnVo2kzT+q5DhM1aD17dZV0smZZL5C0j8zuHtf5Nu fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c103kb71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:29:09 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JF4VSs103580
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 11:29:09 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c103kb69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 11:29:09 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JFNbm2018509;
        Fri, 19 Mar 2021 15:29:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 378n18b3xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:29:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JFT3Pd17170750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 15:29:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB7ED11C04C;
        Fri, 19 Mar 2021 15:29:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DE7911C04A;
        Fri, 19 Mar 2021 15:29:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.3.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 15:29:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/6] s390x: lib: css: disabling a
 subchannel
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-2-git-send-email-pmorel@linux.ibm.com>
 <20210319110327.48ca8f8a.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c37a9dab-07b9-b0c9-7c22-3393b5772153@linux.ibm.com>
Date:   Fri, 19 Mar 2021 16:29:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319110327.48ca8f8a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_06:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=948 malwarescore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 11:03 AM, Cornelia Huck wrote:
> On Thu, 18 Mar 2021 14:26:23 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Some tests require to disable a subchannel.
>> Let's implement the css_disable() function.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   lib/s390x/css_lib.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 70 insertions(+)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
