Return-Path: <kvm+bounces-49643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD64BADBE01
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 150D13B6FF6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E65A16CD33;
	Tue, 17 Jun 2025 00:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="seeF3m3y"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93898EEDE;
	Tue, 17 Jun 2025 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750119542; cv=none; b=K7wdxpLzZZAR3mFhZURl9Y0FyS6h43HbjuTzTTSmaoXGB67+k27qtHgMvgEX9YgfrsPL5fwEhISWGQAokvakpZb4mouJ4SoOBmerYjmy06npjzPR582xR1K+M447aBU8R3C4zj2s074jFfr/aDFzT+x7OUEXG/5z/KaOQJhKp/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750119542; c=relaxed/simple;
	bh=wHwubcvxWKQy0krfNlspd/TVMyE2xEDWaDT/14aJ0xs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A0X/q7g7WPhNKKhqsYQL/GUv0D8H39ohO7LzSwg4tkoGFrBAdBkKVfyZ+xxlqVO79/VTJ7jaZk4LKnObD1MeG4+jZPbt4aqjJy1eW7r1D/Bki0XbNuVQcGJUvy7bJq781TeUNZ6yh61dhAx0x1DGiQg4yfcAE4zOioYptisuk/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=seeF3m3y; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=WGpF7Rn+xW3Vt3nzVj7bA/d7EoN0EMp0OrH8gZw+CFM=; b=seeF3m3yWmcYzDjs
	izx9zkvDCXZNyIdQJGBF1BLlJRLksjywcsFU4z4CpY4UA26elhhOODlX7NFQIHruzl0rTgdxEthNU
	XTGa5Aetx5ceYwiEALJ6a2a26tFZapluGah6fLlOFL5xiCst08ffuuHKY8Vv3viFnsOr+Gz/2xvpo
	7i+Bujcfyt3u8e65PYMJFBU0MrSaXGXqwdWJ1w9UBs0H3y3XafNxzXkS7Qw6OAc9bF1xgRlREw/u/
	UURkXM3OPmIWFt4INbs9OLtnz1xmiK1kVS0rwotWLb7LbX5mO4s9XV2RJYCEICdYvk69etMUdwghr
	MNAw/hfpNikpD72xgQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uRK2L-009znJ-0d;
	Tue, 17 Jun 2025 00:18:49 +0000
From: linux@treblig.org
To: mst@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH v2 0/2] vringh small unused functions
Date: Tue, 17 Jun 2025 01:18:35 +0100
Message-ID: <20250617001838.114457-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  The following pair of patches remove a bunch of small functions
that have been unused for a long time.

Dave

v2
  Remove the xfer_kern() and kern_xfer() helpers that are now
  unused. (As spotted by Simon's review)

Dr. David Alan Gilbert (2):
  vhost: vringh: Remove unused iotlb functions
  vhost: vringh: Remove unused functions

 drivers/vhost/vringh.c | 118 -----------------------------------------
 include/linux/vringh.h |  12 -----
 2 files changed, 130 deletions(-)

-- 
2.49.0


