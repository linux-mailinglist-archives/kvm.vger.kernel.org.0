Return-Path: <kvm+bounces-5989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49AF08297F4
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 11:49:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 718471C218D4
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 10:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22622481C3;
	Wed, 10 Jan 2024 10:47:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374AE4176B
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 10:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: Shiyuan Gao <gaoshiyuan@baidu.com>
To: <gaoshiyuan@baidu.com>
CC: <kvm@vger.kernel.org>, <mtosatti@redhat.com>, <pbonzini@redhat.com>,
	<qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: limit the maximum CPUID.0xA.edx[0..4] to 3
Date: Wed, 10 Jan 2024 18:13:17 +0800
Message-ID: <20240110101317.46344-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230602073857.96790-1-gaoshiyuan@baidu.com>
References: <20230602073857.96790-1-gaoshiyuan@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BC-Mail-EX08.internal.baidu.com (172.31.51.48) To
 bjkjy-mail-ex26.internal.baidu.com (172.31.50.42)
X-FEAS-Client-IP: 172.31.51.22
X-FE-Policy-ID: 15:10:21:SYSTEM

Anyone has suggestion?

When the host kernel before this commit 2e8cd7a3b828 ("kvm: x86: limit the maximum number of vPMU
fixed counters to 3") on icelake microarchitecture and newer, execute cpuid in the Guest:

Architecture Performance Monitoring Features (0xa/edx):
    number of fixed counters    = 0x4 (4)

This is not inconsistent with num_architectural_pmu_fixed_counters in QEMU.

