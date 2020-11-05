Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E9E2A8097
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 15:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgKEOPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 09:15:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730922AbgKEOPy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 09:15:54 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5E4ZnT145736;
        Thu, 5 Nov 2020 09:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ks5ml82JtwEIeSkr25ZGskMY1W9FRlN45G1r5YiKSBk=;
 b=eb+WWLp1nvcRLRclVHb6n9caF3r1L7lvZJaVwLzSYSn/SN2mGWGyvXsqZwKs6h1oQGtl
 Q6m9G93fwkstHUezfN66pIVj9xf5B+K4kXCPN8Ip/P1gxzvyccnUKdIpHHzk1CepsxOV
 yjX6dmTmZjH+D93se/44dQfbRcTEDUV/Wz/0kaUIqIlJ2TSOaTm8ULT0qzSXKOS6Rl/z
 YlFWVbHjteta9QZa1sccs4k1HYRM+Rc1ga+KHBRAp9uHNQXW3QLXoh5B8wfHX+0nkzdr
 R6tEHgAHPWJnyxn/2hVgV48FYfz0WbJAIL/XLi2wtX7Cb3olTAWUhHi+8YAUWxbE85k5 DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m34y4tk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 09:15:54 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A5E5wkk151086;
        Thu, 5 Nov 2020 09:15:53 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m34y4tht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 09:15:53 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A5E956K030136;
        Thu, 5 Nov 2020 14:15:51 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 34h01kjtv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 14:15:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A5EFmiC56688960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 14:15:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 800C65204F;
        Thu,  5 Nov 2020 14:15:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.90.189])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1EC1352050;
        Thu,  5 Nov 2020 14:15:48 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com,
        Paolo Bonzini <pbonzini@redhat.com>
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
 <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
 <20200928173147.750e7358.cohuck@redhat.com>
 <136e1860-ddbc-edc0-7e67-fdbd8112a01e@linux.ibm.com>
 <f2ff3ddd-c70e-b2cc-b58f-bbcb1e4684d6@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
Message-ID: <63ac15b1-b4fe-b1b5-700f-ae403ce7fb85@linux.ibm.com>
Date:   Thu, 5 Nov 2020 15:15:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <f2ff3ddd-c70e-b2cc-b58f-bbcb1e4684d6@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_07:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011050092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/5/20 1:16 PM, Pierre Morel wrote:
> 
> 
> On 9/29/20 9:19 AM, Janosch Frank wrote:
>> On 9/28/20 5:31 PM, Cornelia Huck wrote:
>>> On Mon, 28 Sep 2020 16:23:34 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>
>>>> Some architectures need allocations to be done under a
>>>> specific address limit to allow DMA from I/O.
>>>>
>>>> We propose here a very simple page allocator to get
>>>> pages allocated under this specific limit.
>>>>
>>>> The DMA page allocator will only use part of the available memory
>>>> under the DMA address limit to let room for the standard allocator.
>>>>
> 
> ...snip...
> 
>>
>> Before we start any other discussion on this patch we should clear up if
>> this is still necessary after Claudio's alloc revamp.
>>
>> I think he added options to request special types of memory.
> 
> Isn't it possible to go on with this patch series.
> It can be adapted later to the changes that will be introduced by 
> Claudio when it is final.
> 
> 

Pierre, that's outside of my jurisdiction, you're adding code to the
common code library.

I've set Paolo CC, let's see if he finds this thread :)
