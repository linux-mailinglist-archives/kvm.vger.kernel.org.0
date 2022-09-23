Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4665E7CCB
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 16:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiIWOWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 10:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiIWOWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 10:22:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A90814355B
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 07:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663942953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xJ7NvBNqMyAjonIBYUaUOjGEw+4M/heegLtpVu08Dzc=;
        b=NbqgqTIp3LmZT3Mpiu6v5zqj4wmzEj5j3XrX+oa8x1CKCqfV1RCzxZRLHQzD3PIkdrzuAi
        uuliMBnszLbMsfHCEFp7n2s8Ox+LkBs7qtvYpE2b5mXPQI4dBglSrsMKFzzD6W+meypSJv
        1QG/Si3EPCeeeHebD9eLoXfBmezyNTw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-554-y35HsmJnO2uInPSW2SjEZg-1; Fri, 23 Sep 2022 10:22:32 -0400
X-MC-Unique: y35HsmJnO2uInPSW2SjEZg-1
Received: by mail-qk1-f200.google.com with SMTP id bj42-20020a05620a192a00b006cf663bca6aso145029qkb.3
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 07:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=xJ7NvBNqMyAjonIBYUaUOjGEw+4M/heegLtpVu08Dzc=;
        b=KC8SD5LGsbKo6PgG8FY6hpj5QlJlbaJDrcJNZS8cRdXeeFPPjtVoikD2s+NYoN5aHS
         IYmsKarOqEwTJnhcpeP2aW6425/Pv37aS5KH1jWmceDJn3Xkz7MkYGJz2cAdLda34GEM
         V5F+JUG7fN1bqPoUvmTE7KFlFOVDtItlVY9mNDESp0I0tkT5kFineEk5YExQu8ly4kBr
         e4VzzKPKUzDfQ2BrNBW1FLYkQSpz2X+XqhPWtjpGu596fnwyxEJUdt7rbZDrtWUlEISp
         OvlJ+x2xoGSvwTxmaXkLo40svMgAS6AMN+vovW3XasZ1PIE2arAlIfR+U3s+dAt9KiTI
         VKbg==
X-Gm-Message-State: ACrzQf1izf5OsTSpU4XTNFjayvbbgfhxDnCcxCABG+wdYl0syp8EO7hR
        PrBRlvg54/quJd/e18u6hqcm0hZnhcjd48DGDp9b8TcNVtDMdE5JDJoVPcQ3lEcvA7fr5ojkdEQ
        RHnvIgErcAyi/HHM2RFiylP236xeE
X-Received: by 2002:a05:622a:138c:b0:35c:e9d2:8d76 with SMTP id o12-20020a05622a138c00b0035ce9d28d76mr7419965qtk.463.1663942952210;
        Fri, 23 Sep 2022 07:22:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5U63XjjsWCKo/SDdgvyLMGUUVGC9LLE0uEX7Hqm+64kfM+1tiDckgPMyWf276UjUFrP0+Pcg+GxDuU1uEhlYw=
X-Received: by 2002:a05:622a:138c:b0:35c:e9d2:8d76 with SMTP id
 o12-20020a05622a138c00b0035ce9d28d76mr7419940qtk.463.1663942951968; Fri, 23
 Sep 2022 07:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220922170133.2617189-1-maz@kernel.org> <20220922170133.2617189-2-maz@kernel.org>
 <YyzV2Q/PZHPFMD6y@xz-m1.local> <87edw2jhpv.wl-maz@kernel.org>
In-Reply-To: <87edw2jhpv.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 23 Sep 2022 16:22:20 +0200
Message-ID: <CABgObfbRb_rPNqL+=yPVWc7e8a7uumATR6cEEdvYrkEKUS1_2A@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: Use acquire/release semantics when accessing
 dirty ring GFN state
To:     Marc Zyngier <maz@kernel.org>
Cc:     Peter Xu <peterx@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        gshan@redhat.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 4:20 PM Marc Zyngier <maz@kernel.org> wrote:
> > > This is only a partial fix as the userspace side also need upgrading.
> >
> > Paolo has one fix 4802bf910e ("KVM: dirty ring: add missing memory
> > barrier", 2022-09-01) which has already landed.
>
> What is this commit? It doesn't exist in the kernel as far as I can see.

That's the load_acquire in QEMU, and the store_release part is in 7.2
as well (commit 52281c6d11, "KVM: use store-release to mark dirty
pages as harvested", 2022-09-18).

So all that QEMU is missing is the new capability.

Paolo

