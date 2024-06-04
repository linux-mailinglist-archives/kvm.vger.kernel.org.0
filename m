Return-Path: <kvm+bounces-18790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 990D08FB62E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 335D21F2685D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63F7148FFA;
	Tue,  4 Jun 2024 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="NtkODWDF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02113146D71;
	Tue,  4 Jun 2024 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717512503; cv=none; b=WIFRief4iQQGoyP90YO+KpOZKxFPfGS1WsR5Pd2w2U0QFGM02l7uX/2kCXk7j7xI4s4uVLNn/6ZOL/8M2KR7xsh8OZuC8CWDk/c3KZ74YwqOYbnAU4dLPQoxgLz/bbf4JNrO5HxfHAuD8Vo06vN6rQXRGfdVopfWe+cFEABu/QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717512503; c=relaxed/simple;
	bh=X3pKUNEhyy4JUdYuNYNPC1vPFLR4XD7NwElEq41qojE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mXsj4JVkb1eAck6PbtFaoX8je7TYiwgG1xvRW7nx4+seHmS4pmUYSDzgnApuqH1r/z0QzASwDLhaSTB0nlMNJBiiwo/9X/eHMQlKYWlLYmyfE059yJpmaDp9SsxuXC6eBb2ENsEm+e9+vf8APW/+OjM7246s6OQW5XmhmEpmOzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=NtkODWDF; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (pd9fe9dd8.dip0.t-ipconnect.de [217.254.157.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 92CD91C7728;
	Tue,  4 Jun 2024 16:48:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1717512500;
	bh=X3pKUNEhyy4JUdYuNYNPC1vPFLR4XD7NwElEq41qojE=;
	h=Date:From:To:Cc:Subject:From;
	b=NtkODWDFp0kt1/YXItVWHnU7VGECbhhGtzzSxqe7BjnkAV16A3BIUmxyGMFRSN9h0
	 1TDdu5SzS5Ac2L1bjH6eSId5R903k9ajJ68Bk4Vb2dM4KjQ4bTqsLDkNuhHnKRT809
	 b5OmARNUfa435onkqtnGkTCcWUaDnEyZcGtSTmG2VeYz/wsJkwTjwfuXuFeDtSGvM6
	 C52vf0YkMFcjDA9BVfUzQTJcMPiXeBijj3oCvPoOT3kLt16Vvwyh0k/OXI67D2Xfp4
	 CMu74rCdsNtju3Fw7w9vmdJ+/QEpL+6p6O9ae0QeFuKucCnQjcvY1kRJWhuR5kmiE6
	 eMe3zomKdtfZw==
Date: Tue, 4 Jun 2024 16:48:19 +0200
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: linux-coco@lists.linux.dev, svsm-devel@coconut-svsm.dev,
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Subject: Call for Registration - Confidential Computing Microconference @ LPC
 2024
Message-ID: <Zl8pM8aDDT10oqmd@8bytes.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

We are pleased to announce that the Confidential Computing Microconference has
been accepted into this years Linux Plumbers Conference, happening from
September 18th to 20th in Vienna, Austria.

With this Call for Registration we want to encourage everyone interested in
this microconference to register for LPC soon and select the Confidential
Computing among the microconferences you plan to attend.

This is important because, due to the high number of accepted
microconferences, the LPC Planing Committee did not decide yet which
microconferences will get a 3 hour vs a 1.5 hour time slot. The more
people express their interest, the better our chances for a longer time
slot.

A Call for Presentations will be sent out shortly in a separate email.

Hope to see you all there!


	Dhaval and Joerg

