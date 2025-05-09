Return-Path: <kvm+bounces-46068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 278EDAB16EE
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 16:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F29AF3BDC43
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 14:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50692951D8;
	Fri,  9 May 2025 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastemail60.com header.i=@fastemail60.com header.b="VKD6Rbeh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.fastemail60.com (mail.fastemail60.com [102.222.20.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FFC2951B7
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=102.222.20.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799934; cv=none; b=oTVcUTlWDXKHkcLgmqwCt5l7y4fIEL0R8ajfv0A8/9Op0zsV6l5v6GWM79RF9igCSQbGwHgGUToUt6Ep4UijbTtbelzmrIC/3K3SMnx+neQe7ji0IPlDUz2J0XMvONqIHNAw3Jcsp5s+5ogvpG/DqW5to3zzUvF4XLeaTKL3hds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799934; c=relaxed/simple;
	bh=0kM12Ki2v7eI61I1WvQrX7nQw+DKE1uiGUA45uahRZc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f7RBz2yQ9QW6GuvHze9KqQuM6sCyqRITBiTB/knp/GqHW6SeQW7wwqjqo4Yiny46GV1h3E3A1FjVyH31vQ++HkCQXHxbR6mVijRM7C1xSgyag+ed0izDNVWBhOSpisZvAmMt2mK3zP6TwNl4tS9o2PAp5IrUQsm4AE8zRNuvimE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fastemail60.com; spf=none smtp.mailfrom=fastemail60.com; dkim=pass (2048-bit key) header.d=fastemail60.com header.i=@fastemail60.com header.b=VKD6Rbeh; arc=none smtp.client-ip=102.222.20.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fastemail60.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fastemail60.com
Received: from fastemail60.com (unknown [194.156.79.202])
	by mail.fastemail60.com (Postfix) with ESMTPA id 916B887944A
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 15:56:38 +0200 (SAST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.fastemail60.com 916B887944A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastemail60.com;
	s=202501; t=1746798999;
	bh=0kM12Ki2v7eI61I1WvQrX7nQw+DKE1uiGUA45uahRZc=;
	h=Reply-To:From:To:Subject:Date:From;
	b=VKD6RbehJKsOy43nhYwCdBY2TKGC1HbZA4hdXdHPySyMPaLMhVt/NOY3TINHUbLfw
	 mDfsLa35h8LxleFEdMDShjCouOynUv7C6ngTlEZMEb8OBZ8neWLQAcX+uVABxvDERa
	 bdTk5LSGU3HpONpMXpdtmwZppFuWPN0jbyp5YsXNnHBKkN/37vQH8y875sziYQsVIe
	 7OrScM50Q30OgIktXJucT0WtdWX116pg2h3KYwL0sw8MIfN5SHic2O2KhIz0Q2Nygr
	 jyCZII9mD6EYM07fupkwwuH70Fk4bWyLu0f8JHqlt3WqoCN3qv0jOPiB+IAWviSIgJ
	 maL4ChAJaYB6g==
Reply-To: import@herragontradegroup.cz
From: Philip Burchett<info@fastemail60.com>
To: kvm@vger.kernel.org
Subject: Inquiry
Date: 09 May 2025 09:56:38 -0400
Message-ID: <20250509095638.4103948C69C1E721@fastemail60.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (mail.fastemail60.com [0.0.0.0]); Fri, 09 May 2025 15:56:39 +0200 (SAST)

Greetings, Supplier.

Please give us your most recent catalog; we would want to order=20
from you.

I look forward to your feedback.


Philip Burchett

