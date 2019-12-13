Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D3311E5C2
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 15:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfLMOkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 09:40:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727673AbfLMOkv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 09:40:51 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDEWxM8068252
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 09:40:49 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wusnc1sha-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 09:40:49 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 13 Dec 2019 14:40:46 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 13 Dec 2019 14:40:43 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBDEegie34406406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 14:40:42 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B11B052059;
        Fri, 13 Dec 2019 14:40:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7B25E5204E;
        Fri, 13 Dec 2019 14:40:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
 <20191212130111.0f75fe7f.cohuck@redhat.com>
 <83d45c31-30c3-36e1-1d68-51b88448f4af@linux.ibm.com>
 <20191212151002.1c7ca4eb.cohuck@redhat.com>
 <c92089cf-39f4-3b64-79a8-3264654130b1@linux.ibm.com>
 <20191212153303.6444697e.cohuck@redhat.com>
 <a29048f4-1783-54c6-8bf3-91d573b2d49d@linux.ibm.com>
 <d34fdb07-c2ff-3a1e-eb31-cf9d160ebac9@linux.ibm.com>
 <20191213103346.1e42d52b.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 13 Dec 2019 15:40:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191213103346.1e42d52b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121314-0008-0000-0000-000003407DE9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121314-0009-0000-0000-00004A608448
Message-Id: <cd625af6-c225-7871-bd74-bf52e22093ef@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_03:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=983 priorityscore=1501 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-13 10:33, Cornelia Huck wrote:
> On Thu, 12 Dec 2019 18:33:15 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> After all, I make it simple by testing if the MSCH works as expected, no
>> retry, no delay.
>> This is just a test.
> 
> That's probably fine if you only run under kvm (not sure what your
> further plans here are).

If the test fails, it fails.

However, for other tests we need the enable to work.
For example before making a SENSE_ID, in this case we will make retries.



> 
>>
>> I will add a new patch to add a library function to enable the channel,
>> with retry to serve when we really need to enable the channel, not to test.
> 
> A simple enable should be enough for kvm-only usage, we can add a retry
> easily if needed.
> 
> We probably can also defer adding the library function until after we
> get another user :)
> 

I already work on it in the prepared next series, I have
- the enable test
and
- a enable_sch to use as a librairy function

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

