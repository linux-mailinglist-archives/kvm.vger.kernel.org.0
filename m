Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0785878BB1D
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 00:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbjH1WoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 18:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbjH1Wnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 18:43:50 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B80115
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:43:46 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-307d20548adso3094813f8f.0
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693262625; x=1693867425;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iZRzXnLTRqN+NAoFSdgE2RqfPIcu18B7VBfCAs46eww=;
        b=vKaHEoB/I/WDoQEz5zNNnkbrl804LBwDXx4lF9APsqwUXCowOf3zuslob0G7emNhQS
         c7FvZHjKxWiSeyajHZUsh9PAebi7BwYRduFgmrLwNTYcQi79sDHDkvlVHNpJPCLmRJ/a
         jbxo0K9c5u5i4vw9PDwEmMk2p5ttHexo5bI+WPfI/H/IScp0p91faVAhRZINzsjMqTjJ
         Or1xKgUeRFlSQo/kUvxfJnYIthx1ctlqdsbuGibqfvjg9f4j53UCxFD1eNkMOHpkKJUb
         kHifz5LC2vVdF1wU2HjM+0ed5lEilDsG8gPcngcaE6A7G74E3AuyEorhshgZPam+26vb
         GNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693262625; x=1693867425;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZRzXnLTRqN+NAoFSdgE2RqfPIcu18B7VBfCAs46eww=;
        b=bmNQ9MXNDJHoj+ZTS5vhF6iJHLE+xOZOU+McpG7IaM6tFalZULqY2X1991rzhSZwiR
         TonJk96hd3iU2seSCcsPAqX2HU6N+RO3kltsTUib0VaLPgrgPJTETHJqIlnQw+ZIttz7
         Ocj/Iht9z1Ma1GyvW3zAHUJgJJpe2Pe1dZ5J2SClsBmoH1616SoZO5Wbv03oBBHSLi6j
         ydtaxMsFNK2XBVUxOyd4xxufOUBN5bx8Z9/jIHhD4/6Ya2n1EkOF3riQZg6fKw02iUE+
         3vET1DHij9mpMnBFtCDjgrLMI6nlBYEi6pZI7UW8I3bk4oJXZ3xlfDRPvFY+gUV9jc51
         jUng==
X-Gm-Message-State: AOJu0YwAt6i9oj/2yWX61F8kP39Ghfs/invpa11wKXZdHklEe7DOlU1w
        tjQCGirfMferbkX7/GFoy3XyDg==
X-Google-Smtp-Source: AGHT+IEcB9ejLEN+i2kjgdIcf4x84n+ATGTzcwGQJD7X+LB/AsKZ0ASEFUjsmSgESasn5iXXImVX9Q==
X-Received: by 2002:a5d:62cf:0:b0:319:79a9:4d9e with SMTP id o15-20020a5d62cf000000b0031979a94d9emr19473948wrv.44.1693262625241;
        Mon, 28 Aug 2023 15:43:45 -0700 (PDT)
Received: from [192.168.69.115] ([176.164.201.64])
        by smtp.gmail.com with ESMTPSA id v7-20020a5d6107000000b0031c4d4be245sm11720033wrt.93.2023.08.28.15.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 15:43:44 -0700 (PDT)
Message-ID: <2d3fe007-c8d3-b6dd-a4a7-7f85daaa259b@linaro.org>
Date:   Tue, 29 Aug 2023 00:43:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2 15/16] memory,vhost: Allow for marking memory device
 memory regions unmergeable
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230825132149.366064-1-david@redhat.com>
 <20230825132149.366064-16-david@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230825132149.366064-16-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/8/23 15:21, David Hildenbrand wrote:
> Let's allow for marking memory regions unmergeable, to teach
> flatview code and vhost to not merge adjacent aliases to the same memory
> region into a larger memory section; instead, we want separate aliases to
> stay separate such that we can atomically map/unmap aliases without
> affecting other aliases.
> 
> This is desired for virtio-mem mapping device memory located on a RAM
> memory region via multiple aliases into a memory region container,
> resulting in separate memslots that can get (un)mapped atomically.
> 
> As an example with virtio-mem, the layout would look something like this:
>    [...]
>    0000000240000000-00000020bfffffff (prio 0, i/o): device-memory
>      0000000240000000-000000043fffffff (prio 0, i/o): virtio-mem
>        0000000240000000-000000027fffffff (prio 0, ram): alias memslot-0 @mem2 0000000000000000-000000003fffffff
>        0000000280000000-00000002bfffffff (prio 0, ram): alias memslot-1 @mem2 0000000040000000-000000007fffffff
>        00000002c0000000-00000002ffffffff (prio 0, ram): alias memslot-2 @mem2 0000000080000000-00000000bfffffff
>    [...]
> 
> Without unmergable memory regions, all three memslots would get merged into
> a single memory section. For example, when mapping another alias (e.g.,
> virtio-mem-memslot-3) or when unmapping any of the mapped aliases,
> memory listeners will first get notified about the removal of the big
> memory section to then get notified about re-adding of the new
> (differently merged) memory section(s).
> 
> In an ideal world, memory listeners would be able to deal with that
> atomically, like KVM nowadays does. However, (a) supporting this for other
> memory listeners (vhost-user, vfio) is fairly hard: temporary removal
> can result in all kinds of issues on concurrent access to guest memory;
> and (b) this handling is undesired, because temporarily removing+readding
> can consume quite some time on bigger memslots and is not efficient
> (e.g., vfio unpinning and repinning pages ...).
> 
> Let's allow for marking a memory region unmergeable, such that we
> can atomically (un)map aliases to the same memory region, similar to
> (un)mapping individual DIMMs.
> 
> Similarly, teach vhost code to not redo what flatview core stopped doing:
> don't merge such sections. Merging in vhost code is really only relevant
> for handling random holes in boot memory where; without this merging,
> the vhost-user backend wouldn't be able to mmap() some boot memory
> backed on hugetlb.
> 
> We'll use this for virtio-mem next.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   hw/virtio/vhost.c     |  4 ++--
>   include/exec/memory.h | 22 ++++++++++++++++++++++
>   softmmu/memory.c      | 31 +++++++++++++++++++++++++------
>   3 files changed, 49 insertions(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


