Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187FB24D4F9
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 14:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgHUM2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 08:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbgHUM2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 08:28:11 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0A13207DA;
        Fri, 21 Aug 2020 12:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598012891;
        bh=aqC6RZNlt7cZGGx+IBQoEw4qDdBVryztZiC0kX5TFGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q44brypNNE2SNVLZWrKmVRPjo7tOjE0VonpVpa02qDTpajq70gcguWQKAlypKsrBf
         9iKVsIzsVgBMwzClP+EXSxntojA3uzon1vV2TEPQE1uqbyBVK2mG68HlgHvD/sPvmy
         TA/RECpb4cGFBjAKvdU3h8webIa1FxOQnv0vQvN0=
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, jean-philippe@linaro.org,
        Anvay Virkar <anvay.virkar@arm.com>, andre.przywara@arm.com,
        julien.thierry.kdev@gmail.com, milon@wq.cz
Subject: Re: [PATCH v2 kvmtool] virtio: Fix ordering of virtio_queue__should_signal()
Date:   Fri, 21 Aug 2020 13:28:04 +0100
Message-Id: <159801216222.4167343.15351174209082689141.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804145317.51633-1-alexandru.elisei@arm.com>
References: <20200804145317.51633-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Aug 2020 15:53:17 +0100, Alexandru Elisei wrote:
> The guest programs used_event in the avail ring to let the host know when
> it wants a notification from the device. The host notifies the guest when
> the used ring index passes used_event. It is possible for the guest to
> submit a buffer, and then go into uninterruptible sleep waiting for this
> notification.
> 
> The virtio-blk guest driver, in the notification callback virtblk_done(),
> increments the last known used ring index, then sets used_event to this
> value, which means it will get a notification after the next buffer is
> consumed by the host. virtblk_done() exits after the value of the used
> ring idx has been propagated from the host thread.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio: Fix ordering of virtio_queue__should_signal()
      https://git.kernel.org/will/kvmtool/c/d7d79bd51412

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
