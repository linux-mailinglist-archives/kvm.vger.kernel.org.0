Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654701430B2
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 18:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgATRQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 12:16:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 12:16:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KHDgJT190805;
        Mon, 20 Jan 2020 17:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=LCQ5bPAGIkg/GqnXK6log4muedwz0XwjY4OpzWodpiw=;
 b=WxiJPe9ZPQv9qIUoARsSFzPY8yccoA9sc9XkISkEGZkPQ6K+1qdaGkH3rYcKeceNCU6Q
 dCLzrxANBo7gmTm/hjliEdtoIanls1Qp+62rfDW8d5Pw5/zybtPQe/I3i4IgfCkTeGPU
 Izt/X0yrnTrQJ7bTydPnS8zvaUsgQOMGLiAyuD0vsqRUet3SLcbl2ktNun6L6bV59KqC
 LxJuNYeU4oKO8KMNdcUXXuLR5H4GyZFCa8I1IiIvN1h1EpktDW8MMaKt4+eRxfbtNm3E
 HCcIJ8WuF6XubZQ2Jp32Gn6oZsQtRSCzV4TExF56rKp45aYBh4x0oLUjMpglPCOXSU/z Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyq0ks7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 17:16:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KHEFu7023649;
        Mon, 20 Jan 2020 17:16:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xmc5ky5yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 17:16:41 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KHGe7B024006;
        Mon, 20 Jan 2020 17:16:40 GMT
Received: from [10.74.126.30] (/10.74.126.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 09:16:39 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC] Revert "kvm: nVMX: Restrict VMX capability MSR changes"
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <30525d58-10de-abb4-8dad-228da766ff82@redhat.com>
Date:   Mon, 20 Jan 2020 19:16:34 +0200
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <232F8FDD-D53E-4FA4-95A5-8BC06BCB6685@oracle.com>
References: <20200120151141.227254-1-vkuznets@redhat.com>
 <30525d58-10de-abb4-8dad-228da766ff82@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=871
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=932 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 20 Jan 2020, at 17:41, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> On 20/01/20 16:11, Vitaly Kuznetsov wrote:
>> 
>> RFC. I think the check for vmx->nested.vmxon is legitimate for everything
>> but restore so removing it (what I do with the revert) is likely a no-go.
>> I'd like to gather opinions on the proper fix: should we somehow check
>> that the vCPU is in 'restore' start (has never being run) and make
>> KVM_SET_MSRS pass or should we actually mandate that KVM_SET_NESTED_STATE
>> is run after KVM_SET_MSRS by userspace?
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> I think this should be fixed in QEMU, by doing KVM_SET_MSRS for feature
> MSRs way earlier.  

I agree.

> I'll do it since I'm currently working on a patch to
> add a KVM_SET_MSR for the microcode revision.

Please Cc me.

Thanks,
-Liran

