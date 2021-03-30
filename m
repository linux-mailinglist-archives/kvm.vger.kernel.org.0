Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE634E825
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 14:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhC3M7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 08:59:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232021AbhC3M7H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 08:59:07 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UCYK37136833
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rumlZ3bVz4BjDUI4xAglYAvzcbx6DwBBx/ktAUz6PvU=;
 b=q2Xof/nsof12nzbnAKwUXCMtIzaTEcLEWjgY86bd84rL64lAmcYrvVkTmuAjDLn4GucA
 uNVZABY+xXTXF5N/Jq7M924xrRKz+olieceLbuAviGlmBv7zfom61LmzfbcO5dKMNEZc
 GZmktfQzM9j8BBIoZu5u8qort3BrY5uDMka3CuLl4eSCmvApHpwrWMdwsmkRSinWBrcJ
 4WueEzWTrxnZ2qp34S5XzGwU4jJxeGYkPQnuDW6mxK1R8O7a2cjFLmbQY2dRYhr/xpqF
 IiOK5U5jI7xSBqWy085lArSRgyw3m6dtORLH8sHhArXYRbY4Wx41nnG/x7rlUuUs/esa Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jjb60uf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:59:06 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12UCYLwX136968
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:59:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jjb60ued-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 08:59:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12UCvtJe013114;
        Tue, 30 Mar 2021 12:59:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 37hvb8aqvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 12:59:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12UCwg8O19202378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 12:58:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EA12AE056;
        Tue, 30 Mar 2021 12:59:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4069BAE04D;
        Tue, 30 Mar 2021 12:59:01 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Mar 2021 12:59:01 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: lib: css: SCSW bit
 definitions
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
 <20210330134931.169d071d.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ef2c3b68-f792-7f00-110f-f92b4e6542bc@linux.ibm.com>
Date:   Tue, 30 Mar 2021 14:59:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210330134931.169d071d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CRX5xDuY1brC1Oqgm2E1_2Tv19_xt6ll
X-Proofpoint-ORIG-GUID: 3AaFMQ131QM__di8EPDkUNVdBnZ5nkGq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_03:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/30/21 1:49 PM, Cornelia Huck wrote:
> On Thu, 25 Mar 2021 10:39:01 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We need the SCSW definitions to test clear and halt subchannel.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h | 23 +++++++++++++++++++++++
>>   1 file changed, 23 insertions(+)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
