Return-Path: <kvm+bounces-31937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C6AD9CDFB9
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 14:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1276C283BCD
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 13:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9EE1BCA1B;
	Fri, 15 Nov 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sMGIoaGz"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C4E1BBBDD;
	Fri, 15 Nov 2024 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731676714; cv=none; b=o2MSGDDIX1ddqOpxTVPTVB7h7SNQsFxltiDYlzWEIooQLUAu9FCy3wcdEdZb0C5uZeKNFS0+Ob9ti/ul18o4jOsnRrjqSy4oq1VJ1Zprnlz1peEhyrAK85HlIJ4LlI04kBPfTcpMhgv55xg9FiWhW2DbNA3/9UXZrRBQknvugek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731676714; c=relaxed/simple;
	bh=h+GmX49mS0AoGSHxJpoOE1qFr5uVvx6zsvBZtvVB0xA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pdW63V4RQOMNGwdOF9vZTsmd2C0Gl35MlW7wbjW9+eXEU2zU4muJxJUjAhrkaknpwcMiHEKKtGLJOPl17DMRjwMIxvqGbisyNRMGzZx7I9Ng13X7kkTgL1nm0ddnwRyiwG7JYCYJOFkc5oNMGCbJWHA6uJitrI8Op3AF3K5cPj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sMGIoaGz; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=avfnMRQjUr6PZsS1yQOib+tarQZ0aNnNNPTLTyzXg1A=; b=sMGIoaGzS0OKeBKeWUgAsftwwz
	10rNE26btq8FtMRY4ntsH0IUwhDC5Rg2AqiFwy1ARN2aO1eCZjO2+wv+pxJxRu53KdlHRKqvJ32hu
	I4XbXd0Dcmr92yuApnCKhdi7dAWIMlWJ3h7tvMvwKmg8PmPjPzimfx9TxCIsiO6KnKWbfI9QTqKoc
	tLXG4AeNfSa/tkgOrCMTG4ZFREJ/AIxAjxVzuL5EbcfMr/1j0j5s+8yrhroZXH3QW0FYrHuv0dqmP
	ftRLTUvzJUl0VgIfQizJdM+Dzt+gxcTrjD9ePRnKv4oPJrfwBp8jwydTn7EEE4Pg+KkaSxGZCxxoS
	eBkA1HEA==;
Received: from [212.102.57.3] (helo=[172.31.28.190])
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tBwDV-00000001SBh-2SMO;
	Fri, 15 Nov 2024 13:18:29 +0000
Message-ID: <9447b7b512627a505396799080f45bf0596ef9c5.camel@infradead.org>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
From: Amit Shah <amit@infradead.org>
To: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand
 <david@redhat.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 15 Nov 2024 14:18:27 +0100
In-Reply-To: <diqzmsieybwf.fsf@ackerleytng-ctop-specialist.c.googlers.com>
References: <diqzmsieybwf.fsf@ackerleytng-ctop-specialist.c.googlers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 (3.54.1-1.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-11-04 at 20:36 +0000, Ackerley Tng wrote:
> David Hildenbrand <david@redhat.com> writes:
>=20
> > Ahoihoi,
> >=20
> > while talking to a bunch of folks at LPC about guest_memfd, it was=20
> > raised that there isn't really a place for people to discuss the=20
> > development of guest_memfd on a regular basis.

[...]

Please add me to the meeting invite.

Thanks,
		Amit

