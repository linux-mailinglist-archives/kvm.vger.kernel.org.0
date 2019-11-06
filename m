Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549E2F2144
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 23:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfKFWAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 17:00:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32870 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfKFWAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 17:00:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6LnCuD021588;
        Wed, 6 Nov 2019 21:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qq7rR/SNaAPmM1KeC/QtRZmmpY96r1t2fWo0M2z1Y2w=;
 b=U4JAPh1rRXqMPjixJF66qbLVNpNQRau2Iu+l4VBCMMhWA7qMXXB2pssRQkqkKLu6+qor
 2cg2NRsVDOVlwAv6YXpWc9J+ZY4bd/WKe7Wytu5L6LNOarugvUFwuwnngMpLwmbRSH0N
 va3fTX3vkaqtyL8EpmWcV9mSQgsUOwnehbN+WcgiqVoPMRjEf/6oHuk9Q9BXMqeWygCr
 qgl6s4rzRiUaZhX/K5OWiPSiylHayXbnqU46uFVxvYP2F86eQt5UKjdKkRlIRxBJyHIC
 WDxbM1C7GwFs3P3o7r5qZmWjotHQpBK/d/rqc0FNYBhE8D2pL5QZPhNUMLUXTNEkMn4M lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w11ywe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:58:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6LmMHw076597;
        Wed, 6 Nov 2019 21:56:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w41w83rvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 21:56:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6LuOvZ028453;
        Wed, 6 Nov 2019 21:56:24 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 13:56:23 -0800
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 556416A0123; Wed,  6 Nov 2019 16:59:45 -0500 (EST)
Date:   Wed, 6 Nov 2019 16:59:45 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Mathieu Tarral <mathieu.tarral@protonmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        "patrick.colp@oracle.com" <patrick.colp@oracle.com>,
        "mdontu@bitdefender.com" <mdontu@bitdefender.com>
Subject: Re: Talk publication - Leveraging KVM as a Debugging Platform
Message-ID: <20191106215945.GA3731@char.us.oracle.com>
References: <sl3TLCS0smnynp96Xa7kv5gHsbFIjQ9gzxPC1O5BYVb_QtXi6ZFQNR73zmrWSbicaUlBq54De6vAMkbIg0U2uWxEAUd1Q4-vaxn5mbc8LKE=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sl3TLCS0smnynp96Xa7kv5gHsbFIjQ9gzxPC1O5BYVb_QtXi6ZFQNR73zmrWSbicaUlBq54De6vAMkbIg0U2uWxEAUd1Q4-vaxn5mbc8LKE=@protonmail.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060211
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 30, 2019 at 05:53:31PM +0000, Mathieu Tarral wrote:
> Hi,
> 
> I wanted to publish a talk that I did last week at hack.lu 2019 conference in Luxembourg.

That is neat! Thank you for sharing it!
> 
> The talk was about showing the new introspection capabilities of KVM, still in development,
> and plugging a "smart" GDB stub on top that would understand the guest execution context.
> 
> There are 2 demos:
> 1. I demonstrate the integration in LibVMI (intercepting CR3, memory events and MSR)
> 2. I demonstrate debugging Microsoft Paint inside a Windows 10 VM, setting a breakpoint
>    on NtWriteFile in the kernel, and avoid other processes's hits.
> 
> Abstract:
> https://cfp.hack.lu/hacklu19/talk/MLPXAF/
> 
> Slides:
> https://drive.google.com/file/d/1nFoCM62BWKSz2TKhNkrOjVwD8gP51VGK/view
> 
> Video:
> https://www.youtube.com/watch?v=U-wDpvItPUU
> 
> Project:
> https://github.com/Wenzel/pyvmidbg
> 
> I thought it might be interesting to share it with the KVM community.
> 
> Thanks.
> 
