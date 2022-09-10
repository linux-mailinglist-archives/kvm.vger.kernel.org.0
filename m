Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B94D5B4436
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 07:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIJFUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 01:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIJFT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 01:19:59 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B9E27FF8
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 22:19:58 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id 67so3741461vsv.2
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 22:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1Q8xez3ltSahYUjHDy9HC9ApI6Tf5mJxjUk7SUwH3gE=;
        b=bxbtWmDBjSqoviCB7dbG1jM6t6nVv1LH9lO11ejN7Onu9V8LweLKGCMcQIZGrc5Zxp
         u/kzslzr7tQ1ehp19pSsev4LN+QDWOntIyqr9bSsj01px352X1psd1cfEtHEoX1UfD88
         8AGKpzzWU+WihgK6kGVRbbtX+vjtFdJU5AfSUq/tiJwlrzefhMAuY1yJzOhlDIKZmTkg
         u8ndKmR48jgZIxmSw7/Z/cZJE7rgnGiPTpRRHn+nfD/BMcDbjDiXj+9UOiTO1ivLjjrJ
         U87WTZHN+7HTApMBAKebLuMhrNtiRfgWDrBBj4RgvpbCwJuL1J9QMg81DV+gN7tBZnx/
         bkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1Q8xez3ltSahYUjHDy9HC9ApI6Tf5mJxjUk7SUwH3gE=;
        b=bvuFzXsMJnF58q6fPPThJvyZmz3GRFpWj5w4o1K5foH7pmQc5btJ2vkMmQvz7ehZL0
         9W4Wbps2TLfPSwBALdiFcSqEzKQwjhdReFM1pxKvHnMSL+/OxvgNtzmXnwfUI4RbKCo9
         8de2NncrdGzOtstkqrsIr9xnbsd0qgkEV3zM215UZKSi6IJt1sObHQEAAJBgzRcEdLcY
         S//nfoc9/rq0nf/nTMdpDS3YE5VPESABa6RfX5K5F3h4THnLSGTcNXGB9JEOpttpSHxu
         syXzroyGg4hA3xprzZ0Jvfn8nXk+xZrryBQ0tXuDjHI7DJfpQnb83L2yt0MVaolYVeV2
         qCwg==
X-Gm-Message-State: ACgBeo3Sm4TWeYaMjjRt97baqMmQYc2atwj6POKj5SQ9Z3oHfv5WCktO
        S0vABMOOMW4chaI+uKJOAqJEAjUOp3/VvY8/kc2ziod9TDhuYg==
X-Google-Smtp-Source: AA6agR44nfldY7tAzzaAQ1D6EFpSHsZyYKTtetNc0RGMnsJpeLOtNcS5qH1aKDOYzQY1oDIO9Iycm2Zy4vjSUED6iPo=
X-Received: by 2002:a67:c00b:0:b0:390:8e1f:594a with SMTP id
 v11-20020a67c00b000000b003908e1f594amr6242068vsi.80.1662787197272; Fri, 09
 Sep 2022 22:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com> <20220825050846.3418868-8-reijiw@google.com>
 <YxupmpFFPOVx95w+@google.com>
In-Reply-To: <YxupmpFFPOVx95w+@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 9 Sep 2022 22:19:41 -0700
Message-ID: <CAAeT=FxPn3xtPcg2_1EHGghZwHZ972cCXzNqJn+Jej2nsC7Y4A@mail.gmail.com>
Subject: Re: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked breakpoint
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

Thank you for the review!

On Fri, Sep 9, 2022 at 2:01 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:44PM -0700, Reiji Watanabe wrote:
> > Currently, the debug-exceptions test doesn't have a test case for
> > a linked breakpoint. Add a test case for the linked breakpoint to
> > the test.
>
> I would add some more detail, like the fact that this is a pair of
> breakpoints: one is a context-aware breakpoint, and the other one
> is an address breakpoint linked to the first one.

Sure, I would add more detail.

