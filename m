Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D3C7C5A93
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbjJKRz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjJKRz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:55:27 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195CC8F
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:55:22 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-3af5b5d7f16so28603b6e.0
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697046921; x=1697651721; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+qr3lgrcrbP/5gkIgkGNw3UMoeYR1RXB4GZuAt+u7kM=;
        b=E1y6i2RxlBIrH/wc5JKLr4tjnS07pk7hke+GIXqJZ9Wi7oxTFDqZ5GIAjpendrXkQ1
         rC27OLEwwjRviagpYxRzbsqSccsceHUkHRaVgieOJzJG1EPgtUQh7mblqqQsJm7T0DJ6
         ACNQ/vtERU79ARCXRzXRGYwwypcIXh9kgquNd63N8pzxcgEbfCbnjPvJuauH1wSm90y0
         yL+TOtrV4uNhTiF0pqdmFh5L3OOzeQ/DBR6XJIBYX+fZyyXautmXpRUnkXImo8vmKqhX
         8Fwg5wCjkDRKZian3tr1XZ+yGr/s08W83/F+SNPnzrq0uQVlndpE90jX5MnTEbKVE4na
         3/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697046921; x=1697651721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qr3lgrcrbP/5gkIgkGNw3UMoeYR1RXB4GZuAt+u7kM=;
        b=CeXqsJ8odKSlb8L6Vz+5OzdFdRsdAK3fA9RwlNQv2fYges87WvNQ72N2f5JpOEn4c5
         gK4H/0nG+u7lZAo3V/BvBQoNOy53mr5VIDMcr+gVewzg+t7N91XDh1iqDmI9wQDA2G9b
         1yjNKXVbDeuJgTEu+tqF3jVZlsdLLd+YzHWtZdM+RVmYJzA4izM7Ru9uHEklXZzwP4Kq
         /QXsJQ3N+MSqmV/JeUEQvkm0pz1a6ZxjLnxLe0nxzp9/aW1yxo5xG2nupio29sc5lM5Z
         fHuSk/uO1ftjtnqgJ8mnENuv2arlBgN3Nk7wbdRv/GSXBOY4uaE5dC98vGozNnz/1rKN
         TERA==
X-Gm-Message-State: AOJu0YxecsvLVMmTFzJMDrLqhf9kx8ur7T/ga8rzQyI0QIt2CHPccKZt
        MZmKfvv7Lv0XCxsDnMgnf/QsznSLKFuhmy53gKjeug==
X-Google-Smtp-Source: AGHT+IH1xR3vjV99+M/LkuCERrf8FFb6dhrZO5dQtTRdGG7+xvAKomWG5ggluYGHUD3vZWhYu7IBXcl8FWzcBM1cD+k=
X-Received: by 2002:a05:6808:2897:b0:3af:d1d6:8a59 with SMTP id
 eu23-20020a056808289700b003afd1d68a59mr14716017oib.38.1697046921341; Wed, 11
 Oct 2023 10:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-10-amoorthy@google.com>
 <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com>
In-Reply-To: <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 11 Oct 2023 10:54:45 -0700
Message-ID: <CAF7b7mrt-iWduEQusKHhP3TLiWwL1gQjGj0HB=u1R2Vd5yEP0A@mail.gmail.com>
Subject: Re: [PATCH v5 09/17] KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING
 without implementation
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Bike Shedding! Maybe KVM_MEM_EXIT_ON_MISSING? "Exiting" has concrete
> meaning in the KVM UAPI whereas "userfault" doesn't and could suggest
> going through userfaultfd, which is the opposite of what this
> capability is doing.

You know, in the three or four names this thing has had, I'm not sure
if "exit" has ever appeared :D

It is accurate, which is a definite plus. But since the exit in
question is special due to accompanying EFAULT, I think we've been
trying to reflect that in the nomenclature ("memory faults" or
"userfault")- maybe that's not worth doing though.

Wrt the current name, I agree w/ you on the potential for userfaultfd
confusion but I sort of see Sean's argument as well [1]. I see you've
re-raised the question of the exit accompanying EFAULT in [2] though,
so we should probably resolve that first.

[1] https://lore.kernel.org/kvm/20230602161921.208564-1-amoorthy@google.com/T/#t
[2] https://lore.kernel.org/kvm/CALzav=csPcd3f5CYc=6Fa4JnsYP8UTVeSex0-7LvUBnTDpHxLQ@mail.gmail.com/
