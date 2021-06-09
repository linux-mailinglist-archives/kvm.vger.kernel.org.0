Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7FA3A1C5A
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 19:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhFIRuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 13:50:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231810AbhFIRuE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 13:50:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159HXPwH166986;
        Wed, 9 Jun 2021 13:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qq7VXFeevVpStHRWsXVOehxcpO+2RgWaMg7rO3uTjhk=;
 b=GyE176ThP/s+gHa/G/nLJWTZRbP3sFQepOwOmSFxbAt+h5iqDkJXdVz6jETuZI24pVlO
 8pZkI4t+JMkGatQ9GdFY0AzqdCZHfAfEhxC/12WB1gqY09OzzSl1b013Dya1bJw4WFqA
 kLl2F39iwSZFOFjkuJ0+LwAR2As0zWdhp+ye8j1nB6HRBC+kvTglhCoyODSyS8KBe8KX
 D9ArHgCgkWzbtjQ5OsgEfI8tbeIo44f1xmwY6JIPhdNYaCM4DGrlotOtMaFFebx7Kbgv
 XTDORSD2izCW38oNeiPodNEespc+pRlMLscWjRoFWgJ+hXWSdhJkAY7xGpo+xMI6ECCH ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3930r1k7vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 13:47:50 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 159HZc8v173764;
        Wed, 9 Jun 2021 13:47:50 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3930r1k7v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 13:47:49 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 159HldaD005888;
        Wed, 9 Jun 2021 17:47:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3900w89a21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 17:47:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 159Hlj4Z32309716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Jun 2021 17:47:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19C62AE051;
        Wed,  9 Jun 2021 17:47:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E95EAE045;
        Wed,  9 Jun 2021 17:47:44 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.13.5])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Jun 2021 17:47:44 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] mm/vmalloc: export __vmalloc_node_range
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
 <20210608180618.477766-2-imbrenda@linux.ibm.com>
 <YMDlVdB8m62AhbB7@infradead.org> <20210609182809.7ae07aad@ibm-vm>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <6bf6fb06-0930-8cae-3e2b-8cb3237a6197@de.ibm.com>
Date:   Wed, 9 Jun 2021 19:47:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210609182809.7ae07aad@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZsdyWAcx_73hJwtXE9Sp0Mco4mrsan6t
X-Proofpoint-GUID: qH6CxK9epqyjYop4gXKwm76Ys42u_HKD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 clxscore=1011 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.06.21 18:28, Claudio Imbrenda wrote:
> On Wed, 9 Jun 2021 16:59:17 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Tue, Jun 08, 2021 at 08:06:17PM +0200, Claudio Imbrenda wrote:
>>> The recent patches to add support for hugepage vmalloc mappings
>>> added a flag for __vmalloc_node_range to allow to request small
>>> pages. This flag is not accessible when calling vmalloc, the only
>>> option is to call directly __vmalloc_node_range, which is not
>>> exported.
>>>
>>> This means that a module can't vmalloc memory with small pages.
>>>
>>> Case in point: KVM on s390x needs to vmalloc a large area, and it
>>> needs to be mapped with small pages, because of a hardware
>>> limitation.
>>>
>>> This patch exports __vmalloc_node_range so it can be used in modules
>>> too.
>>
>> No.  I spent a lot of effort to mak sure such a low-level API is
>> not exported.
> 
> ok, but then how can we vmalloc memory with small pages from KVM?

An alternative would be to provide a vmalloc_no_huge function in generic
code  (similar to  vmalloc_32) (or if preferred in s390 base architecture code)
Something like

void *vmalloc_no_huge(unsigned long size)
{
         return __vmalloc_node_flags(size, NUMA_NO_NODE,VM_NO_HUGE_VMAP |
                                 GFP_KERNEL | __GFP_ZERO);
}
EXPORT_SYMBOL(vmalloc_no_huge);

or a similar vzalloc variant.
