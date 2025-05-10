Return-Path: <kvm+bounces-46116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E11AAAB24EB
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 20:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 562889E6916
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 18:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5521225D551;
	Sat, 10 May 2025 18:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastemail60.com header.i=@fastemail60.com header.b="SUJWvQaz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.fastemail60.com (mail.fastemail60.com [102.222.20.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4EB72626
	for <kvm@vger.kernel.org>; Sat, 10 May 2025 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=102.222.20.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746901110; cv=none; b=Jw3ifmzYQENUqqsMfEK7Rgedma6X6QAzU0OuOQp5RHV9uIWZC351tSHXS0c0ItR3iBRUgyQyl8qgeLVxpKLJIgnk8unQ4B4UL3dvBh/DG3IyVzfeVMToD5I6+eFA+jDFR/AqGIbS3+gZLMNTLEVW88TWz1Qfls2LxvdP1s5tsMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746901110; c=relaxed/simple;
	bh=0kM12Ki2v7eI61I1WvQrX7nQw+DKE1uiGUA45uahRZc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZKs7DZ14Q6j/9c8Pimgnu7k9ajyP5Oa3q2sX4CPR/0uqH1iFXVJ6Fvwex7mTcf8XqYhidUl7V/B4jbFvwvP3D4k373yFeKGQJYdsLakgUaRccYqj83KezubMLq2dkrsVQ+ZcekCSB6kKmHEA4dQyd1q+094EFl0dayaW1RmnKLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fastemail60.com; spf=none smtp.mailfrom=fastemail60.com; dkim=pass (2048-bit key) header.d=fastemail60.com header.i=@fastemail60.com header.b=SUJWvQaz; arc=none smtp.client-ip=102.222.20.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fastemail60.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fastemail60.com
Received: from fastemail60.com (unknown [194.156.79.202])
	by mail.fastemail60.com (Postfix) with ESMTPA id 2F1AD887AE6
	for <kvm@vger.kernel.org>; Sat, 10 May 2025 16:32:23 +0200 (SAST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.fastemail60.com 2F1AD887AE6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastemail60.com;
	s=202501; t=1746887545;
	bh=0kM12Ki2v7eI61I1WvQrX7nQw+DKE1uiGUA45uahRZc=;
	h=Reply-To:From:To:Subject:Date:From;
	b=SUJWvQazmKccqExKzaO3x6Fam3wmVpoaeOqSgIhwJXn3OJ4rswSQ2Ydy44N1PwiXd
	 WkH3ArFhycdli5PaCnSlFs5zDWGbtoLFYOrp7QzKpQbFpWXjeu+P3hbBgS+vveT7an
	 GR8eSGZT7/glv1Urw7ek0f3BL3mhX10HQqDyacyDTIrsDbkkiUMXNys06QNoNCFAEv
	 MA9aT8jUjDqODz6hA/TmSmCmOR3KXQyzY5IoIvig4xtaZ8AmiflNdXUk4SpKGKDySh
	 sjrRiENCIq6PveapAQlRJwvPrqjvkjB6J6n0jjTAwtA+DvI+DQViv091jfpZmEL7vD
	 o3CoZSVedheMw==
Reply-To: import@herragontradegroup.cz
From: Philip Burchett<info@fastemail60.com>
To: kvm@vger.kernel.org
Subject: Inquiry
Date: 10 May 2025 10:32:23 -0400
Message-ID: <20250510103223.C563B630EAD08DD8@fastemail60.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (mail.fastemail60.com [0.0.0.0]); Sat, 10 May 2025 16:32:25 +0200 (SAST)

Greetings, Supplier.

Please give us your most recent catalog; we would want to order=20
from you.

I look forward to your feedback.


Philip Burchett

