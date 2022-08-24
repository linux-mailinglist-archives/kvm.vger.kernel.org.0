Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126CC5A0162
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 20:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239299AbiHXSdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 14:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiHXSc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 14:32:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D78F5EDDE
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 11:32:57 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso2365768pjj.4
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 11:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=YKbWM2IXwqJA8k15hvSun4kOmPMn3++8YYGLXKX1GWE=;
        b=NXcrZMf9GCTf2+fJZTGC4/4U4W2eDlXjQs5mTc8NbQyE/zs1Z4JcBCQVQZbj79VhJP
         5X9TMgN3MWEKhSvQPJfSk/Pvrv25mOgddHlNEztmjpvVxpQK/MG1TKr5crXfyTgwHW21
         pkfMZl7w5Mwqo6XM6PnYham5YSyr2vf1OrZOdBv+KQNpktIGPhVXR6G5Ethi8g2WSflJ
         Yp4WQHvHKc6puTOFC6y4oUE+ud45jAZAa+esUX77UGvkonMQDIuxBZJtEg0UybNI+zef
         hMT5ugVraVJU3XOT9TbxSAX1esNgYPHF3PBVlqpiyMCbv1WvBTIgs5dtJqDO92Tl75qJ
         K86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YKbWM2IXwqJA8k15hvSun4kOmPMn3++8YYGLXKX1GWE=;
        b=CE6RDbOAuI9Nh4LfO7zm/aQwnO6CaQ8v2DVNCcXy8GLecR+4ev1ugOVKxpGx1eCgyZ
         /aJKgG5DX+/2F1HB5/M9H9GvL/hu5skXLvYbeP6L5V6XnN5hvDqGqjG9WOBVuq9I3b8C
         M48UrGRWSJYcwCHqKeJ1rCfaDNknmvKVXB6wvWwiv6dTYXfxhJHrCd575eys7ttaoXUC
         mwbzwx6Szaj0M90yTpEfIIZfUEC9b1FhB72fMtSbwzR9MSd7rSptKD2qFcRvKylXZu32
         tP/R1JXS2csAuPyLuwVErSwAIcqxYIrOzzgUU7E8FaK9mkP59a31luqVeTT/U6znPAPc
         0VHA==
X-Gm-Message-State: ACgBeo3H7Xey71XbjGDCUS7CrZhOjyfZ+ILgB/JD8eoPcR1QAWOJgzNk
        cM8dxGLvbPDhOL7GY3XRnFohVQ==
X-Google-Smtp-Source: AA6agR4cSTbUhsC4mfBgC7eCCfX00YS43u9ve24YmzoHayP7aBtgISYMlGo2JvSFI/0mYCvjuFeIQg==
X-Received: by 2002:a17:902:e80d:b0:172:ff23:faa8 with SMTP id u13-20020a170902e80d00b00172ff23faa8mr244863plg.26.1661365976918;
        Wed, 24 Aug 2022 11:32:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 3-20020a631943000000b0041c30def5e8sm11378093pgz.33.2022.08.24.11.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 11:32:56 -0700 (PDT)
Date:   Wed, 24 Aug 2022 18:32:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test POP-SS blocking
Message-ID: <YwZu1K5Rgb1sevsy@google.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
 <20220821220647.1420411-1-mhal@rbox.co>
 <9b853239-a3df-f124-e793-44cbadfbbd8f@rbox.co>
 <YwOj6tzvIoG34/sF@google.com>
 <6d19f78f-120a-936b-3eba-e949ecc3509f@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d19f78f-120a-936b-3eba-e949ecc3509f@rbox.co>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Michal Luczaj wrote:
