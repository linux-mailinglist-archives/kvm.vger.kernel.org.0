Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33595E6E8A
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 23:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiIVVjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 17:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiIVVjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 17:39:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF26112654
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663882751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oggKyBrtLm+rbie47pghj85Ta1UvbEqK5VovLbBRoGo=;
        b=EFve9zOb3Y+B3eeOuv3BGvpHPi82afI8nOTKL2CRosWdhAHfmbBi2h45/fPmjbAMZuojbH
        r3raFinAY4Qccm9BXiaO7HL7LZzf21SweNAVy/Lkp2wgPVXUjYLUt49abVDEaggdxTlEop
        V9AxCsIiTSvZP4ODaEygvso2U0QOSxQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-SEFTy81OP-uXl4XWKYSpJQ-1; Thu, 22 Sep 2022 17:39:10 -0400
X-MC-Unique: SEFTy81OP-uXl4XWKYSpJQ-1
Received: by mail-qv1-f72.google.com with SMTP id dw19-20020a0562140a1300b004a8eee124b4so7391491qvb.21
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=oggKyBrtLm+rbie47pghj85Ta1UvbEqK5VovLbBRoGo=;
        b=6NQX7qWgZhI2pMhpej4Fuwp+DejIU687nFpbFYPoS77vUPOmMMLJUnmDQEmOTMAoCX
         s9f1XS0atGEFddpf1S1yisV1eBogLx2sQuwQtI14/K2k87ceyeHTUTZNqEcQDCyHkAGB
         5qPinFvii4YOI9pAUqm9FHgqu/ouA25V+uR5hw+/Sfow2sEEMMn1iMfvsyjwk+R6ipFI
         0iiMtFllMvSN8dfbErtlOA6+Wa7bCaAX06CFGqWVQJwI6tttPhrlL53SaUuRH2WVR9k2
         GVvfatb23Oely6ucuwSqCys852NTXdZHqeVwRJCEOxINEksPo9A05QYfyVdbB+fH1s+s
         6neg==
X-Gm-Message-State: ACrzQf2F9tJjrBZocjQGz02g9TRVVK7JJhUvVONdfXHPIk+qf2GTz9en
        n5ggdeYQOJwoOSxGRV+soX/znAqIIzYgFEdBHTgG8ealy+OthoHM/+wWewImgYot1W5cnNmqWAG
        DvocAktzoPL91XGw8R+x/lvfIZZT1
X-Received: by 2002:a05:620a:3725:b0:6ce:e7b3:d8e4 with SMTP id de37-20020a05620a372500b006cee7b3d8e4mr3683707qkb.144.1663882750096;
        Thu, 22 Sep 2022 14:39:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5odouBoqKR/EFtNQzxBQaOSq4hKEp3fsEc1XCoKzSGpvsyUKt27I1oSmXbqRykom5IjyysB3VvrBo9iRJBy2s=
X-Received: by 2002:a05:620a:3725:b0:6ce:e7b3:d8e4 with SMTP id
 de37-20020a05620a372500b006cee7b3d8e4mr3683680qkb.144.1663882749867; Thu, 22
 Sep 2022 14:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220922170133.2617189-1-maz@kernel.org> <20220922170133.2617189-6-maz@kernel.org>
In-Reply-To: <20220922170133.2617189-6-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 22 Sep 2022 23:38:58 +0200
Message-ID: <CABgObfbtVAM3t2WC6-8-fLdQZTs6B5Xf2-CZ4oWdJMzXNFWy_g@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: selftests: dirty-log: Upgrade
 dirty_gfn_set_collected() to store-release
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        peterx@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
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

On Thu, Sep 22, 2022 at 7:02 PM Marc Zyngier <maz@kernel.org> wrote:
> To make sure that all the writes to the log marking the entries
> as being in need of reset are observed in order, use a
> smp_store_release() when updating the log entry flags.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

You also need a load-acquire on the load of gfn->flags in
dirty_gfn_is_dirtied. Otherwise reading cur->slot or cur->offset might
see a stale value.

Paolo

> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 9c883c94d478..3d29f4bf4f9c 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -17,6 +17,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/atomic.h>
> +#include <asm/barrier.h>
>
>  #include "kvm_util.h"
>  #include "test_util.h"
> @@ -284,7 +285,7 @@ static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
>
>  static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
>  {
> -       gfn->flags = KVM_DIRTY_GFN_F_RESET;
> +       smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
>  }
>
>  static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
> --
> 2.34.1
>

