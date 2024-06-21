Return-Path: <kvm+bounces-20203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 495FC9118DB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 04:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08E1E284F0A
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF95285260;
	Fri, 21 Jun 2024 02:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jsvi.net header.i=contacto2@jsvi.net header.b="m+2y9z9s"
X-Original-To: kvm@vger.kernel.org
Received: from vps9.jsvi.net (vps9.jsvi.net [81.7.6.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3854411
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 02:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.7.6.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718938461; cv=none; b=IX/Vg5P/7J0o5B9XLrMoKxHCdoYy18XPZ9YVJqFaVeANrDfwPECIL1knegF72T9PaN9TP91juX5gFWGN2WvmGT5zQcLYZV+sGBRDJ0/st6dqSEgOo5mrZR6W9GBQgaUMyA3+yn2Yh7nGEjz7+kiE04RL3flM4GuIFUBPoP/wyvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718938461; c=relaxed/simple;
	bh=LBwaLr+wlbr8N/ILBVAzTSG0uUZeAj3452+lutsr+lA=;
	h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type; b=EqhG8xuuH0v1oh3FyCiRyWwiqQV02a2hbVhLs0gertciCqH5U10TdQDvx9Wb6txVvzcS0VCxOR7L0ETcx9ZRcjhII0ihq1vK4SMzB03XvrNVCKLgO5s94F2Y/0o5rCatuN3MJYXCkmYwSQ1FUqNRtZL8m5bjt4NKKn4Rnxvv4m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jsvi.net; spf=fail smtp.mailfrom=jsvi.net; dkim=pass (1024-bit key) header.d=jsvi.net header.i=contacto2@jsvi.net header.b=m+2y9z9s; arc=none smtp.client-ip=81.7.6.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jsvi.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=jsvi.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=default; d=jsvi.net;
 h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type:
 Content-Transfer-Encoding; i=contacto2@jsvi.net;
 bh=LBwaLr+wlbr8N/ILBVAzTSG0uUZeAj3452+lutsr+lA=;
 b=m+2y9z9sCPs8jTiSk68D8adEYcnRntgwLRFUW1MUAnzs24K8/PZazdmTVHQiyg8snQ1wH0Npxg9u
   Yj1ujLlYE7Ju9vgdghtLzJ1UFQ3pA1yN6YHUVRYPYGORP4C2nKD9l2C2gHYgYMEHyLcsYqxVtgFS
   ex8a/xyD7S8c3YNeb98=
Message-ID: <2466abe612d61899ba1abce8e327116a42d4fc7bdc@jsvi.net>
From: Paty <contacto2@jsvi.net>
To: kvm@vger.kernel.org
Subject: hola
Date: Thu, 20 Jun 2024 21:36:39 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1";
Content-Transfer-Encoding: quoted-printable

Saludos a todos

