Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878F96BC52F
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 05:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCPETi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Mar 2023 00:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCPETg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 00:19:36 -0400
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282391A655
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 21:19:34 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: RE: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Topic: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Index: AQHZVtNJrQ6fv1AjakuDDwKmmMwANK77MVQQgABACwCAAVPt4A==
Date:   Thu, 16 Mar 2023 03:48:10 +0000
Message-ID: <9fccf93dd8be42279ec4c4565b167aa9@baidu.com>
References: <20230215121231.43436-1-lirongqing@baidu.com>
 <ZBEOK6ws9wGqof3O@google.com> <01086b8a42ef41659677f7c398109043@baidu.com>
 <ZBHjNuQhqzTx13wX@google.com>
In-Reply-To: <ZBHjNuQhqzTx13wX@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.204.44]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.56
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, March 15, 2023 11:27 PM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: kvm@vger.kernel.org; x86@kernel.org; Paolo Bonzini
> <pbonzini@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Vitaly
> Kuznetsov <vkuznets@redhat.com>
> Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
> 
> On Wed, Mar 15, 2023, Li,Rongqing wrote:
> > > Rather than have the guest rely on host KVM behavior clearing
> > > PV_UNHALT when HLT is passed through), would it make sense to add
> > > something like KVM_HINTS_HLT_PASSTHROUGH to more explicitly tell the
> > > guest that HLT isn't intercepted?
> >
> > KVM_HINTS_HLT_PASSTHROUGH is more obvious, but it need both kvm and
> > guest support
> 
> Yeah, that's the downside.  But modifying KVM and/or the userspace VMM
> shouldn't be difficult, i.e the only meaningful cost is the rollout of a new
> kernel/VMM.
> 
> On the other hand, establishing the heuristic that !PV_UNHALT ==
> HLT_PASSTHROUGH could have to subtle issues in the future.  It safe-ish in the
> context of this patch as userspace is unlikely to set KVM_HINTS_REALTIME, hide
> PV_UNHALT, and _not_ passthrough HLT.  But without the REALTIME side of
> things, !PV_UNHALT == HLT_PASSTHROUGH is much less likely to hold true.

Ok, could you submit these codes

Thanks

-Li
