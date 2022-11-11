Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3651F626495
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 23:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbiKKWXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 17:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbiKKWWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 17:22:49 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F395F005;
        Fri, 11 Nov 2022 14:22:32 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2ABMMF9G1234185
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 11 Nov 2022 14:22:16 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2ABMMF9G1234185
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022110601; t=1668205337;
        bh=MoNQ+dvAI1RNyo5Ci6a/1FS/k7NnsfPn0SHAYx5PQsc=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=yUyQiQOd1zIhu5pf3tbybDEXLkpH0nKfBiMgSPOuveVPtqYKNTgjXwKGx5Do9LDSh
         b38m19wyYelpE7Mlvks20AOjIhBfLOZwO4ohX1oprQ/gUz6ZE08902TQM5Kv0IStc9
         GE43e3X2TJtV5FRGxQgE40BZiwRhqCUQyUpLCtJ0i9P3Mrte5PqLbcQIpnoI0WL379
         HyeF4d1WxDR852eg2VOHxAXyUvmh14kC0gmM4nY3jWgekFJKxKOdQjSedr8XVknTEt
         IJtRhlsbm6NEQNSOSUDZODb6xymq6iGXUkEykX8hRF2JlNb4uTPERHi9HwPQ/DaUAj
         LET0Wyr+5CV0Q==
Date:   Fri, 11 Nov 2022 14:22:12 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: =?US-ASCII?Q?Re=3A_=5BRESEND_PATCH_5/6=5D_KVM=3A_x86/VMX=3A_add_kvm=5F?= =?US-ASCII?Q?vmx=5Freinject=5Fnmi=5Firq=28=29_for_NMI/IRQ_reinjection?=
User-Agent: K-9 Mail for Android
In-Reply-To: <0b5798d6-aa1d-8ad8-b129-9cffdfd4e5da@citrix.com>
References: <20221110061545.1531-1-xin3.li@intel.com> <20221110061545.1531-6-xin3.li@intel.com> <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net> <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com> <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net> <6097036e-063f-5175-72b2-8935b12af853@redhat.com> <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net> <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com> <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net> <0b5798d6-aa1d-8ad8-b129-9cffdfd4e5da@citrix.com>
Message-ID: <8D824B88-1EBB-4CEC-9D1D-89123D536500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On November 11, 2022 8:35:30 AM PST, Andrew Cooper <Andrew=2ECooper3@citrix=
=2Ecom> wrote:
>On 11/11/2022 14:23, Peter Zijlstra wrote:
>> On Fri, Nov 11, 2022 at 01:48:26PM +0100, Paolo Bonzini wrote:
>>> On 11/11/22 13:19, Peter Zijlstra wrote:
>>>> On Fri, Nov 11, 2022 at 01:04:27PM +0100, Paolo Bonzini wrote:
>>>>> On Intel you can optionally make it hold onto IRQs, but NMIs are alw=
ays
>>>>> eaten by the VMEXIT and have to be reinjected manually=2E
>>>> That 'optionally' thing worries me -- as in, KVM is currently
>>>> opting-out?
>>> Yes, because "If the =E2=80=9Cprocess posted interrupts=E2=80=9D VM-ex=
ecution control is 1,
>>> the =E2=80=9Cacknowledge interrupt on exit=E2=80=9D VM-exit control is=
 1" (SDM 26=2E2=2E1=2E1,
>>> checks on VM-Execution Control Fields)=2E  Ipse dixit=2E  Posted inter=
rupts are
>>> available and used on all processors since I think Ivy Bridge=2E
>
>On server SKUs=2E=C2=A0 Client only got "virtual interrupt processing" fa=
irly
>recently IIRC, which is the CPU-side property which matters=2E
>
>> (imagine the non-coc compliant reaction here)
>>
>> So instead of fixing it, they made it worse :-(
>>
>> And now FRED is arguably making it worse again, and people wonder why I
>> hate virt=2E=2E=2E
>
>The only FRED-compatible fix is to send a self-NMI, because because you
>may need a CSL change too=2E
>
>VT-x *does* hold the NMI latch (for VMEXIT_REASON NMI), so it's self-NMI
>and then enable_nmi()s=2E
>
>Except the IRET to self won't work - it will need to be ERETS-to-self=2E=
=C2=A0
>Which I think is fine=2E
>
>But what isn't fine is the fact that a self-NMI doesn't deliver
>synchronously, so you need to wait until it is pending, before enabling
>NMIs=2E=C2=A0 (Well, actually you need to ensure that it's definitely del=
ivered
>before re-entering the VM)=2E
>
>And I'm totally out of ideas here=2E=2E=2E
>
>~Andrew
>

There is no fundamental reason to do a CSL/IST change if you happen to kno=
w a priori that the stack is in a valid state to have the NMI frame on it; =
that is:

1=2E Not deep into a nested I/O layer;
2=2E Valid, and not in flux in any way=2E

Since this reinject will always be in a well-defined location, that's fine=
=2E

So I think *that* concern is not actually an issue=2E

Again, note that this is not a FRED-specific problem=2E
