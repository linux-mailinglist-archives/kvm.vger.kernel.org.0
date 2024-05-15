Return-Path: <kvm+bounces-17416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2F78C5F92
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 06:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F07C1C215D2
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 04:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0111383AC;
	Wed, 15 May 2024 04:03:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B76381B9;
	Wed, 15 May 2024 04:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715745826; cv=none; b=KxMXq4et7UMtyq7IAI88PwGWpYG17Xz+3e6yyR5VCpdWT2MlzAYXvqqqyAy3V4DpAGpyk+cMaLDl8AaznWsyyk9q2TIhtGTSIW792EV7ktAMU2KTybr6odotlQH0qFNNpJRVt5NPgeOIq264g3qKXnfsn9dHI4H4H0uGyq5UneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715745826; c=relaxed/simple;
	bh=O88tAcTlnEuDEVNLDeD9ZcVV/l6h4nyW0awA4mXMQh8=;
	h=Date:Message-ID:In-Reply-To:References:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=YkfGRBbYWKtbb6fDS0m28LiYg/V1NzmWRTS5li3WdATcRVg863CBmUWLwD7w498wQvQ/EWA7bpOBLXdEzwYiXAmwJm3b+IJUkRx/5sFQpdPo1ROWRIXAfaHZGWxEspudiYWci1zl94nBU3chZyS0HD7GPzo3pXYeYhSM4GWYlos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4VfKMw1LbVz4xPBc;
	Wed, 15 May 2024 12:03:40 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
	by mse-fl2.zte.com.cn with SMTP id 44F43WO1087412;
	Wed, 15 May 2024 12:03:32 +0800 (+08)
	(envelope-from cheng.lin130@zte.com.cn)
Received: from mapi (szxlzmapp06[null])
	by mapi (Zmail) with MAPI id mid14;
	Wed, 15 May 2024 12:03:33 +0800 (CST)
Date: Wed, 15 May 2024 12:03:33 +0800 (CST)
X-Zmail-TransId: 2b0866443415ffffffffb5b-22ebd
X-Mailer: Zmail v1.0
Message-ID: <20240515120333724v7bc656U_mnZJaYDZd3vt@zte.com.cn>
In-Reply-To: <ZkPfB2VpGkRmMLsi@google.com>
References: Zj4qEG5QfbX4mo48@google.com,202405111034432081zGPU1OUESImLVeboZ0zQ@zte.com.cn,ZkPfB2VpGkRmMLsi@google.com
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
X-MAIL:mse-fl2.zte.com.cn 44F43WO1087412
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6644341C.000/4VfKMw1LbVz4xPBc

> > > Yes, but _why_?  I know _what_ a debugs knob allows, but you have yet to explain
> > > why this
> > I think that if such an interface is provided, it can be used to check the source of
> > vm's max_halt_poll_ns, general module parameter or per-vm configuration.
> > When configured through per-vm, such an interface can be used to monitor this
> > configuration. If there is an error in the setting through KVMCAP_HALL_POLL, such
> > an interface can be used to fix or reset it dynamicly.
> But again, that argument can be made for myriad settings in KVM.  And unlike many
> settings, a "bad" max_halt_poll_ns can be fixed simply by redoing KVM_CAP_HALL_POLL.
Yes, Whether it is convenient to redo it will depend on the userspace.
> It's not KVM's responsibility to police userspace for bugs/errors, and IMO a
> backdoor into max_halt_poll_ns isn't justified.
Yes, It's not KVM's responsibility to police userspace. In addition to depend on userspace
redo, it can be seen as a planB to ensure that the VM works as expected.

