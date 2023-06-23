Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572DB73BBCD
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 17:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjFWPh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 11:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjFWPh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 11:37:27 -0400
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [IPv6:2001:41d0:203:375::f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE478E5B
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 08:37:25 -0700 (PDT)
Date:   Fri, 23 Jun 2023 17:37:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687534644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8xxylnc3LN6aIFaJfnGQWv4pHCLT8fe59kFt8NUVe/Q=;
        b=pmUhCAJ+tRB8FPwUxPGio0c1KRjcWanMkaznxtVrxhrunWU6Nnh5yptdM6FVooKaZewLMY
        RRAeWIzDYiJ1y9K031gmweSXf0N7PKOKbFuILn2iNUIfTWjRT6uaZSt3glm70t1M32dznS
        jGIPyk6HTLUBsV7ZrcS2eJaCjzxqlS8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] EFI runtime fixes
Message-ID: <20230623-d68ee37c91a981d199441648@orel>
References: <20230607185905.32810-1-andrew.jones@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607185905.32810-1-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 08:59:02PM +0200, Andrew Jones wrote:
> While testing the new EFI support for Arm, I fixed a couple runtime
> script issues.
> 
> Andrew Jones (3):
>   arch-run: Extend timeout when booting with UEFI
>   arm/efi/run: Add Fedora's path to QEMU_EFI
>   configure: efi: Link correct run script
> 
>  arm/efi/run           | 15 ++++++++++-----
>  configure             |  5 ++++-
>  scripts/arch-run.bash | 10 ++++++++++
>  x86/efi/run           |  2 +-
>  4 files changed, 25 insertions(+), 7 deletions(-)
> 
> -- 
> 2.40.1
>

Applied to arm/queue

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew
