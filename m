Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B7C52FA1E
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbiEUIyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 04:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiEUIyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 04:54:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6042D5C659
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 01:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653123273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uMXb1QJ8p+egwSXVcnqkwfUvACuYgu7JP1Fnnb6+/lg=;
        b=iy8aVal33d4MLttEVic3n4rD6K+4QCU8f/u5lu+z+GBWIySEgh39X45whn2kIETNJFJSlj
        dD/LY/vgc6N8P8uP5dWFMVoANrzby5svZXj7FmkS0730KpZp9XnKv44jmgFSVFCvra9g1Y
        HFH9YUmjZgkFcZbugD4VuRQPoFNvgn4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-ZfQNxSlvPOmmJIDN-7Kl7A-1; Sat, 21 May 2022 04:54:31 -0400
X-MC-Unique: ZfQNxSlvPOmmJIDN-7Kl7A-1
Received: by mail-pl1-f198.google.com with SMTP id h10-20020a170902748a00b00161b9277a4aso5199705pll.2
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 01:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMXb1QJ8p+egwSXVcnqkwfUvACuYgu7JP1Fnnb6+/lg=;
        b=qVauy9mT7bWFll+tUjSsW0MKTWuAM/CvaZnnid+BhsNs9wPtXL/FKG/YSpnhMdygoL
         y6iz1JjSspkTfsfp5kgChykcUTShnpKX8CWxpDCK/nX8PF0HM45SLoJ1848FRSnhnO95
         sKAN/2sdPivpQGjK/gFDt2aZQCAWcUoo8K7BFa2+FzAGw8QcLvH0haitV2R2ZdoQ3wsX
         jusda02e0jThmMyW06LPlxtKBhm6cLHgSxXfHyKbkSW0oS/YAsdvLzE7G9TsnlLNLRyx
         ck17Jl4mRgz/KANv5hLUiTmQKlY86zlXfueJgPtQK9zjP+TKQu3sdvURH4PKRd/wusTj
         8wYA==
X-Gm-Message-State: AOAM532KjuvjOXA3AazPzQed5/FBcvhkpKcAHBBxwK6fgPm65CbW90Vb
        YnA725OuU99qOcVObLPeKHjLFH5MHLCnWI/DH0PIGIzSkWsUwFzg5slNr1sMuEtEWOZO5bXzkfU
        +ltM2Awf6fHOT1t45/8arNBK8z8SC
X-Received: by 2002:a65:60d3:0:b0:39c:f431:5859 with SMTP id r19-20020a6560d3000000b0039cf4315859mr11867856pgv.442.1653123270256;
        Sat, 21 May 2022 01:54:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjA/AY+yBQZ3IkzyAJpkZ/LIpp/XClXuv5SLddVQ0bSaa0iUKCDxgP6Y2iEEnyuNPzX1kC2Owyf7Cv1zoIaPo=
X-Received: by 2002:a65:60d3:0:b0:39c:f431:5859 with SMTP id
 r19-20020a6560d3000000b0039cf4315859mr11867841pgv.442.1653123269947; Sat, 21
 May 2022 01:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <be14c1e895a2f452047451f050d269217dcee6d9.1653071510.git.maciej.szmigiero@oracle.com>
In-Reply-To: <be14c1e895a2f452047451f050d269217dcee6d9.1653071510.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 21 May 2022 10:54:18 +0200
Message-ID: <CABgObfZfV66MN11=xEjwH0PE944-OTcAZkSpWEcJeK=1EYWJnw@mail.gmail.com>
Subject: Re: [PATCH] target/i386/kvm: Fix disabling MPX on "-cpu host" with
 MPX-capable host
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 8:33 PM Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
>
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>
> Since KVM commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled")
> it is not possible to disable MPX on a "-cpu host" just by adding "-mpx"
> there if the host CPU does indeed support MPX.
> QEMU will fail to set MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS MSRs in this case
> and so trigger an assertion failure.
>
> Instead, besides "-mpx" one has to explicitly add also
> "-vmx-exit-clear-bndcfgs" and "-vmx-entry-load-bndcfgs" to QEMU command
> line to make it work, which is a bit convoluted.
>
> Sanitize MPX-related bits in MSR_IA32_VMX_TRUE_{EXIT,ENTRY}_CTLS after
> setting the vCPU CPUID instead so such workarounds are no longer necessary.

Can you use feature_dependencies instead? See for example

    {
        .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_RDSEED },
        .to = { FEAT_VMX_SECONDARY_CTLS,    VMX_SECONDARY_EXEC_RDSEED_EXITING },
    },

Paolo

