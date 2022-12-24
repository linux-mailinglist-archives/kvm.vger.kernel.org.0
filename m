Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C40D655897
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 07:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiLXGKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 01:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiLXGKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 01:10:51 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3CBFE2
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 22:10:49 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id w10so1294342qvn.11
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 22:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3E3YAkwQ1FMGK0G4c+k3cWhSC99qn+AW2e60BpLd48M=;
        b=h0YtYQKEi5AnsXB7utpqFRidFunGHv4v+XFF72sE8OGP438jrHeRtPo/jQdOSZ1pLE
         oegIRWAaL4+RlmtvXf3fWwBdtxMDrz9wbhjYKbUArB5tP0fzi7/cIsac8j32oj4Hz6Xj
         3+DSLdyaQWX2k4WvvXwK/zYvkz1jN+G7ah7Zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3E3YAkwQ1FMGK0G4c+k3cWhSC99qn+AW2e60BpLd48M=;
        b=2nZkUZSJ9ymFpKeChswEVX5s1+mvQf8QrrrS3zzxf+6P4LF/FnvlShmPARbmF+zfFg
         oz63sU2ssC7yUxW2b3DXbyn9VldfO3s8EvXFlERr5KmMEIMYbLAHPjqEPTYxSAoob9sR
         T7PgSybqYgOE05Or4BQXUUFogg91o3m+wH61xwaNL9yOXJnIopUO3WmihCpx8nIib3Bn
         BI//USPpjYmT5Lpn6Wn6PafxLkGTFE140FaJitaYhvKS6va2Z/jyhl8r7RA2lCgSYvTR
         qqCxs7i4ISxts25LrixHMLsmA2vS+ckuyZALFJZfX5QlVM44+qxnDoDG9S4JIaoL2Hxg
         3tvg==
X-Gm-Message-State: AFqh2krP3j4J7UI0DyKWwBA3Gfng1ZjB4R6053UC/Wr8Lit1kdsE4SOW
        Ae6uy40sDsNwSh37mcQESo4aVRh/JXaNq45l
X-Google-Smtp-Source: AMrXdXu2FfmussU3/3gByvCJAFl43fkOu3oaVLxcPwlC1nMC8b/MBAPb+C6a/r721+Qbian1UCi0jA==
X-Received: by 2002:a05:6214:37c5:b0:4bb:6c62:c5c with SMTP id nj5-20020a05621437c500b004bb6c620c5cmr16066753qvb.10.1671862248055;
        Fri, 23 Dec 2022 22:10:48 -0800 (PST)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com. [209.85.222.181])
        by smtp.gmail.com with ESMTPSA id do42-20020a05620a2b2a00b006fcc3858044sm3668358qkb.86.2022.12.23.22.10.46
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 22:10:47 -0800 (PST)
Received: by mail-qk1-f181.google.com with SMTP id k2so3227538qkk.7
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 22:10:46 -0800 (PST)
X-Received: by 2002:ae9:ef49:0:b0:6fe:d4a6:dcef with SMTP id
 d70-20020ae9ef49000000b006fed4a6dcefmr506882qkg.594.1671862246626; Fri, 23
 Dec 2022 22:10:46 -0800 (PST)
MIME-Version: 1.0
References: <20221222144343-mutt-send-email-mst@kernel.org>
 <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
 <20221223172549-mutt-send-email-mst@kernel.org> <CAHk-=whpdP7X+L8RtGsonthr7Ffug=FhR+TrFe3JUyb5-zaYCA@mail.gmail.com>
 <20221224003445-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221224003445-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 22:10:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh_cyzZgYp1pL8MDA6sioB1RndQ_fref=9V+vm9faE7fg@mail.gmail.com>
Message-ID: <CAHk-=wh_cyzZgYp1pL8MDA6sioB1RndQ_fref=9V+vm9faE7fg@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, angus.chen@jaguarmicro.com,
        bobby.eshleman@bytedance.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        leiyang@redhat.com, lingshan.zhu@intel.com, lkft@linaro.org,
        lulu@redhat.com, m.szyprowski@samsung.com, nathan@kernel.org,
        pabeni@redhat.com, pizhenwei@bytedance.com, rafaelmendsr@gmail.com,
        ricardo.canuelo@collabora.com, ruanjinjie@huawei.com,
        sammler@google.com, set_pte_at@outlook.com, sfr@canb.auug.org.au,
        sgarzare@redhat.com, shaoqin.huang@intel.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        sunnanyong@huawei.com, wangjianli@cdjrlc.com,
        wangrong68@huawei.com, weiyongjun1@huawei.com,
        xuanzhuo@linux.alibaba.com, yuancan@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022 at 9:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> They were in  next-20221220 though.

So, perfect for the *next* merge window.

Do you understand what the word "next" means? We don't call it
"linux-this", do we?

This is not a new rule. Things are supposed to be ready *before* the
merge window (that's what makes it "next", get it?).

I will also point you to to

  https://lore.kernel.org/lkml/CAHk-=wj_HcgFZNyZHTLJ7qC2613zphKDtLh6ndciwopZRfH0aQ@mail.gmail.com/

where I'm being pretty damn clear about things.

And before you start bleating about "I needed more heads up", never
mind that this isn't even a new rule, and never mind what that "next"
word means, let me just point to the 6.1-rc6 notice too:

  https://lore.kernel.org/lkml/CAHk-=wgUZwX8Sbb8Zvm7FxWVfX6CGuE7x+E16VKoqL7Ok9vv7g@mail.gmail.com/

and if the meaning of "next" has eluded you all these years, maybe it
was high time you learnt. Hmm?

              Linus
