Return-Path: <kvm+bounces-64971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59EC7C9537E
	for <lists+kvm@lfdr.de>; Sun, 30 Nov 2025 19:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB3EA3A2331
	for <lists+kvm@lfdr.de>; Sun, 30 Nov 2025 18:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019582C0F75;
	Sun, 30 Nov 2025 18:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WpqCaTIU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7BE277017;
	Sun, 30 Nov 2025 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764528236; cv=none; b=X/FtZ5BQDREER2jZs6fk2EdAvTgqyeMCU5FBzakblEdnyAotSUc6CLi4SFjCCAzgPchsDLzabMWdfcQ59JJRd5vKPlb5lxOj4qkjrDg3YD5W57cOnPojaGrsosrx1/DfolZpBLDV99zN2QahG6OumOitU+oZ893GLbda7Cj7mYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764528236; c=relaxed/simple;
	bh=3wzaTF12L/K5kVKnD9SvmAThJcX37SwO5WcR8vEwQdE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=TQmrel69QBjb6Y25aX4e8xfi2BWxpuSOGKEufoGMp2LFuInxUEeeBdUKGwfe/Up1IJgJGfwsYwewDoKUpDWAj57ZzkI/Jqh5pRlRjmYAe3Q6/N/vQRt7Wbit+WaCMwzpC7NjUGeTVwg5Gus4pdjZqkLDjyDIQyu62tq86mGKcqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WpqCaTIU; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AUIgTJo503219
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 30 Nov 2025 10:42:30 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AUIgTJo503219
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1764528151;
	bh=3wzaTF12L/K5kVKnD9SvmAThJcX37SwO5WcR8vEwQdE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=WpqCaTIUQFc3+a84lBsNTIuK34BocE4I0sZlPkDUt9+A7DeHM0Q2ajsD9lpxwM2CL
	 lbzzR/bPCXrhuy1vyKW6UGbaPVnBkN0JVGJ9aJqsBGLYmN89p4fcYtyb+pVZOfRaR7
	 wne0W7Ro7bIDcRLVgRPoDavzPRcqYf35cDRIr4DCdz3RHLVJbztvOjTfIDCzdic9+8
	 eKz//lpbNcOnk843s/WW1pgORYNgMzmIar0zBHuwqzarEO2uKo3Kj73VyQZO9rrr/0
	 4xqw0wWYtX1YlaLie1HR0gt15qklcwjuKZ5tQkHjmJaspCe1Oq3cBeOkpt88uxjF3a
	 riKK8PpXS3HnA==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v9 16/22] KVM: VMX: Dump FRED context in dump_vmcs()
From: Xin Li <xin@zytor.com>
In-Reply-To: <aR10b/+lTzZHIyLn@intel.com>
Date: Sun, 30 Nov 2025 10:42:19 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CADC0E43-9B2A-4F07-A9B5-78C49AEE5533@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-17-xin@zytor.com> <aR10b/+lTzZHIyLn@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)


>> Add FRED related VMCS fields to dump_vmcs() to dump FRED context.
>=20
> Why are SSPx not dumped?

Good eye!

It needs extra logic to extract FRED_SSP0, and I=E2=80=99m a bit lazy to =
do it now ;)


