Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4118D1BF16
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 23:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEMV0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 17:26:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42578 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfEMV0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 17:26:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DLOIfI163779;
        Mon, 13 May 2019 21:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=565YBW81DzfaRDIS43k2HzjR+yOfbcWDWWoM7zcskn0=;
 b=grovnzlGNhoWxg5qTfZqqCe1IbYlscPPaFCoCsuR8tt3ASzDgZxK2+mT55ONjtQpCEzY
 kfB5uJIm7OzXwBf4+8TE3xSbFPPVcOCDVWNVFli9RyNtmRNYhiKlGCNLURZHUOscPclr
 IYNal+CRZA/SCX4yPG2Zpsri3AT60IdEClhmHHTYUgtZ3dAmQr+9vx9HV06zYb8AszYn
 9FRvfVgMvL0QV+oO4S7ODYaqwUl2XjF2+9Wo5jDYi7dTaDvu181uHwWAfiIBxuoIDcUx
 2VvBeh+jiKiBWjHJ9ibL/22dVxSBMC832kGL/8a4Y5k8XxNOcY+NvuyxL2Iy8p7Lf8mn RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sdq1q9ry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 21:25:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DLPIdA126929;
        Mon, 13 May 2019 21:25:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2se0tvsthj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 21:25:53 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4DLPpxg006777;
        Mon, 13 May 2019 21:25:52 GMT
Received: from [192.168.14.112] (/79.180.238.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 14:25:51 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC KVM 24/27] kvm/isolation: KVM page fault handler
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190513151500.GY2589@hirez.programming.kicks-ass.net>
Date:   Tue, 14 May 2019 00:25:44 +0300
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        jwadams@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <13F2FA4F-116F-40C6-9472-A1DE689FE061@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com>
 <20190513151500.GY2589@hirez.programming.kicks-ass.net>
To:     Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130142
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 May 2019, at 18:15, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Mon, May 13, 2019 at 04:38:32PM +0200, Alexandre Chartre wrote:
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index 46df4c6..317e105 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -33,6 +33,10 @@
>> #define CREATE_TRACE_POINTS
>> #include <asm/trace/exceptions.h>
>>=20
>> +bool (*kvm_page_fault_handler)(struct pt_regs *regs, unsigned long =
error_code,
>> +			       unsigned long address);
>> +EXPORT_SYMBOL(kvm_page_fault_handler);
>=20
> NAK NAK NAK NAK
>=20
> This is one of the biggest anti-patterns around.

I agree.
I think that mm should expose a mm_set_kvm_page_fault_handler() or =
something (give it a better name).
Similar to how arch/x86/kernel/irq.c have =
kvm_set_posted_intr_wakeup_handler().

-Liran


