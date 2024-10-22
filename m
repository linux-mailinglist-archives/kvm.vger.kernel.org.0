Return-Path: <kvm+bounces-29416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B7D9AB11B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 16:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC6351F241B3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B859A1A0BD0;
	Tue, 22 Oct 2024 14:44:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48537199248
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608240; cv=none; b=aTaDFUOpEcw3HZ3PnDwmP1V+WsxKK/q5tv9nEMsmXbYe3RXxk9wZGWvMaYEuAheshqndwDsnncGQl7Ll5WhSkuPsBkpRCQJ96BlVE447+OS8mYir/Ga+FnRtrgwv8bALo6Db99mDebMUSz/tTPS524B0S8PnAXES5e/A77qdqag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608240; c=relaxed/simple;
	bh=bE1wupx1qvJigVL08kStkKoY/ikN+oob7gIcVCjWZxY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPIeYrzZUBvNOB0pRSfHxUNvP+I9gKAAaCAV+4mrI5iXghorxhacAH0NVe+zgU+l2O3NrFybONtkEbVGUu6t558dkOicQBiLsQELuaJCETZsIHDxOKWM44NoB/4W9GyneOtayZMq80Cm+noB9BZlnB/Xk4FuQ6UZVEn9FOE6Wh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XXvzl2XJ9z6JB90;
	Tue, 22 Oct 2024 22:42:59 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id B9FC714039E;
	Tue, 22 Oct 2024 22:43:54 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 22 Oct
 2024 16:43:53 +0200
Date: Tue, 22 Oct 2024 15:43:52 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S.Tsirkin " <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Alex
 =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v4 1/9] i386/cpu: Don't enumerate the "invalid" CPU
 topology level
Message-ID: <20241022154352.00001a4e@Huawei.com>
In-Reply-To: <20241022135151.2052198-2-zhao1.liu@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
 <20241022135151.2052198-2-zhao1.liu@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)

Resend. Claws-mail is still chewing up the to list for unknown reasons
and I forgot to fix it by hand.

On Tue, 22 Oct 2024 21:51:43 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> In the follow-up change, the CPU topology enumeration will be moved to
> QAPI. And considerring "invalid" should not be exposed to QAPI as an
> unsettable item, so, as a preparation for future changes, remove
> "invalid" level from the current CPU topology enumeration structure
> and define it by a macro instead.
> 
> Due to the removal of the enumeration of "invalid", bit 0 of
> CPUX86State.avail_cpu_topo bitmap will no longer correspond to "invalid"
> level, but will start at the SMT level. Therefore, to honor this change,
> update the encoding rule for CPUID[0x1F].
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

The drop of the invalid level == 0 seems reasonable to me
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

