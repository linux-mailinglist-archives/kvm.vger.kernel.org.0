Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1F51B6FE6
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDXIk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 04:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgDXIk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 04:40:57 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E6F420728;
        Fri, 24 Apr 2020 08:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587717656;
        bh=us+cckoY3UvgSdl2gPr8eg5gI2fu/T9757R6fhdxq84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vqcjhokd+twfLjU9qHCknuOKxiUaqmabSaahgo6Atxa7Nji9kjc44PpG05phFmJpr
         fljMiTbcMAr42S+2AXhI+ea12pJTBtFMfCHAOm0nEIMSq2Fe48wsC4EVivcVMMfPqK
         ePiv9axjwN/eLot213Q3ouLMM0j3ITrlyk6mplpg=
Date:   Fri, 24 Apr 2020 09:40:51 +0100
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
Message-ID: <20200424084051.GA20801@willie-the-truck>
References: <20200423173844.24220-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423173844.24220-1-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 06:38:39PM +0100, Andre Przywara wrote:
> an update for the CFI flash emulation, addressing Alex' comments and
> adding direct mapping support.
> The actual code changes to the flash emulation are minimal, mostly this
> is about renaming and cleanups.
> This versions now adds some patches. 1/5 is a required fix, the last
> three patches add mapping support as an extension. See below.

Cheers, this mostly looks good to me. I've left a couple of minor comments,
and I'll give Alexandru a chance to have another look, but hopefully we can
merge it soon.

Will
