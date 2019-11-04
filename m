Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04E3ED7E9
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 03:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfKDC7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Nov 2019 21:59:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbfKDC7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Nov 2019 21:59:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA42wgtK051862;
        Mon, 4 Nov 2019 02:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rXYd9T5xcZlsJtJKgMbmBfCyv/t8roaEHfDXUqifZr8=;
 b=c6HRIjK9RWPYu6kDZAqSih+48aVDf44jeIQBwUSJpBOa3vQyTJ9yeJ69+6axMwAzibdd
 indoHEbNFeC6Dw90cobujEEO/gSlEo1+EntznGdJXe8fAyd+lvYvz5mKbcx4Toa5T82I
 QWQtQIKF3/8H21UlNlrt6QjTlqEmW27vbRM5/tkZsMk0XUHZRI1uzStiT8+paVqAqLim
 eU2P1/7vd46W/HLCEJ/W+mPUvH88p46ws/W7OAvdfoeDsYoi8KPL7rEzvxlx49I+0EDB
 1JeJ4EJJ2vrRKZUB3nx9mJ39UOsVT8p8PLCIPuSSS1H5nol3TpPU+iT4MnyZ6pbeBrl6 WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w117tmjqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 02:58:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA42sTRe047440;
        Mon, 4 Nov 2019 02:56:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w1ka94s6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 02:56:41 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA42udoX011586;
        Mon, 4 Nov 2019 02:56:39 GMT
Received: from [192.168.0.4] (/111.206.84.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 18:56:38 -0800
Subject: Re: [PATCH 4/5] cpuidle-haltpoll: add a check to ensure grow start
 value is nonzero
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-5-git-send-email-zhenzhong.duan@oracle.com>
 <20191101211908.GA20672@amt.cnet>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <7245089f-788e-03d6-9833-6ce4d313f4ce@oracle.com>
Date:   Mon, 4 Nov 2019 10:56:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101211908.GA20672@amt.cnet>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040030
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/2 5:19, Marcelo Tosatti wrote:
> On Sat, Oct 26, 2019 at 11:23:58AM +0800, Zhenzhong Duan wrote:
>> dev->poll_limit_ns could be zeroed in certain cases (e.g. by
>> guest_halt_poll_shrink). If guest_halt_poll_grow_start is zero,
>> dev->poll_limit_ns will never be larger than zero.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> ---
>>   drivers/cpuidle/governors/haltpoll.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
> I would rather disallow setting grow_start to zero rather
> than silently setting it to one on the back of the user.

Ok, will do.

Thanks

Zhenzhong

