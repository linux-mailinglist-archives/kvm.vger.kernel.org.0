Return-Path: <kvm+bounces-36559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7749FA1BAEC
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBFDA3ACD79
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0811D47AD;
	Fri, 24 Jan 2025 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jj85NQLO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6541CDFC1;
	Fri, 24 Jan 2025 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737737330; cv=none; b=KM/ekrL4sTwhkFv8/vuXm7fZvu5XbNhLbR0hy3qC4GVAaX83s5Ej46XgHjQjRmg57/Z2X45umTXTOL8xkWLTchW6m6z9UJ8HM62qiOIQ18NkGZu8+ag8dWjdCBseiF5iHpeev1fUD6zKdUwVXqrGdE/QcvBX7XYU8k737KuBgn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737737330; c=relaxed/simple;
	bh=Qx9Bk8NinlvhsiKZviOMJjPo0VCNUaYYKMyPD/CMUys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7ygy7HxPXegi0RKnIDbQmXrAAAOeYRVVUDVVQH1mAfB5fbnF5TEeup8YAuyhEdPbczNXncNUV+kavAP5ZTAsl+lqZRdNY95t9KitP7Z6louDy97NZzegOK3mtaCCelKQLauoGzjHE7nTtrhGm6WZqOSJs/tLM9f2JcN8M5nspQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jj85NQLO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDC7C4CED2;
	Fri, 24 Jan 2025 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737737330;
	bh=Qx9Bk8NinlvhsiKZviOMJjPo0VCNUaYYKMyPD/CMUys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jj85NQLOsK8LTmBoqOf51PUxYbjxAtnyAlqShxgr+Tg8gSzX3DEnssuzfRjcX0O8u
	 oltsIiv1+y61LaUEFfQ2f9xrXJHrGo6ozNL72GNfxUt1RePcwG5yRnJUjqZiSr0iAG
	 UL3S9jkkSor+Swj9dGWHangV1qvy8SpitWpPZ8bS2y/MCg0J7TEEDEtwYB7+QAV/Fp
	 bUNyN6qlcnPaNGHxVtlT0NxvumJaclBu19Zbh6mj1+e0YToQZCHEjiFgYJiMoS7rGo
	 XxOwwS+2IueHZPiigG0Eo/a2nsvjiYuPyTK0Fc3JWDAjyxNgB/rZ4bp2dqHMQ1qid6
	 uebTcYOsqNSew==
Date: Fri, 24 Jan 2025 09:48:48 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: remove kvm_arch_post_init_vm
Message-ID: <Z5PEcNgXPktS1NAU@kbusch-mbp>
References: <20250124160039.95808-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250124160039.95808-1-pbonzini@redhat.com>

On Fri, Jan 24, 2025 at 11:00:39AM -0500, Paolo Bonzini wrote:
> The only statement in a kvm_arch_post_init_vm implementation
> can be moved into the x86 kvm_arch_init_vm.  Do so and remove all
> traces from architecture-independent code.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

