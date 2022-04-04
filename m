Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3582B4F1454
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 14:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbiDDMHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 08:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiDDMHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 08:07:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557431FA6E
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 05:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05DF7B81610
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 12:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2669DC340EE;
        Mon,  4 Apr 2022 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649073948;
        bh=d6JRr8U1cpuPPPZ6D2VufWB2hN6lbXNjOAfdpejG4b4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UvZBqVi+CJJFuwKeLo2xleNwTuDGxKMBQXkJJ3nkoh2tLq4cv+Zp061gpTen5ua2P
         CooikNERGgUph02rtRo8Go1WPfBsF1BZUtRmOGU1y9lOnXHqB3xq8eOcRfBLTxn15e
         486afF97FpEh5g8EYZ1/oKLd8ylpe4nal3nuHW9/2aIKF9mSfXN7J94+ort9PDH6yJ
         Ox4c6hF4gl4Ya1prso15p1xi+aQrhmqeq6BldL23sSHcSiBspLYPQayi+CONZGubXR
         qUjC61GwrLBxumEjLp1OTJq+JD4Z7epTlsBqEvVDQf5xVj1UgI6XQ18gBdWzbvNM0Y
         htK9L4ujADWng==
Date:   Mon, 4 Apr 2022 13:05:43 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        catalin.marinas@arm.com, kvm@vger.kernel.org,
        vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org,
        julien.thierry.kdev@gmail.com, steven.price@arm.com
Cc:     kernel-team@android.com
Subject: Re: [kvmtool PATCH v3 0/2] arm64: Add MTE support
Message-ID: <20220404120542.GA23473@willie-the-truck>
References: <20220328103328.18768-1-alexandru.elisei@arm.com>
 <164906755176.1613722.14442142721730095672.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164906755176.1613722.14442142721730095672.b4-ty@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 04, 2022 at 11:34:55AM +0100, Will Deacon wrote:
> On Mon, 28 Mar 2022 11:33:26 +0100, Alexandru Elisei wrote:
> > Add Memory Tagging Extension (MTE) support in kvmtool.
> > 
> > Changes since v2:
> > 
> > * Gathered Reviewed-by and Tested-by tags from Vladimir, thank you!
> > * Slight tweaks to the kvmtool debug and user messages.
> > * Do not set kvm->arch.cfg.mte_disabled is the MTE capability is not
> >   available. It is not used anywhere outside of the MTE setup function and
> >   kvm->arch.cfg is for user config options.
> > 
> > [...]
> 
> Applied to arm64 (master), thanks!
> 
> [1/2] update_headers.sh: Sync ABI headers with Linux v5.17
>       https://git.kernel.org/arm64/c/af1b793cb616
> [2/2] aarch64: Add support for MTE
>       https://git.kernel.org/arm64/c/5657dd3e48b4

Sorry, b4 got confused by my scripts here. The SHAs are correct, but these
have obviously been applied to the kvmtool repository, not the arm64 kernel
tree!

Will
