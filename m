Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97595E8E2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfGCQ2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:28:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfGCQ2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:28:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63GNbXp139693;
        Wed, 3 Jul 2019 16:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=x3dC8l4+a2XaaDiZ4nOifBIIVoVWouOgo1NGCO/FuyY=;
 b=i/E58QCRWRHmHs0MmD0OckIG2ji0uCbGKx5HY1vnbj8UKCHhMjQ0zSsTol9uwlOjO3xb
 pegEDGbBAi5taJHjoGQkC0m2qwQNM0fc8z/s0SIl0s+3997PthkvJLn3vTHyr6sPGnyH
 uqFEq9e0NlRIQYHN1zyPLuu0QqFoTui+tANyhdvqA0q10MQuxKa9xLamOV3Tfv1YURzF
 A2TQgoO6OE2qjVScXMHqxqF6k22td3/Ctsu1qrVPFHBXP9jEvm9fIJ5Rcn3+21OD8bMQ
 hiXDbqOve6ukTe121xa/eBaIgX5sxIvAvsh3WtXPTJgOq4eBcAUIAmF9j2J+4C6FLgrl oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbthxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 16:27:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63GNIhi101526;
        Wed, 3 Jul 2019 16:27:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tebamfetq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 16:27:55 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x63GRpUX028428;
        Wed, 3 Jul 2019 16:27:51 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 09:27:51 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/4] kvm: x86: allow set apic and ioapic debug dynamically
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <685680d5-f642-0c48-08f2-8c73026ccaf0@redhat.com>
Date:   Wed, 3 Jul 2019 19:27:47 +0300
Cc:     Yi Wang <wang.yi59@zte.com.cn>, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Content-Transfer-Encoding: 7bit
Message-Id: <076EBA72-1C86-4E9F-8821-2F49645E03CA@oracle.com>
References: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
 <1561962071-25974-3-git-send-email-wang.yi59@zte.com.cn>
 <685680d5-f642-0c48-08f2-8c73026ccaf0@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907030199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907030199
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 3 Jul 2019, at 19:23, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> On 01/07/19 08:21, Yi Wang wrote:
>> There are two *_debug() macros in kvm apic source file:
>> - ioapic_debug, which is disable using #if 0
>> - apic_debug, which is commented
>> 
>> Maybe it's better to control these two macros using CONFIG_KVM_DEBUG,
>> which can be set in make menuconfig.
>> 
>> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
>> ---
>> arch/x86/kvm/ioapic.c | 2 +-
>> arch/x86/kvm/lapic.c  | 5 ++++-
>> 2 files changed, 5 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index 1add1bc..8099253 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -45,7 +45,7 @@
>> #include "lapic.h"
>> #include "irq.h"
>> 
>> -#if 0
>> +#ifdef CONFIG_KVM_DEBUG
>> #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
>> #else
>> #define ioapic_debug(fmt, arg...)
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 4924f83..dfff5c6 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -54,8 +54,11 @@
>> #define PRIu64 "u"
>> #define PRIo64 "o"
>> 
>> -/* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
>> +#ifdef CONFIG_KVM_DEBUG
>> +#define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
>> +#else
>> #define apic_debug(fmt, arg...) do {} while (0)
>> +#endif
>> 
>> /* 14 is the version for Xeon and Pentium 8.4.8*/
>> #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
>> 
> 
> I would just drop all of them.  I've never used them in years, the kvm
> tracepoints are enough.
> 
> Paolo

As someone who have done many LAPIC/IOAPIC debugging, I tend to agree. :)

-Liran

