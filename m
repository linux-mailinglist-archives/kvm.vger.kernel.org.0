Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26424234D99
	for <lists+kvm@lfdr.de>; Sat,  1 Aug 2020 00:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgGaWgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 18:36:07 -0400
Received: from srw1.wq.cz ([80.92.240.241]:51696 "EHLO srw1.wq.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgGaWgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 18:36:07 -0400
X-Greylist: delayed 1815 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2020 18:36:06 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wq.cz;
        s=default; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+tv/ptYOI0F1xH3HAd77UevlqvOcTsLS/bdj/0Dq7DU=; b=iE/jTz13e+dubZq6E1p3JgD3yT
        iAbg6SsImNdLngKgDMhFe/usQT45Ra3J8Ry1bTC4t8gyzKOMkdWwcsGdTTG+/qtTrVPCOghCYVQtL
        /Roh0Ih5TdI1hyxGbfkA/qEE/f+l0xqZmhFm/ht7sVurD0mlMUhrplvAV5N9obwl/0Fo=;
Received: from fw.wq.cz ([185.71.40.210] helo=msc.wq.cz)
        by srw1.wq.cz with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <milon@wq.cz>)
        id 1k1d9v-00087U-Tc; Sat, 01 Aug 2020 00:05:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wq.cz;
        s=ntm; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+tv/ptYOI0F1xH3HAd77UevlqvOcTsLS/bdj/0Dq7DU=; b=qFT0mjK1sD0ds4o0mYzxqBpy4S
        MU95qJbHWwWoM/C5fLdo8utOB2Ukz4gGTK+85bt0r4npbrQ70tXOr/Sxj68iZn3iEz+d+472dWK+B
        r/MDUnjzE86ET/R5v4RkygPq6NLjYitO6D2u9OcgZW2ONAzJZK7RqZ88VX0quW1DmzqA=;
Received: from milon by msc.wq.cz with local (Exim 4.92)
        (envelope-from <milon@wq.cz>)
        id 1k1d9v-0007LD-O5; Sat, 01 Aug 2020 00:05:47 +0200
Date:   Sat, 1 Aug 2020 00:05:47 +0200
From:   Milan Kocian <milon@wq.cz>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        will@kernel.org, jean-philippe@linaro.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
Subject: Re: [PATCH kvmtool] virtio: Fix ordering of
 virt_queue__should_signal()
Message-ID: <20200731220547.GD7810@msc.wq.cz>
References: <20200731101427.16284-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731101427.16284-1-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
 
> I *think* this also fixes the VM hang reported in [1], where several
> processes in the guest were stuck in uninterruptible sleep. I am not
> familiar with the block layer, but my theory is that the threads were stuck
> in wait_for_completion_io(), from blk_execute_rq() executing a flush
> request. It would be great if Milan could give this patch a spin and see if
> the problem goes away. Don't know how reproducible it is though.
> 
> [1] https://www.spinics.net/lists/kvm/msg204543.html
> 

Okay, I will test it but it takes some time. Because I migrated to the
qemu due this problem :-) so I need to prepare new environment. And
because the problem happens randomly. My environment can run days/few weeks
without this problem.

Thanks.

Best regards.

-- 
Milan Kocian
