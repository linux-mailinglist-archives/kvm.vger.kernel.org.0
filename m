Return-Path: <kvm+bounces-38616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1D9A3CD4E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73832176029
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3F2214A7C;
	Wed, 19 Feb 2025 23:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gk7kc1I1"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC171DE883
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 23:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007182; cv=none; b=fUOfzDxwHU/1JljENKdLpIJM5L4+A5vWVD9zNeUeJBaw+CQ3v/Yv2NFY5m+EWj5t/Im7dsiVtZNnurNiPpHtSYo/lsCeJKWBLEbNuwJCpiE1vbj+ujw9p6fvzJeeEQXjOZXbC7J9DjMfCyOF7OxbgXrqiK1qekJUZ9N4Y9lNPwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007182; c=relaxed/simple;
	bh=O07bv4al2lH3D6yFE3t26uKbSZTZGVw79c0MQqtfdWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3BemQ5uEZJU9pcsYx0b2RQFDal1t9AcCNBAz3BIhFeBOisjKSMNcaAy79W4LkIJ6zmwuYcJ/olWOdr9X8x9cvYteyyPHWsdZ2V5ddnh65mRtiB1UOIU2daSB4oKxVhjpY8hMBZYy04THW0s73NUEbPEkpwji9piNkAwHXIc7pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gk7kc1I1; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Feb 2025 15:19:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740007179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KagvglZHupqGniUWXLUyr/N9cxv5t/e8DpCYVteqRYo=;
	b=gk7kc1I1O6oTn0eCT9zJmnuPN7tg+wSNX0oO/dv6TRU7OKCSIhapie8D7sPw0A922JNEr5
	xzEFD36nCDkGbUQYa7kQc4wh6VcJWlXWtpKP8DuRDFy63FxfU1kuVz3+BUqTA2R+SYh+8k
	rCDYlcapj2cry4xUSAlqmazWSQwRk0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 14/14] KVM: arm64: Document NV caps and vcpu flags
Message-ID: <Z7ZnB2z6psLcbfRZ@linux.dev>
References: <20250215173816.3767330-1-maz@kernel.org>
 <20250215173816.3767330-15-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215173816.3767330-15-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 15, 2025 at 05:38:16PM +0000, Marc Zyngier wrote:
> Describe the two new vcpu flags that control NV, together with
> the capabilities that advertise them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

