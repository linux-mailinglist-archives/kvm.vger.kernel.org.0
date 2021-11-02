Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A711442CE8
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 12:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhKBLmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 07:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhKBLl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 07:41:26 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BEAC06122A;
        Tue,  2 Nov 2021 04:38:48 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hk7Fz2mcmz4xdY;
        Tue,  2 Nov 2021 22:38:47 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     paulus@samba.org, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, npiggin@gmail.com, kvm-ppc@vger.kernel.org
In-Reply-To: <20211027061646.540708-1-mpe@ellerman.id.au>
References: <20211027061646.540708-1-mpe@ellerman.id.au>
Subject: Re: [PATCH] MAINTAINERS: Update powerpc KVM entry
Message-Id: <163584792793.1845480.13540784301137496504.b4-ty@ellerman.id.au>
Date:   Tue, 02 Nov 2021 21:12:07 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Oct 2021 17:16:46 +1100, Michael Ellerman wrote:
> Paul is no longer handling patches for kvmppc.
> 
> Instead we'll treat them as regular powerpc patches, taking them via the
> powerpc tree, using the topic/ppc-kvm branch when necessary.
> 
> Also drop the web reference, it doesn't have any information
> specifically relevant to powerpc KVM.
> 
> [...]

Applied to powerpc/next.

[1/1] MAINTAINERS: Update powerpc KVM entry
      https://git.kernel.org/powerpc/c/19b27f37ca97d1e42453b9e48af1cccb296f6965

cheers
