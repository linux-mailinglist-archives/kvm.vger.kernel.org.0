Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8939102416
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 13:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfKSMQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 07:16:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfKSMQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 07:16:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJCDipR046976;
        Tue, 19 Nov 2019 12:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=AQk/7h5Ym3BmVg5rKLn1o6XSiLk0PA1eheI7FYE0AlQ=;
 b=lIwcWgxcanEFOhZnrPX3xQIzaeHK/r0O6DmcEzxFg2pJ2CJfTazxqxqFjCzwfpG0w0GW
 BfjQho3yNSAI22nKxSmxUEb/9qXzpqZGSnaRi6IJtYpaDIskKPkCt3e2ah8u4BanjTzc
 8kLOJH2oP4NiYoxDhjrrgxsGm177jcSBr9fT6mVmIjER4wwh0vdolna7rHUZ2S0ms2jx
 3xGfUt9f8XYwhvdOjzAygkGrHw6WJEnZEp8LxaCNkFeTLxaD/PYsQxppeT5U3UIF5HLL
 4coQQN1fNTntJnD2Uy5sqiiZ2QZCKw3miA1olQu+k7hke7yJFGThvfwPDchyeKbPEJr5 Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wa9rqecux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 12:14:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJCDw1w180011;
        Tue, 19 Nov 2019 12:14:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wbxm46ft1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 12:14:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAJCEiJ4014217;
        Tue, 19 Nov 2019 12:14:44 GMT
Received: from kadam (/41.210.141.188)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 04:14:43 -0800
Date:   Tue, 19 Nov 2019 15:14:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
Message-ID: <20191119121423.GB5604@kadam>
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8x8gjr5.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=957
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 19, 2019 at 12:58:54PM +0100, Vitaly Kuznetsov wrote:
> Mao Wenan <maowenan@huawei.com> writes:
> 
> > Fixes gcc '-Wunused-but-set-variable' warning:
> >
> > arch/x86/kvm/x86.c: In function kvm_make_scan_ioapic_request_mask:
> > arch/x86/kvm/x86.c:7911:7: warning: variable called set but not
> > used [-Wunused-but-set-variable]
> >
> > It is not used since commit 7ee30bc132c6 ("KVM: x86: deliver KVM
> > IOAPIC scan request to target vCPUs")
> 
> Better expressed as 
> 
> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
> 

There is sort of a debate about this whether the Fixes tag should be
used if it's only a cleanup.

regards,
dan carpenter

