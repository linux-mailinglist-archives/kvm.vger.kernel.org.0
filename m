Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2277DED821
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 04:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfKDDuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Nov 2019 22:50:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfKDDuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Nov 2019 22:50:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA43dALC065594;
        Mon, 4 Nov 2019 03:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=u/WWylMqnru69Kx+UbRelHGNozBuMEoTTsvhB55jFes=;
 b=l00JYOymmHOq2jVkSyc6w/vGcmRLS3li6KjWd8J3+GzsQGOTXmyPJhYu3QpMxy1+SaFR
 DycWeDN15RsiP9++pBicFCviBPVxu4+dZ0bd39x8PMzL1GfjA8kD5Sn891tjp9Z2GRZC
 mFXdpbk9kztg/MVl+VWd+/68NaO/oP8epIhG+2sy8CyjACsrCbp0ysGxTHD3nVBBH0Us
 amQykCybgQzF7aXQ1rcN4l/hHyDpKiD7Nult+KlRsT+TTooYzr6fk1tFhUXBSUq52uqy
 3XAWmswva8uf4jV+rqBRywd7x4H7hqrefHPzLx5TcAsO5bIoAd1TRaL2xfZYFzqHPXm5 hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w11rpmnk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 03:49:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA43blSi070038;
        Mon, 4 Nov 2019 03:49:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w1kxkm8j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 03:49:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA43neED027567;
        Mon, 4 Nov 2019 03:49:40 GMT
Received: from [10.159.157.81] (/10.159.157.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 19:49:39 -0800
Subject: Re: [PATCH 1/5] KVM: simplify branch check in host poll code
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-2-git-send-email-zhenzhong.duan@oracle.com>
 <20191101210331.GA20061@amt.cnet>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <c6a23208-4432-6fc4-a3f8-56a6aff07fd8@oracle.com>
Date:   Mon, 4 Nov 2019 11:49:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101210331.GA20061@amt.cnet>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040035
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/2 5:03, Marcelo Tosatti wrote:
> On Sat, Oct 26, 2019 at 11:23:55AM +0800, Zhenzhong Duan wrote:
>> Remove redundant check.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> ---
>>   virt/kvm/kvm_main.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 67ef3f2..2ca2979 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2366,13 +2366,12 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>>   		} else if (halt_poll_ns) {
>>   			if (block_ns <= vcpu->halt_poll_ns)
>>   				;
>> -			/* we had a long block, shrink polling */
>> -			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
>> -				shrink_halt_poll_ns(vcpu);
>>   			/* we had a short halt and our poll time is too small */
>> -			else if (vcpu->halt_poll_ns < halt_poll_ns &&
> This is not a redundant check: it avoids from calling
> into grow_halt_poll_ns, which will do:
>
> 	1) Multiplication
> 	2) Cap that back to halt_poll_ns
> 	3) Invoke the trace_kvm_halt_poll_ns_grow tracepoint
> 	   (when in fact vcpu->halt_poll_ns did not grow).

In this branch, vcpu->halt_poll_ns < block_ns is true, and if block_ns < 
halt_poll_ns,

then vcpu->halt_poll_ns < halt_poll_ns is always true, isn't it?


I realized I ignored the situation that halt_poll_ns and 
halt_poll_ns_grow could be

updated at runtime, so pls ignore this patch, I'll fix it by following 
the guest haltpoll code.

Thanks

Zhenzhong

