Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9954D5B40A5
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 22:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiIIU2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 16:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiIIU2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 16:28:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4C312B2B8
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 13:27:03 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t70so2601998pgc.5
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 13:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=1rg+8CXL6LaxUGYAq9loFt3B/Y3f1yZ+leG8YKVuchA=;
        b=F++FswWLhpOx97hpq7r+1kbkeUu3uGHk5cy97ldga0Mv2+4zasp7kBg/n1QDheX3rW
         TdqaJRXEB3SYJyPwfK5juSJMA/+JzZtv3rNr+UEthRuYfWvOBokDmhyoPtpr/bHClXJ4
         HtLPmv1iBLuilVv8Zn0Ieo4l9/QcdmQFnLAMpqVECGh7kYmAjn4TOUYetrx6EFt2CUUO
         GdBsC2BixJubJwcX5W27xJqpgJFx0SZMDbLhPM7+VkYDIhAKuufd5W2qCL95hLdcnBhP
         4JGbssWYrifX0uZKes5ZeFgl/me2uRKqMNpv/HjE57qn/AVmYBvZRvMH90MX8bxq8VuD
         OO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1rg+8CXL6LaxUGYAq9loFt3B/Y3f1yZ+leG8YKVuchA=;
        b=dM39viXDFRSVwxfJpEBxm0aPgy39kd49cwWZFUM5jxI2gmd9SGAQvmJtPOlNbXdNR3
         axerYXpb0e4k1xX9mtPfeAlb0NneV8nVY+1aQw3ODxOfz5Ggm7s4whcM2cJ6EtE4dOie
         LZUbsn3dck6MGSy4TJKX1PMISGU5gfSGXhcN0Wllwdr2boXlLD2dmYs4dDFWC+iI1nC5
         PciiN/n6G5HaSNWWhvTgIee7vMfYp91OehMzcRIVdFEqRgYOxWukskxn/GBAprTLFTbH
         /opJxHGTgXrxdX5xGZvFqxYW7wUnVEvxBeTXN90zMKDjm91fmusC3rY2N9cB7oka8VxM
         eObQ==
X-Gm-Message-State: ACgBeo389IWHJuzYmZftVIkfWVngyWuS4Z5r5beFpJ7XZ+KAVFNbRkPO
        kczRlyyWyt/LZKnTvCBJO9eZfQ==
X-Google-Smtp-Source: AA6agR4yZyXcycdC0EpSzkrPaP60iJdEbTBcmyCScHpsjn1U3y13tT7pQo9csrz53VqCQto1Y6MEKw==
X-Received: by 2002:a05:6a00:1a04:b0:52a:d4dc:5653 with SMTP id g4-20020a056a001a0400b0052ad4dc5653mr15834974pfv.69.1662755223017;
        Fri, 09 Sep 2022 13:27:03 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id l3-20020a170903244300b00176a5767fb0sm899132pls.94.2022.09.09.13.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 13:27:02 -0700 (PDT)
Date:   Fri, 9 Sep 2022 13:26:58 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
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
Subject: Re: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked
 breakpoint
Message-ID: <YxuhkvMh5cAtONKe@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-8-reijiw@google.com>
 <CAAeT=FxJLykbrgKSC6DNFr+hWr-=TOq60ODFZ7r+jGOV3a=KWg@mail.gmail.com>
 <YxuflDM6utJbdZa1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxuflDM6utJbdZa1@google.com>
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

