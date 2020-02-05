Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DF6153625
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgBERQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBERQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 12:16:17 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCBCC21741;
        Wed,  5 Feb 2020 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580922977;
        bh=2QojBDt9CUuGBywXUs+J3QiEEixW07f2gJQTGjkofio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JW5WF6Fh0ZQEX8HYSrS7BRhYL6atFgg/m77JSsb+Pq7HiQ4+Elp/O8Q18Dfwl6prg
         7VkJ0WOa3T6oDSxauWoAI72CjmJNn+MgqzLeDXWHhn/6NUoYFvls2qnhbj6JUdBKuQ
         gJObs5qMvaSJ2zeDBuqts7bXDygSe3lkTw+RV4Ng=
Date:   Wed, 5 Feb 2020 17:16:12 +0000
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 00/16] arm: Allow the user to define the memory
 layout
Message-ID: <20200205171612.GC908@willie-the-truck>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 02:35:06PM +0100, Alexandru Elisei wrote:
> The guest memory layout created by kvmtool is fixed: regular MMIO is below
> 1G, PCI MMIO is below 2G, and the RAM always starts at the 2G mark. Real
> hardware can have a different memory layout, and being able to create a
> specific memory layout can be very useful for testing the guest kernel.
> 
> This series allows the user the specify the memory layout for the
> virtual machine by expanding the -m/--mem option to take an <addr>
> parameter, and by adding architecture specific options to define the I/O
> ports, regular MMIO and PCI MMIO memory regions.
> 
> The user defined memory regions are implemented in patch #16; I consider
> the patch to be an RFC because I'm not really sure that my approach is the
> correct one; for example, I decided to make the options arch dependent
> because that seemed like the path of least resistance, but they could have
> just as easily implemented as arch independent and each architecture
> advertised having support for them via a define (like with RAM base
> address).

Do you plan to repost this with Andre's comments addressed?

Will
