Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20168AED8
	for <lists+kvm@lfdr.de>; Sun,  5 Feb 2023 09:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjBEI3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Feb 2023 03:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBEI3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Feb 2023 03:29:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED92206A5
        for <kvm@vger.kernel.org>; Sun,  5 Feb 2023 00:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675585704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UO1EdFuMkkVyfac3fwD45cLw5uizYsR9A5gP2egekTM=;
        b=ELK/1dvHRdUcLT7boLmwcnJq5iy2q6eqEJSmNBE6HO781Aiv0F3hQr+3oNXYbpm4GcrgMT
        PC+OwL/kDZHFERY7cdbzRpoTuTBXkKOIogvuVLLRIVUfjxbFLUwADw7phcY156TLtoQbx/
        +dGgPsX9rCtDBdxMs1dr8AWnOT6p3ag=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-379-YXkfDEjTNb6ZHKinRdUIpQ-1; Sun, 05 Feb 2023 03:28:23 -0500
X-MC-Unique: YXkfDEjTNb6ZHKinRdUIpQ-1
Received: by mail-ua1-f71.google.com with SMTP id bs42-20020a056130102a00b00662eb7179aeso4016554uab.0
        for <kvm@vger.kernel.org>; Sun, 05 Feb 2023 00:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UO1EdFuMkkVyfac3fwD45cLw5uizYsR9A5gP2egekTM=;
        b=us1D3sZhX9T1MNta6S+M+hr9CwHgs948Or488XoMMlh1DJxY/kKWhuylyAluzd/K2o
         FGt94u2wk7XVb7aWh/UVoqRsIn3f7npQ2OCx207AMiEqIcBNQcyYp1AybGfX7lg5vIiW
         eahyMFp7JL9OfUyMpPes2BYueM1YsXsqO1SSMS4Y4yoAqWJn6y5dO/7Sb3+ECIYZ7hjZ
         pG0GNt26GQiz9FBmF+PX26UoJ9ZR8zdfgO7LDYZNIkP/JqcSd2l9HAXpbTBNuwxE3Sj+
         sTyZjBwxKDLU8hry+wHQK9wssPFM9xZJ5dMe8qF3/KE7us4JzHTBODF1cn7LxEjLN/m9
         48Gg==
X-Gm-Message-State: AO0yUKUJijlOlosPt6VaFGSXchWI3Y8RJ5rU6idYFR3EU0qZTYrb69cR
        gGE1Zhqewxrw85pNY4Yq0FjJnxX5sXluosBDlIgzOkOO4O+C8GGYq+kfsL7jeKzVAYsLhDAUeDl
        gQ5+R+vRIqtVjeELntygNdqapnPQT
X-Received: by 2002:a05:6122:2ba:b0:3dd:f386:1bca with SMTP id 26-20020a05612202ba00b003ddf3861bcamr2447216vkq.33.1675585702928;
        Sun, 05 Feb 2023 00:28:22 -0800 (PST)
X-Google-Smtp-Source: AK7set832lmgFJb3yUv2cp0W6x43Si9vq2XdDLN1vzJ5ohOPqMdf2reOo+DXHos/4J9Y9xTmZ3nf0MRQvstms53rCJA=
X-Received: by 2002:a05:6122:2ba:b0:3dd:f386:1bca with SMTP id
 26-20020a05612202ba00b003ddf3861bcamr2447215vkq.33.1675585702650; Sun, 05 Feb
 2023 00:28:22 -0800 (PST)
MIME-Version: 1.0
References: <20230129190142.2481354-1-maz@kernel.org>
In-Reply-To: <20230129190142.2481354-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sun, 5 Feb 2023 09:28:11 +0100
Message-ID: <CABgObfa=++RCcf=5A2DW5YqEq40VfeGoewZ2LXKk+3gS=x-VpQ@mail.gmail.com>
Subject: Re: [GIT PULL] kvm/arm64 fixes for 6.2, take #3
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks.

Paolo

On Sun, Jan 29, 2023 at 8:02 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's the (hopefully) last batch of fixes for KVM/arm64 on 6.2. The
> really important one addresses yet another non-CPU access to the vgic
> memory, which needs to be suitably identified to avoid generating a
> scary warning. The second half of the series fixes a bunch of
> page-table walk tests after the kernel fix that went in earlier in
> 6.2.
>
> Please pull,
>
>         M.
>
> The following changes since commit ef3691683d7bfd0a2acf48812e4ffe894f10bfa8:
>
>   KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation (2023-01-21 11:02:19 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-3
>
> for you to fetch changes up to 08ddbbdf0b55839ca93a12677a30a1ef24634969:
>
>   KVM: selftests: aarch64: Test read-only PT memory regions (2023-01-29 18:49:08 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.2, take #3
>
> - Yet another fix for non-CPU accesses to the memory backing
>   the VGICv3 subsystem
>
> - A set of fixes for the setlftest checking for the S1PTW
>   behaviour after the fix that went in ealier in the cycle
>
> ----------------------------------------------------------------
> Gavin Shan (3):
>       KVM: arm64: Add helper vgic_write_guest_lock()
>       KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending status
>       KVM: arm64: Allow no running vcpu on saving vgic3 pending table
>
> Ricardo Koller (4):
>       KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
>       KVM: selftests: aarch64: Do not default to dirty PTE pages on all S1PTWs
>       KVM: selftests: aarch64: Fix check of dirty log PT write
>       KVM: selftests: aarch64: Test read-only PT memory regions
>
>  Documentation/virt/kvm/api.rst                     |  10 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |  13 +-
>  arch/arm64/kvm/vgic/vgic-v3.c                      |   4 +-
>  arch/arm64/kvm/vgic/vgic.h                         |  14 ++
>  include/kvm/arm_vgic.h                             |   2 +-
>  .../selftests/kvm/aarch64/page_fault_test.c        | 187 ++++++++++++---------
>  6 files changed, 132 insertions(+), 98 deletions(-)
>

