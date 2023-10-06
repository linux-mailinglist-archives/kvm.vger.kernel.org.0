Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E996D7BAFEC
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 03:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjJFBHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 21:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjJFBGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 21:06:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42761A4
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 17:57:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a23fed55d7so23140157b3.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 17:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696553820; x=1697158620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wngn7j6yKtSFTPMW7k+qGiUH7BBA15u51HDdOm1cg3E=;
        b=zmOccEuN7EtJyN+GduajTOivHJfdjEbg7zz/wq/JNF8rg2erEaRmf5A3R2+W7fKKXH
         jCp6THfIZRWnf6Qkrwe4SZD3UKVsnmKffdUDJ3Tfo7vux3mi5+4DwhPe13dEskmqEdj8
         nfv7tjtnWhxNhniVLhEQ0TsP91fb/1I3lJdb/Qd9A1zP9HHgDFmgVTez0PSnWwlIBpeg
         xKkJtvyvIY4+qf1FETs8xcrXScMwMkrBy4pL+1HiHKv0DA5HMc144olJrLJE+q1kdvE1
         vj4dWQv8rhc4V+hAqNB3KNVer2uWRcjFG6hkfZ2dz40y/8j212RpHUmPka9yqpjw2hpi
         DzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696553820; x=1697158620;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wngn7j6yKtSFTPMW7k+qGiUH7BBA15u51HDdOm1cg3E=;
        b=OVuLCepknlnjnOXCBxiK/awMl99xK5Us3s5oJyKgzPEgfVCGTBojdTDWPTqM//WFoQ
         mzc1xvZ5KpTQAQBl+LCAOeQIOIWxugJZRbnroksAOT4Swzs1vJMCN+X+/QVBCHuma5t5
         iK1XZN1Ii8y3LrOvVosgkKvnl5/mPLHF6iFCWsrlzcqExd8g4BojEWzmmhxcPyJOpXTu
         QPLw+WuR9Kcmr3dP2403mnY5WWvzUzjjpMtFLtXjvJAGS07V/MTBhuLNsDB2/y8oRTB8
         3jVqbKGbcQ9WunDah0S/5k/7si4g+EbnUvPfzV4m/oUIL27Y76Rp0zl5yRH+97p9C0EI
         8POQ==
X-Gm-Message-State: AOJu0YzrBoMQYUFMMgUhh2VEeO4oSxFHXSiqz2sLwXnWCXiw1pt92TB8
        5W0p3PjULC6g61soozqC1ZlHnq/LkV0=
X-Google-Smtp-Source: AGHT+IF9fHtrrX/GGgOPG/BXvvUJelJCJzZWpcqgDwtn8b0zwq8T77PGmCqSzSqYWoPwF3xnWBJ4W4tqtso=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bcd:0:b0:d7f:2cb6:7d8c with SMTP id
 196-20020a250bcd000000b00d7f2cb67d8cmr95392ybl.13.1696553820052; Thu, 05 Oct
 2023 17:57:00 -0700 (PDT)
Date:   Fri, 6 Oct 2023 00:56:58 +0000
In-Reply-To: <1b0252b29c19cc08c41e1b58b26fbcf1f3fb06e4.camel@cyberus-technology.de>
Mime-Version: 1.0
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
 <ZR1_lizQd14pbXbg@google.com> <1b0252b29c19cc08c41e1b58b26fbcf1f3fb06e4.camel@cyberus-technology.de>
Message-ID: <ZR9bWv_Fogzx1zwv@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Fix partially uninitialized integer in emulate_pop
From:   Sean Christopherson <seanjc@google.com>
To:     Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023, Julian Stecklina wrote:
> On Wed, 2023-10-04 at 08:07 -0700, Sean Christopherson wrote:
> > On Wed, Oct 04, 2023, Julian Stecklina wrote:
> > > Most code gives a pointer to an uninitialized unsigned long as dest i=
n
> > > emulate_pop. len is usually the word width of the guest.
> > >=20
> > > If the guest runs in 16-bit or 32-bit modes, len will not cover the
> > > whole unsigned long and we end up with uninitialized data in dest.
> > >=20
> > > Looking through the callers of this function, the issue seems
> > > harmless, but given that none of this is performance critical, there
> > > should be no issue with just always initializing the whole value.
> > >=20
> > > Fix this by explicitly requiring a unsigned long pointer and
> > > initializing it with zero in all cases.
> >=20
> > NAK, this will break em_leave() as it will zero RBP regardless of how m=
any
> > bytes
> > are actually supposed to be written.=C2=A0 Specifically, KVM would inco=
rrectly
> > clobber
> > RBP[31:16] if LEAVE is executed with a 16-bit stack.
>=20
> Thanks, Sean! Great catch. I didn't see this. Is there already a test sui=
te for
> this?

No, I'm just excessively paranoid when it comes to the emulator :-)

> > I generally like defense-in-depth approaches, but zeroing data that the=
 caller
> > did not ask to be written is not a net positive.
>=20
> I'll rewrite the patch to just initialize variables where they are curren=
tly
> not. This should be a bit more conservative and have less risk of breakin=
g
> anything.

In all honesty, I wouldn't bother.  Trying to harden the emulator code for =
things
like this will be a never ending game of whack-a-mole.  The operands, of wh=
ich
there are many, have multiple unions with fields of varying size, and all k=
inds
of subtle rules/logic for which field is used, how many bytes within a give=
n field
are valid, etc.

It pains me a bit to say this, but I think we're best off leaving the emula=
tor
as-is, and relying on things like fancy compiler features, UBSAN, and fuzze=
rs to
detect any lurking bugs.

  struct operand {
	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_MM, OP_NONE } type;
	unsigned int bytes;
	unsigned int count;
	union {
		unsigned long orig_val;
		u64 orig_val64;
	};
	union {
		unsigned long *reg;
		struct segmented_address {
			ulong ea;
			unsigned seg;
		} mem;
		unsigned xmm;
		unsigned mm;
	} addr;
	union {
		unsigned long val;
		u64 val64;
		char valptr[sizeof(sse128_t)];
		sse128_t vec_val;
		u64 mm_val;
		void *data;
	};
  };
