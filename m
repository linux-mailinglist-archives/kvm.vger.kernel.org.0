Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235C23F402B
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhHVOvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhHVOtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:49:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6C761208;
        Sun, 22 Aug 2021 14:48:51 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mHomH-006VHr-MU; Sun, 22 Aug 2021 15:48:49 +0100
MIME-Version: 1.0
Date:   Sun, 22 Aug 2021 15:48:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 0/3] target/arm: Reduced-IPA space and highmem=off fixes
In-Reply-To: <20210822144441.1290891-1-maz@kernel.org>
References: <20210822144441.1290891-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <5ae02b70fcb1df96306f96eddae28486@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com, eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-08-22 15:44, Marc Zyngier wrote:
> With the availability of a fruity range of arm64 systems, it becomes
> obvious that QEMU doesn't deal very well with limited IPA ranges when
> used as a front-end for KVM.
> 
> This short series aims at making usable on such systems:
> - the first patch makes the creation of a scratch VM IPA-limit aware
> - the second one actually removes the highmem devices from the
> computed IPA range when highmem=off
> - the last one addresses an imprecision in the documentation for the
> highmem option
> 
> This has been tested on an M1-based Mac-mini running Linux v5.14-rc6.

I realise I haven't been very clear in my description of the above.
With this series, using 'highmem=off' results in a usable VM, while
sticking to the default 'highmem=on' still generates an error.

         M.
-- 
Jazz is not dead. It just smells funny...
