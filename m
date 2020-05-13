Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8D31D180A
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389106AbgEMO4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389099AbgEMO4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 10:56:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 184FE2220D;
        Wed, 13 May 2020 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589381793;
        bh=agpwgaoOTBkYa0Dkemr20fhC2Bv+xPivkw47MUGfkZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wmJeo/RkygjRZTea+j5Jfxa9HlxMzYHd2/nN0P0l7Yi9vGfEuVu2YZmI6O7fQMQdl
         g1WLe9DtI3JUGEKQdC3pLRMVjHeVzkIohizeZDTrxhaDHePj7req56F2+6DFPC0I7a
         gSImUv0ybD8bPIMOEvrYYyCiQZ7K5Xvy/Uhv884E=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jYsoB-00C0Sl-7r; Wed, 13 May 2020 15:56:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 May 2020 15:56:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
Subject: Re: [PATCH v2 kvmtool 00/30] Add reassignable BARs and PCIE 1.1
 support
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <a395e1f397699053840e58207918866b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com, andre.przywara@arm.com, sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

On 2020-01-23 13:47, Alexandru Elisei wrote:
> kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to 
> prevent
> it from trying to reassign the BARs. Let's make the BARs reassignable 
> so
> we can get rid of this band-aid.

Is there anything holding up this series? I'd really like to see it
merged in mainline kvmtool, as the EDK2 port seem to have surfaced
(and there are environments where running QEMU is just overkill).

It'd be good if it could be rebased and reposted.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
