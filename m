Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB61765725
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 17:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbjG0PPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 11:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbjG0PPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 11:15:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481D719B5
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 08:14:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbbc4ae328so7168695ad.1
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 08:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690470898; x=1691075698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uh22aMhq83izPRCbdrRzzwtaMf1me9g6NjbX+Co5bp0=;
        b=V5PJl9OPtbH6rKjCHnQT6vG07X8vn1wK9wE/VoB4pVOU/wXuTZXHBq4qngrQhFqdYx
         7Nc/8XHsnrfsfvv63G5rKFMVKoj2MBlEBdyp1WGHDAFWz3vrGvQ3AdmEIExOtJ1aO6i+
         cnpQEo0+AaWgfFRrDpzagp8FGIL+tu0h/ir+/VZ2zzregWOLzHJM0I9Ivoic0+BxzKz4
         WYd1p4sm9ojfR9ElLG7BmLpUbcffOLNvMQyPdc38Ip378ziKHbWr9liHJkrm859/SeMX
         ozbx6WwLe/AJVj5hZNh0cUCayyHYysk1ulw9KDKJg9gQ0Hv8Z3iv6s5gECSyYS8u0C8i
         fslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690470898; x=1691075698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uh22aMhq83izPRCbdrRzzwtaMf1me9g6NjbX+Co5bp0=;
        b=FLWSMG+Eucbkp5ezwR5dhWwfC3dM/LGrlu00aVae5GXsmtVSAqTfZ+c4nd/nF+rgsl
         e6zcqCPiXeMoTMrzkkDEe+5BIT+hbhNCTRj7dTg0XIhrh5PU/RqFJbbPr/7Gut2+mYaY
         2/WWhFY48UWAh9y4aIGhx51lbpJEF799Fpkkmn735RuUdSTiQq2oUGY4mBs7wcY56d4U
         TZXRkFM5FLUXFFUDz58ZrpLGiKkfozRdmRrDqaC4RButN+Oipu5nTSrwQzTqXg51Tt8j
         yDV6vgtQj3sPdivppQ+6p6ly/5+5SFxcg3uNK4PFuwNBBpUk9jNMgzrGg2vj0Pm6GP8T
         6FjA==
X-Gm-Message-State: ABy/qLYL/jtQAn7pg/sIRUJfAQIXRFdy7bqKuqCFwqXdPuXfRTid0ADm
        fHPaGXZdswMHtp+TRuBw9pgAV1niPS0=
X-Google-Smtp-Source: APBJJlGAozwFR6Zya7MZdDqmVCOsox47jjr1N+m/uDgqX2krJoIRdH7cC9hMOsvAPWaaJ/Ie78DL6VKYewM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2cd:b0:1b9:ce2c:3bb0 with SMTP id
 n13-20020a170902d2cd00b001b9ce2c3bb0mr23241plc.3.1690470897724; Thu, 27 Jul
 2023 08:14:57 -0700 (PDT)
Date:   Thu, 27 Jul 2023 08:14:56 -0700
In-Reply-To: <cover.1690364259.git.haibo1.xu@intel.com>
Mime-Version: 1.0
References: <cover.1690364259.git.haibo1.xu@intel.com>
Message-ID: <ZMKI8RknjjZBOaxf@google.com>
Subject: Re: [PATCH 0/4] RISCV: Add kvm Sstc timer selftest
From:   Sean Christopherson <seanjc@google.com>
To:     Haibo Xu <haibo1.xu@intel.com>
Cc:     xiaobo55x@gmail.com, ajones@ventanamicro.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Vipin Sharma <vipinsh@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Vishal Annapurve <vannapurve@google.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023, Haibo Xu wrote:
> The sstc_timer selftest is used to validate Sstc timer functionality
> in a guest, which sets up periodic timer interrupts and check the
> basic interrupt status upon its receipt.
> 
> This KVM selftest was ported from aarch64 arch_timer and tested
> with Linux v6.5-rc3 on a Qemu riscv64 virt machine.

Would it be possible to extract the ARM bits from arch_timer and make the bulk of
the test common to ARM and RISC-V?  At a glance, there is quite a bit of copy+paste.
