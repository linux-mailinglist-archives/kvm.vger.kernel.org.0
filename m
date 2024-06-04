Return-Path: <kvm+bounces-18791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED8F8FB637
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 169FB2834A0
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AC8149DFA;
	Tue,  4 Jun 2024 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="FzrN1Kds"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B76E149C60;
	Tue,  4 Jun 2024 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717512607; cv=none; b=HhjIIBwvR//Zizoz/UgcNEQaj/cdDU1Q5vOXT+uOeU+JlXZGtaHEGZmO4JaHAPLmtvFw8lZXKXso+2oq3pPda4hzVRfGeIwwqTOuKNA/M7Wdldr0jsuFQV74/SXLA7IxBdznwZp2+FCnD05PWp8zInIMJs/LMqt8ql/TLf7HalA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717512607; c=relaxed/simple;
	bh=LANm07rXulL9ApxBvdsMiKVZhbidRpa5Qu4jlOZvGHk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HWUMfqp4HAXxQzvTAjUbcgN3RSZ6TES2MQwywv06U0xTohWrFWjAp/E4tojcYO7PPYj8mUjETRTQjHrshB8QQHdyzAuVn3ODhvW8VC1jDaO0bDXYsWq9Vm6bSw3IS/+j9oIuBQVjhYR5TqxgxW+/YOojSKb90gMlnX2X4gH0ITU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=FzrN1Kds; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (pd9fe9dd8.dip0.t-ipconnect.de [217.254.157.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 223171C78B6;
	Tue,  4 Jun 2024 16:50:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1717512605;
	bh=LANm07rXulL9ApxBvdsMiKVZhbidRpa5Qu4jlOZvGHk=;
	h=Date:From:To:Cc:Subject:From;
	b=FzrN1Kds631zTIBTSz4dBpVeMvB1pGtIFg7wcRSE572DTLpCGo1I8Bj6AZ9vvsWIr
	 oBxmB9CutBlPmcRQGSTAN/w2BC0If+ofJfZxFcrBOuPx6tyK4i/kgYkxf9W4hru/sW
	 dhlh4t+EoIeKgfslE+b4dAFf5Tl2MDKgAyzMSahRVsqVMD5OUF21VqjOP7BxU6vvn9
	 gLtG1JVMEoZHA30XRr4WZoy5+ySFZMv7zxP3cJQY5d2RZvJ+FaIsyj11h5rwcK9twz
	 qX6jkBbOSXoZFVpPnSG8yHDwfdSAhdG+GTW9CG5LYIepxfbKWasWTaXvPXeG1P18qC
	 4jifFXXMXHMgA==
Date: Tue, 4 Jun 2024 16:50:04 +0200
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: linux-coco@lists.linux.dev, svsm-devel@coconut-svsm.dev,
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Subject: [CfP] Confidential Computing Microconference @ LPC 2024
Message-ID: <Zl8pnPS8EVgFgxSR@8bytes.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

We are pleased to announce the call for presentations for the
Confidential Computing microconference at the Linux Plumbers Conference,
happening in Vienna from September 18th to 20th.

In this microconference we want to discuss ongoing developments around Linux
support for memory encryption and confidential computing in general.

Topics of interest include:


	* Support TEE privilege separation extensions (TDX partitioning and AMD
	  SEV-SNP VM Privilege Levels) both on the guest and host side.

	* Secure IRQ delivery

	* Secure VM Service Module (SVSM) support for multiple TEE architectures

	* Trusted I/O software architecture

	* Live migration of confidential virtual machines

	* Remote attestation architectures

	* Deployment of Confidential VMs

	* Linux as a CVM operating system across hypervisors

	* Unification of various confidential computing API

Please use the LPC CfP process to submit your proposals. Submissions can
be made via

	https://lpc.events/event/18/abstracts/

Make sure to select "Confidential Computing MC" as the track and submit
your session proposal by July 15th. Submissions made after that date
can not be included into the microconference.

Looking forward to seeing all of you in Vienna in September!

Thanks,

	Dhaval and Joerg


