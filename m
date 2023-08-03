Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3400076ECB8
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbjHCOgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbjHCOf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:35:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B634C3E
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:35:01 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-584126c65d1so11390587b3.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691073292; x=1691678092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HeVObJQnYDsmrxbFy3UKyOXJ/04Tm/UrYLmx2eoTf0=;
        b=mY+VlJDI/9R96lHrF/byfI80tHJ1s5Gus55V305s7E4SAg0rPoHWmnYIjWZxnR96Qg
         wNgVWy+nar1i5fCgkhUIxyuPYnwULI/CDGcui4W4frLoCo2Xs6Mvmh4O93VXwINaG4MD
         aLQSjEgY5Sr++uwder4uv1U1zr+RE/TZw70suJBkPoAxfERYGUAh65xpMXXf1VC4L6YR
         QI1yBioovUHQV314pZya8DbV6ot00JQTOHznRjjB0MHBwoe648gepwgyrhx6yF+obTXg
         4b5zV85RlYKVZAVdlQIMyXxU5SyIvwC4aueFb8qZtbmEWd++S6ziiWUINJuLfm1ROpFm
         9WQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691073292; x=1691678092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/HeVObJQnYDsmrxbFy3UKyOXJ/04Tm/UrYLmx2eoTf0=;
        b=Z2+RKSO+W5ArUssNOyh11zcZb8KrSBCkUb8/JvNGT1wL8G/eBYjvhGo4SNvlm89K0C
         OuzVtXAoc4X7WzI/3lo0Oj+SJj6ij75qFYDOGVVGBfrTgIZa7+kfpmdnOM2jSntMo9h7
         rC8wkfvCoP3kF8+6zJZlPsJEDUvbiZwnHVGdqNk3XFvj90tS7il/DyDeZ+e97z/05JEU
         joVlBLqRCBnE2aBT6o1ozSoiMr0AQwRj8EPVDZOaLGKYRBjHcLUos8ChHdeG4ivg6N47
         UI1Oz/flVspBARoquxwL4EKrnMVxm0WTR6B2rfS9QF7++mSuG46Z4l18F1rB+vgWJsqL
         iEqA==
X-Gm-Message-State: ABy/qLaQVBjX5rsPQnEa72MWOLFh+JHGJdbtCaO+AfTJ680IuKpoQDGa
        B8ugGDr+gXtChU6xd9EesyPG3c7vhjA=
X-Google-Smtp-Source: APBJJlFFzKkAdKTRoLZ2bhoaeb1cJvVOWKX7WmBJwxFpjymL5GMdod+dfzaL5IdKDJfMFpNHYNav47SkUAk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:37d8:0:b0:c64:2bcd:a451 with SMTP id
 e207-20020a2537d8000000b00c642bcda451mr133323yba.7.1691073291936; Thu, 03 Aug
 2023 07:34:51 -0700 (PDT)
Date:   Thu, 3 Aug 2023 14:34:50 +0000
In-Reply-To: <ZMto2Yza4rd2JdXf@iZuf6hx7901barev1c282cZ>
Mime-Version: 1.0
References: <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn> <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
 <ZMphvF+0H9wHQr5B@google.com> <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
 <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com> <bdf548d1-84cb-6885-c4eb-cbb16c4a3e3b@amd.com>
 <ZMsekJG8PF0f4sCp@iZuf6hx7901barev1c282cZ> <ZMto2Yza4rd2JdXf@iZuf6hx7901barev1c282cZ>
Message-ID: <ZMu7Cl6im9JwjHIQ@google.com>
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
From:   Sean Christopherson <seanjc@google.com>
To:     Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023, Wu Zongyo wrote:
> On Thu, Aug 03, 2023 at 11:27:12AM +0800, Wu Zongyo wrote:
> > > > > 
> > > > > I'm guessing it was a #NPF, too. Could it be related to the changes that
> > > > > went in around svm_update_soft_interrupt_rip()?
> > Yes, it's a #NPF with exit code 0x400.
> > 
> > There must be something I didn't handle corretly since it behave normally with
> > qemu & ovmf If I don't add int3 before mcheck_cpu_init().
> > 
> > So it'a about memory, is there something I need to pay special attention
> > to?
> > 
> > Thanks
> I check the fault address of #NPF, and it is the IDT entry address of
> the guest kernel. The NPT page table is not constructed for the IDT
> entry and the #NPF is generated when guest try to access IDT.
> 
> With qemu & ovmf, I didn't see the #NPF when guest invoke the int3
> handler. That means the NPT page table has already been constructed, but
> when?

More than likely, the page was used by the guest at some point earlier in boot.
Why the page is faulted in for certain setups but not others isn't really all
that interesting in terms of fixing the KVM bug, both guest behaviors are completely
normal and should work.

Can you try this patch I suggested earlier?  If this fixes the problem, I'll post
a formal patch.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d381ad424554..2eace114a934 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -385,6 +385,9 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
        }

        if (!svm->next_rip) {
+               if (sev_guest(vcpu->kvm))
+                       return 0;
+
                if (unlikely(!commit_side_effects))
                        old_rflags = svm->vmcb->save.rflags;

