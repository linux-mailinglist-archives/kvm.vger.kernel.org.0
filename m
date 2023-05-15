Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A72470416C
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 01:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343559AbjEOXhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 19:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245395AbjEOXhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 19:37:06 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD10859DB
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 16:37:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-528cdc9576cso9342922a12.0
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 16:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684193825; x=1686785825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Aurf2e1xga4E1VZRAAjM7qHxekmbNCzjHV7M/l0zJs=;
        b=kJlbrT9sHPqZiy8sBy5yjrnnr95vWb+Y76dx38wwa/koRXHdxlott2XRlThTgSSIL9
         mDF6S6HLUECwvEjol+rIcSAB5/33Dc7r3bDmclZ4vFpDbHBREP1pYutAB3fITZEme5bF
         iIttQj6Ra8+fn1gCEAoLcm58k+8OrhVOThfrVohBBPnYnORUJ1xToAEhSNWdMUWLS5ea
         Mex70lzgsagN5TXxaI6QGHTwR5l7FPacGoGhNh9+i18ha6l/J6Rj8nETcRu3CyaDFNqu
         liR52nAaI2W9eJYCFcf0EgLWKn/4S9aCJfvcMfQqk3PUaXCLBPTvRjUmjcW33VPlRFRc
         3Zkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684193825; x=1686785825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Aurf2e1xga4E1VZRAAjM7qHxekmbNCzjHV7M/l0zJs=;
        b=PUdaTRhJrZLzXR90Ws83TQMrJGKrtKQV9cP0I6szXC/Sp3cAxyjrr/4zajwfgXDoxo
         O3URXcSaepQCqWdoULjZ9sud+b0JnlKlurMIA/5k8Y/luGG74bVAP9bK28TpeH4AMp62
         x+gt/sIb2XoUlu4RuFXuzodZxSf9A2OD2JvK6zoLyOTw+d11RFpTWPcCnJrQ9KOoGuXf
         Jfe3FhCHV9dUX0jd39C+pxKKcxEjOSnc0Nqn2De8b991UFEgGCX65i1H95DrbRKUQoX1
         xnPtcLT7vgncgMb0DiGu3FOmB8SHfwX2mc+Hx0lXo8cIPOzvRNQcpzHaHppbHK3jprjO
         eLtQ==
X-Gm-Message-State: AC+VfDz6VkmfUoFUYYuqaJht3iLjI2I6tyBxpTCl69FqM/4vVW5m3Hup
        16EhxKayhxIU2ykvD8y+ifYyxg==
X-Google-Smtp-Source: ACHHUZ6y7JbU2oqv2WBkKDZfDfWIxaDuzV8iVU2zUO4rKM3lEahN7rdtcHFNoexVrAFrgz/A2rkotQ==
X-Received: by 2002:a05:6a20:12cf:b0:104:1016:dd4d with SMTP id v15-20020a056a2012cf00b001041016dd4dmr20493931pzg.57.1684193825150;
        Mon, 15 May 2023 16:37:05 -0700 (PDT)
Received: from ?IPV6:2602:ae:1598:4c01:9902:96ac:8d8c:4366? ([2602:ae:1598:4c01:9902:96ac:8d8c:4366])
        by smtp.gmail.com with ESMTPSA id t19-20020a17090b019300b002448f08b177sm163702pjs.22.2023.05.15.16.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 16:37:04 -0700 (PDT)
Message-ID: <356b996c-310a-858f-5987-a698654fec8b@linaro.org>
Date:   Mon, 15 May 2023 16:37:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PULL v2 00/16] Block patches
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Hanna Reitz <hreitz@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Fam Zheng <fam@euphon.net>
References: <20230515160506.1776883-1-stefanha@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230515160506.1776883-1-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/15/23 09:04, Stefan Hajnoczi wrote:
> The following changes since commit 8844bb8d896595ee1d25d21c770e6e6f29803097:
> 
>    Merge tag 'or1k-pull-request-20230513' ofhttps://github.com/stffrdhrn/qemu  into staging (2023-05-13 11:23:14 +0100)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/stefanha/qemu.git  tags/block-pull-request
> 
> for you to fetch changes up to 01562fee5f3ad4506d57dbcf4b1903b565eceec7:
> 
>    docs/zoned-storage:add zoned emulation use case (2023-05-15 08:19:04 -0400)
> 
> ----------------------------------------------------------------
> Pull request
> 
> This pull request contain's Sam Li's zoned storage support in the QEMU block
> layer and virtio-blk emulation.
> 
> v2:
> - Sam fixed the CI failures. CI passes for me now. [Richard]

Applied, thanks.  Please update https://wiki.qemu.org/ChangeLog/8.1 as appropriate.


r~

