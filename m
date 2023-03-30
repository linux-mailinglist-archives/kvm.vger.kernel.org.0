Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257F56CFE03
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjC3ITA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 30 Mar 2023 04:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjC3IS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:18:56 -0400
X-Greylist: delayed 190 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Mar 2023 01:18:53 PDT
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF131BEC
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:18:53 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not
 itlb_multihit
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if
 not itlb_multihit
Thread-Index: AQHZXZKZxhdir/qgNkKqNh6m51lq9K8TBHEg
Date:   Thu, 30 Mar 2023 08:18:05 +0000
Message-ID: <b1d9bf5a35d545879cb4eca4037b5280@baidu.com>
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <ZBxf+ewCimtHY2XO@google.com>
In-Reply-To: <ZBxf+ewCimtHY2XO@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.53
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
> Sent: Thursday, March 23, 2023 10:20 PM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com;
> bp@alien8.de; dave.hansen@linux.intel.com; kvm@vger.kernel.org;
> x86@kernel.org
> Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if
> not itlb_multihit
> 
> On Thu, Mar 23, 2023, lirongqing@baidu.com wrote:
> > From: Li RongQing <lirongqing@baidu.com>
> >
> > if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread is
> > not needed to create
> 
> Unless userspace forces the mitigation to be enabled, which can be done while
> KVM is running.  I agree that spinning up a kthread that is unlikely to be used is
> less than ideal, but the ~8KiB or so overhead is per-VM and not really all that
> notable, e.g. KVM's page tables easily exceed that.
> 

A thread will create lots of proc file, and slow the command, like: ps

-Li
