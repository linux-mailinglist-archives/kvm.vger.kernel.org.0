Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EB0621AE2
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiKHRjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiKHRjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:39:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEEF51C00
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79D1661702
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 17:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DDAC433B5;
        Tue,  8 Nov 2022 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667929150;
        bh=W7G4T6aOSyCn0zovrnoOXf+pgvOiy1Y3P2eE2WMS194=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTv48r12LlGcTx3jiz4bgNBqGkIjD1qN5eEexJMP/MDPW7DyPd1VSAxZFqul9tS/p
         YPWz6t1sh2U8bk4IszTpklh30P0MdqqJMunHmEHgqtfVV/eZ5xS43LxMXI3YxmsC0/
         AHT/1lsatIBRkEZjIKRWRwc7ohi8jiW05IyaUkZnd/m9AWmxOwiP/sd9bLjU6+dGKP
         4jLTrdgxjC78xVdFk3B7+RjZ1Yl1w/l9lbpBcBJyErexXbBn7S+UNF9J1CcXHJtlSd
         fPHvOYqt+M5eODLpWLTeTWWY4b4zueGNVAN87ot+8FVhdhFJLy2fzY+I+ZClItqwG0
         SeozuHLtbIIyw==
From:   Will Deacon <will@kernel.org>
To:     hbuxiaofei <hbuxiaofei@gmail.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool] hw/i8042: Fix value uninitialized in kbd_io()
Date:   Tue,  8 Nov 2022 17:38:45 +0000
Message-Id: <166792156312.1914676.1271283300180845723.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221102080501.69274-1-hbuxiaofei@gmail.com>
References: <20221102080501.69274-1-hbuxiaofei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Nov 2022 16:05:01 +0800, hbuxiaofei wrote:
>   GCC Version:
>     gcc (GCC) 8.4.1 20200928 (Red Hat 8.4.1-1)
> 
>   hw/i8042.c: In function ‘kbd_io’:
>   hw/i8042.c:153:19: error: ‘value’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>      state.write_cmd = val;
>      ~~~~~~~~~~~~~~~~^~~~~
>   hw/i8042.c:298:5: note: ‘value’ was declared here
>     u8 value;
>        ^~~~~
>   cc1: all warnings being treated as errors
>   make: *** [Makefile:508: hw/i8042.o] Error 1
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] hw/i8042: Fix value uninitialized in kbd_io()
      https://git.kernel.org/will/kvmtool/c/5a9cde6532ea

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