> On 8/22/22 17:42, Sean Christopherson wrote:
> >> On 8/22/22 00:06, Michal Luczaj wrote:
> >> test can be simplified to something like
> >>
> >> 	asm volatile("push %[ss]\n\t"
> >> 		     __ASM_TRY(KVM_FEP "pop %%ss", "1f")
> >> 		     "ex_blocked: mov $1, %[success]\n\t"
> > 
> > So I'm 99% certain this only passes because KVM doesn't emulate the `mov $1, %[success]`.
> > kvm_vcpu_check_code_breakpoint() honors EFLAGS.RF, but not MOV/POP_SS blocking.
> > I.e. I would expect this to fail if the `mov` were also tagged KVM_FEP.
> 
> I wasn't sure if I understood you correctly

Yep, you got the gist.

> so, FWIW, I've ran:
> 
> static void test_pop_ss_blocking_try(void)
> {
> 	int success;
> 
> 	write_dr7(DR7_FIXED_1 |
> 		  DR7_GLOBAL_ENABLE_DRx(0) |
> 		  DR7_EXECUTE_DRx(0) |
> 		  DR7_LEN_1_DRx(0));
> 
> #define POPSS(desc, fep1, fep2)					\
> 	asm volatile("mov $0, %[success]\n\t"			\
> 		     "lea 1f, %%eax\n\r"			\

Note, hardcoding EAX doesn't compile for 64-bit KUT.  It's kinda gross, but we
can fudge around this without #ifdeffery by using a dummy input constraint.

> 		     "mov %%eax, %%dr0\n\r"			\
> 		     "push %%ss\n\t"				\
> 		     __ASM_TRY(fep1 "pop %%ss", "2f")		\

No need for __ASM_TRY if this is thrown into debug.c.

> 		     "1:" fep2 "mov $1, %[success]\n\t"		\
> 		     "2:"					\
> 		     : [success] "=g" (success)			\
> 		     :						\
> 		     : "eax", "memory");			\
> 	report(success, desc ": #DB suppressed after POP SS")

To avoid potential "leakage", wrap this whole thing in ({ ... }), and declare
"success" inside that scope.

Aha!  Even better.  s/success/r, make it unsigned long, and force it to be a
register.  Then the blob can use the register as scratch before clearing it via
XOR to indicate success (though that's somewhat pointless, see below).

> 	POPSS("no fep", "", "");
> 	POPSS("fep pop-ss", KVM_FEP, "");
> 	POPSS("fep mov-1", "", KVM_FEP);
> 	POPSS("fep pop-ss/fep mov-1", KVM_FEP, KVM_FEP);
> 
> 	write_dr7(DR7_FIXED_1);
> }
> 
> and got:
> 
> em_pop_sreg unpatched:
> PASS: no fep: #DB suppressed after POP SS
> FAIL: fep pop-ss: #DB suppressed after POP SS
> PASS: fep mov-1: #DB suppressed after POP SS
> FAIL: fep pop-ss/fep mov-1: #DB suppressed after POP SS
> 
> em_pop_sreg patched:
> PASS: no fep: #DB suppressed after POP SS
> PASS: fep pop-ss: #DB suppressed after POP SS
> PASS: fep mov-1: #DB suppressed after POP SS
> PASS: fep pop-ss/fep mov-1: #DB suppressed after POP SS
> 
> For the sake of completeness: basically the same, but MOV SS, i.e.
> 
> 	asm volatile("mov $0, %[success]\n\t"			\
> 		     "lea 1f, %%eax\n\r"			\
> 		     "mov %%eax, %%dr0\n\r"			\
> 		     "mov %%ss, %%eax\n\t"			\
> 		     __ASM_TRY(fep1 "mov %%eax, %%ss", "2f")	\
> 		     "1:" fep2 "mov $1, %[success]\n\t"		\
> 		     "2:"					\
> 		     : [success] "=g" (success)			\
> 		     :						\
> 		     : "eax", "memory");			\
> 
> PASS: no fep: #DB suppressed after MOV SS
> PASS: fep mov-ss: #DB suppressed after MOV SS
> PASS: fep mov-1: #DB suppressed after MOV SS
> PASS: fep mov-ss/fep mov-1: #DB suppressed after MOV SS

This passes for 3 reasons:

  1. The test more than likely doesn't skip the instruction on #DB, and so
     success will be set regardless of whether or not a #DB occurred.

  2. DR0 needs to be loaded with the address of the MOV, not the address of the
     FEP prefix.  Somewhat amusingly, this means my patch to fix redundant #DB
     checking is wrong[*]

  3. My personal favorite.  On VM-Exits due to exceptions (#UD), Intel CPUs set
     EFLAGS.RF=1 and thus effectively suppress #DBs on FEP instructions.

       If the VM exit is caused directly by an event that would normally be delivered
       through the IDT, the value saved is that which would appear in the saved RFLAGS
       image (either that which would be saved on the stack had the event been delivered
       through a trap or interrupt gate1 or into the old task-state segment had the event
       been delivered through a task gate) had the event been delivered through the IDT.
       See below for VM exits due to task switches caused by task gates in the IDT.

     I'm pretty sure this inarguably a KVM bug.  The SDM states the EFLAGS.RF=0
     on instruction-based VM-Exits, and since the intent in the FEP case (but not
     the general #UD case) is to simulate an instruction exit...

       If the VM exit is caused by an attempt to execute an instruction that
       unconditionally causes VM exits or one that was configured to do with a
       VM-execution control, the value saved is 0.

I'll fold a fix for #3 and for the MOV/POP-SS blocking code #DB interaction into
the aforementioned series[*].

As expected, I get two failures (FEP on the XOR testcases) with this tweak to KVM,

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5cecb19cf5..e5fd0b936a48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7261,6 +7261,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
            kvm_read_guest_virt(vcpu, kvm_get_linear_rip(vcpu),
                                sig, sizeof(sig), &e) == 0 &&
            memcmp(sig, kvm_emulate_prefix, sizeof(sig)) == 0) {
+               kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) & ~X86_EFLAGS_RF);
                kvm_rip_write(vcpu, kvm_rip_read(vcpu) + sizeof(sig));
                emul_type = EMULTYPE_TRAP_UD_FORCED;
        }

and this as a testcase.

diff --git a/x86/debug.c b/x86/debug.c
index b66bf047..ab29e94e 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -352,8 +352,44 @@ static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
        return start_rip;
 }
 
