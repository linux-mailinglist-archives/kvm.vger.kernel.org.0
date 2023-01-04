Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AA465DDF8
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 22:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbjADVDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 16:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjADVDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 16:03:21 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456EC18E25;
        Wed,  4 Jan 2023 13:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=DdXvznrWNFXCWn/0dzxvJoX7bP6fArqWW8xJiDt8/zM=; b=ETs0XrrINbauFT2FNiPan8dX/h
        smrSRTJL8gZM3NK1XmGCEoHDQpWXIp/7+j08+gEU3WBABGfV8lB9/uYxsj7wWxPfMmLl3IHUwpj3n
        kn0PYXLHRhgaOsBOPZg82zGOS/5BP7JmytEEnAog2qrIcS/FP0x9gvaqWerZcJiett/oCAWLrQwOH
        BIkaS6ROtmAWt0y3pVnb0HdOwnqJZGAD+aVAtse2jnenc9Mc6DJxA9lPbknW9nqG7XAF59005QCLl
        Z/UOLhVTXZ+nN+ngaM6DOVsYKEZzcqccmLiyNvHQ9Lv6Gm80cbkQaYFn+Ib3s2k/t4Nugns3yXnSg
        w17j9Eig==;
Received: from [172.31.31.126] (helo=[127.0.0.1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pDAub-0014WI-1Z;
        Wed, 04 Jan 2023 21:03:02 +0000
Date:   Wed, 04 Jan 2023 21:03:04 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paul Durrant <pdurrant@amazon.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_2/2=5D_KVM=3A_x86/xen=3A_update_Xen_C?= =?US-ASCII?Q?PUID_Leaf_4_=28tsc_info=29_sub-leaves=2C_if_present?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y7Xfp3Izlc6VPEzC@google.com>
References: <20221220134053.15591-1-pdurrant@amazon.com> <20221220134053.15591-3-pdurrant@amazon.com> <Y7XWHr1kb4AHd4Lv@google.com> <0e58d9a6bc8bf15c23feff25ec24e9b3c26945cc.camel@infradead.org> <Y7Xfp3Izlc6VPEzC@google.com>
Message-ID: <C0955015-2E2F-4D56-9611-4696553E2A2A@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4 January 2023 20:20:55 GMT, Sean Christopherson <seanjc@google=2Ecom> =
wrote:
>On Wed, Jan 04, 2023, David Woodhouse wrote:
>> On Wed, 2023-01-04 at 19:40 +0000, Sean Christopherson wrote:
>> >=20
>> > arch/x86/include/asm/xen/hypervisor=2Eh also open codes the signature=
=2E=C2=A0 Rather than
>> > add a KVM-specific define, what about putting in xen/cpuid=2Eh?=C2=A0=
 (I've had a version
>> > of this series sitting in my todo pile for far too long, sorry)=2E
>>=20
>> xen/cpuid=2Eh is an external header imported from Xen itself so in
>> general I'd prefer to avoid modifying it unless we also send the
>> changes upstream=2E
>
>*sigh*  Fool me once=2E=2E=2E
>
>Can we shove it into arch/x86/include/asm/xen/hypervisor=2Eh?  Or is incl=
uding
>that in KVM too confusing/ugly?

Maybe, if that's our own header=2E We do include a bunch of stuff intended=
 for use by Xen guests, in arch/x86/kvm/xen=2Ec to provide Xen support=2E I=
t's only the 32-bit compat bits we define for ourselves within arch/x86/kvm=
/xen=2Eh=2E

