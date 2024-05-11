Return-Path: <kvm+bounces-17246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 882A48C2F12
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 04:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E1D31F23719
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 02:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D0F225A2;
	Sat, 11 May 2024 02:34:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4828C79FD;
	Sat, 11 May 2024 02:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715394893; cv=none; b=aaE+2A+hy5EPrYXOsSnu5vPtVeqAu1QbzR+Zpvenf1iDU12P5aTBgWWDKw+aqv6Lgey/j36jWeNQqv0o3i79UgGvhH9Y7E6geG8taCaEVhWtG1iZWzV43Tu9Nt04CGDHcFxjDwJcL1QncbouypIGTEmBq9IIR0ZgcsUaz3XMT7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715394893; c=relaxed/simple;
	bh=br2//DU8hP7hyzoQzBUQ/HszYWYcrDUrwnDDw/G8xoM=;
	h=Date:Message-ID:In-Reply-To:References:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=acdUhTV62tGxGV2m/6e64E3TEOAX8V6ZWXIomCiQ85BIR44WWyyXPMD58JjJ7msLtXX9Qj5upncQsrt0xjKWd88sEhIiqZMEgD8HDK35kJ63h/pvLSdhEgiSXR529qEVHsyfkw8RU1rP9se4Bj6szJbthBTXQRdv28VCJPP1QL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4VbqbC073sz8XrX4;
	Sat, 11 May 2024 10:34:47 +0800 (CST)
Received: from szxlzmapp06.zte.com.cn ([10.5.230.252])
	by mse-fl2.zte.com.cn with SMTP id 44B2Yhj3022110;
	Sat, 11 May 2024 10:34:43 +0800 (+08)
	(envelope-from cheng.lin130@zte.com.cn)
Received: from mapi (szxlzmapp05[null])
	by mapi (Zmail) with MAPI id mid14;
	Sat, 11 May 2024 10:34:43 +0800 (CST)
Date: Sat, 11 May 2024 10:34:43 +0800 (CST)
X-Zmail-TransId: 2b07663ed943ffffffff903-37ce6
X-Mailer: Zmail v1.0
Message-ID: <202405111034432081zGPU1OUESImLVeboZ0zQ@zte.com.cn>
In-Reply-To: <Zj4qEG5QfbX4mo48@google.com>
References: Zjzkzu3gVUQt8gJG@google.com,20240510111822405PCAy6fW8F_-AfMPoCfT8u@zte.com.cn,Zj4qEG5QfbX4mo48@google.com
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
X-MAIL:mse-fl2.zte.com.cn 44B2Yhj3022110
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 663ED947.000/4VbqbC073sz8XrX4

> > > > > From: seanjc <seanjc@google.com>
> > > > > > From: Cheng Lin <cheng.lin130@zte.com.cn>
> > > > > >
> > > > > > Introduce vm's max_halt_poll_ns and override_halt_poll_ns to
> > > > > > debugfs. Provide a way to check and modify them.
> > > > > Why?
> > > > If a vm's max_halt_poll_ns has been set using KVM_CAP_HALT_POLL,
> > > > the module parameter kvm.halt_poll.ns will no longer indicate the maximum
> > > > halt pooling interval for that vm. After introducing these two attributes into
> > > > debugfs, it can be used to check whether the individual configuration of the
> > > > vm is enabled and the working value.
> > > But why is max_halt_poll_ns special enough to warrant debugfs entries?  There is
> > > a _lot_ of state in KVM that is configurable per-VM, it simply isn't feasible to
> > > dump everything into debugfs.
> > If we want to provide a directly modification interface under /sys for per-vm
> > max_halt_poll_ns, like module parameter /sys/module/kvm/parameters/halt_poll_ns,
> > using debugfs may be worth.
> Yes, but _why_?  I know _what_ a debugs knob allows, but you have yet to explain
> why this
I think that if such an interface is provided, it can be used to check the source of
vm's max_halt_poll_ns, general module parameter or per-vm configuration.
When configured through per-vm, such an interface can be used to monitor this
configuration. If there is an error in the setting through KVMCAP_HALL_POLL, such
an interface can be used to fix or reset it dynamicly.
> General speaking, functionality of any kind should not be routed through debugfs,
> it really is meant for debug.  E.g. it's typically root-only, is not guaranteed
> to exist, its population is best-effort, etc.
> > Further, if the override_halt_poll_ns under debugfs is set to be writable, it can even
> > achieve the setting of per-vm max_halt_poll_ns, as the KVM_CAP_HALL_POLL interface
> > does.
> > > I do think it would be reasonable to capture the max allowed polling time in
> > > the existing tracepoint though, e.g.
> > Yes, I agree it.
> > It is sufficient to get per-vm max_halt_poll_ns through tracepoint if KVP_CAP_HALL_POLL
> > is used as the unique setting interface.
> >
> > Do you consider it is worth to provide a setting interface other than KVP_CAP_HALL_POLL?