+static void test_mov_ss_code_db(bool fep_available)
+{
+       write_dr7(DR7_FIXED_1 |
+                 DR7_GLOBAL_ENABLE_DRx(0) |
+                 DR7_EXECUTE_DRx(0) |
+                 DR7_LEN_1_DRx(0));
+
+#define MOVSS_DB(desc, fep1, fep2)                             \
+({                                                             \
+       unsigned long r;                                        \
+                                                               \
+       n = 0;                                                  \
+       asm volatile("lea 1f(%%rip), %0\n\t"                    \
+                    "mov %0, %%dr0\n\t"                        \
+                    "mov %%ss, %0\n\t"                         \
+                    fep1 "mov  %0, %%ss\n\t"                   \
+                    fep2 "1: xor %0, %0\n\t"                   \
+                    "2:"                                       \
+                    : "=r" (r)                                 \
+                    :                                          \
+                    : "memory");                               \
+       report(!n && !r, desc ": #DB suppressed after MOV SS"); \
+})
+
+       MOVSS_DB("no fep", "", "");
+       if (fep_available) {
+               MOVSS_DB("fep MOV-SS", KVM_FEP, "");
+               MOVSS_DB("fep XOR", "", KVM_FEP);
+               MOVSS_DB("fep MOV-SS/fep XOR", KVM_FEP, KVM_FEP);
+       }
+
+       write_dr7(DR7_FIXED_1);
+}
+
 int main(int ac, char **av)
 {
+       /* Check for KVM's FEP support prior to usurpsing the #UD handler. */
+       bool fep_available = is_fep_available();
        unsigned long cr4;
 
        handle_exception(DB_VECTOR, handle_db);
@@ -417,6 +453,8 @@ int main(int ac, char **av)
        run_ss_db_test(singlestep_with_movss_blocking_and_icebp);
        run_ss_db_test(singlestep_with_movss_blocking_and_dr7_gd);
 
+       test_mov_ss_code_db(fep_available);
+
        n = 0;
        write_dr1((void *)&value);
        write_dr6(DR6_BS);


[*] https://lore.kernel.org/all/20220723005137.1649592-4-seanjc@google.com

> > The reason I say the setup_idt() change is a moot point is because I think it
> > would be better to put this testcase into debug.c (where "this" testcase is really
> > going to be multiple testcases).  With macro shenanigans (or code patching), it
> > should be fairly easy to run all testcases with both FEP=0 and FEP=1.
> >
> > Then it's "just" a matter of adding a code #DB testcase.  __run_single_step_db_test()
> > and run_ss_db_test() aren't fundamentally tied to single-step, i.e. can simply be
> > renamed.  For simplicity, I'd say just skip the usermode test for code #DBs, IMO
> > it's not worth the extra coverage.
> 
> So that would involve a 32-bit segment for POP SS and making use of DR0/DR7 instead
> of single stepping? I guess I can try.

Eh, let's completely skip usermode for code #DBs and not tweak __run_single_step_db_test().
It's easier to just have a standalone function.
