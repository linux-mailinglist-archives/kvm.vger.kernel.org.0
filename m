Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FA63EA126
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhHLI7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 04:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhHLI73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 04:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E52A860C3F;
        Thu, 12 Aug 2021 08:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628758744;
        bh=8mYYilhUDGBXxNyWqQd1m1A2djqb4Kt850ntLHj3+nM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cB3WXrqd2g2o2zLlMVgOof5kb6v2wUXjrmPiRTDMJAG6qx2L45YQlz5w+2UVzNNip
         d40do10DEn9Xht7JKb3ZXJitrqiu5j7dpfeR46IK6OyMAc+t5LjyJz/nitneMzOQ1q
         dJ/aimBjHaXS65TgwT2SbRa9NcBUs9p9E0WdPaRkS+OyiFSd3CseSTAsaFkOCh9Pyb
         AsP0Zwhr+7PbLUQ9X2mMqaFW7/hH4vvXD+jZDaASFKPYd4xmcWN47nDZ5D97XDTnN+
         aW0rqHhx9b4YdJ02zfBJbQRECQk/qV++h0er6pbNvim0F1vEAZpjz/LIuHGc0r8Yga
         ocOZPiukOqkHQ==
Date:   Thu, 12 Aug 2021 09:58:58 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 01/15] KVM: arm64: placeholder to check if VM is
 protected
Message-ID: <20210812085857.GB5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-2-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-2-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:32PM +0100, Fuad Tabba wrote:
> Add a function to check whether a VM is protected (under pKVM).
> Since the creation of protected VMs isn't enabled yet, this is a
> placeholder that always returns false. The intention is for this
> to become a check for protected VMs in the future (see Will's RFC
> [*]).
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> [*] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

You can make this a Link: tag.

Anyway, I think it makes lots of sense to decouple this from the user-ABI
series:

Acked-by: Will Deacon <will@kernel.org>

Will
