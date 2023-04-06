Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393596D9068
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbjDFH1k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 Apr 2023 03:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbjDFH1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:27:38 -0400
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E45619F
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 00:27:36 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: RE: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Topic: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Index: AQHZVtNJrQ6fv1AjakuDDwKmmMwANK77MVQQgABACwCAAVPt4IAAWJWAgBXD3WCAAGV/AIAKvEJg
Date:   Thu, 6 Apr 2023 07:26:58 +0000
Message-ID: <8629787de966415c83ed02c84040f63a@baidu.com>
References: <20230215121231.43436-1-lirongqing@baidu.com>
 <ZBEOK6ws9wGqof3O@google.com> <01086b8a42ef41659677f7c398109043@baidu.com>
 <ZBHjNuQhqzTx13wX@google.com> <9fccf93dd8be42279ec4c4565b167aa9@baidu.com>
 <ZBMw94f2B1hiNnMC@google.com> <1c0da615bafa4b238fc028870e23aba2@baidu.com>
 <ZCXhFdihHNpVTR07@google.com>
In-Reply-To: <ZCXhFdihHNpVTR07@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.55
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Friday, March 31, 2023 3:26 AM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: kvm@vger.kernel.org; x86@kernel.org; Paolo Bonzini
> <pbonzini@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Vitaly
> Kuznetsov <vkuznets@redhat.com>
> Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
> 


> Guest-side KVM stuff is not my maintenance domain, i.e. this needs Paolo's
> attention no matter what.


Ok, I will rewrite the changelog and modify the code indentation as your suggestion, and resend this patch

Thanks

-Li
