Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814EC394E7A
	for <lists+kvm@lfdr.de>; Sun, 30 May 2021 01:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhE2XPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 19:15:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhE2XPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 May 2021 19:15:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14TNDgMZ154108;
        Sat, 29 May 2021 23:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RkmhCSidUT0y0Ul7NvKR7BmL68rnNC9iDQla8Xzwtko=;
 b=F16IkdRqRhnxqasl0c+0eGwbL1Ht0Meu8uSkXkQooYMJHFTs5mfX5/ME6mr2IUjas6Rv
 AQ9Gz5Jv9s/L14o0mxkVHLACJ4AgC0q8TfZDMa7tadpnOOiGHjyfLVPEoRzU91OOH5tF
 YfEDHpM34jIlmA/fCvkVFoFnbBNQ8doGBcPJLW0Z/SaPWsQVJhVTVtOHfEis4xZpKFLM
 9Thi9vEh5gCh3hBw9aqft6oIF9xDjIf6z5Bmd1GT1wuNsI74BJf9rT0uUu3jwExd5idu
 WL890XX/jfOjQ73EwajOG96n9pdk8B/1iuMKiDWrEIdMlkw/dThjnUmY5xdXzrH7YfIH uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38ud1s8vny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 May 2021 23:13:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14TN6Hfq138762;
        Sat, 29 May 2021 23:13:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 38ubnbh5tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 May 2021 23:13:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14TNDebL014173;
        Sat, 29 May 2021 23:13:41 GMT
Received: from [10.175.203.186] (/10.175.203.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 29 May 2021 23:13:40 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
 memslot_perf_test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210528191134.3740950-1-pbonzini@redhat.com>
 <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
 <fc41bfc4-949f-03c5-3b20-2c1563ad7f62@redhat.com>
Message-ID: <73511f2e-7b5d-0d29-b8dc-9cb16675afb3@oracle.com>
Date:   Sun, 30 May 2021 01:13:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <fc41bfc4-949f-03c5-3b20-2c1563ad7f62@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9999 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105290174
X-Proofpoint-ORIG-GUID: oYZTb328FqYgOXyhTf9894XnCAmX6die
X-Proofpoint-GUID: oYZTb328FqYgOXyhTf9894XnCAmX6die
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9999 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105290175
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29.05.2021 12:20, Paolo Bonzini wrote:
> On 28/05/21 21:51, Maciej S. Szmigiero wrote:
>> On 28.05.2021 21:11, Paolo Bonzini wrote:
>>> The memory that is allocated in vm_create is already mapped close to
>>> GPA 0, because test_execute passes the requested memory to
>>> prepare_vm.  This causes overlapping memory regions and the
>>> test crashes.  For simplicity just move MEM_GPA higher.
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> I am not sure that I understand the issue correctly, is vm_create_default()
>> already reserving low GPAs (around 0x10000000) on some arches or run
>> environments?
> 
> It maps the number of pages you pass in the second argument, see
> vm_create.
> 
>    if (phy_pages != 0)
>      vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
>                                  0, 0, phy_pages, 0);
> 
> In this case:
> 
>    data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
> 
> called here:
> 
>    if (!prepare_vm(data, nslots, maxslots, tdata->guest_code,
>                    mem_size, slot_runtime)) {
> 
> where mempages is mem_size, which is declared as:
> 
>          uint64_t mem_size = tdata->mem_size ? : MEM_SIZE_PAGES;
> 
> but actually a better fix is just to pass a small fixed value (e.g. 1024) to vm_create_default,
> since all other regions are added by hand

Yes, but the argument that is passed to vm_create_default() (mem_size
in the case of the test) is not passed as phy_pages to vm_create().
Rather, vm_create_with_vcpus() calculates some upper bound of extra
memory that is needed to cover that much guest memory (including for
its page tables).

The biggest possible mem_size from memslot_perf_test is 512 MiB + 1 page,
according to my calculations this results in phy_pages of 1029 (~4 MiB)
in the x86-64 case and around 1540 (~6 MiB) in the s390x case (here I am
not sure about the exact number, since s390x has some additional alignment
requirements).

Both values are well below 256 MiB (0x10000000UL), so I was wondering
what kind of circumstances can make these allocations collide
(maybe I am missing something in my analysis).

> 
> Paolo
> 

Thanks,
Maciej
