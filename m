Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2243A2CBF81
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgLBOYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 09:24:05 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60822 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgLBOYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 09:24:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2EExrc118261;
        Wed, 2 Dec 2020 14:23:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=37E9bYly/DSoMvegtY1gV4dMFH3LMubNqRkj3fMCSeE=;
 b=ZJamVgjr3fhLdCU/pEWgfR2Lj+EL5IwmXMFKFN0LlHnDsEXR9Uq2MssH7K7wO36Pwnsd
 7cv0VNlFKUyuAS5pWBMRHDnL+guxiGjwssdFehlsb4WOPkC0ahKczdDbBcoiTsG2ZlVj
 qq3ZIUXLLW+HzMeU7+dm65YZZbtDqsgRoKGI6U7+MXi8mRSGoJQTFRTcBVvdEkgRy9PC
 K9+ggFZv58Hg2rSXS2KXDdr7l+n24JozFkGTkWvFd1Y9Q1DR/KXY1UylB2AToJxf7z+p
 S7omeyNYRaAhzjZjGHzE2Pt0OC1KSyEmiqGaOPhMtp5E8el87OJSrhSobNK1wPNCuj0y 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2b0n08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 14:23:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2EFN5v108164;
        Wed, 2 Dec 2020 14:23:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540fyt7de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 14:23:17 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B2ENG2N011837;
        Wed, 2 Dec 2020 14:23:16 GMT
Received: from [10.175.181.158] (/10.175.181.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 06:23:15 -0800
Subject: Re: [PATCH] KVM: x86: Reinstate userspace hypercall support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
References: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
 <X8VaO9DxaaKP7PFl@google.com>
 <64d5fc26a0b5ccb7592f924aa61068e6ee55955f.camel@infradead.org>
 <56ef38fe-e976-229c-9215-8ddce8d5f9e1@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <da9191fa-6559-50a1-75bd-f7c0359f2b45@oracle.com>
Date:   Wed, 2 Dec 2020 14:23:12 +0000
MIME-Version: 1.0
In-Reply-To: <56ef38fe-e976-229c-9215-8ddce8d5f9e1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 9:20 AM, Paolo Bonzini wrote:
> On 30/11/20 23:42, David Woodhouse wrote:
>> Yes, good point.
>>
>> Xen*does*  allow one hypercall (HVMOP_guest_request_vm_event) from
>> !CPL0 so I don't think I can get away with allowing only CPL0 like
>> kvm_hv_hypercall() does.
>>
>> So unless I'm going to do that filtering in kernel (ick) I think we do
>> need to capture and pass up the CPL, as you say. Which means it doesn't
>> fit in the existing kvm_run->hypercall structure unless I'm prepared to
>> rename/abuse the ->hypercall.pad for it.
>>
>> I'll just use Joao's version of the hypercall support, and add cpl to
>> struct kvm_xen_exit.hcall. Userspace can inject the UD# where
>> appropriate.
> 
> Or you can use sync regs perhaps.  For your specific use I don't expect 
> many exits to userspace other than Xen hypercalls, so it should be okay 
> to always run with KVM_SYNC_X86_REGS|KVM_SYNC_X86_SREGS in 
> kvm_run->kvm_valid_regs.
> 
For interdomain event channels, you can still expect quite a few, if your blkfront
and netfront are trying to go at maximum offered throughput.

Meaning it's not only setup of the guest, but also driver datapath operations.

Assuming of course that vTimer/vIPI are offloaded to the kernel.
