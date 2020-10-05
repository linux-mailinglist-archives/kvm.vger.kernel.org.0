Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B186283535
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 13:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgJELyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 07:54:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgJELyt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 07:54:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095BgsnB101169
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 07:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0BGGaZVlZu8r04E5WuIjjh8FYjN0KQcHGaHmZVMAdik=;
 b=dOGA2+UJ6oonCyhUDL+nABk7XyWAJe2D+qgI/Y/qJV01LV+514g+15ffjfkb5YNyimEU
 VBYL1x0ywD+m2rYD//L8VeEuVficX0bmHTSo2FDYKhXxwqWXT7/Y8wUmQvBDdU6wpkvX
 hi9PdBlB5A7tx6Sl2Hib9TmD539N8ZaLR8ekddbdvGIHMgpMXI2hPhBAQSQT3SOHrn4z
 dam7n79szqW13f01Z4Uo5Q3+/L5WCBTj2EovkOUPCSpk6IL9PLV1z4zk0OMy14bP1Q/J
 e6b2fZPQltWTnlKPy3zY//htYY1bGY6pwWKspmQF0thUMlWdJ2xiQjgjdf3r7pTvMGuP aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3402uug9ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 07:54:48 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095BjS59111948
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 07:54:48 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3402uug9kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 07:54:48 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095Bqaq6030585;
        Mon, 5 Oct 2020 11:54:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 33xgx813hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 11:54:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095BshYv28115416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 11:54:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 192F6A405F;
        Mon,  5 Oct 2020 11:54:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC519A4053;
        Mon,  5 Oct 2020 11:54:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.6.235])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Oct 2020 11:54:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Rewrite the allocators
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <aec4a269-efba-83c0-cbbb-c78b132b1fa9@linux.ibm.com>
Date:   Mon, 5 Oct 2020 13:54:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_06:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=2 mlxlogscore=927
 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-10-02 17:44, Claudio Imbrenda wrote:
> The KVM unit tests are increasingly being used to test more than just
> KVM. They are being used to test TCG, qemu I/O device emulation, other
> hypervisors, and even actual hardware.
> 
> The existing memory allocators are becoming more and more inadequate to
> the needs of the upcoming unit tests (but also some existing ones, see
> below).
> 
> Some important features that are lacking:
> * ability to perform a small physical page allocation with a big
>    alignment withtout wasting huge amounts of memory
> * ability to allocate physical pages from specific pools/areaas (e.g.
>    below 16M, or 4G, etc)
> * ability to reserve arbitrary pages (if free), removing them from the
>    free pool
> 
> Some other features that are nice, but not so fundamental:
> * no need for the generic allocator to keep track of metadata
>    (i.e. allocation size), this is now handled by the lower level
>    allocators
> * coalescing small blocks into bigger ones, to allow contiguous memory
>    freed in small blocks in a random order to be used for large
>    allocations again
> 
> This is achieved in the following ways:
> 
> For the virtual allocator:
> * only the virtul allocator needs one extra page of metadata, but only
>    for allocations that wouldn't fit in one page
> 
> For the page allocator:
> * page allocator has up to 6 memory pools, each pool has a metadata
>    area; the metadata has a byte for each page in the area, describing
>    the order of the block it belongs to, and whether it is free
> * if there are no free blocks of the desired size, a bigger block is
>    split until we reach the required size; the unused parts of the block
>    are put back in the free lists
> * if an allocation needs ablock with a larger alignment than its size, a
>    larger block of (at least) the required order is split; the unused parts
>    put back in the appropriate free lists
> * if the allocation could not be satisfied, the next allowed area is
>    searched; the allocation fails only when all allowed areas have been
>    tried
> * new functions to perform allocations from specific areas; the areas
>    are arch-dependent and should be set up by the arch code
> * for now x86 has a memory area for "lowest" memory under 16MB, one for
>    "low" memory under 4GB and one for the rest, while s390x has one for under
>    2GB and one for the rest; suggestions for more fine grained areas or for
>    the other architectures are welcome


While doing a page allocator, the topology is not the only 
characteristic we may need to specify.
Specific page characteristics like rights, access flags, cache behavior 
may be useful when testing I/O for some architectures.
This obviously will need some connection to the MMU handling.

Wouldn't it be interesting to use a bitmap flag as argument to 
page_alloc() to define separate regions, even if the connection with the 
MMU is done in a future series?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
