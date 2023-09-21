Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A837AA50B
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjIUWaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbjIUWaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:30:24 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E724F7EC0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:05:24 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-656307a52e8so6144456d6.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695315917; x=1695920717; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9nCvb9CrO2GaZq009DzYQ8CxVOSv0DQu3f44RpIAl4=;
        b=hD8dTZV55dQw/KKvw6hEheom6xuujJ7tCVwAHIP5Jr2CyxQvTAM9dCRO9wZFehvGz+
         JUpt9URJGSLFV36Wdmz7tDnfIdm3unrhDtn50bN+BuOTzc3iiqojk3x/aUytTxI1HA3S
         /fklXnGXUCNvm+9gUWRac53WRtMyrwovGAccgp+6WTKDaKmpiHitYYP+dHMMRW3V6gIY
         LZHyh8mJTQp8/SzX9bxFM9gg4tvwPOwQF/Mhqf0n58EecDQe7UEtB/U8f/LMHISLN9+g
         Jk6/uikmu7XmPnR2ONepYjA0fkRabWtuVsrufY6jFkWrH+0R26yQbX/zQoNXQeE8yikd
         wbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695315917; x=1695920717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9nCvb9CrO2GaZq009DzYQ8CxVOSv0DQu3f44RpIAl4=;
        b=jrWJkSd+gbbm3QN61houIN8fKR91jxEdSTmRFS1oCZ5yk6BT5rNi9Kc1jgJ2bGKtOF
         VC8iiNBKfkENRBxBNGj2ME8CgnvyVjeS0T153Z4MyPBdPsDUUEGG5NUe6MgkjWC5L5u8
         SH/ryUHnI1gmZuFiBMxt4m6xU75iCNJSAykIQ3ce/QUC2Ap/abzyUnPMxzHGLW83OPiI
         RQw8SW3nM8StpnV4Mfd74ulrWkv7h8FiGWVjiOeTsiFlpZBlswaWLJOhNUPhzNslOrEk
         wxXAnr7vpPA/uKZ7CflvrpRzrju8+vzVIDFan4PbFn1n0kBD6YOciKBD/N+7uykEQ4UX
         oe+Q==
X-Gm-Message-State: AOJu0YzS0nRW3lXtOdc5IMY38PEIhvDxJ/mLFw7UVU+GlKe8gMob/1P1
        kG4EWFpfBngX+s5aAXvP1i231M3Z72ueipdpNDcVP5yJ3TOjgJ+2M0Y=
X-Google-Smtp-Source: AGHT+IHVPuhFW+sGrMGW2iY7pMa14QvaelEddHySWV/HAgZhZpuV4DDEx4xNG/hsPPFcqiqQeUvbDngd1S9ogJ2JCoI=
X-Received: by 2002:a17:90a:c08a:b0:268:553f:1938 with SMTP id
 o10-20020a17090ac08a00b00268553f1938mr4569172pjs.4.1695273761830; Wed, 20 Sep
 2023 22:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230920154608.1447057-1-apatel@ventanamicro.com>
In-Reply-To: <20230920154608.1447057-1-apatel@ventanamicro.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Thu, 21 Sep 2023 10:52:29 +0530
Message-ID: <CAK9=C2WXtRLTFA5JeWbkyKt+1qyTat0nw7v3-b6oQ-YO_37tdA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM RISC-V fixes for ONE_REG interface
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023 at 9:16=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series includes few assorted fixes for KVM RISC-V ONE_REG interface
> and KVM_GET_REG_LIST API.
>
> These patches can also be found in riscv_kvm_onereg_fixes_v2 branch at:
> https://github.com/avpatel/linux.git
>
> Changes since v1:
>  - Addressed Drew's comments in PATCH4
>
> Anup Patel (4):
>   RISC-V: KVM: Fix KVM_GET_REG_LIST API for ISA_EXT registers
>   RISC-V: KVM: Fix riscv_vcpu_get_isa_ext_single() for missing
>     extensions
>   KVM: riscv: selftests: Fix ISA_EXT register handling in get-reg-list
>   KVM: riscv: selftests: Selectively filter-out AIA registers

Queued this series for 6.6-rcX fixes

Thanks,
Anup

>
>  arch/riscv/kvm/vcpu_onereg.c                  |  7 ++-
>  .../selftests/kvm/riscv/get-reg-list.c        | 58 ++++++++++++++-----
>  2 files changed, 47 insertions(+), 18 deletions(-)
>
> --
> 2.34.1
>
