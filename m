Return-Path: <kvm+bounces-16970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C61058BF638
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03FC11C22625
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A310B2BB00;
	Wed,  8 May 2024 06:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vh1PdP00"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED0117BCB
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 06:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715149547; cv=none; b=Zyy3kKCpqCzpZtDVSMwc+hlI7rr80oZPFo1xuI8GpJ+weGAK59gc4yiFHILsDYYt99P6EfzGgb8zXeRiX6ZqGbR++Es1WJRhgieo53m223R7OQL/LUNJDEUxyzDSJSsLzfQSp5x3fAkPschhAnc1PgqKf0o++NHINmPAZmX3He4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715149547; c=relaxed/simple;
	bh=0yTnDzRzl6YMEDAYdK4MzUFIs1RryobdwGldopgZgrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zp9BSvDDidUUk7aaTCpdSus+LxJR4GC8JzFd7oecxZ8dEJDHnS0lWXylUG+1s2ibx75EukXPVEJudfjQve3KoM9gOF4Oa5wQ/Znvl6/cupynm8HONuK0mnjKdPu0mnldp1ed9fY7tBT315d6LN5cwuFQOjw9kto/En012TO9weo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vh1PdP00; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 8 May 2024 06:25:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715149544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cX9UDFEcMUiOwQWR3+txM6O/c7psSYzDc8seRaVOFUA=;
	b=Vh1PdP00Hz0dsjoJ8XSe+qAtpu16Gl/4TaRhsPZ3AnqRi04QNU82oEK7OXqFZH7NOcVwXg
	7Ua/e5i8KWFXYzf9bVHTz+fHUkVvEm217ZgRHX9ISZtqa/oPPeSwyVV/0Sc2h1xdGJSLkt
	wLnhCNlaP/Y6fwqO9DMHaKu4KWAfCwQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
	shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.8 18/52] KVM: selftests: Add test for uaccesses
 to non-existent vgic-v2 CPUIF
Message-ID: <Zjsa4yeD_EmV7TgP@linux.dev>
References: <20240507230800.392128-1-sashal@kernel.org>
 <20240507230800.392128-18-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507230800.392128-18-sashal@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi,

On Tue, May 07, 2024 at 07:06:44PM -0400, Sasha Levin wrote:
> From: Oliver Upton <oliver.upton@linux.dev>
> 
> [ Upstream commit 160933e330f4c5a13931d725a4d952a4b9aefa71 ]

Can you please drop this and pick up the bugfix instead?

6ddb4f372fc6 ("KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()")

-- 
Thanks,
Oliver

