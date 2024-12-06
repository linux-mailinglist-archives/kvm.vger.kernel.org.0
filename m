Return-Path: <kvm+bounces-33214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B74579E750A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0319A161F4A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 16:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5361B20C01A;
	Fri,  6 Dec 2024 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="I572kRLj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D4BA20
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733500933; cv=none; b=k1aKHL6CDqQB9yCTWLwnS/X1JU9NyAbFlYBZXNjVj3qy6IIs3jbfONgFKxuEjsr0x1IudYNsGEq2E0B2fQesR+t7+XOrFAkWnej9e5lwWzQ0HubVaR9zcSxzQM3/dYgjo4d5FWbqYGahrapEvT0y6oorZXruCZhduFfMvYEc3e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733500933; c=relaxed/simple;
	bh=/LUHfXUBfmlSCnUk1NQ1/+u4GZXnmY86u6m/eCWBhTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfg9W4NSuIOdbd/C0R83A6o8pFE4mHbeMwSQD5uickwd1KxAnSNJBtzNCbim2apcGxDUiP1SOfHaGdJHbapOYiAfS0XFlsM/AcWmaoR1U2CC019QCXcwtfwdrdeWdIEDQIKd0oe4ZH/TUlHXA2ciadyFeKrRXJqqavnxouCBDec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=I572kRLj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D5AF640E01A2;
	Fri,  6 Dec 2024 16:02:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id o4L2AvS5yxOc; Fri,  6 Dec 2024 16:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733500918; bh=7qwm3GdfmYClnvPh5qPE0AqhIcLFaqEvLPdb0JE4OKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I572kRLj06hRqvzXiuNQlLFAPyYJj0HZAzE73Gh9EkmPsV8XglgCHNDeara90uXb2
	 G07pHaRN5e9Ar5nag2KrtH7dsipXskdVDU23ZtKyWZwCKVJziQQBYHXv7Xk4Fz5S09
	 soROoqOtsyWASUMtpM5doVUl0cpyZ2R6CigbSHnJH4zL7Y3Ikrjagrc1Yrjg2/F59S
	 KGBF94aI03pLh3UlWUIOYpq2wJB3IJVqxHBqvz8UjC2xLXz6gDZi9OVHVM81zhkzrb
	 A8ssUAcbw3rSGxDLyYl9/E6oAo8IXLU7EfoYiqLeFrfHRXNxCXG3qUJWEDpyo8Ae6m
	 V0UW3aNsU2+MKpTb8r/+eQLUA3YCeS3NWZ5USsQk6b+QYDHTv8GdvonPWOvQv+oTNq
	 4k8CuagBKqTimI7rqvkmoBJXKXikuHqkpZePtoig9iofrp+K8sHUjuIQ9Hu2NOJjNS
	 s3jYgkJLgZW90siw5ecnP6XU2zwuiisaz/3ehU/z+YbkXCKUkIOjkyYCdehUjfDQSN
	 3ziiBKBbzW2iFiIVXU68MTu55trzPqKvzHkr2MLeCoKAUsNIDxA7iJ++Pvxfgx8V3s
	 jpZAXyuTPSSjQYu8I4+1k852ovpPPYNU84fqFt6BSWCYMYi76t9BJWC1pj6tqBkcyl
	 RcPtCpCfMo5ZByT8hXJgOJHc=
Received: from zn.tnic (p200300Ea971f939c329C23FFFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:939c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C3CA640E0269;
	Fri,  6 Dec 2024 16:01:51 +0000 (UTC)
Date: Fri, 6 Dec 2024 17:01:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, jmattson@google.com, Xin Li <xin@zytor.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in
 kvm_x86_ops
Message-ID: <20241206160144.GBZ1Mf6OHq8DCFStL5@fat_crate.local>
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-13-aaronlewis@google.com>
 <Z0eV4puJ39N8wOf9@google.com>
 <20241128164624.GDZ0ieYPnoB4u39rBT@fat_crate.local>
 <Z09gVXxfj5YedL7V@google.com>
 <20241205180608.GCZ1HrkLq2NQfpNoy-@fat_crate.local>
 <Z1MW__KcGo-QyDtc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z1MW__KcGo-QyDtc@google.com>

On Fri, Dec 06, 2024 at 07:23:43AM -0800, Sean Christopherson wrote:
> Are you trying to apply this patch directly on kvm/next | kvm-x86/next?  This is
> patch 12 of 15.

Oh, that's why. I thought it is a single, standalone patch, being called
0001-tmp. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

