Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7FE785770
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 14:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbjHWMEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 08:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbjHWME3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 08:04:29 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A3BE70;
        Wed, 23 Aug 2023 05:04:03 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RW4cz2GpGz4x3D;
        Wed, 23 Aug 2023 22:04:03 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
References: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
Subject: Re: [PATCH] powerpc: Make virt_to_pfn() a static inline
Message-Id: <169279175548.797584.16810981257080808003.b4-ty@ellerman.id.au>
Date:   Wed, 23 Aug 2023 21:55:55 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 09 Aug 2023 10:07:13 +0200, Linus Walleij wrote:
> Making virt_to_pfn() a static inline taking a strongly typed
> (const void *) makes the contract of a passing a pointer of that
> type to the function explicit and exposes any misuse of the
> macro virt_to_pfn() acting polymorphic and accepting many types
> such as (void *), (unitptr_t) or (unsigned long) as arguments
> without warnings.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc: Make virt_to_pfn() a static inline
      https://git.kernel.org/powerpc/c/58b6fed89ab0f602de0d143c617c29c3d4c67429

cheers
