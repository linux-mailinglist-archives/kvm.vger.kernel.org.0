Return-Path: <kvm+bounces-16362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CED8B8F0E
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 19:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13B95B2266D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 17:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D941B28D;
	Wed,  1 May 2024 17:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qK+FKBzy"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A81FBEA
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714584604; cv=none; b=Tz2sTtRIpblyp15cfoGvZgzPCdd1qrbJRjXuTbbSiQ/lJloOYq8iQLXHoLUCa+kx2s62eiZRNTss4Czp6OWx68Av2f0Mt/iGdE3x/yV2pthNSGyH4kfRepD2tIK3wMvY1+hfWz7dtpsPMYa2lbLlBQocS7u6I2IJ/hsIv4mSLWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714584604; c=relaxed/simple;
	bh=K/Et1WHuYdtUFgrCOVeuwKNIM51j0a8AcKSOlNcW55Q=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=MKOez0CpmF8qqeHziMx2IjiOFx/OeAtPDvUXjjvXOO3KHBkrmnDzZXovtooItM9WL4qfGC8uqy+9N7gr9e8OHHI67LLcLLmUAx/Il9VlfyWmgVDbrjZ5ShYS3GIaFvlmtJikyjGscQ9Q5xoPfn1B0Tdbak1pxYTpY0qpUDuD5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=qK+FKBzy; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1001)
	id 8229A2066E79; Wed,  1 May 2024 10:30:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8229A2066E79
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1714584602;
	bh=8b8ZpPrUlcTiNbAcOuYL1jeFkFldN2BTF7vLwet1mQc=;
	h=Date:From:To:cc:Subject:From;
	b=qK+FKBzyFj/E9lUYWr24rPv5lsp2hZC7U2zVdksuF+dSFC4fuOMuOV7pX88FhI+L1
	 F2lBelTQEU8ZbOSxudXDbZ2NN54uOdmxNbCd9oHc2oJ01878nMFMzS/S2b+excBfzW
	 6ErJTENo4f8MNTm6p3lKs8yJbzwIYgT30M/S57qg=
Received: from localhost (localhost [127.0.0.1])
	by linux.microsoft.com (Postfix) with ESMTP id 7EF4C30705CC;
	Wed,  1 May 2024 10:30:02 -0700 (PDT)
Date: Wed, 1 May 2024 10:30:02 -0700 (PDT)
From: James Morris <jamorris@linux.microsoft.com>
To: kvm@vger.kernel.org
cc: pbonzini@redhat.com, Thara Gopinath <tgopinath@linux.microsoft.com>, 
    mic@digikod.net
Subject: 2024 HEKI discussion: LPC microconf / KVM Forum?
Message-ID: <3564836-aa87-76d5-88d5-50269137f1@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Folks,

We are planning our travel & conference submissions and I'm wondering if 
there is likely to be an LPC KVM microconf again this year. And if so, 
what would be the best option for proposing an update on the HEKI 
(hypervisor enforced kernel integrity) project?

We'd like to demonstrate where we're at with the project and discuss next 
steps with the community, in terms of both core kernel changes and the 
KVM-specific project work.


As a reference, here are the LPC sessions from 2023:
- KVM microconf: https://lpc.events/event/17/contributions/1486/
- Main track overview: https://lpc.events/event/17/contributions/1515/



-- 
James Morris
<jamorris@linux.microsoft.com>