On Fri, Sep 09, 2022 at 01:18:28PM -0700, Ricardo Koller wrote:
> On Thu, Aug 25, 2022 at 06:29:34PM -0700, Reiji Watanabe wrote:
> > On Wed, Aug 24, 2022 at 10:10 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Currently, the debug-exceptions test doesn't have a test case for
> > > a linked breakpoint. Add a test case for the linked breakpoint to
> > > the test.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > >
> > > ---
> > >  .../selftests/kvm/aarch64/debug-exceptions.c  | 59 +++++++++++++++++--
> > >  1 file changed, 55 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > > index ab8860e3a9fa..9fccfeebccd3 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > > @@ -11,6 +11,10 @@
> > >  #define DBGBCR_EXEC    (0x0 << 3)
> > >  #define DBGBCR_EL1     (0x1 << 1)
> > >  #define DBGBCR_E       (0x1 << 0)
> > > +#define DBGBCR_LBN_SHIFT       16
> > > +#define DBGBCR_BT_SHIFT                20
> > > +#define DBGBCR_BT_ADDR_LINK_CTX        (0x1 << DBGBCR_BT_SHIFT)
> > > +#define DBGBCR_BT_CTX_LINK     (0x3 << DBGBCR_BT_SHIFT)
> > >
> > >  #define DBGWCR_LEN8    (0xff << 5)
> > >  #define DBGWCR_RD      (0x1 << 3)
> > > @@ -21,7 +25,7 @@
> > >  #define SPSR_D         (1 << 9)
> > >  #define SPSR_SS                (1 << 21)
> > >
> > > -extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
> > > +extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
> > >  static volatile uint64_t sw_bp_addr, hw_bp_addr;
> > >  static volatile uint64_t wp_addr, wp_data_addr;
> > >  static volatile uint64_t svc_addr;
> > > @@ -103,6 +107,7 @@ static void reset_debug_state(void)
> > >         isb();
> > >
> > >         write_sysreg(0, mdscr_el1);
> > > +       write_sysreg(0, contextidr_el1);
> > >
> > >         /* Reset all bcr/bvr/wcr/wvr registers */
> > >         dfr0 = read_sysreg(id_aa64dfr0_el1);
> > > @@ -164,6 +169,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
> > >         enable_debug_bwp_exception();
> > >  }
> > >
> > > +void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
> > > +                      uint64_t ctx)
> > > +{
> > > +       uint32_t addr_bcr, ctx_bcr;
> > > +
> > > +       /* Setup a context-aware breakpoint */
> > > +       ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> > > +                 DBGBCR_BT_CTX_LINK;
> > > +       write_dbgbcr(ctx_bp, ctx_bcr);
> > > +       write_dbgbvr(ctx_bp, ctx);
> > > +
> > > +       /* Setup a linked breakpoint (linked to the context-aware breakpoint) */
> > > +       addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
> > > +                  DBGBCR_BT_ADDR_LINK_CTX |
> > > +                  ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
> > > +       write_dbgbcr(addr_bp, addr_bcr);
> > > +       write_dbgbvr(addr_bp, addr);
> > > +       isb();
> > > +
> > > +       enable_debug_bwp_exception();
> > > +}
> > > +
> > >  static void install_ss(void)
> > >  {
> > >         uint32_t mdscr;
> > > @@ -177,8 +204,10 @@ static void install_ss(void)
> > >
> > >  static volatile char write_data;
> > >
> > > -static void guest_code(uint8_t bpn, uint8_t wpn)
> > > +static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
> > >  {
> > > +       uint64_t ctx = 0x1;     /* a random context number */
> > > +
> > >         GUEST_SYNC(0);
> > >
> > >         /* Software-breakpoint */
> > > @@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
> > >                      : : : "x0");
> > >         GUEST_ASSERT_EQ(ss_addr[0], 0);
> > >
> > 
> > I've just noticed that I should add GUEST_SYNC(10) here, use
> > GUEST_SYNC(11) for the following test case, and update the
> > stage limit value in the loop in userspace code.
> > 
> > Or I might consider removing the stage management code itself.
> > It doesn't appear to be very useful to me, and I would think
> > we could easily forget to update it :-)
> > 
> > Thank you,
> > Reiji
> >
> 
> Yes, it's better to remove it. The intention was to make sure the guest
> generates the expected sequence of exits. In this case for example,
> "1, .., 11, DONE" would be correct, but "1, .., 11, 12, DONE" would not.

Sorry, the correct sequence should be "1, .., 10, DONE". And also, what
I meant to say is that *original* intention was to check that, which
wasn't actually completed as the incorrect sequence would also succeed.

> 
> > > +       /* Linked hardware-breakpoint */
> > > +       hw_bp_addr = 0;
> > > +       reset_debug_state();
> > > +       install_hw_bp_ctx(bpn, ctx_bpn, PC(hw_bp_ctx), ctx);
> > > +       /* Set context id */
> > > +       write_sysreg(ctx, contextidr_el1);
> > > +       isb();
> > > +       asm volatile("hw_bp_ctx: nop");
> > > +       write_sysreg(0, contextidr_el1);
> > > +       GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
> > > +
> > > +       GUEST_SYNC(10);
> > > +
> > >         GUEST_DONE();
> > >  }
> > >
> > > @@ -327,6 +369,7 @@ int main(int argc, char *argv[])
> > >         struct ucall uc;
> > >         int stage;
> > >         uint64_t aa64dfr0;
> > > +       uint8_t brps;
> > >
> > >         vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> > >         ucall_init(vm, NULL);
> > > @@ -349,8 +392,16 @@ int main(int argc, char *argv[])
> > >         vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> > >                                 ESR_EC_SVC64, guest_svc_handler);
> > >
> > > -       /* Run tests with breakpoint#0 and watchpoint#0. */
> > > -       vcpu_args_set(vcpu, 2, 0, 0);
> > > +       /* Number of breakpoints, minus 1 */
> > > +       brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
> > > +       __TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
> > > +
> > > +       /*
> > > +        * Run tests with breakpoint#0 and watchpoint#0, and the higiest
> > > +        * numbered (context-aware) breakpoint.
> > > +        */
> > > +       vcpu_args_set(vcpu, 3, 0, 0, brps);
> > > +
> > >         for (stage = 0; stage < 11; stage++) {
> > >                 vcpu_run(vcpu);
> > >
> > > --
> > > 2.37.1.595.g718a3a8f04-goog
> > >
