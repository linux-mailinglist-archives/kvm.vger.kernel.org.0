Return-Path: <kvm+bounces-5145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC5581CAC4
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 234471F23160
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBC01A58A;
	Fri, 22 Dec 2023 13:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkqCBW5j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52530199A1;
	Fri, 22 Dec 2023 13:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E251C433C7;
	Fri, 22 Dec 2023 13:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703252052;
	bh=GZRyFaBvIki9enXYb02TS6Skv6X1UKUdbbABm1/fk0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AkqCBW5jHwKr0qg0d1HQtPBtyYpaHQ7dXBxzXkxSxct+ynJ66ix/LUUV5NdFVrBQu
	 g9oKHJcwQ5ZE07DgFziLidBzPE/W1d5Z6CJIjnMQBfM0s2m3gWTuPVYBXqp45+30Wj
	 CCX5Ew+ipsf8dERprkKM4YGWZhXS3ZNtFUfnNj3Rm/fGIhzEGik9gfr0Y5miJ35P4w
	 RMgQrrGWb3MtxnFx1o86bdKKzr7OmuCvswr9OtTB/318Sy+AH6vqaGh4K+C9ZERk2h
	 2JUzdRMtd2ekzTTh5dc0Y5zhv/cI/FfTl8Q/ibUtmLAlOfB6Ew4N1pEjV/E2QliFbD
	 1/kYvaSLDGofw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rGffF-006Jtc-P6;
	Fri, 22 Dec 2023 13:34:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 22 Dec 2023 13:34:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini
 <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
In-Reply-To: <ffbca4ce-7386-469b-952c-f33e2ba42a51@sirena.org.uk>
References: <ZYCaxOtefkuvBc3Z@thinky-boi>
 <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
 <69259c81441a57ceebcffb0e16895db1@kernel.org>
 <ffbca4ce-7386-469b-952c-f33e2ba42a51@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <441ff2c753fbfd69a60e93031070b09e@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: broonie@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-12-22 13:26, Mark Brown wrote:
> On Fri, Dec 22, 2023 at 01:16:41PM +0000, Marc Zyngier wrote:
> 
>> > Oliver, should your tree be in -next?
> 
>> No, we don't have the KVM/arm64 fixes in -next.
> 
> I see it's not, I'm asking if it should be - given the latencies
> involved it seems like it'd be helpful for keeping -next working.

This is on purpose. We use -next for, well, the next release,
and not as a band-aid for some other purpose. If you think things
don't get merged quickly enough, please take it with the person
processing the PRs (Paolo).

> 
>> And we have another two weeks to release, so ample amount of
>> time until Paolo picks up the PR.
> 
> Sure, but we do also have the holidays and also the fact that it's a
> build failure in a configuration used by some of the CIs means that
> we've got a bunch of testing that simply hasn't been happening for a
> couple of weeks now.

Given that most of the KVM tests are usually more broken than
the kernel itself, I'm not losing much sleep over it.

         M.
-- 
Jazz is not dead. It just smells funny...

