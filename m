Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989C36FD050
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 22:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbjEIUyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 16:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjEIUyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 16:54:39 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFE56A64
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 13:54:19 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-43476bbec67so4040638137.2
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 13:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683665528; x=1686257528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ek4N4zhVnFp0OjD2e91cJw6qEMFFDQc5/FTgmHiGak=;
        b=rVJW9XdHV4bhVBpENigqqik2I2pCncaz794aO5r0GaFD6EOogLB5GsTpjkOXXFk1cl
         BLaajyFwcHYbDsMksrmy46rkJ8Xg5XgSiPcKIeqTk5sc4i6ByJVNSNE661bfq0lTqdr5
         15qPLPCf/jWgZf76j7FinTn4I6xu8cSDiM5g9kSu8JtTXKgSM8OwYPMKVaG7suYL8InA
         DMrcHjABRjgiApDllMJEgP/iLFCOFcqlwydZH35zZAE5dGhLWBf35Ag5dGmDJHpUzL+l
         I6D5uZx78KFyGlmPQFh+q8W5REGbWvTcrIRfpmnEKUzBt+OarAE0cEQNLkGT/+HDIP0z
         HuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665528; x=1686257528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ek4N4zhVnFp0OjD2e91cJw6qEMFFDQc5/FTgmHiGak=;
        b=LdyM9jW0QV4RR5cS0YX0YM5J9wooomM3Xm2GNSKkSmppfZfm5lwiKMNamHWOdWrs4P
         dKFS3i7OZGeDW5AsjkOPSqiQhDd8lWL2MzEnMbpEKTbYnOmdBULlfkB8Gn6vRh/Aqox0
         HGs1/EfwZDUEI+1a9tTzNbEI9S/VAmELgx/xLv4RStgieYBGdAmN7kT5iz//GrliE1QZ
         KTe7JYZpNkBMeO2VlXEi8dPEkeLXiBhv/fRlbx/Li3jT5UUuoXqJjpboLy06BfLBNqSZ
         FVuwl01UUJKSVVH2IBAr24qf6B7+Zt184IdYBgX/+ucohmSInf2/ZB4f/nf0il8Nm+1s
         I/Eg==
X-Gm-Message-State: AC+VfDzj+UVImeJU+kTn3ydgmPJeIfN1SBISopELTLThmSggdxhLc8C6
        QrCWGTX9M/wPwD4s0jRPWud2O0Vi4FuBkRBiljZnMA==
X-Google-Smtp-Source: ACHHUZ5qUtibgquXG1CHXn5rsYEnNugGuamTPmXoGAjYsiSltyM3mefeFrXCpD+c8boXnApqrdpstv0ZlJ4ZhdJ1iOQ=
X-Received: by 2002:a67:f291:0:b0:42e:6748:13dc with SMTP id
 m17-20020a67f291000000b0042e674813dcmr5348659vsk.0.1683665528538; Tue, 09 May
 2023 13:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 9 May 2023 13:51:42 -0700
Message-ID: <CALzav=fZFpzw57hNmg2fqYG-0ddtvQd9+=7cw8tzuOGbZW1A1A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: Refactor KVM stats macros and enable custom
 stat names
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Mar 6, 2023 at 11:01=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> This series refactors the KVM stats macros to reduce duplication and
> adds the support for choosing custom names for stats.

Hi Paolo,

I just wanted to double-check if this series is on your radar
(probably for 6.5)?
