Return-Path: <kvm+bounces-17150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D79328C1CF0
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 05:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7ACCAB22373
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 03:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166C51494A6;
	Fri, 10 May 2024 03:18:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80557148FE0;
	Fri, 10 May 2024 03:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.216.63.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715311137; cv=none; b=u+rWnB+u6IN6zboTPMN3ROO1yrRiL0LJK1VLnAqq3/ICVbJB8JEoo3jPaLoBqv7h1T/aNpy0IUlnF0j7i0qHgcFxSv52h6WRO860H9+47zV2/a6AeH7EXbfBS0lFdptucIvFQplD3tqWe3YhnU7ZLssaMJPfqP6jKlBY8LlsETM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715311137; c=relaxed/simple;
	bh=IleNnU39C17nvFTpv4osFYDq9Q9V++izKYBe/MFz3KA=;
	h=Date:Message-ID:In-Reply-To:References:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=OdOl5h8ERD7Su9xpmCXEtuNJcjLg7YAg0JDrCRH4xmg4BFsXpw/RNCC0hvTnmSc2jMbvPf/tFQLUL92Fq2JgayKqhNPCqq6zo2bg9q/zE4DEyjH1I4yMckQr6wEAHxWDy9zXhIDNOKcC4iiYX4mrz1Xxg96MqIz9L+xZJoV/vRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=63.216.63.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4VbDcP5N6Qz8XrX5;
	Fri, 10 May 2024 11:18:45 +0800 (CST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4VbDc43SlHz4x6CW;
	Fri, 10 May 2024 11:18:28 +0800 (CST)
Received: from szxlzmapp06.zte.com.cn ([10.5.230.252])
	by mse-fl1.zte.com.cn with SMTP id 44A3IKWP090570;
	Fri, 10 May 2024 11:18:20 +0800 (+08)
	(envelope-from cheng.lin130@zte.com.cn)
Received: from mapi (szxlzmapp03[null])
	by mapi (Zmail) with MAPI id mid14;
	Fri, 10 May 2024 11:18:22 +0800 (CST)
Date: Fri, 10 May 2024 11:18:22 +0800 (CST)
X-Zmail-TransId: 2b05663d91feffffffff9e9-e8514
X-Mailer: Zmail v1.0
Message-ID: <20240510111822405PCAy6fW8F_-AfMPoCfT8u@zte.com.cn>
In-Reply-To: <Zjzkzu3gVUQt8gJG@google.com>
References: ZjuhDH_i9QWL4vyz@google.com,202405091030597804KUqLDPPj2FpTIBrZZ5Eo@zte.com.cn,Zjzkzu3gVUQt8gJG@google.com
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
X-MAIL:mse-fl1.zte.com.cn 44A3IKWP090570
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 663D9215.001/4VbDcP5N6Qz8XrX5

> > > From: seanjc <seanjc@google.com>
> > > > From: Cheng Lin <cheng.lin130@zte.com.cn>
> > > >
> > > > Introduce vm's max_halt_poll_ns and override_halt_poll_ns to
> > > > debugfs. Provide a way to check and modify them.
> > > Why?
> > If a vm's max_halt_poll_ns has been set using KVM_CAP_HALT_POLL,
> > the module parameter kvm.halt_poll.ns will no longer indicate the maximum
> > halt pooling interval for that vm. After introducing these two attributes into
> > debugfs, it can be used to check whether the individual configuration of the
> > vm is enabled and the working value.
> But why is max_halt_poll_ns special enough to warrant debugfs entries?  There is
> a _lot_ of state in KVM that is configurable per-VM, it simply isn't feasible to
> dump everything into debugfs.
If we want to provide a directly modification interface under /sys for per-vm
max_halt_poll_ns, like module parameter /sys/module/kvm/parameters/halt_poll_ns,
using debugfs may be worth.
Further, if the override_halt_poll_ns under debugfs is set to be writable, it can even
achieve the setting of per-vm max_halt_poll_ns, as the KVM_CAP_HALL_POLL interface
does.
> I do think it would be reasonable to capture the max allowed polling time in
> the existing tracepoint though, e.g.
Yes, I agree it. 
It is sufficient to get per-vm max_halt_poll_ns through tracepoint if KVP_CAP_HALL_POLL
is used as the unique setting interface.

Do you consider it is worth to provide a setting interface other than KVP_CAP_HALL_POLL?

