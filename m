Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837C850A753
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 19:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390787AbiDURrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 13:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380150AbiDURrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 13:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1276C1A2
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650563091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/qrcto3C5vh3ouIKAO3cip7P94YKBPTPSMO9FpDxaVY=;
        b=OdAuhsEwJ/zNhyVGARmpQBHBGr8zTRX8V9LZRkQu+3jQw3olGXbw1UFOcdTI8u2mn7qesF
        MLa1wvy3n8Bor/13gpKAEloR5NPY6vfSoXpNb9iaUVBOxSo3A4RSvbuWR8m7Zo9IfQ7gRN
        v2e1H3+p3is/66JCJoTZkZ3hF2ZoCUg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-vOT40KhyNjGmpvbkzZcsjA-1; Thu, 21 Apr 2022 13:44:50 -0400
X-MC-Unique: vOT40KhyNjGmpvbkzZcsjA-1
Received: by mail-il1-f200.google.com with SMTP id j5-20020a056e020ee500b002cbc90840ecso3017180ilk.23
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/qrcto3C5vh3ouIKAO3cip7P94YKBPTPSMO9FpDxaVY=;
        b=rtgMfX8sWAYwuuPWe6kgv8d8HGizMsAFY4wbSiFFypF24JuGQpwt43dPEvnx655GNy
         cfDGDg4HdVu2VelI5qsUoWFFcPM8vIei1UjyoKXwAvj+AFtw40Dfybn9VzHMbLtuQb96
         mT3j/Kx8syvkn54oXAT67xT7zp7bM5aK/f2CsBJzZpkruNadV4L+TWfUPhhYo18Yq1hW
         F0lFygDu3v7G4kQccEL3mo1QdU+j2TLvAH2npxbPQli9CEPt0L0UlnqTmsZtadAowhMJ
         JHTbzJ8mDB7w+mBMuZSMQ0NZO2VVk+93oUjShPRG+9bOHr4nKMv5UbZJrAgafSmnXtyI
         3bmw==
X-Gm-Message-State: AOAM530MVF4QuadafW4Cc9c+55vl9uNLbEmZ9xqcJLl1uERcItO8kivE
        gs+LLAn3RB7ttPH3aUpVrGOcM4ny5TtdM0scDyLuwpezsvh7cpyqYrb+V3HMbsdN5sF3w0uF/Jo
        Ms95Di3DhNbdt
X-Received: by 2002:a05:6602:1211:b0:654:94db:fa48 with SMTP id y17-20020a056602121100b0065494dbfa48mr429045iot.48.1650563089203;
        Thu, 21 Apr 2022 10:44:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl1YQOEVY+1qSNaDbIxcdVgs0qKa/G47nRJAskX+bzbU7JPpMpW0BqMh/3zik9rjEYsNK6RA==
X-Received: by 2002:a05:6602:1211:b0:654:94db:fa48 with SMTP id y17-20020a056602121100b0065494dbfa48mr429042iot.48.1650563088978;
        Thu, 21 Apr 2022 10:44:48 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id w5-20020a05660205c500b006546d0b5f6dsm9867748iox.41.2022.04.21.10.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 10:44:48 -0700 (PDT)
Date:   Thu, 21 Apr 2022 13:44:47 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v6 01/10] KVM: selftests: Remove dynamic memory
 allocation for stats header
Message-ID: <YmGYD20mn9hNfAEF@xz-m1.local>
References: <20220420173513.1217360-1-bgardon@google.com>
 <20220420173513.1217360-2-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220420173513.1217360-2-bgardon@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 10:35:04AM -0700, Ben Gardon wrote:
> There's no need to allocate dynamic memory for the stats header since
> its size is known at compile time.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

