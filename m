Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364246D9DB2
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 18:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239240AbjDFQnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 12:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbjDFQnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 12:43:07 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5CD4EFF
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 09:43:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s3-20020a632c03000000b0050300a8089aso11871068pgs.0
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 09:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680799386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AYsbyALIYv+X9w8bL9Dllzu+6ryq0NV+c3WTFwhcy70=;
        b=saf8muKa1u/C+Nb/mWnNjAt0Ks7VJ4fenL0VV+aDeCLwaCXQJh26HPTrE3U8+Se61P
         7P3PXuXgMPrAqPIj+KglpYWiapgN7zJj6Y72ggZAoswddWo5NWrtEV0DnwKpBGe4DUZN
         bz9kRCLZxxK0vDjSHHm/T4BiXMat8EJNsvkRl2+6DrFMMQPY+p6D+GEZOV70Pb6nJGka
         8pnfZF9SQZ8eWoHxvCiViJ7FezgN6V8z/uUONSfNxhiAfolR9uPhilx7cb+EGHZr777m
         jLNpIixBeky+ddxjAHkfH6XJpP/FkP6NcHWThkl4g1p4kn46i/8UsMxcthduFu54iWrG
         rlPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680799386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AYsbyALIYv+X9w8bL9Dllzu+6ryq0NV+c3WTFwhcy70=;
        b=1LKJ324Iuo/8ovO2jtUqRMAhYTB+0Nvy48mPV32yv7v/Dl0VvxFT2JONyUmHDunZrj
         0wfRfcg0n3mN7z/0VSjTJSLIlLhp0AAAq08MYrf7gNYE2Nkruhg3WCfpJrxmY4b/kt7s
         MLqAjnosgqIAZa+CzRy7BA09F9SBRhY4cB5W2HA+DtmdzkE60BuXkUAm8DM3TlTZKHzJ
         fqcXzQQCGmZ1gcxqbsZMwqps+1icY6zvn+E9OA19u8ngglQhAFr9kzV+yCqzo5jayDDH
         DbjnEZMexPT6aum4nTgiKz2FuQlzU0C/nc5Z33DHZDsATV12rzh1d182t3mACo2c+6oK
         tt5g==
X-Gm-Message-State: AAQBX9dY+OBDqTN2+OfbGRCX8i8jHAJHBSVXpfZT7Z6CG9eczYWEv1K3
        Lt44+Qpowaq+sglsp+HUQcP+JgKBgoY=
X-Google-Smtp-Source: AKy350ZKPODZ1QTM9MeV0Rl/fy/dG60DokUW3D/my2C/iKVEcSIytzMylNZv/cZq4J8gqcs/os8ugUmS5+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:fd8:b0:23b:446b:bbfd with SMTP id
 gd24-20020a17090b0fd800b0023b446bbbfdmr3889242pjb.1.1680799385735; Thu, 06
 Apr 2023 09:43:05 -0700 (PDT)
Date:   Thu, 6 Apr 2023 09:43:04 -0700
In-Reply-To: <f34b3d78-a1c4-90cb-079a-2dc81a5e6e7b@grsecurity.net>
Mime-Version: 1.0
References: <20230215142344.20200-1-minipli@grsecurity.net>
 <ZC42RavGH2Z82oJd@google.com> <f34b3d78-a1c4-90cb-079a-2dc81a5e6e7b@grsecurity.net>
Message-ID: <ZC72mHH4oU4n7Jjc@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test non-canonical memory
 access exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Mathias Krause wrote:
> On 06.04.23 05:02, Sean Christopherson wrote:
> > On Wed, Feb 15, 2023, Mathias Krause wrote:
> >> +static void test_reg_noncanonical(void)
> >> +{
> >> +	extern char nc_rsp_start, nc_rsp_end, nc_rbp_start, nc_rbp_end;
> >> +	extern char nc_rax_start, nc_rax_end;
> >> +	handler old_ss, old_gp;
> >> +
> >> +	old_ss = handle_exception(SS_VECTOR, advance_rip_and_note_exception);
> >> +	old_gp = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
> >> +
> >> +	/* RAX based, should #GP(0) */
> >> +	exceptions = 0;
> >> +	rip_advance = &nc_rax_end - &nc_rax_start;
> >> +	asm volatile("nc_rax_start: orq $0, (%[msb]); nc_rax_end:\n\t"
> > 
> > Can't we use ASM_TRY() + exception_vector() + exception_error_code()?  Installing
> > a dedicated handler is (slowly) being phased out.
> 
> Well, you may have guessed it, but I tried to be "consistent with the
> existing style." Sure this code could get a lot of cleanups too, the
> whole file, actually, like the externs should be 'extern char []'
> instead to point out they're just "labels" and no chars. But, again, I
> just did as was "prior art" in this file. But if moving forward to a
> more modern version is wanted, I can adapt.

Yes, please ignore prior art in KVM-Unit-Tests, so much of its "art" is just awful.

> > And why hardcode use of RAX?  Won't any "r" constraint work?
> 
> Unfortunately not. It must be neither rsp nor rbp and with "r" the
> compiler is free to choose one of these.

Ah, right, I forgot about RBP.

> It'll unlikely make use of rsp, but rbp is a valid target we need to avoid.
> (Yes, I saw the -no-omit-frame-pointer handling in the Makefiles, but I
> dislike this implicit dependency.)
> 
> I can change the constraints to "abcdSD" to give the compiler a little
> bit more freedom, but that makes the inline asm little harder to read,
> IMHO. Hardcoding rax is no real constraint to the compiler either, as
> it's a volatile register anyway. The call to report() will invalidate
> its old value, so I don't see the need for a change -- a comment, at
> best, but that's already there ;)

Hardcoding RAX is totally fine, I just forgot about RBP.

> > E.g. I believe this can be something like:
> > 
> > 	asm_safe_report_ex(GP_VECTOR, "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
> > 	report(!exception_error_code());
> > 
> > Or we could even add asm_safe_report_ex_ec(), e.g.
> > 
> > 	asm_safe_report_ex_ec(GP_VECTOR, 0,
> > 			      "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
> 
> Yeah, the latter. Verifying the error code is part of the test, so that
> should be preserved.
> 
> The tests as written by me also ensure that an exception actually
> occurred, exactly one, actually. Maybe that should be accounted for in
> asm_safe*() as well?

That's accounted for, the ASM_TRY() machinery treats "0" as no exception (we
sacrified #DE for the greater good).  Realistically, the only way to have multiple
exceptions without going into the weeds is if KVM somehow restarted the faulting
instruction.  That would essentially require very precise memory corruption to
undo the exception fixup handler's modification of RIP on the stack.  And at that
point, one could also argue that KVM could also corrupt the exception counter.

> PS: Would be nice if the entry barrier for new tests wouldn't require to
> handle the accumulated technical debt of the file one's touching ;P

Heh, and if wishes were horses we'd all be eating steak.  Just be glad I didn't
ask you to rewrite the entire test ;-)

Joking aside, coercing/extorting contributors into using new/better infrastructure
is the only feasible way to keep KVM's test infrastructure somewhat manageable.
E.g. I would love to be able to dedicate a substantial portion of my time to
cleaning up the many warts KUT, but the unfortunate reality is that test infrastructure
is always going to be lower priority than the product itself.

> But I can understand that adding more code adapting to "existing style"
> makes the problem only worse. So it's fine with me.
