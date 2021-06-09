Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F203A1C5E
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhFIRwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 13:52:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231785AbhFIRwn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 13:52:43 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159HXGdG062295;
        Wed, 9 Jun 2021 13:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TsE7K9AEgOY5t7Fl5iXw74bhWOBWGgF7QY2kPSYlNb8=;
 b=of6Ys8gf/aMloMG3AblIDMM4yVktSuQy9oBpdS4zGFyO7uEbhZDtQOghDpgmBl8VVsTi
 oYiLTx7P0nkuNrba8/jLPnosI/n3zQn+eAMiXeATNg6lFFqg1F04v7eGCDQ35zZQt47T
 Rdqb9naZMTghHIZjTkdO1OzJEYkLfw8uA/FerCXn+2EjPVXCb8frUoTosiy6RUMjWMHD
 bYHYDhjyKwVP0KrUrwF95HrpULMRHZ9/QvxddBLMS2zjyuLLK7PUmp5333etOFab3Kqn
 Z+AOxzeCcO06roXiDR+B27PPTEYy97/CcnwNCYA+5WnPN9ENuA1YjTfGNxtmRD++1Pjo lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39324grcm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 13:50:35 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 159HZ8ho069317;
        Wed, 9 Jun 2021 13:50:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39324grcka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 13:50:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 159HlNHp012435;
        Wed, 9 Jun 2021 17:50:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8jb5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 17:50:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 159Hncrp27525546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Jun 2021 17:49:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39843AE053;
        Wed,  9 Jun 2021 17:50:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A8EFAE045;
        Wed,  9 Jun 2021 17:50:28 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.13.5])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Jun 2021 17:50:28 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] mm/vmalloc: export __vmalloc_node_range
To:     Uladzislau Rezki <urezki@gmail.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
 <20210608180618.477766-2-imbrenda@linux.ibm.com>
 <YMDlVdB8m62AhbB7@infradead.org> <20210609182809.7ae07aad@ibm-vm>
 <20210609164919.GA1938@pc638.lan>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1fec60f1-6479-39a6-f47f-f47166f754f6@de.ibm.com>
Date:   Wed, 9 Jun 2021 19:50:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210609164919.GA1938@pc638.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C7pzIybad354Dlmg-WHXAmSDyDEkUBA0
X-Proofpoint-ORIG-GUID: 8lJefzpcUGju01xPyP9PWcM0k5gaepPN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_07:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09.06.21 18:49, Uladzislau Rezki wrote:
> On Wed, Jun 09, 2021 at 06:28:09PM +0200, Claudio Imbrenda wrote:
>> On Wed, 9 Jun 2021 16:59:17 +0100
>> Christoph Hellwig <hch@infradead.org> wrote:
>>
>>> On Tue, Jun 08, 2021 at 08:06:17PM +0200, Claudio Imbrenda wrote:
>>>> The recent patches to add support for hugepage vmalloc mappings
>>>> added a flag for __vmalloc_node_range to allow to request small
>>>> pages. This flag is not accessible when calling vmalloc, the only
>>>> option is to call directly __vmalloc_node_range, which is not
>>>> exported.
>>>>
>>>> This means that a module can't vmalloc memory with small pages.
>>>>
>>>> Case in point: KVM on s390x needs to vmalloc a large area, and it
>>>> needs to be mapped with small pages, because of a hardware
>>>> limitation.
>>>>
>>>> This patch exports __vmalloc_node_range so it can be used in modules
>>>> too.
>>>
>>> No.  I spent a lot of effort to mak sure such a low-level API is
>>> not exported.
>>
>> ok, but then how can we vmalloc memory with small pages from KVM?
> Does the s390x support CONFIG_HAVE_ARCH_HUGE_VMALLOC what is arch
> specific?

Not yet, but we surely want that for almost everything on s390.
Only this particular firmware interface does not handle large pages
for donated memory.

> 
> If not then small pages are used. Or am i missing something?
> 
> I agree with Christoph that exporting a low level internals
> is not a good idea.
