Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBDB1024BB
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 13:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfKSMnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 07:43:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbfKSMnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 07:43:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJCPNIB069833;
        Tue, 19 Nov 2019 12:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=J1DVFWDWgRDlJNqhrtPfMZhXf4YNBEMKWsybmojvTLo=;
 b=JgnqN+VBvqZZJ86GuNVp+b1Ft61fTaXz3I1+uwYOAS5cE8ccyiXt3+XDKCQErW4byYg7
 LOUIJNY9zoyFWLXgfu77EZLnt7zaH08pKn0ucWpmFEcXSVYeqIotvFgfxFIapIAbLMqC
 5GNH1EwRat2Z1PGDhwT4/m4JKOl5+MqlWL6TayJ/jhrBtFAyaHkfjBqx3zYmAzWtQyGw
 weoD1PTW2+I1lvoj+EkgSUY4+UNNIukOkr0LDPUoqpZoUpWDgl9+gFMHdW+ctdKnGfMx
 5OTXTBAlnwApcHzY13V4I43jmorxsV98qvVi8vPb19OLm2tpmRgOdDOKVsSMjQaupnQt gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92ppj87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 12:42:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJCSEIk167569;
        Tue, 19 Nov 2019 12:40:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wcem8sa94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 12:40:17 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJCeDVh026432;
        Tue, 19 Nov 2019 12:40:13 GMT
Received: from kadam (/41.210.141.188)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 04:40:12 -0800
Date:   Tue, 19 Nov 2019 15:39:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
Message-ID: <20191119123956.GC5604@kadam>
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com>
 <20191119121423.GB5604@kadam>
 <87imnggidr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imnggidr.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 19, 2019 at 01:28:32PM +0100, Vitaly Kuznetsov wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > On Tue, Nov 19, 2019 at 12:58:54PM +0100, Vitaly Kuznetsov wrote:
> >> Mao Wenan <maowenan@huawei.com> writes:
> >> 
> >> > Fixes gcc '-Wunused-but-set-variable' warning:
> >> >
> >> > arch/x86/kvm/x86.c: In function kvm_make_scan_ioapic_request_mask:
> >> > arch/x86/kvm/x86.c:7911:7: warning: variable called set but not
> >> > used [-Wunused-but-set-variable]
> >> >
> >> > It is not used since commit 7ee30bc132c6 ("KVM: x86: deliver KVM
> >> > IOAPIC scan request to target vCPUs")
> >> 
> >> Better expressed as 
> >> 
> >> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
> >> 
> >
> > There is sort of a debate about this whether the Fixes tag should be
> > used if it's only a cleanup.
> >
> 
> I have to admit I'm involved in doing backporting sometimes and I really
> appreciate Fixes: tags. Just so you know on which side of the debate I
> am :-)

But we're not going to backport this hopefully?

regards,
dan carpenter

