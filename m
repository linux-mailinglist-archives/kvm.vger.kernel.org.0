Return-Path: <kvm+bounces-2717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F297FCD63
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 04:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E113A283436
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 03:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F716FB2;
	Wed, 29 Nov 2023 03:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+bnPFDP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97D71990
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 19:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701228096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qn+4k3AM11LFL57uM6GEUi282zVBW5ZFN35fzgUwu4s=;
	b=C+bnPFDP2uw4ccUsrIHLVYcDKAdJJHdQF6QMzz7UNSplEmvh5yt9VlHAuOEcIff+A91XQh
	gFg0gX2MtxJcUzEBzVxwCYXzaqAQzrvab9XDbKgpOXhL7epRnRkHA+W4Fz4BAx8N/93Phg
	69BHnx8530329ewjxPzFEJvdHrSirI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-rcYgkwPFP7mWc4xYumLwag-1; Tue, 28 Nov 2023 22:21:31 -0500
X-MC-Unique: rcYgkwPFP7mWc4xYumLwag-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0A6180F82F;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66AD7492BFE;
	Wed, 29 Nov 2023 03:21:30 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Nico Boehr <nrb@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Ricardo Koller <ricarkol@google.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v1 0/3] arm64: runtime scripts improvements on efi
Date: Tue, 28 Nov 2023 22:21:20 -0500
Message-Id: <20231129032123.2658343-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

When I run the arm64 tests on efi, I found several runtime scripts issues. This
patch series try to fix all the issues.

The first patch add a missing error reporting.

The second patch skip the migration tests when run on efi since it will always
fail.

The thrid patch fix the issue when parallel running tests on efi.

Shaoqin Huang (3):
  runtime: Fix the missing last_line
  runtime: arm64: Skip the migration tests when run on EFI
  arm64: efi: Make running tests on EFI can be parallel

 arm/efi/run          | 16 +++++++++-------
 scripts/runtime.bash |  7 +++++++
 2 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.40.1


