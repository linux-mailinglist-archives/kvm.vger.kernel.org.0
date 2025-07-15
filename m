Return-Path: <kvm+bounces-52507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 238B9B05F4C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A62057BC3C0
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410C12EAB83;
	Tue, 15 Jul 2025 13:50:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130642E6136;
	Tue, 15 Jul 2025 13:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587422; cv=none; b=nSQeM90gmr8QzB2fDyUsA9rujAhSCM7Zs7TDyXu+fn427s7CBNnpQrZ+Zco/f+HyQuzhoEueH2jaAYqu+p5ZEtOnjiOvkRD5i00vfDSjhd+B9mg73Kvtwm4s4v6nW8zCfPo0PzCqzUdWt3wUCzsE7Rha2EVszw0cLnKnaFWcpE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587422; c=relaxed/simple;
	bh=+0PGXrsSAKe+iUuwlrADb2v3BmRkBV8/GR6xTlwwAMo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/i9oZ8kA3RpLFZSkTm21BRt4negqC3pKfBOvQTOqx9kOzdlDRSUdi6WKUkuyfQm2E2mBtudUcwhUqf0UrlhU+LujNTYqdDs/M1SjfGlF6WWC4BFRCgPqHQIW/hAyaE5LISy/MWwzgAwi8XPzLWD399i59BWUSmxWDVRn+D0qaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bhL874BTNz6L4wL;
	Tue, 15 Jul 2025 21:46:47 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 7F934140446;
	Tue, 15 Jul 2025 21:50:17 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 15 Jul
 2025 15:50:15 +0200
Date: Tue, 15 Jul 2025 14:50:14 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: WangYuli <wangyuli@uniontech.com>
CC: <airlied@gmail.com>, <akpm@linux-foundation.org>,
	<alison.schofield@intel.com>, <andrew+netdev@lunn.ch>,
	<andriy.shevchenko@linux.intel.com>, <arend.vanspriel@broadcom.com>,
	<bp@alien8.de>, <brcm80211-dev-list.pdl@broadcom.com>,
	<brcm80211@lists.linux.dev>, <colin.i.king@gmail.com>, <cvam0000@gmail.com>,
	<dan.j.williams@intel.com>, <dave.hansen@linux.intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <davem@davemloft.net>,
	<dri-devel@lists.freedesktop.org>, <edumazet@google.com>,
	<gregkh@linuxfoundation.org>, <guanwentao@uniontech.com>, <hpa@zytor.com>,
	<ilpo.jarvinen@linux.intel.com>, <intel-xe@lists.freedesktop.org>,
	<ira.weiny@intel.com>, <j@jannau.net>, <jeff.johnson@oss.qualcomm.com>,
	<jgross@suse.com>, <jirislaby@kernel.org>, <johannes.berg@intel.com>,
	<kuba@kernel.org>, <kvalo@kernel.org>, <kvm@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux@treblig.org>, <lucas.demarchi@intel.com>, <marcin.s.wojtas@gmail.com>,
	<ming.li@zohomail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<netdev@vger.kernel.org>, <niecheng1@uniontech.com>,
	<oleksandr_tyshchenko@epam.com>, <pabeni@redhat.com>, <pbonzini@redhat.com>,
	<quic_ramess@quicinc.com>, <ragazenta@gmail.com>, <rodrigo.vivi@intel.com>,
	<seanjc@google.com>, <shenlichuan@vivo.com>, <simona@ffwll.ch>,
	<sstabellini@kernel.org>, <tglx@linutronix.de>,
	<thomas.hellstrom@linux.intel.com>, <vishal.l.verma@intel.com>,
	<x86@kernel.org>, <xen-devel@lists.xenproject.org>, <yujiaoliang@vivo.com>,
	<zhanjun@uniontech.com>
Subject: Re: [PATCH v2 8/8] scripts/spelling.txt: Add notifer||notifier to
 spelling.txt
Message-ID: <20250715145014.000075ec@huawei.com>
In-Reply-To: <A205796B545C4241+20250715134407.540483-8-wangyuli@uniontech.com>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
	<A205796B545C4241+20250715134407.540483-8-wangyuli@uniontech.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 15 Jul 2025 21:44:07 +0800
WangYuli <wangyuli@uniontech.com> wrote:

> This typo was not listed in scripts/spelling.txt, thus it was more
> difficult to detect. Add it for convenience.
> 
> Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/

Adding a link tag to your own previous patch doesn't seem particularly
useful as something to end up in the git log (which depending on
maintainer preference may gain a link tag to this version).

> Signed-off-by: WangYuli <wangyuli@uniontech.com>
other than that, LGTM

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  scripts/spelling.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/spelling.txt b/scripts/spelling.txt
> index c9a6df5be281..d824c4b17390 100644
> --- a/scripts/spelling.txt
> +++ b/scripts/spelling.txt
> @@ -1099,6 +1099,7 @@ notication||notification
>  notications||notifications
>  notifcations||notifications
>  notifed||notified
> +notifer||notifier
>  notity||notify
>  notfify||notify
>  nubmer||number


