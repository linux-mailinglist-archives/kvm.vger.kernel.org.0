Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A6B74A2FD
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjGFRSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjGFRSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:18:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED121BDB
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:18:02 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9741caaf9d4so114646766b.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1688663881; x=1691255881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jOtE5xTd2bkD5397BmKCeosVtbbWLhxVlPHfzE5Y9mY=;
        b=iMZlqoMMthHaV2VcUQoKgNXtB5RF8z/ReyvnJCaY86v6NqGIqIvV7t3TkjVz3/wUvj
         KYRtVM4Tuzi46SuREYJJ5sjUHtlSye2DUsdNI0KolwDBSA05IXkn/c2v/23YSPq+mh1V
         zqRW6HxV8v6/1VZ5sXE1KVYYRj9X3JYIb00kpUQ2wbPxdcNZgnmL4VePdG9fI4Cnjbui
         cVEY7JHYALHe2Cij8Rbbw+TpJSR6XQNAb/xUDz0OV+VzeAMZY4A9Qy8ZgrU6CsHvE3FD
         GnT+0iyFsB+pNIziH7XZVUyJRakiVPCJdoknvIRRsOXUc7liMpEEML9T91RlXLME5eeo
         9XLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688663881; x=1691255881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jOtE5xTd2bkD5397BmKCeosVtbbWLhxVlPHfzE5Y9mY=;
        b=YaRN5fvafGwkgRolYEIT/Wdru2LwpwqThDTsZ2vZU/2txo0/i9HAVihbwoQK8aT1i+
         X5BRascJohl/0GDBibDtZ1dg6WVVSsBSXzmfwEIzXm5KkvGWR9BqBR2znfaR5GFGW14x
         uNikbSSGnFhYlitAh3SYLE9Y52wTB1o7abxOwKMBDyhtiOnaF7qLbd8cApkxaOYqLnQd
         URMoOr8ZZzpCyaH7x56dGWmGpGEIxvbpWJng/TXGAV0+BRw9Yd59zjOxEaTwlpVBJR8r
         0h3TmsjCgjJQAYzSb9kX800vb3NlRYbgpjh5SgxLYZO62gIWmuC7m/hmYnbB1RNp99AT
         1bKg==
X-Gm-Message-State: ABy/qLbtrOXP5NHTrGnNzj8ZpQS1Q0hw626CWv9aZGNP2gP/AJglrChC
        P4gRMv9CHi96dyUmFZfTvXrW+xTLlpquMdQmmq4XFw==
X-Google-Smtp-Source: APBJJlFzHjsoJe3hHqigfBdQg9ZyiIPD2lBPk8FW0iTTUaNsaiDEEinp/IgGHdn9c8u6Cy/UzZYQsdAudsH0p/M3Y+Q=
X-Received: by 2002:a17:906:17d4:b0:98f:5640:16a with SMTP id
 u20-20020a17090617d400b0098f5640016amr2438746eje.53.1688663880620; Thu, 06
 Jul 2023 10:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230605140208.272027-1-apatel@ventanamicro.com>
 <20230605140208.272027-2-apatel@ventanamicro.com> <20230706143333.GA29413@willie-the-truck>
In-Reply-To: <20230706143333.GA29413@willie-the-truck>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 6 Jul 2023 22:47:49 +0530
Message-ID: <CAAhSdy1LWqwqS2sJ_1Nf9no1_-0aMxH6xn2_iFF+MqBbqwjc1Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] Sync-up headers with Linux-6.4-rc5
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 6, 2023 at 8:03=E2=80=AFPM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jun 05, 2023 at 07:32:01PM +0530, Anup Patel wrote:
> > We sync-up Linux headers to get latest KVM RISC-V headers having
> > SBI extension enable/disable, Zbb, Zicboz, and Ssaia support.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
>
> Now that 6.4 is released, mind resending this series with a snap to the
> released kernel headers instead?

Sure, I will do it right away.

Thanks,
Anup

>
> Cheers,
>
> Will
