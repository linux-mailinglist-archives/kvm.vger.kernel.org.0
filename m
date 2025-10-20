Return-Path: <kvm+bounces-60562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 971B3BF2A72
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 19:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED31422D63
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 17:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075CB331A76;
	Mon, 20 Oct 2025 17:11:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02ECF17A2F0;
	Mon, 20 Oct 2025 17:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760980313; cv=none; b=gmHeRP1F5dF0CFITYHt0JbtpgKvNN2mYq7PePCQfE/+d3B+cO1DShFZibILyr6+GIS4SjcbUSIJeaKQmWn3dCf+5d5WP20gqqj07dO+2NXm9ELhppnaTK+cF8MIZkB8FAyCXhNmuGiUrgzjCMkRBatqt90wOiTqS6hRO5ic+ahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760980313; c=relaxed/simple;
	bh=KAlYS6zuzNONWFCiNofiPVTUIcr94HG5Jq+e/8sSYk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Ah6zai3mm5QvB6iWcbAu09/HFob22XfV4dnOPJqLhLHwCr2J32M6200ZgEC9+JKIviL6GP4ea7b0SECQ1No4EMZH1maB/wUKBnJJhLfoogY1z+MFrfkMlXKoGpU65dbxum4B/yvWEq+iig+FF86QJbuQ4k78kBQ2Msgt+7LBiI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78F471007;
	Mon, 20 Oct 2025 10:11:43 -0700 (PDT)
Received: from JFWG9VK6KM.emea.arm.com (JFWG9VK6KM.cambridge.arm.com [10.1.26.166])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC69D3F66E;
	Mon, 20 Oct 2025 10:11:49 -0700 (PDT)
From: Leonardo Bras <leo.bras@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] doc/kvm/api: Fix VM exit code for full dirty ring
Date: Mon, 20 Oct 2025 18:11:46 +0100
Message-ID: <aPZtUlTjEm5_bqDe@JFWG9VK6KM.cambridge.arm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <176097609826.440019.16093756252971850484.b4-ty@google.com>
References: <20251014152802.13563-1-leo.bras@arm.com> <176097609826.440019.16093756252971850484.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Oct 20, 2025 at 09:33:01AM -0700, Sean Christopherson wrote:
> On Tue, 14 Oct 2025 16:28:02 +0100, Leonardo Bras wrote:
> > While reading the documentation, I saw a exit code I could not grep for, to
> > figure out it has a slightly different name.
> > 
> > Fix that name in documentation so it points to the right exit code.
> 
> Applied to kvm-x86 generic, with a massaged shortlog.  Thanks!
> 
> [1/1] KVM: Fix VM exit code for full dirty ring in API documentation
>       https://github.com/kvm-x86/linux/commit/04fd067b770d
> 
> --
> https://github.com/kvm-x86/linux/tree/next

Thanks!
Leo

