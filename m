Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159C51D46DC
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgEOHOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:14:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44408 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726313AbgEOHOm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 03:14:42 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F72bCc149023;
        Fri, 15 May 2020 03:14:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ua8tpep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:14:41 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F72ixw149222;
        Fri, 15 May 2020 03:14:41 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ua8tpe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:14:41 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F74wZp001191;
        Fri, 15 May 2020 07:14:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3100ub53s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 07:14:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F7EbtJ58261606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 07:14:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 277FAA4054;
        Fri, 15 May 2020 07:14:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE92A4060;
        Fri, 15 May 2020 07:14:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 07:14:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 05/10] s390x: Library resources for CSS
 tests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-6-git-send-email-pmorel@linux.ibm.com>
 <20200514140315.6077046b.cohuck@redhat.com>
 <42beb241-8cc1-51a1-b374-3fb89968df36@linux.ibm.com>
 <20200515091127.3cd629d7.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <4b55b2ec-6e68-1edd-2263-ef0bbe949fc2@linux.ibm.com>
Date:   Fri, 15 May 2020 09:14:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515091127.3cd629d7.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 priorityscore=1501 suspectscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-15 09:11, Cornelia Huck wrote:
> On Fri, 15 May 2020 09:02:37 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2020-05-14 14:03, Cornelia Huck wrote:
>>> On Fri, 24 Apr 2020 12:45:47 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>>>> + * - IRB  : Interuption response Block, describes the result of an operation
>>>
>>> s/operation/operation;/
>>
>> ? I do not understand, do you want a ";" at the end of "operation"
> 
> Yes, I think that makes the description read more like a proper
> sentence (describe what its purpose is; describe its contents).
> 

You are right, thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
