Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8586553DD
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 20:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiLWTe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 14:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLWTeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 14:34:25 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9185E2018E;
        Fri, 23 Dec 2022 11:34:24 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2BNJY7kW3005320
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 23 Dec 2022 11:34:08 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2BNJY7kW3005320
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022120601; t=1671824048;
        bh=IrboZx5CPC/dL/EdCsJXRS0OtXozRdw6gy0xC4hc90I=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=R5pLy9wg3IEoVnGbPbdm89AwneJqiYGnORrjHZQGNU+Paj35segoutCkPgDjLEYEx
         ykh5cC1tDtHw4Q8U1Ww7NZ+8B9VuYfHGv/NrrMX5JbDR0Kx8TqRz8DSNygppgJPy/b
         wmLkB+wbiOEHzsRoqoupa8JUtS2oMhFtig5tQpMuV93UUB8yPV0kU5qbUEmPcbKqe1
         Inf9JJBwsBUh+5q78j8dLNq2SSeDWKTe4zJphbTpISrDMawJNqV+B+2+WCNkj406RK
         Xrk1n55tRsZ/QxGMBE4kqkMcUPjs49vIP2ncJxGAAutBpLnDm1tkCCaTsvpXvCkc6G
         DDybFYu/EihVw==
Date:   Fri, 23 Dec 2022 11:34:05 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Li, Xin3" <xin3.li@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [RFC PATCH 14/32] x86/fred: header file with FRED definitions
User-Agent: K-9 Mail for Android
In-Reply-To: <Y6RVvRg20Xc6IR4k@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com> <20221220063658.19271-15-xin3.li@intel.com> <Y6F4s0K2b2G8aMve@hirez.programming.kicks-ass.net> <BN6PR1101MB21615569318BD964A2855F44A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com> <Y6RVvRg20Xc6IR4k@hirez.programming.kicks-ass.net>
Message-ID: <BBD4EA67-C076-4718-93C6-EB25A59C342B@zytor.com>
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

On December 22, 2022 5:03:57 AM PST, Peter Zijlstra <peterz@infradead=2Eorg=
> wrote:
>On Wed, Dec 21, 2022 at 02:58:06AM +0000, Li, Xin3 wrote:
>
>> > > +/* Flags above the CS selector (regs->csl) */
>> > > +#define FRED_CSL_ENABLE_NMI		_BITUL(28)
>> > > +#define FRED_CSL_ALLOW_SINGLE_STEP	_BITUL(25)
>> > > +#define FRED_CSL_INTERRUPT_SHADOW	_BITUL(24)
>> >=20
>> > What's the state of IBT WAIT-FOR-ENDBR vs this? That really should al=
so get a
>> > high CS bit=2E
>>=20
>> FRED does provide more possibilities :)
>
>That's not an answer=2E IBT has a clear defect and FRED *should* fix it=
=2E

You are not wrong, of course=2E That being said, we have not wanted to hit=
ch too many things to the FRED baseline, lest it ends up delayed for implem=
entation/validation reasons=2E The important thing is that FRED *does* prov=
ide the mechanism for addressing that even if it does not make the first im=
plementation=2E
