Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9139C76B997
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjHAQXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjHAQXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:23:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB5ABC
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:23:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583312344e7so72796447b3.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 09:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690907013; x=1691511813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NgZSQqVHoMoE0f+lS5e3QWSUOJFOEE52tAnc49VIYRg=;
        b=1d0AeLxpW6AaqQYKp6bsfKUSfvqCTazQibc601NnJqqQxWwpSfkc0bkzGIAScujRWR
         5GYNHlVns/SMJIfjbI4qCaIBNuwRx9qiQFS/4LI8uhcC4qRKqxjw3M7ZT3BheRJxo4sG
         UKhhpv6QGYKf8tMSiksOV42hayAmOUAKI6BOs+c50Xnddf1KIoVcx4KUjtB3cSLX/2D6
         HUGlQuNsjvTD6GLe9pchnYC5DO71KiLwfGbA4O10lnmzbxTKXdhKaLcMnkdFWr2kveON
         8nqH05tVlHXqtwLmipIIinCuYxrEQ5MFIyQ5bYFqPl8zgF9UY13ULRvTqpawV7ZB+Fpv
         9ZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690907013; x=1691511813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NgZSQqVHoMoE0f+lS5e3QWSUOJFOEE52tAnc49VIYRg=;
        b=I2Cwgz77fMyJ//QBGUBaoxyRocSoAGFBijMV1qx/Es5+S7XR3U+mf/k25d8R8xLAbh
         dlzKnDQ6nVQZ8oZOtHLQvA+6whUCKcwhwtw+2oAtbINBxIUudFyUfCanaP48u6v/Ib9b
         T169bVXeuUpAAs41H0mK7UsHlqZtfrqRqwgbGGHS6bpd0An6hClH3ESDLXP+EJwGOei9
         58x11tGaJoGWXw5QjQDTVU3X9ebZ2UwJP9KE6bgweSgr54GHLq2UBD3vgNd2dSsRzuwf
         BFqyrD1pnm3F0RKl56GMBXRW2vaiprVhh8QaFTQjJNdO+6QiegTY+SEPHoYH0KckuvR4
         UdnQ==
X-Gm-Message-State: ABy/qLZM1LEL9PBD4umASm6/ao7+bCE7ZbYm7GBrcP8mrkmQfzL9RKoC
        Z7oR6EEWlTBGTmXZWMU0oI0dGEGBg6Q=
X-Google-Smtp-Source: APBJJlHFG1aWzseIj2/abAfwCu1Bgk1T523XeBUXRqAUKi+lEhA3pqwo6TwG4Ih2Lc8QYauvbY3mcrh0aww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4144:0:b0:586:4dec:80b6 with SMTP id
 f4-20020a814144000000b005864dec80b6mr50325ywk.1.1690907013406; Tue, 01 Aug
 2023 09:23:33 -0700 (PDT)
Date:   Tue, 1 Aug 2023 09:23:31 -0700
In-Reply-To: <ZMhQGi6MuHfyvNS9@x1n>
Mime-Version: 1.0
References: <20230731162201.271114-1-xiaoyao.li@intel.com> <20230731162201.271114-5-xiaoyao.li@intel.com>
 <ZMgma0cRi/lkTKSz@x1n> <ZMgo3mGKtoQ7QsB+@google.com> <20230731173607-mutt-send-email-mst@kernel.org>
 <ZMhQGi6MuHfyvNS9@x1n>
Message-ID: <ZMkxg0+vmehOmSL5@google.com>
Subject: Re: [RFC PATCH 04/19] memory: Introduce memory_region_can_be_private()
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?=" <berrange@redhat.com>,
        "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023, Peter Xu wrote:
> On Mon, Jul 31, 2023 at 05:36:37PM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jul 31, 2023 at 02:34:22PM -0700, Sean Christopherson wrote:
> > > On Mon, Jul 31, 2023, Peter Xu wrote:
> > > > On Mon, Jul 31, 2023 at 12:21:46PM -0400, Xiaoyao Li wrote:
> > > > > +bool memory_region_can_be_private(MemoryRegion *mr)
> > > > > +{
> > > > > +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
> > > > > +}
> > > > 
> > > > This is not really MAP_PRIVATE, am I right?  If so, is there still chance
> > > > we rename it (it seems to be also in the kernel proposal all across..)?
> > > 
> > > Yes and yes.
> > > 
> > > > I worry it can be very confusing in the future against MAP_PRIVATE /
> > > > MAP_SHARED otherwise.
> > > 
> > > Heh, it's already quite confusing at times.  I'm definitely open to naming that
> > > doesn't collide with MAP_{PRIVATE,SHARED}, especially if someone can come with a
> > > naming scheme that includes a succinct way to describe memory that is shared
> > > between two or more VMs, but is accessible to _only_ those VMs.
> > 
> > Standard solution is a technology specific prefix.
> > protect_shared, encrypt_shared etc.
> 
> Agreed, a prefix could definitely help (if nothing better comes at last..).
> If e.g. "encrypted" too long to be applied everywhere in var names and
> functions, maybe it can also be "enc_{private|shared}".

FWIW, I would stay away from "encrypted", there is no requirement that the memory
actually be encrypted.
