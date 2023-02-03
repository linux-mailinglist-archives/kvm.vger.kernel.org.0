Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F856895DF
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 11:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjBCKWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 05:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjBCKWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 05:22:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7134CDD1;
        Fri,  3 Feb 2023 02:22:05 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id d2so906490pjd.5;
        Fri, 03 Feb 2023 02:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BC26glmyLYvqdRj/s/s6MK4qi5hy8JZOEYo3ZDI0Vnw=;
        b=iGcWrv4W143DbiJRKR8Be2u+UuFLvv+TMD04aaKkE8FyPZW/j/42Togzc26Of4xCHk
         L4O+J9J3KGooZvCPheaHtCVvhd+8yD7F+6cwfgRaYM7XlcjMHxjcBj+d00IuGOnZoxua
         p47HghzIR0V5V9BHB1MOTBO58vuNmWhvqwqTKzCWyKZoGTbMh0eeUZEg1LCG1i8w6yr+
         rGoonbhjlDDP0EM8BSTnSmM8hJ6sGKjQQ8ZQlho2AVRiZ9i9GSJGVG8WpNzZ88bsOJib
         p3nxwmBfaPRdS2D7OrOB+MkhuKe20M4wZIzbxooQQ7YLHch4yOj2EJIoaSWTjBZnOEHA
         LYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BC26glmyLYvqdRj/s/s6MK4qi5hy8JZOEYo3ZDI0Vnw=;
        b=FnvxqurYkNUL0/+YLCtYzS95dpw4J/MuQec3VTV15bq4M94ZFnnG7H/GmAp0+A1ql0
         dBe+8d+BEXJAQ44MbA6bRG2YhgpQ2d3xACrjPjZPxaZJBBvHaTmy+eWVG0k5FRzv7BoJ
         miX705FotrakTp/zf0/u9JAdEfuN25G1o2XlwXjxmFSD/4iRkUVnoWV6u9MtdIo2avch
         HGv/Qeltfez1BOlFh3NEctT9DzfhrvW6N17Cdpi+k/I9g6kPebp1GfIYIhBrBPgpb/Er
         DXCWRGR1pzTlZRtua/NhtmWubJwbe0Iq/KuovBoYzzmUjs5EvBjt5OAsxDw7TDHbYt4L
         rE5w==
X-Gm-Message-State: AO0yUKVwy2RlAI8JPD1AFR+O+H/KQA4HKFE8wq1XCggwxQruJhMmThIn
        BQsg18r+1NAmP2mCJ6L10BY=
X-Google-Smtp-Source: AK7set+WpN/kIwzQ9KpDMGx5dpl4PBMS/21AHFGf650c2cUKaoV8+4j20Irc5p0mFaig/53VJ2J67w==
X-Received: by 2002:a05:6a20:a002:b0:bb:aabe:7a56 with SMTP id p2-20020a056a20a00200b000bbaabe7a56mr12482709pzj.58.1675419724901;
        Fri, 03 Feb 2023 02:22:04 -0800 (PST)
Received: from localhost (193-116-117-77.tpgi.com.au. [193.116.117.77])
        by smtp.gmail.com with ESMTPSA id l6-20020a639846000000b004768b74f208sm1233813pgo.4.2023.02.03.02.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:22:04 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 03 Feb 2023 20:21:55 +1000
Message-Id: <CQ8UPZX0BERP.2TFM4914IGJZF@bobo>
Cc:     "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        "Marc Zyngier" <maz@kernel.org>,
        "David Hildenbrand" <david@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        "Oliver Upton" <oliver.upton@linux.dev>,
        "Zenghui Yu" <yuzenghui@huawei.com>,
        "James Morse" <james.morse@arm.com>,
        <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 4/7] KVM: PPC: Standardize on "int" return types in the
 powerpc KVM code
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>
X-Mailer: aerc 0.13.0
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-5-thuth@redhat.com>
In-Reply-To: <20230203094230.266952-5-thuth@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri Feb 3, 2023 at 7:42 PM AEST, Thomas Huth wrote:
> Most functions that are related to kvm_arch_vm_ioctl() already use
> "int" as return type to pass error values back to the caller. Some
> outlier functions use "long" instead for no good reason (they do not
> really require long values here). Let's standardize on "int" here to
> avoid casting the values back and forth between the two types.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Thanks for the patch. It looks fine to me, it should be okay to
go via Paolo's tree if he's going to take the series.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/include/asm/kvm_ppc.h  | 14 +++++++-------
>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 14 +++++++-------
>  arch/powerpc/kvm/book3s_64_vio.c    |  4 ++--
>  arch/powerpc/kvm/book3s_hv.c        |  6 +++---
>  arch/powerpc/kvm/book3s_pr.c        |  4 ++--
>  5 files changed, 21 insertions(+), 21 deletions(-)
