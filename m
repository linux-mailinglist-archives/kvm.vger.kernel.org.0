Return-Path: <kvm+bounces-39680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B6CA494A9
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74CAE3B315A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073382566F1;
	Fri, 28 Feb 2025 09:19:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7581CAA99;
	Fri, 28 Feb 2025 09:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734375; cv=none; b=Eqaq1BAvdBQiUfF+uBhSh+uFh2m/DRLX32Ph6eV5jS14psGgPScbbi8W2t2lVlE6Vh5C7Qv6583pSFgO2s1gYp+ZGWlTMjXdku2U77NDYD0+f1psoPbwvpaofS4qSWVqDt9yuALa20NQCwFnYTrLEprzrjC8Dflk1bqe8hQM9ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734375; c=relaxed/simple;
	bh=Vd3UmTfRLm+F06cpBFFtBHu6pRElLdw3agBFpIi7T2w=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBaZZR1BEin0XXEqNTNG9st6NN1hoUcREccUPTG/FawgTKea6L7kN5ZTc5s6JFDLZsLA5np6692O6FFYwYs2NHew8IEjnwxHSZf6zq5jUdWoXndHjbffgKgM0/RiTGP/qDWJJoY66Ker22TsIVW+fcupDbz8ifhewFlO5Q1KmDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Z42ff3zTmz6K9Sq;
	Fri, 28 Feb 2025 17:17:30 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 6F3ED140CF4;
	Fri, 28 Feb 2025 17:19:31 +0800 (CST)
Received: from localhost (10.96.237.92) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 28 Feb
 2025 10:19:17 +0100
Date: Fri, 28 Feb 2025 17:19:13 +0800
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC: Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, Shiju Jose <shiju.jose@huawei.com>, <qemu-arm@nongnu.org>,
	<qemu-devel@nongnu.org>, Ani Sinha <anisinha@redhat.com>, Dongjiu Geng
	<gengdongjiu1@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Peter
 Maydell" <peter.maydell@linaro.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 04/19] acpi/ghes: Cleanup the code which gets ghes
 ged state
Message-ID: <20250228171913.00003442@huawei.com>
In-Reply-To: <cd48953a4568b401c689078898a729c3d5cb10c2.1740671863.git.mchehab+huawei@kernel.org>
References: <cover.1740671863.git.mchehab+huawei@kernel.org>
	<cd48953a4568b401c689078898a729c3d5cb10c2.1740671863.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 27 Feb 2025 17:00:42 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Move the check logic into a common function and simplify the
> code which checks if GHES is enabled and was properly setup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by:  Igor Mammedov <imammedo@redhat.com>
This is the only place Igor's tag seems to have a bonus space..
Probably worth tidying up if you are doing a v7

Jonathan

