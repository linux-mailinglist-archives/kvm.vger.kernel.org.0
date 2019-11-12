Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFA1F8F7A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 13:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfKLMOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 07:14:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfKLMON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 07:14:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACC93f8089973;
        Tue, 12 Nov 2019 12:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cwbFHdOtQE8djdjL/sCVjGdnyrOIqq0d6NAU+DO6W2o=;
 b=pGJUYjRErF5MSYnvt99xZ/GzFKSytJJJighqp1OzWLITlOukYTRfgE+o5GUYIHF9ND4i
 c7ltWLXPWv/5PA4sB10piz72J7Fe9wSE3ADeeMR+nl50c7m6dadMePOD3pfenVuZvfdt
 keZnyY9CQTNMUMwAklaB9Pvlxu5MTL0eEqx7tBlKUHbkhSQrnleBggaXX8g95GO0aWpA
 Z79GBcJIytxJECfZzjspitb9zSUkevvzG9p9EKtBHRct5f2m4g1Ko0g3JRWvnEkwzy2C
 xUg21vlMCsmIRZ+6Hcmt1xrQaLoNmsx6v63TVYqmrPVY33cyzkIk0Km3lc98cha+Vdo8 Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w5p3qm99j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 12:14:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACC8MBm006620;
        Tue, 12 Nov 2019 12:14:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w6r8m3pb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 12:14:08 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xACCE7eb016328;
        Tue, 12 Nov 2019 12:14:07 GMT
Received: from [10.191.24.133] (/10.191.24.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 04:14:07 -0800
Subject: Re: [PATCH 3/5] KVM: ensure pool time is longer than block_ns
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-4-git-send-email-zhenzhong.duan@oracle.com>
 <20191101211623.GB20061@amt.cnet>
 <76044f07-0b76-cd91-dc87-82ed3fca061e@redhat.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <fc9eab27-5251-feb7-29f4-1e2923d5d013@oracle.com>
Date:   Tue, 12 Nov 2019 20:14:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <76044f07-0b76-cd91-dc87-82ed3fca061e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/11 21:53, Paolo Bonzini wrote:
> On 01/11/19 22:16, Marcelo Tosatti wrote:
>>   		if (!vcpu_valid_wakeup(vcpu)) {
>>   			shrink_halt_poll_ns(vcpu);
>>   		} else if (halt_poll_ns) {
>> -			if (block_ns <= vcpu->halt_poll_ns)
>> +			if (block_ns < vcpu->halt_poll_ns)
>>   				;
>>   			/* we had a short halt and our poll time is too small */
>>   			else if (block_ns < halt_poll_ns)
> What about making this "if (!waited)"?  The result would be very readable:
>
>                          if (!waited)
>                                  ;
>                          /* we had a long block, shrink polling */
>                          else if (block_ns > halt_poll_ns && vcpu->halt_poll_ns)
>                                  shrink_halt_poll_ns(vcpu);
>                          /* we had a short halt and our poll time is too small */
>                          else if (block_ns < halt_poll_ns && vcpu->halt_poll_ns < halt_poll_ns)
>                                  grow_halt_poll_ns(vcpu);

This patch is dropped in v2 as it rarely happen in real scenario.

Appreciate you reviewing v2 in https://lkml.org/lkml/2019/11/6/447

Thanks

Zhenzhong

