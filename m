Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFC511E67C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 16:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfLMPYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 10:24:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726599AbfLMPYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 10:24:24 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDFN3si134447
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 10:24:23 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wurcrxt6k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 10:24:22 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 13 Dec 2019 15:24:21 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 13 Dec 2019 15:24:19 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBDFOIw624904160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 15:24:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 925B852054;
        Fri, 13 Dec 2019 15:24:18 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5B9725204E;
        Fri, 13 Dec 2019 15:24:18 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 8/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-9-git-send-email-pmorel@linux.ibm.com>
 <20191212132634.3a16a389.cohuck@redhat.com>
 <1ea58644-9f24-f547-92d5-a99dcb041502@linux.ibm.com>
 <96034dbc-489a-7f76-0402-d5c0c42d20b3@linux.ibm.com>
 <20191213104350.6ebe4aa6.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 13 Dec 2019 16:24:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191213104350.6ebe4aa6.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19121315-0020-0000-0000-00000397D401
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121315-0021-0000-0000-000021EEE253
Message-Id: <ea7707f9-bba2-e9f4-77ad-7f2e9fdef21d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_03:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=801
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-13 10:43, Cornelia Huck wrote:
> On Thu, 12 Dec 2019 19:20:07 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2019-12-12 15:10, Pierre Morel wrote:
>>>
>>>
>>> On 2019-12-12 13:26, Cornelia Huck wrote:
>>>> On Wed, 11 Dec 2019 16:46:09 +0100
>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>>>>> +
>>>>> +    senseid.cu_type = buffer[2] | (buffer[1] << 8);
>>>>
>>>> This still looks odd; why not have the ccw fill out the senseid
>>>> structure directly?
>>>
>>> Oh sorry, you already said and I forgot to modify this.
>>> thanks
>>
>> hum, sorry, I forgot, the sense structure is not padded so I need this.
> 
> Very confused; I see padding in the senseid structure? (And what does
> padding have to do with it?)

Sorry my fault:
I wanted to say packed and... I forgot to pack the senseid structure.
So I change this.

> 
> Also, you only copy the cu type... it would really be much better if
> you looked at the whole structure you got back from the hypervisor;
> that would also allow you to do some more sanity checks etc. If you
> really can't pass in a senseid structure directly, just copy everything
> you got?
> 

No I can, just need to work properly ;)

I will only check on the cu_type but report_info() on all fields.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

