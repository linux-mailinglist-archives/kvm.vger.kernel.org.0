Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465806DD706
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 11:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDKJjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 05:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDKJij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 05:38:39 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC58C1984;
        Tue, 11 Apr 2023 02:37:54 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1003)
        id 4Pwgk52nX0z4xFd; Tue, 11 Apr 2023 19:37:49 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.org;
        s=201707; t=1681205869;
        bh=ZqYO+3AAJ7KdoPIQv+9ft6lOTImzO3egTdFAE+QjTNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IysLWq276d8TOdhvNMHA8UHL/7Esa9zUf65Wv2wj0jsCkvxZ7sXNjFyQpiMqMMP3m
         mrjDO2oH3a7dFkzt7RbQLm8A8V8zHRnUtsqJEkhYPXf4wMkzs3dddakSFeynBf1z7l
         GN0ZRFKO2huqhQVH6QuQfy1SD0ZxnxvIo6avvYL9nFNPp3P9Fl5docy+dJijqbkDY5
         To6AzdLRgO9KwHmfl2I/TB754D7moWLFuTBBV2o+pnSc8PLaKs46iIj2A9dULu+iTU
         iALnuKiRbVy6By3+ACij14tqAwH2iqKKs5s1X4mTiEAbygIGaoxUgQ24elbSGqkLdG
         QgsXJ3bZp7/6Q==
Date:   Tue, 11 Apr 2023 19:37:45 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] KVM: PPC: Fix documentation for ppc mmu caps
Message-ID: <ZDUqaUbakmKvNFXM@cleo>
References: <20230411061446.26324-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411061446.26324-1-joel@jms.id.au>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 03:44:46PM +0930, Joel Stanley wrote:
> The documentation mentions KVM_CAP_PPC_RADIX_MMU, but the defines in the
> kvm headers spell it KVM_CAP_PPC_MMU_RADIX. Similarly with
> KVM_CAP_PPC_MMU_HASH_V3.
> 
> Fixes: c92701322711 ("KVM: PPC: Book3S HV: Add userspace interfaces for POWER9 MMU")
> Signed-off-by: Joel Stanley <joel@jms.id.au>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
