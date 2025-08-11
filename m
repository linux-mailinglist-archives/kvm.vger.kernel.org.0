Return-Path: <kvm+bounces-54435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B133EB2143B
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7A79625900
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 18:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEEF2E3702;
	Mon, 11 Aug 2025 18:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="JbiXTDGE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E8A2E11B5;
	Mon, 11 Aug 2025 18:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936482; cv=none; b=lh42jA/jhq+nrzvHdgIVZbdC1PQG6j6YChZSO7e0HamSey0SRMj5J08OeW5SUSzhl+pcNOoKRlerOvjBig11rBu81wiP0t/gzenthuUVvv46WsQu4ffgXDi2lpFMZZMk4ytlBz+mmA4iBWucec6B8AFKrY+O5OCKq8NIa0HQZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936482; c=relaxed/simple;
	bh=SvPZlqXRWngt1utHyAUTnrl/jVOB9D2tqo++t5yz1aY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PXzoc3wiwRnWzr0qQ/gM1urJ4yS7630CQmQmGrxBQNwzeHrt4Sc2VKPAd0oKFpRN/TMLJf8Jtuh3akwIFSPA+rBAFUsgTrquUYgEbRN+W/obYd6ImIZ0aEg9A0fZfjB1MufIetnSEMtTJ2vKS6n1SbHD1BUlTQ9fVJYtIbtENXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=JbiXTDGE; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p54921b16.dip0.t-ipconnect.de [84.146.27.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 3233B473D0;
	Mon, 11 Aug 2025 20:21:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1754936473;
	bh=SvPZlqXRWngt1utHyAUTnrl/jVOB9D2tqo++t5yz1aY=;
	h=Date:From:To:Cc:Subject:From;
	b=JbiXTDGEuSq+AOUV4o4PsNQ3+J6W+PQVn/CIT1q2IPHcInJKM398cNvcLz50fuPmX
	 voYaFt4om+GrZU0hopvOvqSeqpj4A68jsOvuU2PKfUdcusc4vppMwMIoiul4lTV/j5
	 Tw4OdnjEQpdVCQuOjqKqKtXs+Q/on2CsAGrdsEJZCVFOHG/HMpL97xwaXiLKUdKV3t
	 VI2/qEC+JPxesSGX2loC/74XdYS4Sk4iYf6AxQwWvlV+ig/Y8qOWTKVHwKQrAO/tE5
	 j8e4J28oKeLj1oz8P+kIwBnzH+ukMyPLVCcFIP/tshoVicYQEdSLK2M2cYS+0t0P9I
	 HLbuNy2Okg6Pw==
Date: Mon, 11 Aug 2025 20:21:12 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: linux-coco@lists.linux.dev, svsm-devel@coconut-svsm.dev, 
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Subject: [CfP] Confidential Computing Microconference @ LPC 2025
Message-ID: <hbvvob7wwgymmg3hts3gdpr6jygzhlht4yq57riewryd6oulva@jpzuxrvljzb5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

We are pleased to announce the call for presentations for the Confidential
Computing microconference at the Linux Plumbers Conference, happening in Tokyo,
Japan from December 11 to 13, 2025.

In this microconference we want to discuss ongoing developments around Linux
support for memory encryption and confidential computing in general.

	- Support for large-page backing of confidential virtual machines
	  (CVM).
	- Privilege separation features in KVM via VM planes.
	- Live migration of CVMs.
	- Secure VM Service Module architecture and Linux support.
	- Trusted I/O software architecture.
	- Further topics to discuss are:
	- Possible solutions for the full CVM (remote) attestation problem.
	- Linux as a CVM operating system across hypervisors.
	- Performance of CVMs.

Please use the LPC CfP process to submit your proposals. Submissions can be
made via

	https://lpc.events/event/19/abstracts/

Make sure to select "Confidential Computing MC" as the track and submit your
session proposal by September 30th. Submissions made after that date can not be
included into the microconference.

Looking forward to seeing all of you in Tokyo in December!

Thanks,

	Dhaval and Joerg


