Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5771E1F82
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 12:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbgEZKR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 06:17:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731857AbgEZKRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 06:17:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QAC4dm102952;
        Tue, 26 May 2020 10:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6z4UXbxpSB4DLFidU7cgyywd9E0B1auRRbxxbHOd0lw=;
 b=gAkFY+lAo2pSNT4dx/FYBl7382fK97ukzDFOsmwnT1jUOh9zi55UYj1sx19BsHvSst2f
 dv9pSPtFIenT9+Z/m3NPVIlQKkeKC3nPmA7LwGKXAnOh9Z+5YZ0AmBA9BzhnP0qjCppL
 MCyrjIRMuWP+m8vJ4mlB5Y/NwNtiy3ZDJM7e8QLqWnJZHbz1A5+Rm6Wz4/WvidKuZj9m
 b5WmZyzIV1mfPHmh0NXx7tdw7cfCNWX+3tEjuHf3gJITyHsYU3NCQbQX9aMa7BOgCSNr
 U80aAvtVxyM33SE+nPmQwTkBZNCTdjgLI76p3pgQzCYI8R5Re0XCrMR6bJ/45E0NVLNn Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 318xe18wue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 10:16:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QADV5p185253;
        Tue, 26 May 2020 10:16:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 317j5myx0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 10:16:27 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04QAGLTa030926;
        Tue, 26 May 2020 10:16:23 GMT
Received: from [192.168.14.112] (/79.178.199.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 03:16:21 -0700
Subject: Re: [RFC 00/16] KVM protected memory extension
To:     Mike Rapoport <rppt@kernel.org>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
 <20200526061721.GB48741@kernel.org>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <8866ff79-e8fd-685d-9a1d-72acff5bf6bb@oracle.com>
Date:   Tue, 26 May 2020 13:16:14 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526061721.GB48741@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9632 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9632 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 26/05/2020 9:17, Mike Rapoport wrote:
> On Mon, May 25, 2020 at 04:47:18PM +0300, Liran Alon wrote:
>> On 22/05/2020 15:51, Kirill A. Shutemov wrote:
>>
>> Furthermore, I would like to point out that just unmapping guest data from
>> kernel direct-map is not sufficient to prevent all
>> guest-to-guest info-leaks via a kernel memory info-leak vulnerability. This
>> is because host kernel VA space have other regions
>> which contains guest sensitive data. For example, KVM per-vCPU struct (which
>> holds vCPU state) is allocated on slab and therefore
>> still leakable.
> Objects allocated from slab use the direct map, vmalloc() is another story.
It doesn't matter. This patch series, like XPFO, only removes guest 
memory pages from direct-map.
Not things such as KVM per-vCPU structs. That's why Julian & Marius 
(AWS), created the "Process local kernel VA region" patch-series
that declare a single PGD entry, which maps a kernelspace region, to 
have different PFN between different tasks.
For more information, see my KVM Forum talk slides I gave in previous 
reply and related AWS patch-series:
https://patchwork.kernel.org/cover/10990403/
>
>>>    - Touching direct mapping leads to fragmentation. We need to be able to
>>>      recover from it. I have a buggy patch that aims at recovering 2M/1G page.
>>>      It has to be fixed and tested properly
>> As I've mentioned above, not mapping all guest memory from 1GB hugetlbfs
>> will lead to holes in kernel direct-map which force it to not be mapped
>> anymore as a series of 1GB huge-pages.
>> This have non-trivial performance cost. Thus, I am not sure addressing this
>> use-case is valuable.
> Out of curiosity, do we actually have some numbers for the "non-trivial
> performance cost"? For instance for KVM usecase?
>
Dig into XPFO mailing-list discussions to find out...
I just remember that this was one of the main concerns regarding XPFO.

-Liran

