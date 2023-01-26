Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D854C67D406
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbjAZSYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjAZSYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:24:16 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F107A2E811;
        Thu, 26 Jan 2023 10:24:15 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 748872CD;
        Thu, 26 Jan 2023 18:24:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 748872CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1674757455; bh=NDkHtT0XjsN48TGbkrZ3csn8ktoYSDEN7MwnP8baIsI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=EfE1CVoBF1Lav23Y8wMwuTM1CGVqLS3IWz+nISXGDdFbPIyEUe7SW+jf3xOlU0DHf
         lfvBfJEFlncw56/QVROaAgU+gtk7Jpnn70NV8ESfaRX5mO8JhzJfwB1WoyGS8RMSn5
         U5GsPIv+d523u8tOjZ8PkYMJyA+/B60lO7WiEYnN2SL00p/nwDaLrWPqg/Uh7BynkO
         +qISNhKnhSfBgZKrRDE7QbaYQ3EN5u10cp5GnZ39YuGnalzCy/IOpt/78fqqQ5Alz5
         BnEJvGjdOUO/DVh9CMXI0e7rJ24ojMFS0WzKuJ/1N06+dJx+4GHIUAQMsRBeOqqR3a
         sO9zJRCnposSw==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Wang Yong <yongw.kernel@gmail.com>, pbonzini@redhat.com,
        kchamart@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wang Yong <yongw.kernel@gmail.com>
Subject: Re: [PATCH] Documentation: KVM: fix typos in running-nested-guests.rst
In-Reply-To: <20230110150046.549755-1-yongw.kernel@gmail.com>
References: <20230110150046.549755-1-yongw.kernel@gmail.com>
Date:   Thu, 26 Jan 2023 11:24:14 -0700
Message-ID: <87edrh9msx.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wang Yong <yongw.kernel@gmail.com> writes:

> change "gues" to "guest" and remove redundant ")".
>
> Signed-off-by: Wang Yong <yongw.kernel@gmail.com>
> ---
>  Documentation/virt/kvm/x86/running-nested-guests.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/x86/running-nested-guests.rst b/Documentation/virt/kvm/x86/running-nested-guests.rst
> index a27e6768d900..71136fe1723b 100644
> --- a/Documentation/virt/kvm/x86/running-nested-guests.rst
> +++ b/Documentation/virt/kvm/x86/running-nested-guests.rst
> @@ -150,7 +150,7 @@ able to start an L1 guest with::
>      $ qemu-kvm -cpu host [...]
>  
>  The above will pass through the host CPU's capabilities as-is to the
> -gues); or for better live migration compatibility, use a named CPU
> +guest, or for better live migration compatibility, use a named CPU
>  model supported by QEMU. e.g.::

Applied, thanks.

jon
