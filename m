Return-Path: <kvm+bounces-37843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F389A30AD9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E82AD3A3C8D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885DB1F9A95;
	Tue, 11 Feb 2025 11:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4h74rka"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DEA1EEA38;
	Tue, 11 Feb 2025 11:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739274973; cv=none; b=gws64HvLTNe0gab0Rn062+mussUVgWDUviRQlezSUTqDWDoFm+e3i/82x+ZmbxaXWv1FbyCNkpbykyJsAbZcFEy1bih0RZrusf+m7zLJJf9+PT+SOqndRMUwnG628qJqEUbcsg13bBP6pY+ENdDc7NnohmFCnVYesZa/ZDdAPFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739274973; c=relaxed/simple;
	bh=vqQ+kZkktSUzfHi4PPu4xV47PiL3v0xitLfIzMdRc4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ijDMJNIN6ePLdOqyG92uJ+jbntCZXNPSgwuUyEz3CSzP9Nk5cSq7HPF/3x9jC9veE1IyIBeLbuANDAlkqXmi38N9833m+ue62uUkJdwPMvY1fBTlQjZn6Slju5uMRmchdaWtMVuvhKfiaunETE6i+eoqer55R18ihBN/71Yc4Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4h74rka; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB4AC4CEE6;
	Tue, 11 Feb 2025 11:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739274973;
	bh=vqQ+kZkktSUzfHi4PPu4xV47PiL3v0xitLfIzMdRc4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4h74rka0pDTk9QHYyrofCKJegWjerIIfJ0iLB7WMHXMKeoJjUB/SjN1wP211ZICa
	 7agyAoxb2YO4w44SaHpy62V6tJqZLlX2ZSr822ElNsmR3jtptHmZ5LET2wFiNhv0I0
	 7YNlaLEytL/qlvmU+HsxWH2pxOWJf8Jw3hHiqMSOgXUCS+3uVGF+3/+WrsB5gHqSRY
	 7p4SuUou/I1Av8wBH23qGwHJ4FGD9y3WPCA78ZanI/rCipVcBR45sYmTVONNQPyepz
	 8O+jtR8jq92dT0F+YCeSWztVUJJ3HEpa37Co9Y5rsoC0mcWlfAqno+nJW1e+SXW5/f
	 B26in/NhMKylw==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	apatel@ventanamicro.com,
	andrew.jones@linux.dev,
	andre.przywara@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool v1 0/2] Error handling fixes
Date: Tue, 11 Feb 2025 11:56:06 +0000
Message-Id: <173927325831.2097843.13985921488166849200.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250120161800.30270-1-alexandru.elisei@arm.com>
References: <20250120161800.30270-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 20 Jan 2025 16:17:58 +0000, Alexandru Elisei wrote:
> Two fixes for how kvmtool handles errors, both found while working on
> integrating kvmtool with the kvm-unit-tests automatic test runner (patches
> incoming).
> 
> The first patch is needed so kvm-unit-tests can detect when a test failed.
> 
> The second is just to make it easier to interpret a particular error message.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/2] Propagate the error code from any VCPU thread
      https://git.kernel.org/will/kvmtool/c/6e0b71815a63
[2/2] Do not a print a warning on failing host<->guest address translation
      https://git.kernel.org/will/kvmtool/c/4c4191b113c1

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

