Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887B724355
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 00:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfETWHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 18:07:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfETWHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 18:07:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KLsi2B096816;
        Mon, 20 May 2019 22:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=IhbnF3IAZp36F576Ct1dbLqdq3TZJLtaieA/2nBlH2w=;
 b=b+rsplbFBz2/Rm+eSRqDYlVlk3DLEdlzHmYfqktdE8Vno6Kzso8MckgDSrUnq6q5qw+v
 i4sogmiwRZxBzUpfGObIejPVPWUeZr04eZqlhj//8uZci58P0scXgz4RJJHs12c6mVUM
 Ab4bQ5CMvUh3EiLO7Zr7QZ2EukCgoJzzq41qLRwoY2zEAs4L4t5vnnrOjAe7wzFDQ5A+
 2Z7Fjxyz/1+8vY/YTDUafScALYM1mhufWRA3M83QXOewmFE7ZjuHqeUHArYfpjKrEOXG
 Fk7KRSXnxpKO+en0Llm0slXEKNe16iUwUkv0GftOEZmbwKDAaHNjKEuCjBp0cTelJMw3 gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sj7jdhyf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:06:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KM5TGK182819;
        Mon, 20 May 2019 22:06:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sks1xuhjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:06:52 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KM6oZx015725;
        Mon, 20 May 2019 22:06:51 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:06:50 +0000
Subject: Re: [kvm-unit-test nVMX]: Test "load IA32_PAT" VM-entry control on
 vmentry of nested guests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190418213941.20977-1-krish.sadhukhan@oracle.com>
 <d9145c8b-ce7a-6d74-c6c4-3390b1406e0a@oracle.com>
 <03b136e4-20fb-0f39-3c9e-696e925fb3a2@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <10ea0f6d-a8fa-51e7-bdd4-e2bff5dadc8c@oracle.com>
Date:   Mon, 20 May 2019 15:06:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <03b136e4-20fb-0f39-3c9e-696e925fb3a2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200136
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/20/2019 06:22 AM, Paolo Bonzini wrote:
> On 08/05/19 19:43, Krish Sadhukhan wrote:
>> Ping...
> There have been some changes inthe meanwhile so the patches needed some
> work to rebase.  I hope I haven't butchered them too much, please take a
> look at the master branch. :)

They look fine. Thanks !
It seems you have fixed two call sites in test_pat() by replacing 
__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL)   with
enter_guest().  There is still one call site we need to fix:  the first 
for-loop in test_pat(). There we should call enter_guest() instead of 
enter_guest_with_invalid_guest_state()  because there the guest state is 
valid as far as PAT is concerned and so we should abort on both an early 
vmentry failure as well as an invalid guest state.

Please let me know if you want to fix it or want me to send a patch.

>
> Thanks,
>
> Paolo
>
>> On 4/18/19 2:39 PM, Krish Sadhukhan wrote:
>>> This is the unit test for the "load IA32_PAT" VM-entry control. Patch# 2
>>> builds on top of my previous patch,
>>>
>>>      [PATCH 6/6 v5][kvm-unit-test nVMX]: Check "load IA32_PAT" on
>>> vmentry of L2 guests
>>>
>>>
>>> [PATCH 1/2][kvm-unit-test nVMX]: Move the functionality of
>>> enter_guest() to
>>> [PATCH 2/2][kvm-unit-test nVMX]: Check "load IA32_PAT" VM-entry
>>> control on vmentry
>>>
>>>    x86/vmx.c       |  27 +++++++----
>>>    x86/vmx.h       |   4 ++
>>>    x86/vmx_tests.c | 140
>>> ++++++++++++++++++++++++++++++++++++++++++++++--------
>>>    3 files changed, 143 insertions(+), 28 deletions(-)
>>>
>>> Krish Sadhukhan (2):
>>>         nVMX: Move the functionality of enter_guest() to
>>> __enter_guest() and make the former a wrapper of the latter
>>>         nVMX: Check "load IA32_PAT" VM-entry control on vmentry of
>>> nested guests
>>>

