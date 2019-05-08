Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1794017F46
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfEHRnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:43:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47710 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfEHRnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:43:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48HXd4E179169;
        Wed, 8 May 2019 17:43:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LaW/t4EP/l66HJ1m2EKtOk4Yc0gDioAL/wcWvcPa0W8=;
 b=BuKUm8bJmAj2bV+KXw+qtTF0jMC7p1J0O6ACRaS704GywJhMfoGzpUE/7+DYAy+mT9D4
 rs7eBIMDpKwQd5R+AG/+gXvbDgO0Ghwhzh/VIZRQjOKY+kfWJhnZT+rjp3VVHxGiv3xI
 faVX7lMujaEbXdad4n2vmdXEdQvXpzpyVla7Qd6ir5WLXuJVU3KiI5kezWs/1S2/wWtv
 G9G1vK3nnMRMMDnQ8nJ7mHw+qmpUPDhjYYsEx0427z2SRXgyIkjtircaF63EBn+jnYAe
 RhoZ2OqFykXF2WTelAW1ttmJU9wsaeosfZAsm4WCywgSznUEwp1ZUnzeh0So1vmdze+B Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2s94bg5qk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 17:43:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48HhHeO005715;
        Wed, 8 May 2019 17:43:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2sagyuqjr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 17:43:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x48HhEP1008711;
        Wed, 8 May 2019 17:43:14 GMT
Received: from [192.168.1.71] (/162.197.212.154)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 May 2019 10:43:14 -0700
Subject: Re: [kvm-unit-test nVMX]: Test "load IA32_PAT" VM-entry control on
 vmentry of nested guests
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
References: <20190418213941.20977-1-krish.sadhukhan@oracle.com>
Message-ID: <d9145c8b-ce7a-6d74-c6c4-3390b1406e0a@oracle.com>
Date:   Wed, 8 May 2019 10:43:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190418213941.20977-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=888
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905080108
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=899 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905080107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping...

On 4/18/19 2:39 PM, Krish Sadhukhan wrote:
> This is the unit test for the "load IA32_PAT" VM-entry control. Patch# 2
> builds on top of my previous patch,
>
>     [PATCH 6/6 v5][kvm-unit-test nVMX]: Check "load IA32_PAT" on vmentry of L2 guests
>
>
> [PATCH 1/2][kvm-unit-test nVMX]: Move the functionality of enter_guest() to
> [PATCH 2/2][kvm-unit-test nVMX]: Check "load IA32_PAT" VM-entry control on vmentry
>
>   x86/vmx.c       |  27 +++++++----
>   x86/vmx.h       |   4 ++
>   x86/vmx_tests.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++--------
>   3 files changed, 143 insertions(+), 28 deletions(-)
>
> Krish Sadhukhan (2):
>        nVMX: Move the functionality of enter_guest() to __enter_guest() and make the former a wrapper of the latter
>        nVMX: Check "load IA32_PAT" VM-entry control on vmentry of nested guests
>
