Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4AB750E9D
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGLQeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjGLQeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:34:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810F81711
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:34:11 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-991ef0b464cso215241166b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1689179650; x=1691771650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKxiM/mmkZsT+AN/tRL7fIWPMsOwkeO0vnAXqp6D7ms=;
        b=G4thK2RcyzM4mRu72n5VtguYngqvbPwGcxJG3aJO8YS0Ptu1jKUImTzCO6mD+Z9dE1
         6tHVJ2XEt3FtwWA6ZjT2RweOzIk0xzNiJbzBCzdqkficKekjD1aAsvLJkxnc/uITUCiy
         Vs3dJqvTRVFGoaYJP33k8VVoa/F+EKjdFfjZNsoyyrEwtHqeqdGe+hR9CDXEddJMU4sq
         wUTifWjCHShR/1qSlZsxKrCi9I9Va25TJyMJJ6fYJq91aO707aK6TzZU8KVUq4jyrO0n
         5fIwYryEU3yuLPuOEyfNGt/y6tdqxq5X4x0C9N3zJakwAgiNGcjCj4+KU2WAp3jDsR1/
         MP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179650; x=1691771650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mKxiM/mmkZsT+AN/tRL7fIWPMsOwkeO0vnAXqp6D7ms=;
        b=c3q8ADikNxt0Qok7xnvCN6IefEAUbUhgIwBfN3pPpPVHHB9dCgUEQpSqCLp4qzlArW
         +NLhqT8SxkgLlveRMQ70zPoX8YLflrvuXC+10L5b9Z8Mqb0xnZY61P7wxt991uOCoW8F
         Lj+dfHp9BC0ouBxWGPHgxcXPcyw3/ebFzcT+IqRS4WRa7szqbQgi5JULLJPiknxMPrdv
         5f/ouUlQX6AefGOyMqVJHYB84XdUF2JspHTE5/wyf/bQsuQyDnIvyrTLT7sHa89Bq2UT
         R4fYo9OWg/g8CXPxnmnY9+uvBhrEU7d/zcegp4RJhLjIXTQvAPeX6yZYpoLNadJsX+Sr
         n4uQ==
X-Gm-Message-State: ABy/qLbb0WBPbmnpJ+qu7KrMr1JozsJ9gnO2TA2cyWYZj70VGgY3KK8r
        LXLF8tb1GvULZnxXr4EV/4rNchvazStFSg9eLIeQKA==
X-Google-Smtp-Source: APBJJlF7gdR6TPMrH5zXqRQ7EPmGOC+xGDba/PIpj57S0UXCgVS8brRRdAbLozeeM/IafuCfNGHNzpSdX8eCBjcvecY=
X-Received: by 2002:a17:907:6d05:b0:98d:abd4:4000 with SMTP id
 sa5-20020a1709076d0500b0098dabd44000mr3335058ejc.35.1689179649673; Wed, 12
 Jul 2023 09:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230706173804.1237348-1-apatel@ventanamicro.com> <20230712161053.GA2986@willie-the-truck>
In-Reply-To: <20230712161053.GA2986@willie-the-truck>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 12 Jul 2023 22:03:57 +0530
Message-ID: <CAAhSdy3o8a=Dsxw53rXJR3h4QP_tMD4bUgwLuU-2c68aCit4_Q@mail.gmail.com>
Subject: Re: [kvmtool PATCH v3 0/8] RISC-V SBI enable/disable, Zbb, Zicboz,
 and Ssaia support
To:     Will Deacon <will@kernel.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 9:41=E2=80=AFPM Will Deacon <will@kernel.org> wrote=
:
>
> On Thu, Jul 06, 2023 at 11:07:56PM +0530, Anup Patel wrote:
> > The latest KVM in Linux-6.4 has support for:
> > 1) Enabling/disabling SBI extensions from KVM user-space
> > 2) Zbb ISA extension support
> > 3) Zicboz ISA extension support
> > 4) Ssaia ISA extension support
> >
> > This series adds corresponding changes in KVMTOOL to use the above
> > mentioned features for Guest/VM.
> >
> > These patches can also be found in the riscv_sbi_zbb_zicboz_ssaia_v3
> > branch at: https://github.com/avpatel/kvmtool.git
> >
> > Changes since v2:
> >  - Rebased on commit 0b5e55fc032d1c6394b8ec7fe02d842813c903df
> >  - Updated PATCH1 to sync-up header with released Linux-6.4
>
> Bah, now we're back to the __DECLARE_FLEX_ARRAY breakage :(
>
> In file included from include/linux/kvm.h:15,
>                  from x86/include/kvm/kvm-cpu-arch.h:6,
>                  from include/kvm/kvm-cpu.h:4,
>                  from include/kvm/ioport.h:4,
>                  from hw/rtc.c:4:
> x86/include/asm/kvm.h:511:17: error: expected specifier-qualifier-list be=
fore =E2=80=98__DECLARE_FLEX_ARRAY=E2=80=99
>   511 |                 __DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_=
data, vmx);
>       |                 ^~~~~~~~~~~~~~~~~~~~

My bad, the fix for this error was folded in the header sync patch of v2
which got accidently dropped in this version.

I will send v4 with the compile error fix as a separate patch.

Regards,
Anup
