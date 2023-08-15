Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DB077D601
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 00:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbjHOWaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 18:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbjHOWau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 18:30:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C461FF0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:30:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57320c10635so79450517b3.3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692138649; x=1692743449;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNKxKU9a0k5QwlnHGJaZtqPp9x+MfH7uASd6ddnnEGk=;
        b=N1mh0iZlQU8pl32cDnHblEsftvP+4ptCDqmlHtK9LvQ8rp8vvY5xnNHansnMhCNlf4
         2wft/kVP+IOiuuGI7F76Dxp/VGngrE9p/gcHjSZuJhgCIlyLaQIMxtsoAeBO2HYg2muU
         QTg1bBY2JiuD+HBSAr8OeSuQmC2c2vIHrTZx4r0vBPvyvC711MPVCDG381fy/47Q69LF
         bpsdHZR0fotPIe6D7l2BU6/h4ntZ++swGu8PVbrqzP8YQMYl9lJ9l+3RZSo/GqSWGI2r
         g//wP+QbgTiNuhh+PZn4/YKmCFoJM0+p/xgaZOIW6JPH4jqBZ+tkpSYF/yvRoMaU1+B7
         hYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692138649; x=1692743449;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gNKxKU9a0k5QwlnHGJaZtqPp9x+MfH7uASd6ddnnEGk=;
        b=BOGJ3aXszntxI40a01wkYngHK4tu0teqE2ePTSkqmDHp02U2GJlbkXNH7HPOtzPMZx
         3suS+h5gMAXJmJUZLauyBfqZmhAJo5BQska2u/MRO9Bqvlj3dGunNpkq6ZJsc5iScClM
         yxas5Zf7rLhqOtptLreJspTHyWWXoruNRdJ35sLkdjqAszt8cjccpL0Qb42hw7vbjL5X
         6GJrDr9RyvaP6Czbldua9RWlt9k7j6KAcX9YKrPpEwzHK82VWV5bmQ7ajrF5qf7gq10b
         2AInS2B3rtR2fR123OAbxhm2yaUuq2XZ1wx3lwDbcysOFpwLtyQttspQOJDiH1A9wCXm
         j0cw==
X-Gm-Message-State: AOJu0YxKSf+CUcGszZ+lzUh5q483vmlD1maHS0ehd0SrildZ/PymkT5I
        72GgExhufwL/f3UTNco+rqNpJ/kNCm0=
X-Google-Smtp-Source: AGHT+IHjqo/FB8qF6/mUmxkmvTmKIc5leYLXNSH3BL88+7yOIuIDWfQQa40QRwmSX5edxm8UNLTBq+krgbo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b60a:0:b0:586:a689:eb69 with SMTP id
 u10-20020a81b60a000000b00586a689eb69mr194454ywh.2.1692138648813; Tue, 15 Aug
 2023 15:30:48 -0700 (PDT)
Date:   Tue, 15 Aug 2023 15:30:47 -0700
In-Reply-To: <20230811045127.3308641-2-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <20230811045127.3308641-2-rananta@google.com>
Message-ID: <ZNv8l3mmC/vtqf3j@google.com>
Subject: Re: [PATCH v9 01/14] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
>=20
> Rename kvm_arch_flush_remote_tlb() and the associated macro
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.
>=20
> Making the name plural matches kvm_flush_remote_tlbs() and makes it more
> clear that this function can affect more than one remote TLB.
>=20
> No functional change intended.
>=20
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>
