Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020527337B9
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 19:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjFPR5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 13:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345227AbjFPR45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 13:56:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A78630DF
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 10:56:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56938733c13so11975147b3.1
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 10:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686938204; x=1689530204;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XdEBYinZEP7oCUKRZF8/sBIDoz+bbiwUaZcYs+aSp6M=;
        b=rMqYcB03De1k2qMDIISBklz3TWPvfwXa7utfxKeTZ0aGTkwW/DPx4TF8ro5tyLNHpl
         V+sthQOwwx5+MNo5iWE1efXcd173dBXRy47gF2v0kTu25P420C/lLEanxBy8g1sJDlu1
         vHj0DVP+wGcMPjWzq/mS+AcN2bOGOf8oI2IvbhHn1XS97MoJW1rsjSyLaXqriVu8VFOz
         0y3RcHE7hB+5ZWG7qI0sJGYK0MA3+Wj9TDEpCosbU5CWFYecdgO1b8OioLkddFuyI5uB
         ttIvb0PG52m/cZYb1fvanNfDceLKnd6MuAu4bGk2JmTc7sAYJlthLPB0SHfjbgZJHdxP
         rX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686938204; x=1689530204;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XdEBYinZEP7oCUKRZF8/sBIDoz+bbiwUaZcYs+aSp6M=;
        b=AyjFPHYvX3LzohpRyCcyqqYx6NXwPkEssXsUVcGzsm1yhNXVBUVK6yL+0uuB7qko6t
         CVi/FgqIsqM3OdHY8r6WVQm3FkxQs+qSkqJm4/mgBN82fpvqe8unhKIdEqY2urVUkqKH
         wFMOONYxWLiGn4xABEwgwSVJY9ZFQ0MFfOU1gQKSL0GxCFE5Cx/F5SKUR8cA2dKWHg63
         ZmI5oyTk/0Q8Ti5a13j1SGw+cRQ0OevPx63GNpWx2q8LrK66UqXwnzRuyrTJxTruGLHK
         dshJ9L5GlkcOG/88KIde/wyQ++W5nz9uxkdtZdULAkKw1cPt0wnu3aFUi602IYmZzL/G
         bwcQ==
X-Gm-Message-State: AC+VfDxlwcCjkF8F/Db5Igs6Qn9j7eMBqOcMmZDVd/V2suinT86ZudLx
        ot91x/M56iTW3aOIfcfbVX7GoraQ94I=
X-Google-Smtp-Source: ACHHUZ6HEgPWTWewG0yDNBc6/rrRCA1VeI8vz5gQ01rnPZohM1EZNxFsMXtb1B5VwfYdcp8iXfRfn5N4ffI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae07:0:b0:570:200:18e1 with SMTP id
 m7-20020a81ae07000000b00570020018e1mr883903ywh.3.1686938204700; Fri, 16 Jun
 2023 10:56:44 -0700 (PDT)
Date:   Fri, 16 Jun 2023 10:56:42 -0700
In-Reply-To: <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com> <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
Message-ID: <ZIyiWr4sR+MqwmAo@google.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Weijiang Yang wrote:
>=20
> On 6/16/2023 7:30 AM, Sean Christopherson wrote:
> > On Thu, May 11, 2023, Yang Weijiang wrote:
> > > The last patch is introduced to support supervisor SHSTK but the feat=
ure is
> > > not enabled on Intel platform for now, the main purpose of this patch=
 is to
> > > facilitate AMD folks to enable the feature.
> > I am beyond confused by the SDM's wording of CET_SSS.
> >=20
> > First, it says that CET_SSS says the CPU isn't buggy (or maybe "less bu=
ggy" is
> > more appropriate phrasing).
> >=20
> >    Bit 18: CET_SSS. If 1, indicates that an operating system can enable=
 supervisor
> >    shadow stacks as long as it ensures that certain supervisor shadow-s=
tack pushes
> >    will not cause page faults (see Section 17.2.3 of the Intel=C2=AE 64=
 and IA-32
> >    Architectures Software Developer=E2=80=99s Manual, Volume 1).
> >=20
> > But then it says says VMMs shouldn't set the bit.
> >=20
> >    When emulating the CPUID instruction, a virtual-machine monitor shou=
ld return
> >    this bit as 0 if those pushes can cause VM exits.
> >=20
> > Based on the Xen code (which is sadly a far better source of informatio=
n than the
> > SDM), I *think* that what the SDM is trying to say is that VMMs should =
not set
> > CET_SS if VM-Exits can occur ***and*** the bit is not set in the host C=
PU.  Because
> > if the SDM really means "VMMs should never set the bit", then what on e=
arth is the
> > point of the bit.
>=20
> I need to double check for the vague description.
>=20
> From my understanding, on bare metal side, if the bit is 1, OS can enable
> SSS if pushes won't cause page fault. But for VM case, it's not recommend=
ed
> (regardless of the bit state) to set the bit as vm-exits caused by guest =
SSS
> pushes cannot be fully excluded.
>=20
> In other word, the bit is mainly for bare metal guidance now.
>=20
> > > In summary, this new series enables CET user SHSTK/IBT and kernel IBT=
, but
> > > doesn't fully support CET supervisor SHSTK, the enabling work is left=
 for
