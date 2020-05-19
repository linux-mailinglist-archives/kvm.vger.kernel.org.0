Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B98F1D9D2C
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 18:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgESQrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 12:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbgESQrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 12:47:08 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58DEE20849;
        Tue, 19 May 2020 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589906828;
        bh=ufwS9ijimnGV/ZABJq1u2AJuDxGOiNSw4YaSpDx4uOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8CL8qMwpov+p7cZafh0oTBiXZlClJawMLn6KEHkPiJH/4ToseJD8gX/BYPvOQwlA
         3M+0MxyCdq3lrT3gmAMS/dr2jDUqn3YMAX45NLP4+0Cfro1fyZXkQhgER5mYTFvYEt
         mgnoD3Ze7anLa52vX1o3p3k0k7N0UyvQ/PtpAe1M=
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool v2] net: uip: Fix GCC 10 warning about checksum calculation
Date:   Tue, 19 May 2020 17:46:59 +0100
Message-Id: <158990624263.2259.695515833438045756.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200518125649.216416-1-andre.przywara@arm.com>
References: <20200518125649.216416-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 13:56:49 +0100, Andre Przywara wrote:
> GCC 10.1 generates a warning in net/ip/csum.c about exceeding a buffer
> limit in a memcpy operation:
> ------------------
> In function 'memcpy',
>     inlined from 'uip_csum_udp' at net/uip/csum.c:58:3:
> /usr/include/aarch64-linux-gnu/bits/string_fortified.h:34:10: error: writing 1 byte into a region of size 0 [-Werror=stringop-overflow=]
>    34 |   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from net/uip/csum.c:1:
> net/uip/csum.c: In function 'uip_csum_udp':
> include/kvm/uip.h:132:6: note: at offset 0 to object 'sport' with size 2 declared here
>   132 |  u16 sport;
> ------------------
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] net: uip: Fix GCC 10 warning about checksum calculation
      https://git.kernel.org/will/kvmtool/c/56ef7bdc6a7d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
