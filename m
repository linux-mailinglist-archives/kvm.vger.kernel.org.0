Return-Path: <kvm+bounces-68728-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cD06GN/rcGk+awAAu9opvQ
	(envelope-from <kvm+bounces-68728-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:08:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA7558F4B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 80888A0C791
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA5648C3F6;
	Wed, 21 Jan 2026 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="XyP2x8F6"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579FF269811;
	Wed, 21 Jan 2026 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.57.120.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769003887; cv=none; b=HjbOihxNI+NkjjYhKHz3Ck51oqksxTkLVgd1PvaJQ7sMKSWcLkuUSHjBP05rUOpGq9ez5dkdCDYyxDU5wU9E3uIuXiUIbWfvjFO7ems8mISNymTWg9n/K2Ggt76kxmLV6/Wl0xaVvw1ondge3Cxwe4oy+B0S1GkeCsVf5Agxs/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769003887; c=relaxed/simple;
	bh=89M39Kki2E06BqFpd/hc0HReSpIPWWO32V+PPC5e5h8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwqMOANY1sP57dsgWBdMCx1sc9FdwjpJ0WnBTL3hchWwSd+F/f4/NDAwp/QqcvFIVQ7YoMDlUR9jca5/PvgxJkyBPM4xBIkduNsWvp4yWotg2J/vxDyMbC3AYDLDDdml/aFG/3MCOHRE5s3gAtHjljrUaDDKOZYtWvL0855+bQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=XyP2x8F6; arc=none smtp.client-ip=52.57.120.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1769003885; x=1800539885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=89M39Kki2E06BqFpd/hc0HReSpIPWWO32V+PPC5e5h8=;
  b=XyP2x8F6gfC6sLWKzf/21yKT0h4BmlPIBjfDJD5qoGSUYbttEI0rnxel
   bzOCHJ4eauWDy3Tc1OXNiCI2EzrkBYEu8KtBXKttztxNUA2nrnnlZJC+2
   UfgciVNVWUu+/WGYrmsNq0EGgB+n7UKSFeT+bETJTtCrjy+vr4aTPCDe6
   PcWoK7f7zwvVgHKSljVkKnJJ96qinlcHmPrSB0bVF8Ru1almZbzH38X7U
   isXaY6CQcMN1Do7zQ8pMlnEEyplXEz86azOBTOTyHN9kjjgvyOFZVKuH0
   Ue3gTXLCRbZ/QiCMKXwanp9bICWWhaJlFlkogpy3N3QqHh7wTe4b3XG37
   Q==;
X-CSE-ConnectionGUID: 1l+8TWG3SFmIUEjO9TvkmQ==
X-CSE-MsgGUID: MtoxTnH+QhedP6ao+2Zi2g==
X-IronPort-AV: E=Sophos;i="6.21,242,1763424000"; 
   d="scan'208";a="8127399"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 13:57:47 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:4201]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.54:2525] with esmtp (Farcaster)
 id 177d1623-b088-4bdc-8cf7-d9ab759f06c3; Wed, 21 Jan 2026 13:57:46 +0000 (UTC)
X-Farcaster-Flow-ID: 177d1623-b088-4bdc-8cf7-d9ab759f06c3
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 21 Jan 2026 13:57:38 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.108) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 21 Jan 2026 13:57:29 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <dwmw2@infradead.org>, <peterz@infradead.org>, <seanjc@google.com>
CC: <abusse@amazon.de>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hborghor@amazon.de>, <hpa@zytor.com>, <jschoenh@amazon.de>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
	<nh-open-source@amazon.com>, <nsaenz@amazon.com>, <pbonzini@redhat.com>,
	<sieberf@amazon.com>, <stable@vger.kernel.org>, <tglx@linutronix.de>,
	<x86@kernel.org>
Subject: Re: [PATCH v2] perf/x86/intel: Do not enable BTS for guests
Date: Wed, 21 Jan 2026 15:57:13 +0200
Message-ID: <20260121135713.214711-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ff49b3013a4ff7626c6f6ac574f85348c35ccc42.camel@infradead.org>
References: <20251210111655.GB3911114@noisy.programming.kicks-ass.net> <20251211183604.868641-1-sieberf@amazon.com> <ff49b3013a4ff7626c6f6ac574f85348c35ccc42.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-7.96 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[amazon.com,quarantine];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68728-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_NEQ_ENVFROM(0.00)[sieberf@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0FA7558F4B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Peter,

Could you please take another look and see if you are happy to pull in v2 which
implements the approach that you suggested?

Thanks,

--Fernand



Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


