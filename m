Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF544D635
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 12:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhKKL5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 06:57:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233245AbhKKL5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 06:57:47 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABAvnsD021890
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 11:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=muRukBJ8i0haFQjSTGNVrEoJbGz5jxx8cYxIWGNvG4w=;
 b=Z+HprmeyH/SPkTCnr1rBV2hUSmdpjwybJDmp33JsLVha4nw1U1nl+By/WRlXvQ5IlnA/
 8YzumBsb64sDZMSxFJFg9uf7JSN/0wjJWVZuLh8K41lH4fjeIklX0w2HlqE1LSmopWwU
 F2n5N1nk1I8GLD9cWS7Ezl3g5OFvgeB9BNOM5B2WrykIh5ILlbU9TDrHjmbOIUrxvj/n
 9o/A70rzQKdwunls9rEZX+RlgD+oIDI1mGPBgx81QMmbV79I2jOnvp6xhydVH7GfHzqJ
 FePbXF7yLw/UYri0sVaD8bqJuQOeI6N5ahttFmD8lW7zZwDEbpRML4lmpwXBumBRoSOM gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c8wbp8jq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 11:54:58 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABBfYvZ025400
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 11:54:57 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c8wbp8jp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 11:54:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABBqrT9013321;
        Thu, 11 Nov 2021 11:54:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hbaw95x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 11:54:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABBsqlA59179410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 11:54:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31A9C4C04A;
        Thu, 11 Nov 2021 11:54:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C22B44C050;
        Thu, 11 Nov 2021 11:54:51 +0000 (GMT)
Received: from [9.171.69.58] (unknown [9.171.69.58])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 11:54:51 +0000 (GMT)
Message-ID: <8f8d6807-1ab4-3782-b448-f1c629876194@linux.ibm.com>
Date:   Thu, 11 Nov 2021 12:55:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        cohuck@redhat.com
References: <20211111100153.86088-1-pmorel@linux.ibm.com>
 <31f51c84-c7f9-8251-39a8-3ff38496ae5e@redhat.com>
 <20211111112806.50e4d22a@p-imbrenda>
 <4828bb9d-6bfe-a9da-51a4-77f4e78f7556@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <4828bb9d-6bfe-a9da-51a4-77f4e78f7556@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 13Id2sbF1GuB_SLn-GIJSkqHJPF8tFhW
X-Proofpoint-GUID: j1dOmtuc89YYbXe2NBMBd1n7OMBMebyw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_03,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/11/21 11:39, David Hildenbrand wrote:
> On 11.11.21 11:28, Claudio Imbrenda wrote:
>> On Thu, 11 Nov 2021 11:14:53 +0100
>> David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 11.11.21 11:01, Pierre Morel wrote:
>>>> The allocator allocate pages it follows the size must be rounded
>>>> to pages before the allocation.
>>>>
>>>> Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
>>>>    
>>>
>>> What's the symptom of this? A failing test? Or is this just a pro-activ fix?
>>
>> if size < PAGE_SIZE then we would allocate 0, and in general we are
>> rounding down instead of up, which is obviously wrong.
>>
> 
> I know, but is this fixing a failing test or is this just a pro-activ fix?
> 

It is not fixing an existing test but it must be fixed before the VIRTIO 
test that I am currently developing.
In the current tests we do not allocate sizes greater than 1 page that 
are no multiple of pages.

-- 
Pierre Morel
IBM Lab Boeblingen
