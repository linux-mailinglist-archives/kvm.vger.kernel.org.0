Return-Path: <kvm+bounces-63041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E11C5997F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD0D23B6BD4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 19:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A90C316902;
	Thu, 13 Nov 2025 19:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRYWWgdo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A3312830;
	Thu, 13 Nov 2025 19:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060508; cv=none; b=KtXjTl8KeZcNz2PNMS35edxJ2tdykZv5VYoq9CHkDkynH61akIF5mbZCV55X/9+BKg4GxetnqWHgk9cKF80CKCToo9Jh7W3xUYqAa7JL/DJlCiN4X0VV/hkhv6fJ7MiFsKVxT9HT4yFzQJiGgNLZa7JusXWul63BmmgU89m4aYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060508; c=relaxed/simple;
	bh=oDRRct8+8e6d4sESV9pqEb3O+7eJ3tDiXPVRXj0oYHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdekaZjMkHy9IKCczDXGyMHp2HKM+g+IPk4NYztYgTPZfk6NuJ+9Uvd7tq9thCEuw4oK0at+24eiuHSXMqljfz54f4yww8lN6XqhfPRQMHVDV00e6+z+NiNty9hSebrQVjUfBT17eLt8Ssjb+XoBsR7rdZdjgZyUDTjOFN+1ItY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRYWWgdo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7EBC4CEF7;
	Thu, 13 Nov 2025 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763060507;
	bh=oDRRct8+8e6d4sESV9pqEb3O+7eJ3tDiXPVRXj0oYHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRYWWgdoyK2Dmc0eMVR+VL0/Vx4QMjFcxrj04kxA/BT4Lt61IAlsv99RJPGUKKhff
	 eEjsWbyKvdZsFnKoyMY844jlKQy9iSsnUFNznMjCBoBDKNZcZnL979tB9c+Q2cCJRe
	 UkPfJtmfbwO+Ovz0DNsbRyI7yXvXQgBHp6oRyzItZVPcCq5hv0ilCmLlGYjM2vYY2H
	 9kFD7vF2dX66DyAX6EDbh534uwno29thYSmTgZW6uHRa/VBfgzSOmhkNGiKW92hnuM
	 LHyS+0QxIV/rLr9DCrC/Q/B7m5wvTDxD4yYMAnfARapORcVrQaIweqF9j+DeGp74/E
	 9ztwxzRv30XBg==
From: Catalin Marinas <cmarinas@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	nd <nd@arm.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	maz@kernel.org,
	oliver.upton@linux.dev,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	lpieralisi@kernel.org
Subject: Re: (subset) [PATCH v3 0/5] arm64/sysreg: Introduce Prefix descriptor and generated ICH_VMCR_EL2 support
Date: Thu, 13 Nov 2025 19:01:00 +0000
Message-ID: <176306037418.2469077.5379528252615859360.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022134526.2735399-1-sascha.bischoff@arm.com>
References: <20251022134526.2735399-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Catalin Marinas <catalin.marinas@arm.com>

On Wed, 22 Oct 2025 13:45:35 +0000, Sascha Bischoff wrote:
> This series introduces support for conditional field encodings in the
> sysreg description framework and migrates the vGIC-v3 code to use
> generated definitions for ICH_VMCR_EL2, in part as an example of how
> the Prefix descriptor can be used. In addition, it fixes an issue with
> the tracking of incomplete system register definitions.
> 
> Together, these patches complete the migration of ICH_VMCR_EL2 to the
> sysreg framework and establish the infrastructure needed to describe
> registers with multiple field encodings.
> 
> [...]

Applied to arm64 (for-next/sysreg), thanks!

[1/5] arm64/sysreg: Fix checks for incomplete sysreg definitions
      https://git.kernel.org/arm64/c/0aab5772a53d
[2/5] arm64/sysreg: Support feature-specific fields with 'Prefix' descriptor
      https://git.kernel.org/arm64/c/fe2ef46995d5
[3/5] arm64/sysreg: Move generation of RES0/RES1/UNKN to function
      https://git.kernel.org/arm64/c/a0b130eedde0
[4/5] arm64/sysreg: Add ICH_VMCR_EL2
      https://git.kernel.org/arm64/c/a04fbfb8a175

I left the last patch to Marc/Oliver.

-- 
Catalin


