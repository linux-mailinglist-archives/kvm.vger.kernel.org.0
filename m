Return-Path: <kvm+bounces-17086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 119A78C0A53
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 06:02:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D744B21EE6
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 04:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD2D1482FE;
	Thu,  9 May 2024 04:02:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC817147C8B;
	Thu,  9 May 2024 04:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715227331; cv=none; b=hff6X4wqdOb6kKmodgtU1poqOfY6FfWVtEKKLWwvkz3sjlbRR63FbLuRXFvad/ImBOP1gzS71PMq23KswfpLY8AGNaKxXteAQjWTRxpuqc3PIBS8fR2X6pij1gt26Lt3hmFvmrYtjiT2ZyhZ4YhItqLJJi4+UHdcgrKWltKn8S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715227331; c=relaxed/simple;
	bh=48L2aqqLFVW7XU+gBbBWyvRk7z2MDQ5uEfpVBPdJmho=;
	h=Date:Message-ID:In-Reply-To:References:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=Xu/RmDIbTLmBMC/idmOPNlagHqOvo2YXu9Bj/yS5eWZtV/qNKC9svN1AnW2tAuTJirWPvQUM39l3KGx1D/DyAPmDrMWaljIxx8oOHaMdAOQCVV3+AN9WJ0gW14pEWWJqtXBJADsX2XA2vynColN+ALAHX6rCKJVgIZ0OF8pzoIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4VZdcs4h0mz8XrSB;
	Thu,  9 May 2024 12:02:05 +0800 (CST)
Received: from szxlzmapp05.zte.com.cn ([10.5.230.85])
	by mse-fl1.zte.com.cn with SMTP id 4492OwvM072423;
	Thu, 9 May 2024 10:31:16 +0800 (+08)
	(envelope-from cheng.lin130@zte.com.cn)
Received: from mapi (szxlzmapp03[null])
	by mapi (Zmail) with MAPI id mid14;
	Thu, 9 May 2024 10:30:59 +0800 (CST)
Date: Thu, 9 May 2024 10:30:59 +0800 (CST)
X-Zmail-TransId: 2b05663c356305b-30337
X-Mailer: Zmail v1.0
Message-ID: <202405091030597804KUqLDPPj2FpTIBrZZ5Eo@zte.com.cn>
In-Reply-To: <ZjuhDH_i9QWL4vyz@google.com>
References: 20240508184743778PSWkv_r8dMoye7WmZ7enP@zte.com.cn,ZjuhDH_i9QWL4vyz@google.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <cheng.lin130@zte.com.cn>
To: <seanjc@google.com>
Cc: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jiang.yong5@zte.com.cn>,
        <wang.liang82@zte.com.cn>, <jiang.xuexin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gS1ZNOiBpbnRyb2R1Y2Ugdm0ncyBtYXhfaGFsdF9wb2xsX25zIHRvIGRlYnVnZnM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 4492OwvM072423
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 663C4ABD.007/4VZdcs4h0mz8XrSB

> From: seanjc <seanjc@google.com>
> > From: Cheng Lin <cheng.lin130@zte.com.cn>
> >
> > Introduce vm's max_halt_poll_ns and override_halt_poll_ns to
> > debugfs. Provide a way to check and modify them.
> Why?
If a vm's max_halt_poll_ns has been set using KVM_CAP_HALT_POLL,
the module parameter kvm.halt_poll.ns will no longer indicate the maximum
halt pooling interval for that vm. After introducing these two attributes into
debugfs, it can be used to check whether the individual configuration of the
vm is enabled and the working value.
This patch provides a way to check and modify them through the debugfs.

