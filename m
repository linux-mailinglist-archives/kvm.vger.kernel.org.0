Return-Path: <kvm+bounces-36029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C486A16FFA
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 907DB3AA207
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0939B1EBA07;
	Mon, 20 Jan 2025 16:18:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5284D1E32D7
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389918; cv=none; b=ZLnEVYPd+XLFdRqiyemg9q6dEDXxFU3zVl+i79N5h6SEE3tEj4Vko4lwJtEV4dOiswu7o0Cy3ErwnP32bJPyu3xkpjG9ELn0xnzyKa98xCPHhxORd5eyoGsUYL9Si6ODvqxwwgwALWfpzpqjoOKGCT4g+8wYHc8aqbp8/GhP2Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389918; c=relaxed/simple;
	bh=vmWp/d3ggKFMlfuH8NdzhF5Bt/Nf1IIfjVydr8sC11E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VIG3kpZyjM1TAUBqmdZJlRZU3bPE1kb1a/J8f0yQ7gzX22WnbAZXRE+d5hZVazKRZu+4nOEF8S6beFsbgeZVjz7SyXo2hnn7lixAc7kuubqv0qUAC32DsqVQ2IzJl/jow1S7vDCrjTvuO7UxWl+hAIz+WfaB3mtOPUijudpLQ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74DD21063;
	Mon, 20 Jan 2025 08:19:00 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7C153F5A1;
	Mon, 20 Jan 2025 08:18:30 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: apatel@ventanamicro.com,
	andrew.jones@linux.dev,
	andre.przywara@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH kvmtool v1 0/2] Error handling fixes
Date: Mon, 20 Jan 2025 16:17:58 +0000
Message-ID: <20250120161800.30270-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two fixes for how kvmtool handles errors, both found while working on
integrating kvmtool with the kvm-unit-tests automatic test runner (patches
incoming).

The first patch is needed so kvm-unit-tests can detect when a test failed.

The second is just to make it easier to interpret a particular error message.

Alexandru Elisei (2):
  Propagate the error code from any VCPU thread
  Do not a print a warning on failing host<->guest address translation

 builtin-run.c         |  9 +++++----
 include/kvm/kvm-cpu.h |  2 +-
 kvm-cpu.c             | 17 ++++++++++-------
 kvm.c                 |  4 ++--
 4 files changed, 18 insertions(+), 14 deletions(-)


base-commit: 6d754d01fe2cb366f3b636d8a530f46ccf3b10d8
-- 
2.34.1


