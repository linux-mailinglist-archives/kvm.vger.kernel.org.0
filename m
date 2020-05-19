Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED1E1D9D2B
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 18:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgESQrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 12:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbgESQrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 12:47:07 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EFB020842;
        Tue, 19 May 2020 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589906826;
        bh=Ltv/jh2GtI2b5nJnqo8Jl/8YtfEYU5Wy+ivuZx1vTlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1OSFzGd2kZRfKoKZD2a0EzGfDTi4WDgnIP5bry7jiaQ8fUQEx4XX4MHFmaY7d2uOa
         A02ZSYfsm0yUi0hAEsLdUbvcuwXa1F1VJFKFJSA+V/S5FFQGQ20vHB5+y7OjIhepA1
         V0ZBm0AkVukpkhVcPVwMirKD2wOqS9B1d1ljalvY=
From:   Will Deacon <will@kernel.org>
To:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool] rtc: Generate fdt node for the real-time clock
Date:   Tue, 19 May 2020 17:46:58 +0100
Message-Id: <158990595902.1665.1735005226213648378.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514094553.135663-1-andre.przywara@arm.com>
References: <20200514094553.135663-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 10:45:53 +0100, Andre Przywara wrote:
> On arm and arm64 we expose the Motorola RTC emulation to the guest,
> but never advertised this in the device tree.
> 
> EDK-2 seems to rely on this device, but on its hardcoded address. To
> make this more future-proof, add a DT node with the address in it.
> EDK-2 can then read the proper address from there, and we can change
> this address later (with the flexible memory layout).
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] rtc: Generate fdt node for the real-time clock
      https://git.kernel.org/will/kvmtool/c/5a3a5c07dd87

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
