Return-Path: <kvm+bounces-36336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12382A1A23F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 11:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04945188A1E8
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 10:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A55320E009;
	Thu, 23 Jan 2025 10:54:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430B11C5F14;
	Thu, 23 Jan 2025 10:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737629694; cv=none; b=VHzIDbQ+GLaWKp/QIR5vEqvaO0NPRUMqyBynXbOIVEfy6ah4TQrPWfI2zgnQkT8RATmCWbVQszO4EOvCeR/362pt0WW3WI5h3JvKb7Mqf6/KwiGWjVZFo1j1Y+dmgAl6g4WVeXZt8RW7rkgCbGJpF4plIqCN3tJaIPdPCgUwQtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737629694; c=relaxed/simple;
	bh=L8BSsX4KBPmRfcbrxMBUiEQEaiS0qNJL96y6+8Jhw08=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i86eJoGez5iWV8pGpg1v96/dRmQVmp2ppg3bTWvE3p12u8RfWVahYoCboDR4ySsP77UOtROSTL80Ec0U2moAKIVNkacrmzhrmD7W0pHusN0xghIv9E/qYBKzdo/SvtVSMTOfLY1K6oTXL4UfmhGRkZzRipylSuL3pHYCzopd33w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YdyTJ6wnsz6M4Rv;
	Thu, 23 Jan 2025 18:52:52 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id DE6561404C4;
	Thu, 23 Jan 2025 18:54:49 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 23 Jan
 2025 11:54:49 +0100
Date: Thu, 23 Jan 2025 10:54:47 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC: Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, Shiju Jose <shiju.jose@huawei.com>, <qemu-arm@nongnu.org>,
	<qemu-devel@nongnu.org>, Ani Sinha <anisinha@redhat.com>, Dongjiu Geng
	<gengdongjiu1@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Peter
 Maydell" <peter.maydell@linaro.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/11] acpi/ghes: Cleanup the code which gets ghes ged
 state
Message-ID: <20250123105447.0000585a@huawei.com>
In-Reply-To: <200501cb372d5121c44128a79b8775e529dc46e6.1737560101.git.mchehab+huawei@kernel.org>
References: <cover.1737560101.git.mchehab+huawei@kernel.org>
	<200501cb372d5121c44128a79b8775e529dc46e6.1737560101.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 22 Jan 2025 16:46:24 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Move the check logic into a common function and simplify the
> code which checks if GHES is enabled and was properly setup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Seems a reasonable cleanup to me.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


