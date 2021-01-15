Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8352F84B7
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 19:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbhAOStM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 13:49:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57592 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbhAOStM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 13:49:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FIdwSY058936;
        Fri, 15 Jan 2021 18:47:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EAHeuu2Rqg2Jt6+I/DGebspS35E8SkUI2yr67Ixz714=;
 b=XlISAWKq1yXIsnTRpn7WzjLIWM1vSpvlc7WK8wrXhIa1XBnwAva9WrcmKkDMC+VpZ6MP
 H4q/Qr1ynkMy5DMQ/xkr4sos392kGc9rzJDdh1xXkMrMLlIUX8Pldi3mgsdTVLnIGPRB
 1z+9x4HRZVdzInI8jKdFvQkNLwX1878SjOfNgtAE6rjKU5nPF+oq15HcR7A+rrzvnW48
 je1s1QP8Q4p/XJ6ELx50wTg9uqyMPKMtskPcfw9NBJnfcb1NsWiCrCWefj0iL3JsKrPA
 1jf48r0tOmFbJ+USpDsc9IMZxAQxzbfztX2V6C/M3519b2J2XlSmC2mgshjhUhIVNM7W Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg26b43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 18:47:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FIfJiC064297;
        Fri, 15 Jan 2021 18:47:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kfbe20x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 18:47:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10FIlOD7014658;
        Fri, 15 Jan 2021 18:47:24 GMT
Received: from [10.175.172.67] (/10.175.172.67)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Jan 2021 10:47:24 -0800
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS
 limit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
Organization: Oracle Corporation
Message-ID: <40efcfa8-c625-80b5-7ac9-da7839ed6011@oracle.com>
Date:   Fri, 15 Jan 2021 19:47:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210115131844.468982-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=744 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=754 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.01.2021 14:18, Vitaly Kuznetsov wrote:
> TL;DR: any particular reason why KVM_USER_MEM_SLOTS is so low?
> 
> Longer version:
> 
> Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
> configurations. In particular, when QEMU tries to start a Windows guest
> with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
> requires two pages per vCPU and the guest is free to pick any GFN for
> each of them, this fragments memslots as QEMU wants to have a separate
> memslot for each of these pages (which are supposed to act as 'overlay'
> pages).
> 
> Memory slots are allocated dynamically in KVM when added so the only real
> limitation is 'id_to_index' array which is 'short'. We don't have any
> KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined arrays.
> 
> We could've just raised the limit to e.g. '1021' (we have 3 private
> memslots on x86) and this should be enough for now as KVM_MAX_VCPUS is
> '288' but AFAIK there are plans to raise this limit as well.
> 

I have a patch series that reworks the whole memslot thing, bringing
performance improvements across the board.
Will post it in few days, together with a new mini benchmark set.

Maciej
