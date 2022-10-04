Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6B25F4439
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiJDN1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJDN1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:27:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A33543E6
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 06:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664889976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1a5fI7ggkfQfFR1kPFxspjmxx+2AyvDZdYuODjfSZ6k=;
        b=gNN0pSgsFSJTJUS6afguIL1NrdDUvhvBUYfoF4msb0QXAHRJlhclVVAIVLqE6xgZ4sxMCm
        Kcuz55FBj7vCEIWpr7i6USNtdri4LZ6WXgUbWqsC+1Fyqf9EJOS9YSxdJ6vCQ1wMjP1aaF
        NTXogz23VHTloAKfv2mIR+qs9H+y5dE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-353-8Pvn9R8CPYuHAcJ6WmJFCw-1; Tue, 04 Oct 2022 09:26:15 -0400
X-MC-Unique: 8Pvn9R8CPYuHAcJ6WmJFCw-1
Received: by mail-qk1-f200.google.com with SMTP id f12-20020a05620a408c00b006ced53b80e5so11655087qko.17
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 06:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1a5fI7ggkfQfFR1kPFxspjmxx+2AyvDZdYuODjfSZ6k=;
        b=WIv+rqjCEX9nJCOa8Y5xhRBJNs2drD5kPSnUZu6hRO6E8+/ec72+l9lam+RIcbpHT1
         bO8h/yu/b4qgOrMA6Cmbfx08kcgPrxbPDXeljlIqah6yiln4o051S346fE3+YHsmqFKr
         yrtZfWhFnIlgctXR1tw3FV++eeXAHy2+bOfAn8/hubXCpV/B5XU2HO3f2oy+rCj+g0aO
         aqeJ9xt5FUto7X+FQwZCS+Iog4ZdBC2GnIlvXk5sUiFbOMMzuepOgf/6DgZCTjtrJ2S4
         bspLMp7pmxvqUyuJjjk2GRz9hOoCL2P/GdORqan13VGFEuwLnhWyYG0XU7FR02VlldtC
         rIXw==
X-Gm-Message-State: ACrzQf2i3WIcPkC0sEKHZjvZat5WKxp4RTJ7/h/IoUe1fEb6oJeRE0B8
        SVUPjX5dVwmYmoA4vKEs9L7xYYAQYtUao5WDGzYFliT2P6PN17ms0E87XL0TjWRfC9uvp1d1yKV
        lVmXDFwgT+qJC
X-Received: by 2002:a05:622a:390:b0:35d:44ab:c615 with SMTP id j16-20020a05622a039000b0035d44abc615mr19888374qtx.594.1664889974655;
        Tue, 04 Oct 2022 06:26:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6M0PX+ipcJM7x33PxLdL7QLzw6bN4v+B38ziDmyGUyWyjBElmxYO5+ApuqF1XR0sZTmHhR3A==
X-Received: by 2002:a05:622a:390:b0:35d:44ab:c615 with SMTP id j16-20020a05622a039000b0035d44abc615mr19888354qtx.594.1664889974443;
        Tue, 04 Oct 2022 06:26:14 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id i10-20020ac8764a000000b0031f41ea94easm12512816qtr.28.2022.10.04.06.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 06:26:13 -0700 (PDT)
Date:   Tue, 4 Oct 2022 09:26:11 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <Yzw0c5tD28W8L7wP@x1n>
References: <20220927005439.21130-4-gshan@redhat.com>
 <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org>
 <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org>
 <YzRfkBWepX2CD88h@x1n>
 <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
 <86fsga6y40.wl-maz@kernel.org>
 <8b82ef3d-16ab-0aee-b464-8ad9b3718028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8b82ef3d-16ab-0aee-b464-8ad9b3718028@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022 at 12:26:23PM +0800, Gavin Shan wrote:
> Note: for post-copy and snapshot, I assume we need to save the dirty bitmap
>       in the last synchronization, right after the VM is stopped.

Agreed on postcopy.  Note that snapshot doesn't use kvm dirty logging
because it requires synchronous events (userfaultfd), so that's not
affected by this work.  Thanks,

-- 
Peter Xu

