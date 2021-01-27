Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A29A3068B0
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 01:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhA1Ae7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 19:34:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhA1Aet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 19:34:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RMJu1s092018;
        Wed, 27 Jan 2021 22:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8UXsEmAiHDf4D1fAXGZeZey7rd2DdvzyvK1/GxuSs/o=;
 b=W3zEXvppoEce2l5X05cjoz+XkAL/uTdNGsM9zAghwbwPUAGa0ivq7dxHMi662mlWFwlg
 dCr8uFsCma3dy7Rx5GBjj+oXrggFb/7NuChcN6ZmVIkjVh/ytjFYLeyXfmgoH+ARgJRF
 MBZh/+4sEer5IfHba8uxfpWvGupFNHnkW3Bixrl4uTRZrSRm4e33a+76TO0n6z+utca5
 8c6IxNhwMr00PEQucUILlIY1bRfoU+7MJunaL5SDWL6Disq7iTZcAZoMxNxgf7LyYPLY
 1WvmAelGrFA3sLVhE5DpnYXVE4m6wW5SW1J4Hcioas7ZwEOMny7i/6zGriHz7aW8qOLM /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7r1hcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 22:27:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RMKa2s003539;
        Wed, 27 Jan 2021 22:27:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 368wq0tp1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 22:27:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10RMRXnU026850;
        Wed, 27 Jan 2021 22:27:33 GMT
Received: from [10.175.204.117] (/10.175.204.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Jan 2021 14:27:33 -0800
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
Message-ID: <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
Date:   Wed, 27 Jan 2021 23:27:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127175731.2020089-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.01.2021 18:57, Vitaly Kuznetsov wrote:
> Limiting the maximum number of user memslots globally can be undesirable as
> different VMs may have different needs. Generally, a relatively small
> number should suffice and a VMM may want to enforce the limitation so a VM
> won't accidentally eat too much memory. On the other hand, the number of
> required memslots can depend on the number of assigned vCPUs, e.g. each
> Hyper-V SynIC may require up to two additional slots per vCPU.
> 
> Prepare to limit the maximum number of user memslots per-VM. No real
> functional change in this patch as the limit is still hard-coded to
> KVM_USER_MEM_SLOTS.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Perhaps I didn't understand the idea clearly but I thought it was
to protect the kernel from a rogue userspace VMM allocating many
memslots and so consuming a lot of memory in kernel?

But then what's the difference between allocating 32k memslots for
one VM and allocating 509 slots for 64 VMs?

A guest can't add a memslot on its own, only the host software
(like QEMU) can, right?

Thanks,
Maciej
