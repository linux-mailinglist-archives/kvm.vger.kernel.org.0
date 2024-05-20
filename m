Return-Path: <kvm+bounces-17760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2AA8C9D2A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BFE51C21ECC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A6956760;
	Mon, 20 May 2024 12:26:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx314.baidu.com [180.101.52.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8543153E3D
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 12:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716207961; cv=none; b=GfDXXZKMFUmLUkoJUm/QZ0egm/C3pRQSDJHBXZs25ie/Ai/W0SrpD27XMR7xjnJaMPlJVn8hom8DLXnhNHVMhqDH+Q49bgE4AbHwpQq+DGb45R5SmxXsl6jSWW0fge+4nNEVVB+sVpjhuRzE0HVVnQQeOJUvF4jg3zFr9t/+bHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716207961; c=relaxed/simple;
	bh=SaQsi/c6OIaccgd4DL6Fzj7L7E7N0I3JG/mNdItCwCA=;
	h=From:To:Cc:Subject:Date:Message-Id; b=mVsOkneFKlM8hqKl845KbjLUza+7r+spZ6txrRqOVa1JiOcI2UjQGQsit1pYYG6Oh44a/J4Ynq86kQlBmwwWi+KuTTuxT6/Mj1buk+qs7oa47j3sINM5F7GwUQICCSEAoYUAmhxZqQZ1G+xriurXS7VKLz9DLstBcCAL7P+jZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id BA0757F0005C;
	Mon, 20 May 2024 20:09:00 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	yosryahmed@google.com,
	pgonda@google.com
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v3 0/3] KVM: SVM: refine snp_safe_alloc_page() implementation
Date: Mon, 20 May 2024 20:08:55 +0800
Message-Id: <20240520120858.13117-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This series include three changes for snp_safe_alloc_page:
1. remove useless input parameter
2. not account memory allocation for per-CPU svm_data
3. Consider NUMA affinity when allocating per-CPU save_area

Diff V3: rebase
Diff V2: remove useless input parameter and not account per-CPU svm_data

Li RongQing (3):
  KVM: SVM: remove useless input parameter in snp_safe_alloc_page
  KVM: SVM: not account memory allocation for per-CPU svm_data
  KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area

 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/sev.c    |  6 +++---
 arch/x86/kvm/svm/svm.c    |  8 ++++----
 arch/x86/kvm/svm/svm.h    | 18 +++++++++++++++---
 4 files changed, 23 insertions(+), 11 deletions(-)

-- 
2.9.4


