Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C12785779
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 14:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbjHWMFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 08:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbjHWMFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 08:05:15 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98661BD1;
        Wed, 23 Aug 2023 05:04:52 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RW4dW1J3dz4x2F;
        Wed, 23 Aug 2023 22:04:31 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        kernel test robot <lkp@intel.com>
In-Reply-To: <20230803-ppc_tlbilxlpid-v3-1-ca84739bfd73@google.com>
References: <20230803-ppc_tlbilxlpid-v3-1-ca84739bfd73@google.com>
Subject: Re: [PATCH v3] powerpc/inst: add PPC_TLBILX_LPID
Message-Id: <169279175566.797584.17891188620028353230.b4-ty@ellerman.id.au>
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

On Thu, 03 Aug 2023 11:33:52 -0700, Nick Desaulniers wrote:
> Clang didn't recognize the instruction tlbilxlpid. This was fixed in
> clang-18 [0] then backported to clang-17 [1].  To support clang-16 and
> older, rather than using that instruction bare in inline asm, add it to
> ppc-opcode.h and use that macro as is done elsewhere for other
> instructions.
> 
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/inst: add PPC_TLBILX_LPID
      https://git.kernel.org/powerpc/c/ae7936d232d862e5b8311180036281ffe93735b8

cheers
