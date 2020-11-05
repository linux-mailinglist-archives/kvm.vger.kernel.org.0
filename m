Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2EB2A86C3
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 20:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbgKETGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 14:06:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727376AbgKETGs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 14:06:48 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5J6iaN060924
        for <kvm@vger.kernel.org>; Thu, 5 Nov 2020 14:06:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/GgNsaiPDfiqCPaPc0HcyUnFNqPXIst/Dy8hSK2KLno=;
 b=Q6rOoAzYv/qAP8GWw7j1+vbM0W64pSmsrZU9sUCahzrRYzkQc40vdf7a+hGzAWyjCHh8
 iqsBCksbpLfnYSK+11fXTO2a84qzCcgin+A+XsXFSoLe8b5C03/2rrulzqsYW29AnRFS
 3/SgQohDlgLSbQ/zJO1Vy8TuBDAtU40MR3Yi7kMqsbCoqKaLmx3d+kjw+zW+tZ//WqIB
 e9pTc737VfHSY87m6rAIQ1fOBIPqYILLVGMArdp5pUesviOPsggFzVuHvRqUMn/vX7YN
 jvEa+xKuqbSCtMnh8cpg2DK6SkW86B4BPnbaA3mVL2BONzc5fmti5LNlf8aiW6qW5ReO 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34m5dby5cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 14:06:46 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A5J6k9t061111
        for <kvm@vger.kernel.org>; Thu, 5 Nov 2020 14:06:46 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34m5dby3pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 14:06:46 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A5IllkJ007306;
        Thu, 5 Nov 2020 18:54:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 34hm6hd0sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 18:54:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A5IsQq78454870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 18:54:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C757A4054;
        Thu,  5 Nov 2020 18:54:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10A2DA405F;
        Thu,  5 Nov 2020 18:54:26 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.167.78])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Nov 2020 18:54:25 +0000 (GMT)
Subject: Re: [PATCH 09/11] KVM: selftests: Make vm_create_default common
To:     Peter Xu <peterx@redhat.com>, Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        bgardon@google.com
References: <20201104212357.171559-1-drjones@redhat.com>
 <20201104212357.171559-10-drjones@redhat.com>
 <20201104213612.rjykwe7pozcoqbcb@kamzik.brq.redhat.com>
 <c2c57735-2d1c-5abf-c2c0-ed04a19db5a0@de.ibm.com>
 <20201105095930.nofg64qyuf4qertu@kamzik.brq.redhat.com>
 <20201105184511.GC106309@xz-x1>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c27eb25a-3e4d-7812-3534-22a557443419@de.ibm.com>
Date:   Thu, 5 Nov 2020 19:54:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201105184511.GC106309@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_11:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.11.20 19:45, Peter Xu wrote:
> On Thu, Nov 05, 2020 at 10:59:30AM +0100, Andrew Jones wrote:
>>>>> +#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
>>>>
>>>> Doh. I think this 8 is supposed to be a 16 for s390x, considering it
>>>> was dividing by 256 in its version of vm_create_default. I need
>>>> guidance from s390x gurus as to whether or not I should respin though.
>>>>
>>>> Thanks,
>>>> drew
>>>>
>>>
>>> This is kind of tricky. The last level page table is only 2kb (256 entries = 1MB range).
>>> Depending on whether the page table allocation is clever or not (you can have 2 page
>>> tables in one page) this means that indeed 16 might be better. But then you actually 
>>> want to change the macro name to PTES_PER_PAGE?
>>
>> Thanks Christian,
>>
>> I'll respin with the macro name change and 16 for s390.
> 
> Maybe it can also be moved to common header, but instead define PTR_SIZE for
> per-arch?  I'm also curious whether PTR_SIZE will equals to "sizeof(void *)",
> but seems not for s390x..  Thanks,

Thats why I want to change the name. It is not about the ptr size. It is about
number of page table entries in a page. And as a page table is just 2kb on s390
there is a mismatch. So instead of

#define PTRS_PER_PAGE(page_size)	((page_size) / 8)

let us just to
#define PTES_PER_PAGETABLE 256
for s390
and
#define PTES_PER_PAGETABLE 512
for the others
