Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221BF407B1F
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 02:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhILApL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Sep 2021 20:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhILApK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Sep 2021 20:45:10 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098B7C061574
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 17:43:57 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id g14so9990811ljk.5
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 17:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=djPK8cia5m0qX5Zxp7M6GNMnA/J0EGKvTFEvrA/orKo=;
        b=BeZ4wj46QWUIa1PRMxDJJzSxU067c8arLPq359/YAIYM2Pa0vDxJ8SxI9wU5chvg6x
         BdROVYGYeqJj5fLU+2WKja4e3teRqDF//UpkYy1+DfaBSxLpp8qry0a9vpB11tJA8BrZ
         wqMor7qv9Hf7pXq+K01/g7ViYfTGbH32VnwLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=djPK8cia5m0qX5Zxp7M6GNMnA/J0EGKvTFEvrA/orKo=;
        b=SopuFWF83pojjZodrQyikdHVZYa+EQfENXiahY8FyCcbMEr1zitfFyepTBp1ul6FX0
         Tx//8pyeRueEwoab06UlFAlbS0VoJ6wbcPEEZfV67t7qpgS60p3fKenrfGHX1p/E9YnN
         RC8d+qZHxYYGjCt/ob4ADu/sxEmja58f6p2f37js2+Ar/HqOcvdYRhN5SBa1yE2w1d0g
         sPO4+3by7LCDNXNUX4+dWjOWU7iKPmbQujwNwhACiEGDRzT/mMHpqHctXUv3oebpWJer
         6ajX4peV6gWcCr4dc+nJeTkP9smOAvnzc23E5VwCS76gGVf6o4K6j37gPsAJlRQmGlbG
         Y9Yg==
X-Gm-Message-State: AOAM532Z7ePpqsn5DF3615Ec7sAhmXRxpTmlGE4kotIIr6Eq5wYPPbEx
        +F2puriq/L5BdV7VXmSH/amJXZd9SjbpgA223m4=
X-Google-Smtp-Source: ABdhPJzqcu8SYDozLjw3yfHYfL8m6wLzl2aaju/xiWYX0Bg9cUwZxVNbmamTkXVp89oqczc2hggazw==
X-Received: by 2002:a05:651c:150b:: with SMTP id e11mr4130716ljf.289.1631407434812;
        Sat, 11 Sep 2021 17:43:54 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id h20sm354854lfc.174.2021.09.11.17.43.52
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 17:43:52 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id a4so12539902lfg.8
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 17:43:52 -0700 (PDT)
X-Received: by 2002:a05:6512:34c3:: with SMTP id w3mr3705182lfr.173.1631407431833;
 Sat, 11 Sep 2021 17:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210909095608-mutt-send-email-mst@kernel.org>
 <CAHk-=wgcXzshPVvVgGDqa9Y9Sde6RsUvj9jvx0htBqPuaTGX4Q@mail.gmail.com> <20210911200508-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210911200508-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Sep 2021 17:43:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wguv1zB0h99LKH1UpjNvcg7tsckE_udYr3AP=2aEUdtwA@mail.gmail.com>
Message-ID: <CAHk-=wguv1zB0h99LKH1UpjNvcg7tsckE_udYr3AP=2aEUdtwA@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vdpa,vhost: features, fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, Jason Wang <jasowang@redhat.com>,
        lingshan.zhu@intel.com, mgurtovoy@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>, Wolfram Sang <wsa@kernel.org>,
        xianting.tian@linux.alibaba.com, xieyongji@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 11, 2021 at 5:11 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> It's in the tag for_linus_v2 - the point of keeping for_linus
> intact was so anyone can compare these two.

Well, since I had already spent the effort in trying to figure things
out, I had merged the original branch.

I just didn't _like_ having to spend that effort, particularly not the
weekend before I do rc1.

This has not been one of those smooth merge windows that we occasionally have.

             Linus