>
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 59 +++++++++++++++++--
> >  1 file changed, 55 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index ab8860e3a9fa..9fccfeebccd3 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -11,6 +11,10 @@
> >  #define DBGBCR_EXEC  (0x0 << 3)
> >  #define DBGBCR_EL1   (0x1 << 1)
> >  #define DBGBCR_E     (0x1 << 0)
> > +#define DBGBCR_LBN_SHIFT     16
> > +#define DBGBCR_BT_SHIFT              20
> > +#define DBGBCR_BT_ADDR_LINK_CTX      (0x1 << DBGBCR_BT_SHIFT)
> > +#define DBGBCR_BT_CTX_LINK   (0x3 << DBGBCR_BT_SHIFT)
> >
> >  #define DBGWCR_LEN8  (0xff << 5)
> >  #define DBGWCR_RD    (0x1 << 3)
> > @@ -21,7 +25,7 @@
> >  #define SPSR_D               (1 << 9)
> >  #define SPSR_SS              (1 << 21)
> >
> > -extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
> > +extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
> >  static volatile uint64_t sw_bp_addr, hw_bp_addr;
> >  static volatile uint64_t wp_addr, wp_data_addr;
> >  static volatile uint64_t svc_addr;
> > @@ -103,6 +107,7 @@ static void reset_debug_state(void)
> >       isb();
> >
> >       write_sysreg(0, mdscr_el1);
> > +     write_sysreg(0, contextidr_el1);
> >
> >       /* Reset all bcr/bvr/wcr/wvr registers */
> >       dfr0 = read_sysreg(id_aa64dfr0_el1);
> > @@ -164,6 +169,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
> >       enable_debug_bwp_exception();
> >  }
> >
> > +void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
> > +                    uint64_t ctx)
> > +{
> > +     uint32_t addr_bcr, ctx_bcr;
> > +
> > +     /* Setup a context-aware breakpoint */
> > +     ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> > +               DBGBCR_BT_CTX_LINK;
>                                ^^^^^
>                           isn't this a regular context-aware breakpoint?
>                           the other one is the linked one.

That is one of the types that we could use only for context-aware
breakpoints (Linked Context ID Match breakpoint).  I should probably
have stated we use Linked Context ID Match breakpoint for the
context-aware breakpoint ?


>
> > +     write_dbgbcr(ctx_bp, ctx_bcr);
> > +     write_dbgbvr(ctx_bp, ctx);
> > +
> > +     /* Setup a linked breakpoint (linked to the context-aware breakpoint) */
> > +     addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> > +                DBGBCR_BT_ADDR_LINK_CTX |
> > +                ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
>
> Just a curiosity, can the context-aware one link to this one?

No, it can't (LBN field for the Context breakpoint is ignored).

>
> > +     write_dbgbcr(addr_bp, addr_bcr);
> > +     write_dbgbvr(addr_bp, addr);
> > +     isb();
> > +
> > +     enable_debug_bwp_exception();
> > +}
> > +
> >  static void install_ss(void)
> >  {
> >       uint32_t mdscr;
> > @@ -177,8 +204,10 @@ static void install_ss(void)
> >
> >  static volatile char write_data;
> >
> > -static void guest_code(uint8_t bpn, uint8_t wpn)
> > +static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
> >  {
> > +     uint64_t ctx = 0x1;     /* a random context number */
>
> nit: make this number a bit more unlikely to happen by mistake.
> I guess you could use all available 32 bits.

Sure, I could change it to some different number.


>
> > +
> >       GUEST_SYNC(0);
> >
> >       /* Software-breakpoint */
> > @@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
> >                    : : : "x0");
> >       GUEST_ASSERT_EQ(ss_addr[0], 0);
> >
> > +     /* Linked hardware-breakpoint */
> > +     hw_bp_addr = 0;
> > +     reset_debug_state();
> > +     install_hw_bp_ctx(bpn, ctx_bpn, PC(hw_bp_ctx), ctx);
> > +     /* Set context id */
> > +     write_sysreg(ctx, contextidr_el1);
> > +     isb();
> > +     asm volatile("hw_bp_ctx: nop");
> > +     write_sysreg(0, contextidr_el1);
> > +     GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
> > +
> > +     GUEST_SYNC(10);
> > +
> >       GUEST_DONE();
> >  }
> >
> > @@ -327,6 +369,7 @@ int main(int argc, char *argv[])
> >       struct ucall uc;
> >       int stage;
> >       uint64_t aa64dfr0;
> > +     uint8_t brps;
> >
> >       vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> >       ucall_init(vm, NULL);
> > @@ -349,8 +392,16 @@ int main(int argc, char *argv[])
> >       vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> >                               ESR_EC_SVC64, guest_svc_handler);
> >
> > -     /* Run tests with breakpoint#0 and watchpoint#0. */
> > -     vcpu_args_set(vcpu, 2, 0, 0);
> > +     /* Number of breakpoints, minus 1 */
> > +     brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
>
> If brps is "number of breakpoints", then there should be a "+ 1" above.
> Otherwise brps is really "last breakpoint" (last_brp).
>
> > +     __TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
>
> Yes, based on this test, brps is really "last breakpoint". I would
> suggest changing the name to "last_brp" (or something similar).

The 'brps' I meant is simply 'BRPS' field value of ID_AA64DFR0_EL1.
I agree that it could be misleading.

The following patches use xxx_num for the number of watch/break points.
So, I am thinking of changing it brp_num to indicate the number of
breakpoints (and add 1).


> > +
> > +     /*
> > +      * Run tests with breakpoint#0 and watchpoint#0, and the higiest
>
>          * Run tests with breakpoint#0, watchpoint#0, and the highest

Will fix this.

Thank you,
Reiji
