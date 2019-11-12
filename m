Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F87F8F8F
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 13:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfKLMTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 07:19:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46782 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfKLMTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 07:19:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACC92uk119335;
        Tue, 12 Nov 2019 12:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vJi+sgSpT/msCu8MaaZcjY30BS9nxFhGVS/H9KWglz8=;
 b=MwYUSKkDy7qhbAyxsaSs4Pe7s3VeJaZi5XFd6CkjEqcHjkAxXXmHveei75re0JsT+VdH
 /IGRzoK4euLvB66LenmKhgQ8XEJTjWhYQ51M/GQ6cAhu21JhfKABtk1R5tmyI7WZzQGj
 hJl29MYPUVkajnbjP41qYT4O/5xbjuSCZQndzqEsr8mOQciFD5nNDaR1RHAeeJot+g37
 1c8d5cbrI8FjDijZJgyxcvqT+NMd2QN5h0wzPSCHt8Wc6YpznsGlAQyf2VYXBomd7gGU
 hGTZ50wHPln8NK4nApccWUQZzDkgFBmjxEckKD57bDB4FQe6yct2Usd6UymVJWtu/UOG Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w5mvtmdr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 12:19:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACC8n55137438;
        Tue, 12 Nov 2019 12:19:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w7khk7hvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 12:19:18 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xACCJHpi018994;
        Tue, 12 Nov 2019 12:19:17 GMT
Received: from [10.191.24.133] (/10.191.24.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 04:19:17 -0800
Subject: Re: [PATCH RESEND v2 2/4] KVM: ensure grow start value is nonzero
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, rafael.j.wysocki@intel.com,
        joao.m.martins@oracle.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
 <1573041302-4904-3-git-send-email-zhenzhong.duan@oracle.com>
 <20191111201320.GA7431@linux.intel.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <0c8543e6-7664-cce9-c890-a10663d76d55@oracle.com>
Date:   Tue, 12 Nov 2019 20:19:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191111201320.GA7431@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=781
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=847 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/11/12 4:13, Sean Christopherson wrote:
> On Wed, Nov 06, 2019 at 07:55:00PM +0800, Zhenzhong Duan wrote:
>> vcpu->halt_poll_ns could be zeroed in certain cases (e.g. by
>> halt_poll_ns = 0). If halt_poll_grow_start is zero,
>> vcpu->halt_poll_ns will never be bigger than zero.
>>
>> Use param callback to avoid writing zero to halt_poll_grow_start.
> This doesn't explain why allowing an admin to disable halt polling by
> writing halt_poll_grow_start=0 is a bad thing.  Paolo had the same
> question in v1, here[1] and in the guest driver[2].
>
> [1]https://lkml.kernel.org/r/57679389-6e4a-b7ad-559f-3128a608c28a@redhat.com
> [2]https://lkml.kernel.org/r/391dd11b-ebbb-28ff-5e57-4a795cd16a1b@redhat.com

Ok, answer all the same questions about grow_start=0 here.

VCPU halt polling time may be nonzero even if grow_start=0, such as in below situation:
0=grow_start< block_ns< (vcpu->halt_poll_ns)< halt_poll_ns

grow_start=0 has your mentioned effect only in below sequence:
1. set halt_poll_ns=0 to disable halt polling(this lead to vcpu->halt_poll_ns=0)
2. set grow_start=0
3. set halt_poll_ns to nonzero
4. Admin expect halt polling time auto adjust in range [0, nonzero], but polling time stick at 0.

So I think we should use halt_poll_ns=0 to disable halt polling instead of grow_start=0.

Zhenzhong

