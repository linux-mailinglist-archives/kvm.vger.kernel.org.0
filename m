Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C8F23C739
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 09:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHEHxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 03:53:34 -0400
Received: from srw1.wq.cz ([80.92.240.241]:51764 "EHLO srw1.wq.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgHEHxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 03:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wq.cz;
        s=default; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=70BAV1/GDN5+Jzd7DjxRMQB7uEmFb47ibqtU8zEuk+M=; b=rH12b35c15in9IxZMnZtvQ4DAk
        8wVWJUjZz9gWT4yI6lRAK3w7o2svtPpOAviIl6xUvup+b+rD9yU77N46t6w/UKwDrlxHkIqLG1J/W
        wdEZxaPsNV6XgJj3yVNBFDWET9tszJ3FUCTRapIO+BSI1w+9FCDtTwGpiI3I51fHDQyk=;
Received: from fw.wq.cz ([185.71.40.210] helo=msc.wq.cz)
        by srw1.wq.cz with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <milon@wq.cz>)
        id 1k3EEp-00039o-MI; Wed, 05 Aug 2020 09:53:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wq.cz;
        s=ntm; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=70BAV1/GDN5+Jzd7DjxRMQB7uEmFb47ibqtU8zEuk+M=; b=ZXp1EDhBeohuRFcipXzQG604Xn
        isD3GiWgNcwFrcR1dDLJreUvPmkpmVfbpOT/hrNWqbkHVAfXx5sdy6BIJdt0lEmoRn2C5lsFrRLpx
        GhV1A+Gamu5vblo1ZEjL98T0J4KMGO3MRrxmbQV2MB//R1yOJ6159wfO973w8ElU1PW8=;
Received: from milon by msc.wq.cz with local (Exim 4.92)
        (envelope-from <milon@wq.cz>)
        id 1k3EEp-0007Vt-DX; Wed, 05 Aug 2020 09:53:27 +0200
Date:   Wed, 5 Aug 2020 09:53:27 +0200
From:   Milan Kocian <milon@wq.cz>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        will@kernel.org, jean-philippe@linaro.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
Subject: Re: [PATCH v2 kvmtool] virtio: Fix ordering of
 virtio_queue__should_signal()
Message-ID: <20200805075327.GJ7810@msc.wq.cz>
References: <20200804145317.51633-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804145317.51633-1-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

> I *think* this also fixes the VM hang reported in [2], where several
> processes in the guest were stuck in uninterruptible sleep. I am not
> familiar with the block layer, but my theory is that the threads were stuck
> in wait_for_completion_io(), from blk_execute_rq() executing a flush
> request. Milan has agreed to give this patch a spin [3], but that might
> take a while because the bug is not easily reproducible. I believe the
> patch can be merged on its own.
> 
> [1] http://diy.inria.fr/www/index.html?record=aarch64&cat=aarch64-v04&litmus=SB%2Bdmb.sys&cfg=new-web
> [2] https://www.spinics.net/lists/kvm/msg204543.html
> [3] https://www.spinics.net/lists/kvm/msg222201.html
> 

Unfortunately it didn't help. I can see the problem again now.

Thanks.

Best regards.

-- 
Milan Kocian