> > > the future.
> > Why?  If my interpretation of the SDM is correct, then all the pieces a=
re there.

...

> And also based on above SDM description, I don't want to add the support
> blindly now.

*sigh*

I got filled in on the details offlist.

1) In the next version of this series, please rework it to reincorporate Su=
pervisor
   Shadow Stack support into the main series, i.e. pretend Intel's implemen=
ation
   isn't horribly flawed.  KVM can't guarantee that a VM-Exit won't occur, =
i.e.
   can't advertise CET_SS, but I want the baseline support to be implemente=
d,
   otherwise the series as a whole is a big confusing mess with unanswered =
question
   left, right, and center.  And more importantly, architecturally SSS exis=
ts if
   X86_FEATURE_SHSTK is enumerated, i.e. the guest should be allowed to uti=
lize
   SSS if it so chooses, with the obvious caveat that there's a non-zero ch=
ance
   the guest risks death by doing so.  Or if userspace can ensure no VM-Exi=
t will
   occur, which is difficult but feasible (ignoring #MC), e.g. by staticall=
y
   partitioning memory, prefaulting all memory in guest firmware, and not d=
irty
   logging SSS pages.  In such an extreme setup, userspace can enumerate CE=
T_SSS
   to the guest, and KVM should support that.
=20
2) Add the below patch to document exactly why KVM doesn't advertise CET_SS=
S.
   While Intel is apparently ok with treating KVM developers like mushrooms=
, I
   am not.

---
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 Jun 2023 10:04:37 -0700
Subject: [PATCH] KVM: x86: Explicitly document that KVM must not advertise
 CET_SSS

Explicitly call out that KVM must NOT advertise CET_SSS to userspace,
i.e. must not tell userspace and thus the guest that it is safe for the
guest to enable Supervisor Shadow Stacks (SSS).

Intel's implementation of SSS is fatally flawed for virtualized
environments, as despite wording in the SDM that suggests otherwise,
Intel CPUs' handling of shadow stack switches are NOT fully atomic.  Only
the check-and-update of the supervisor shadow stack token's busy bit is
atomic.  Per the SDM:

  If the far CALL or event delivery pushes a stack frame after the token
  is acquired and any of the pushes causes a fault or VM exit, the
  processor will revert to the old shadow stack and the busy bit in the
  new shadow stack's token remains set.

Or more bluntly, any fault or VM-Exit that occurs when pushing to the
shadow stack after the busy bit is set is fatal to the kernel, i.e. to
the guest in KVM's case.  The (guest) kernel can protect itself against
faults, e.g. by ensuring that the shadow stack always has a valid mapping,
but a guest kernel obviously has no control over, or even knowledge of,
VM-Exits due to host activity.

To help software determine when it is safe to use SSS, Intel defined
CPUID.0x7.1.EDX bit (CET_SSS) and updated Intel CPUs to enumerate CET_SS,
i.e. bare metal Intel CPUs advertise to software that it is safe to enable
SSS.

  If CPUID.(EAX=3D07H,ECX=3D1H):EDX[bit 18] is enumerated as 1, it is
  sufficient for an operating system to ensure that none of the pushes can
  cause a page fault.

But CET_SS also comes with an major caveat that is kinda sorta documented
in the SDM:

  When emulating the CPUID instruction, a virtual-machine monitor should
  return this bit as 0 if those pushes can cause VM exits.

In other words, CET_SSS (bit 18) does NOT enumerate that the underlying
CPU prevents VM-Exits, only that the environment in which the software is
running will not generate VM-Exits.  I.e. CET_SSS is a stopgap to stem the
bleeding and allow kernels to enable SSS, not an indication that the
underlying CPU is immune to the VM-Exit problem.

And unfortunately, KVM itself effectively has zero chance of ensuring that
a shadow stack switch can't trigger a VM-Exit, e.g. KVM zaps *all* SPTEs
when any memslot is deleted, enabling dirty logging write-protects SPTEs,
etc.  A sufficiently motivated userspace can, at least in theory, provide
a safe environment for SSS, e.g. by statically partitioning and
prefaulting (in guest firmware) all memory, disabling PML, never
write-protecting guest shadow stacks, etc.  But such a setup is far, far
beyond typical KVM deployments.

Note, AMD CPUs have a similar erratum, but AMD CPUs *DO* perform the full
shadow stack switch atomically so long as the stack is mapped WB and does
not cross a page boundary, i.e. a "normal" KVM setup and a well-behaved
guest play nice with SSS without additional shenanigans.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1e3ee96c879b..ecf4a68aaa08 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -658,7 +658,15 @@ void kvm_set_cpu_caps(void)
 	);
=20
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
+
+		/*
+		 * Do NOT advertise CET_SSS, i.e. do not tell userspace and the
+		 * guest that it is safe to use Supervisor Shadow Stacks under
+		 * KVM when running on Intel CPUs.  KVM itself cannot guarantee
+		 * that a VM-Exit won't occur during a shadow stack update.
+		 */
+		0 /* F(CET_SSS) */
 	);
=20
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,

base-commit: 9305c14847719870e9e08294034861360577ce08
--=20

