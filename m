Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D91678B8A0
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 21:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjH1TpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 15:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbjH1TpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 15:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A03122;
        Mon, 28 Aug 2023 12:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACFAE646DC;
        Mon, 28 Aug 2023 19:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D26C433C7;
        Mon, 28 Aug 2023 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693251902;
        bh=pIZ450UJMkVzx8UlKp54rw2QfZHBgu0tCxB/2xr8MYo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WY26HVRiphuvRN+tnmGDhk3V2iWC7qtXKgEFawaeznWhiUDUo0mUZpaczBtYkPDdT
         sVEl7Wdoz7OcPF2j+eL5sCFprBwPgDEpu3QYlkHSqJr4MOjx4akhOGF+wODANOFu19
         7iU6NvSVVvjjMH4kGfkqX8axpT68iWKz2+x2pgC87bi189r5ItiryZAmBt3lD2BXfp
         Xmu16Ll7b04NSS1O6VGtdA1hg4xbhuPLCWSV3Ku0O2SpUy6T8aYLZV542SNTcnYkL2
         OoqeUxCTszHVOZ/XVnxK5kh7OVg+NWVIn7STTB7jlgtyv274ArDDt7SEteSOw76Ym7
         ZR6c4npF4OsTw==
Date:   Mon, 28 Aug 2023 12:45:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
Subject: Re: [PATCH net-next v7 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Message-ID: <20230828124500.446929fe@kernel.org>
In-Reply-To: <20230827085436.941183-1-avkrasnov@salutedevices.com>
References: <20230827085436.941183-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 27 Aug 2023 11:54:32 +0300 Arseniy Krasnov wrote:
> this patchset is first of three parts of another big patchset for
> MSG_ZEROCOPY flag support:
> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/

## Form letter - net-next-closed

The merge window for v6.6 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Sept 11th.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer

