Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D019626435
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 23:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiKKWIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 17:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbiKKWIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 17:08:07 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C632788559;
        Fri, 11 Nov 2022 14:07:36 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2ABM79Ie1232560
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 11 Nov 2022 14:07:09 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2ABM79Ie1232560
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022110601; t=1668204430;
        bh=qiOQuHaGOzvrf8e0omxIQW2OX158BWNc3RVEXRzilII=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=FpzBJKmRL7vLt1n0fTRXI/3MnL6r/SLyWOXChBzaiYC02z4cW1rUisXtZbIUc1F2Y
         lcE8KLkxje0L9FOhPALFGd4sc8s9mobABzWcwXvUWCJQiw4wk31c8TzdsRhDAZHPcA
         wWd/F9/UUdxF/TPOFhB/fbxEwqXuGpJdZKtRf3lzKDQY6bfxNgSD1LzuMEkIl3MCaJ
         YVSLC9jrYc4WRvwWWjlb/biHXzG3cL519UDQIVgBR8mxijnJtUd1ckroyhThW1rDr+
         lT1Tk/iikZdR9/I/ARUFTEQm2To7+HbVqHQqKOYz1CaAuYVWxMrsvPAAkLZPczDE3V
         sR9Yc0jANWYUA==
Date:   Fri, 11 Nov 2022 14:07:05 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: =?US-ASCII?Q?RE=3A_=5BRESEND_PATCH_2/6=5D_x86/traps=3A_add_a_system?= =?US-ASCII?Q?_interrupt_table_for_system_interrupt_dispatch?=
User-Agent: K-9 Mail for Android
In-Reply-To: <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com> <20221110061545.1531-3-xin3.li@intel.com> <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net> <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
Message-ID: <EA13BAB1-FD67-4145-9325-5705FEE6915A@zytor.com>
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

On November 10, 2022 11:55:22 AM PST, "Li, Xin3" <xin3=2Eli@intel=2Ecom> wr=
ote:
>> > Signed-off-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>> > Signed-off-by: Xin Li <xin3=2Eli@intel=2Ecom>
>>=20
>> This is not a valid SOB, it would suggest hpa is the author, but he's n=
ot in in
>> From=2E
>
>HPA wrote the initial dispatch code for FRED, and I worked with him to
>refactor it for KVM/VMX NMI/IRQ dispatch=2E  So use SOB from both=2E  No?
>
>> > diff --git a/arch/x86/kernel/traps=2Ec b/arch/x86/kernel/traps=2Ec in=
dex
>> > 178015a820f0=2E=2E95dd917ef9ad 100644
>> > --- a/arch/x86/kernel/traps=2Ec
>> > +++ b/arch/x86/kernel/traps=2Ec
>> > @@ -1444,6 +1444,61 @@ DEFINE_IDTENTRY_SW(iret_error)  }  #endif
>> >
>> > +#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] =3D
>> > +(system_interrupt_handler)y
>> > +
>> > +#pragma GCC diagnostic push
>> > +#pragma GCC diagnostic ignored "-Wcast-function-type"
>>=20
>> How does this not break CFI ?
>
>I wasn't aware of it, will check=2E
>

It doesn't break CFI because the arguments passed is always a strict super=
set of the ones expected and they are free enough that they are always pass=
ed in registers=2E
