Return-Path: <kvm+bounces-49084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D792AD5A9C
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 17:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F0433A7438
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C421DF74F;
	Wed, 11 Jun 2025 15:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRvKhwI6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF5156F45
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749656099; cv=none; b=gwRRCKHiaMnFXeDwmZocicjV+QaNkqwk9qRoBxudst8hhP4E9iertC3AyP/kTyJXufLbXoffrKxVeNBjRE6HSkJF/CPIC2D38zA1mjgRFTkDE3wWmqZH2xx/MpgApMuasco1HGABmNa+QsAxqsnPW8Z1qfqbjkyZaNnXZXgOV7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749656099; c=relaxed/simple;
	bh=oBXwFVsvxKQvihRYD+E/ypPjhW6UchvHo0fLopX35uQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lbYFZ+hirzcDNGqGPviBslnSHRydSHyAiR4eCa0eQTBFJiE7x69pueDMLthxlN/BRUdEBVlZaab1u6Ol8tI5kP0Xhrvh/6tgi6LrPMY/D6u5o8ByKqsJ7Q8lHPA0yhRNMknhPxHN3CXqVhESQjMGT09uMApLrLo7IhS2Rw6V7AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRvKhwI6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1698AC4CEE3;
	Wed, 11 Jun 2025 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749656098;
	bh=oBXwFVsvxKQvihRYD+E/ypPjhW6UchvHo0fLopX35uQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WRvKhwI6I48gXzxK9h+/KVI5tZy2oXezWEB/PPybMRKCG06rQ3Gg37iF+oUAgRM8+
	 3k1/nx5niTaGThuWk7LywmnH836QbxypOBywzCa+3c2LvYREIhfivEBSxaDIbV6sCi
	 R/4IKuCJ1ODo9Kh48yD0eH8poPQ8teov4jvIEAk5mP4yDzljhpBpNcpMGdAihJ/4xB
	 Jv60RQhKmng8ihFuY55/WYg6t7AxWDs+0X6UbfKetwn5Ev56j5nyRYJVTobx5JDvx7
	 1oGTd9IWAMCTTCa/xvk7EFU2csoGl0J4wdXLJ9UM/6DxHWD745MbMcEymXOlw2RI55
	 qUDUfnPg60WLw==
Date: Wed, 11 Jun 2025 21:04:10 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Disable PIT re-injection for all
 tests to play nice with (x2)AVIC
Message-ID: <mf25czbm6fyz7bdgbeecz7nizjmnhoahr3gvbzxyp2inutzeev@3xz54si5gbo6>
References: <20250603235433.196211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603235433.196211-1-seanjc@google.com>

On Tue, Jun 03, 2025 at 04:54:33PM -0700, Sean Christopherson wrote:
> Disable PIT re-injection via "-global kvm-pit.lost_tick_policy=discard"
> for all x86 tests, as KVM inhibits (x2)AVIC when the PIT is in re-injection
> mode (AVIC doesn't allow KVM to intercept EOIs to do re-injection).  Drop
> the various unittests.cfg hacks which disable the PIT entirely to effect
> the same outcome.
> 
> Disable re-injection instead of killing off the PIT entirely as the
> realmode test uses the PIT (but doesn't rely on re-injection).
> 
> Cc: Naveen N Rao <naveen@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/run           |  7 ++++++-
>  x86/unittests.cfg | 10 +++-------
>  2 files changed, 9 insertions(+), 8 deletions(-)

This is indeed much better, thanks!
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen


