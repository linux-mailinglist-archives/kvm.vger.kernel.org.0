Return-Path: <kvm+bounces-3139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B12800EF8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 661291C2097B
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF5E4BA97;
	Fri,  1 Dec 2023 16:05:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B803C10D0;
	Fri,  1 Dec 2023 08:05:03 -0800 (PST)
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1r960h-0003eb-QO; Fri, 01 Dec 2023 17:04:59 +0100
Message-ID: <00fa768e-eceb-48c3-ae23-1966f110ec49@maciej.szmigiero.name>
Date: Fri, 1 Dec 2023 17:04:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use it
 due to an errata
Content-Language: en-US, pl-PL
To: Jim Mattson <jmattson@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
 <ZWTQuRpwPkutHY-D@google.com>
 <9a8e3cb95f3e1a69092746668f9643a25723c522.camel@redhat.com>
 <b3aec42f-8aa7-4589-b984-a483a80e4a42@maciej.szmigiero.name>
 <CALMp9eQvLpYdq=2cYyOBERBh2G+xubo6Mb0crWO=dugpie4BRg@mail.gmail.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <CALMp9eQvLpYdq=2cYyOBERBh2G+xubo6Mb0crWO=dugpie4BRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1.12.2023 00:57, Jim Mattson wrote:
> On Thu, Nov 30, 2023 at 2:00 PM Maciej S. Szmigiero
> <mail@maciej.szmigiero.name> wrote:
>> I think that if particular guest would work on bare metal it should
>> work on "-cpu host" too - no tinkering should be required for such
>> basic functionality as being able to successfully finish booting.
> 
> I disagree. Let's not focus on one particular erratum. If, for
> whatever reason, the host kernel is booted with "noxsaves," I don't
> think KVM should allow a guest to bypass that directive.

Good point, I agree that if user explicitly disabled XSAVES on
the host via this parameter then it should remain disabled for
the whole host kernel, including KVM.

This could be achieved by either adding special "noxsaves" flag
or by setting X86_BUG_XSAVES_AVOID instead of clearing
X86_FEATURE_XSAVES on these CPUs.

Then the core kernel XSAVES code would check for lack of
X86_BUG_XSAVES_AVOID (in addition to checking for
presence of X86_FEATURE_XSAVES) while KVM would keep using
only X86_FEATURE_XSAVES.

Thanks,
Maciej


