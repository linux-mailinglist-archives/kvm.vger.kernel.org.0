Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9714C695952
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjBNGkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBNGkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DD5B747;
        Mon, 13 Feb 2023 22:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 205E860E8C;
        Tue, 14 Feb 2023 06:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3561C433EF;
        Tue, 14 Feb 2023 06:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676356810;
        bh=epEYT2bBFKhloOKJkQKS1toE8ZF4uZ/r0fMG2x/8Yuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lyf7vA2oE0qTtQcTHrOPakOqIdRGcOr3diK1jL93GrHP3JbutcqRuJhghYW2xlnuv
         tB4llqDiMgkYnRi+SX8qUb/NzZiCp0IeoZEFtl0n1fv7d5l+873DkLS3MGOJNUKqmU
         kuLv+Tjl+27mjIZ8X+zYzeL8MxxpdRVasAlyo1XE=
Date:   Tue, 14 Feb 2023 07:40:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH v1 03/24] LoongArch: KVM: Implement vcpu
 create,run,destroy operations.
Message-ID: <Y+ssx3hQPD2l23u+@kroah.com>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
 <20230214025648.1898508-4-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214025648.1898508-4-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 10:56:27AM +0800, Tianrui Zhao wrote:
> Implement loongarch vcpu related operations:
> 1. Implement vcpu create interface, saving some info into vcpu arch
> structure such as vcpu exception entrance, vcpu enter guest pointer,
> etc. Init vcpu timer and set address translation mode when vcpu create.
> 2. Implement vcpu run interface, handling mmio, iocsr reading fault
> and deliver interrupt, lose fpu before vcpu enter guest.
> 3. Implement vcpu handle exit interface, getting the exit code by ESTAT
> register and using kvm exception vector to handle it.

Again, when you have to list different things in a patch, that is a huge
hint that it needs to be split up into smaller pieces.

thanks,

greg k-h
