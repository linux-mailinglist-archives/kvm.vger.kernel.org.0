Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699E25EAD94
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiIZRGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiIZRFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:05:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E1112D21
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 09:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664208580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iTIkpj/uqiuathtIklraEqz3rfA21BYm4Tj1un/aEU4=;
        b=c5C7qjdZmxf7NTQMdf6gaiV8EQ1vgkIKUio3eyvvGiwikL3qz+6bvSc5o/CnaftIW+YJ8k
        rxqP775x15cvJT65w408XK7Ho5gDHoXN5unztQ8/ouNNxhUOjFfFfHEX4+Ignng0GoudZO
        MSVNwxBn3wYk3Q5zvL/D1xYtpWFmLPs=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618-zKYzoJ0tM5y481T3sL9HrQ-1; Mon, 26 Sep 2022 12:09:37 -0400
X-MC-Unique: zKYzoJ0tM5y481T3sL9HrQ-1
Received: by mail-vk1-f199.google.com with SMTP id v129-20020a1f2f87000000b003a3e340d26bso2457234vkv.7
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 09:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=iTIkpj/uqiuathtIklraEqz3rfA21BYm4Tj1un/aEU4=;
        b=fwtEkuhx3Mp7uVodYlpFOx+St8U8xh/mChpBD+HMIY0dVNSWcgwK6FLWYhMD2fiqC0
         n+xjbtNhJ0jXdqtX0mhktbSsvttZoDG20nSdCRRQifpqJXtR6xszCP866cFU62GnFNxf
         2gIBBffFQHs+LncKUS/B9cyPiadzCb4XTBq/6PV9CQONkqE2mp3LcP2zB1x+i3GHsTMB
         3kvXqh+yfP83G2BQIDyHD3N22jwaZH8eiY7z4GJjT0W1XrQQlUBclex91b9j4ux7XvC2
         woGxR2e/jDdEnnoaJQoeuC/hgPn3U9HLKKGGYVkED0NawChDnYV6t3vR1GcqZD79L6we
         BCew==
X-Gm-Message-State: ACrzQf2jMnUPcktiADCecqwIoUSQ0e2NrnRH9l9yCordxoOOceuUuSk4
        65572Atg30OS/8Jl0AdVpZfE96G2fQEQAd4c933rxo7kb3yFD7ett0hffN4Ha+wrnjKhwfpzn/3
        UfjBwekFcNBlxygkfFTyvBZMh2S1e
X-Received: by 2002:ab0:784a:0:b0:3c6:9d3:bd4d with SMTP id y10-20020ab0784a000000b003c609d3bd4dmr8965806uaq.75.1664208576831;
        Mon, 26 Sep 2022 09:09:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7xN+tgAcQBx4QgQ7cDjRBNP8zB6lEGq1bsXTo0XjqdD+gGY2La3GcFwkH2vc/VUNKegCrzLuOkrz4ICh9TNec=
X-Received: by 2002:ab0:784a:0:b0:3c6:9d3:bd4d with SMTP id
 y10-20020ab0784a000000b003c609d3bd4dmr8965783uaq.75.1664208576614; Mon, 26
 Sep 2022 09:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <YypJ62Q9bHXv07qg@google.com>
In-Reply-To: <YypJ62Q9bHXv07qg@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 26 Sep 2022 18:09:25 +0200
Message-ID: <CABgObfY5VRxSfKX_EoubCdaimDAhvdnZ8NhgZZXRVnQFmboi8Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: First batch of updates for 6.1, i.e. kvm/queue
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 1:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> First batch of x86 updates for 6.1, i.e. for kvm/queue.  I was planning to get
> this out (much) earlier and in a smaller batch, but KVM Forum and the INIT bug
> I initially missed in the nested events series threw a wrench in those plans.
>
> Note, there's one arm64 patch hiding in here to account KVM's stage-2 page
> tables in the kernel's memory stats.

Thanks, I didn't get a respin so I just rebased to remove the problematic
commits.

>   - The aforementioned nested events series (Paolo, Sean)

Applied on top.

>   - APICv/AVIC fixes/cleanups (Sean)
>   - Hyper-V TLB flush enhancements (Vitaly)

These should wait for 6.2.

>   - Small-ish PMU fixes (Like, Sean)
>   - Misc cleanups (Miaohe, et al)

These can be in a separate pull request.

Paolo

