Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E63A41AC43
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 11:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239985AbhI1Jwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 05:52:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240031AbhI1Jwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 05:52:33 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S9Cvu3015651;
        Tue, 28 Sep 2021 05:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XNDkmWzTb22GJXmq8gcwj59SGI8ba0ANlLXQ4wU7cVg=;
 b=JwEm0mSmnyREt35V2NeT6qQ84owf1bwvptxxa2NAsIKy56eCuowgTwNLa2rv3VttjPEs
 yO2L6W6ntqWz96u6+gcXfJzPBzp9jd17eOPgtn4j9TFSLWiaUJxJeuaQ/IfvwZ38CuaW
 nv0VFF1pI+HMz8cc8ycyZq9f5kK/kX3AkkoC47v/y1rIfkYU6mWAovvRKnvrIOBpxdND
 nyH0jd9gXjQQzI81K0yfew20Of+7Vdp5JW5t3Rby9PyWq1Fhg+Ej6/aXFFkEHT9l0Ikl
 /sgG2snO4gBYx5JXeR4cnQ2B+SV8z63vulnJQB1xiww7Rsg8EOkaajweDLc0VHicN5VK ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktqpmvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 05:50:52 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18S9knPu001213;
        Tue, 28 Sep 2021 05:50:52 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktqpmux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 05:50:52 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18S9Vpqt019548;
        Tue, 28 Sep 2021 09:50:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3b9ud9jw1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 09:50:49 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18S9okUJ48496938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:50:46 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76C374C052;
        Tue, 28 Sep 2021 09:50:46 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23A444C046;
        Tue, 28 Sep 2021 09:50:46 +0000 (GMT)
Received: from [9.145.12.195] (unknown [9.145.12.195])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Sep 2021 09:50:46 +0000 (GMT)
Message-ID: <43044ebc-38c5-ed5a-3552-78abc24af8d1@linux.ibm.com>
Date:   Tue, 28 Sep 2021 11:50:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH 2/9] s390x: pfmf: Fix 1MB handling
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-3-frankja@linux.ibm.com>
 <3826d85d-6a3f-4674-800e-1866eb80cdab@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <3826d85d-6a3f-4674-800e-1866eb80cdab@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Wp3E42gh5eeSc1rXUH6-l9-RovOF5lrS
X-Proofpoint-GUID: xknekDFLiyb3uksxKk_l98ejl-L5bBMd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=924 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/21 17:23, Thomas Huth wrote:
> On 22/09/2021 09.18, Janosch Frank wrote:
>> On everything larger than 4k pfmf will update the address in GR2 when
>> it's interrupted so we should loop on pfmf and not trust that it
>> doesn't get interrupted.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/pfmf.c | 10 ++++++++--
>>    1 file changed, 8 insertions(+), 2 deletions(-)
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

I had another discussion with the people that told me to change this and 
after some starring at the documentation we found out this won't fix 
anything because it's not a problem. FW will update GR2 and back off the 
PSW when it has been interrupted so it effectively loops itself.

So I'm dropping this patch
