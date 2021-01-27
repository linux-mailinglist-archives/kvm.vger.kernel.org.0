Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C47306846
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 00:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhA0XsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 18:48:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhA0XsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 18:48:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RMIeXf167220;
        Wed, 27 Jan 2021 22:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TdHww95gjSxUeJXxsJ60xTRT/aET3PzURPA/c9zfpWU=;
 b=MPJi5+7cKK/c9ICSu1xIG/0Vye67NLfuSxHbrYPhv99N08QV+oQqBDptbUFZNu8aAAtF
 qFyZTM8Oh/xtqJn+7wQgxRdyxbcpspCy+JPLlUolpNa8KWFLgMnhioQVi5Os+kE6o4sL
 sbYtBayC/yxHDlT1TCP5sXio+ASA+G6Tzzeqcqq25+0FjuWEnncTaH+QykfmNDQOoi5m
 aHup/6jCs1i+Ot+tGnwhtEFLY9t6Qaf49OHj4P4HEY7nOdTDyciqCZcVjgaHfkcc8nP7
 1q8rCznrGUPSSAMdX+AnHjOcVZ+o/b6JGKKPpYUBaScw9fL9kG45pratHroxKsq5IB9h RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 368brksefc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 22:27:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RMKDT8010375;
        Wed, 27 Jan 2021 22:27:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 368wqydshq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 22:27:07 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10RMR287001684;
        Wed, 27 Jan 2021 22:27:02 GMT
Received: from [10.175.204.117] (/10.175.204.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Jan 2021 14:27:02 -0800
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS
 limit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <40efcfa8-c625-80b5-7ac9-da7839ed6011@oracle.com>
 <87czxq2rj9.fsf@vitty.brq.redhat.com>
Message-ID: <117b94cc-d1e0-1575-e127-dd5785cf17cd@oracle.com>
Date:   Wed, 27 Jan 2021 23:26:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <87czxq2rj9.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 27.01.2021 18:55, Vitaly Kuznetsov wrote:
> "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com> writes:
> 
>> On 15.01.2021 14:18, Vitaly Kuznetsov wrote:
>>> TL;DR: any particular reason why KVM_USER_MEM_SLOTS is so low?
>>>
>>> Longer version:
>>>
>>> Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
>>> configurations. In particular, when QEMU tries to start a Windows guest
>>> with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
>>> requires two pages per vCPU and the guest is free to pick any GFN for
>>> each of them, this fragments memslots as QEMU wants to have a separate
>>> memslot for each of these pages (which are supposed to act as 'overlay'
>>> pages).
>>>
>>> Memory slots are allocated dynamically in KVM when added so the only real
>>> limitation is 'id_to_index' array which is 'short'. We don't have any
>>> KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined arrays.
>>>
>>> We could've just raised the limit to e.g. '1021' (we have 3 private
>>> memslots on x86) and this should be enough for now as KVM_MAX_VCPUS is
>>> '288' but AFAIK there are plans to raise this limit as well.
>>>
>>
>> I have a patch series that reworks the whole memslot thing, bringing
>> performance improvements across the board.
>> Will post it in few days, together with a new mini benchmark set.
> 
> I'm about to send a successor of this series. It will be implmenting
> Sean's idea to make the maximum number of memslots a per-VM thing (and
> also raise the default). Hope it won't interfere with your work!

Thanks for your series and CC'ing me on it.

It looks like there should be no design conflicts, I will merely need to
rebase on top of it.

By the way I had to change a bit the KVM selftest framework memslot
handling for my stuff, too, since otherwise just adding 32k memslots
for a test would take almost forever.

Thanks,
Maciej
