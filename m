Return-Path: <kvm+bounces-53105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 219F0B0D5E6
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EEA8169807
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA572DD60E;
	Tue, 22 Jul 2025 09:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjJRYeJZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8218F189902;
	Tue, 22 Jul 2025 09:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176272; cv=none; b=DlUlAhNpldZkz0ooqfPapBxY/KnuOA6TrrMT4w0sE6uE1V/ZuM+iGZC/sEMdeniXDgqhatVUoy1nc+Q0XO/MtZyOk+zNL3htQRzS5nAECnc590d4MdaZ+yrD5dPn/SLP6rt6Sw6FnM7u7UY1lU2VH/ZNOnzuGjgw+1iHWXoGOKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176272; c=relaxed/simple;
	bh=Ksr4RcpyiaVxvdAz9Ft+gR94b9IMq2d1CEO85zHMm3o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ozdi7zxKbUqjVpS7bhPaGPOyba+XSkcY455kr2390EfonGP85biUUp9cXiGLNr9gVbbeTJ+MgwGtO0D32hkHab3nWo1xwF/bGoaBk/cKjpIi85g6kTgFijANpAAaCz9w+glrzCbw2yUhCsIgjDjHfmCUPY2N4E2iLwGsY0Fld2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjJRYeJZ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753176271; x=1784712271;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Ksr4RcpyiaVxvdAz9Ft+gR94b9IMq2d1CEO85zHMm3o=;
  b=MjJRYeJZpalrlHw+UcPoLhG0hsnDsFWT4Vl198E033SFSD8VB0j88IgK
   tsdjYlB+nUlOBtv2gmxqzWzz9v+1Vz7qcqmQRLBAvR7KjSNbfuZ3TSzwx
   6qaTp8+EIIpqjbs7F1OpPp5qYQBh9Dmgn1p5WW0Z46zH98v9JSfFuaIof
   mP7E3btZygMf7XIArG3cCmTUHgD3AJV5tezE1D566DfnmyOrKeYuvS5xy
   aEiF4fT4jF51WLsfHPlb0dYBL8C8bnah7e9LuE9zS+DhxKao1yeS5i3uh
   FKU4YUYIuD8NilU9B5NSz6N2dJHzhdmg7f0JBMvNqHTQ++GDVFQ8Titq4
   w==;
X-CSE-ConnectionGUID: dXx7JM3uS8aac5OU3dpXgA==
X-CSE-MsgGUID: L+02RNx2QLSMDZdllhWsjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55574717"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="55574717"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 02:24:30 -0700
X-CSE-ConnectionGUID: cbehGU95QkWPRtX5+LVZGA==
X-CSE-MsgGUID: 7OhfXV8JRdOAnLadikdZ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="163133052"
Received: from vpanait-mobl.ger.corp.intel.com (HELO [10.245.244.202]) ([10.245.244.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 02:24:17 -0700
Message-ID: <ffd58e1a8b51c98cac9be49e85d367f1a3a24c2d.camel@linux.intel.com>
Subject: Re: [PATCH v3 3/8] drm/xe: Fix typo "notifer"
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: WangYuli <wangyuli@uniontech.com>
Cc: airlied@gmail.com, akpm@linux-foundation.org,
 alison.schofield@intel.com, 	andrew+netdev@lunn.ch,
 andriy.shevchenko@linux.intel.com, 	arend.vanspriel@broadcom.com,
 bp@alien8.de, brcm80211-dev-list.pdl@broadcom.com, 
	brcm80211@lists.linux.dev, colin.i.king@gmail.com, cvam0000@gmail.com, 
	dan.j.williams@intel.com, dave.hansen@linux.intel.com,
 dave.jiang@intel.com, 	dave@stgolabs.net, davem@davemloft.net,
 dri-devel@lists.freedesktop.org, 	edumazet@google.com,
 gregkh@linuxfoundation.org, guanwentao@uniontech.com, 	hpa@zytor.com,
 ilpo.jarvinen@linux.intel.com, intel-xe@lists.freedesktop.org, 
	ira.weiny@intel.com, j@jannau.net, jeff.johnson@oss.qualcomm.com,
 jgross@suse.com, 	jirislaby@kernel.org, johannes.berg@intel.com,
 jonathan.cameron@huawei.com, 	kuba@kernel.org, kvalo@kernel.org,
 kvm@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux@treblig.org,
 lucas.demarchi@intel.com, 	marcin.s.wojtas@gmail.com, ming.li@zohomail.com,
 mingo@kernel.org, 	mingo@redhat.com, netdev@vger.kernel.org,
 niecheng1@uniontech.com, 	oleksandr_tyshchenko@epam.com, pabeni@redhat.com,
 pbonzini@redhat.com, 	quic_ramess@quicinc.com, ragazenta@gmail.com,
 rodrigo.vivi@intel.com, 	seanjc@google.com, shenlichuan@vivo.com,
 simona@ffwll.ch, sstabellini@kernel.org, 	tglx@linutronix.de,
 vishal.l.verma@intel.com, wangyuli@deepin.org, x86@kernel.org, 
	xen-devel@lists.xenproject.org, yujiaoliang@vivo.com, zhanjun@uniontech.com
Date: Tue, 22 Jul 2025 11:24:15 +0200
In-Reply-To: <94190C5F54A19F3E+20250722073431.21983-3-wangyuli@uniontech.com>
References: <576F0D85F6853074+20250722072734.19367-1-wangyuli@uniontech.com>
	 <94190C5F54A19F3E+20250722073431.21983-3-wangyuli@uniontech.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-07-22 at 15:34 +0800, WangYuli wrote:
> There is a spelling mistake of 'notifer' in the comment which
> should be 'notifier'.
>=20
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>

> ---
> =C2=A0drivers/gpu/drm/xe/xe_vm_types.h | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/xe/xe_vm_types.h
> b/drivers/gpu/drm/xe/xe_vm_types.h
> index 1979e9bdbdf3..0ca27579fd1f 100644
> --- a/drivers/gpu/drm/xe/xe_vm_types.h
> +++ b/drivers/gpu/drm/xe/xe_vm_types.h
> @@ -259,7 +259,7 @@ struct xe_vm {
> =C2=A0		 * up for revalidation. Protected from access with
> the
> =C2=A0		 * @invalidated_lock. Removing items from the list
> =C2=A0		 * additionally requires @lock in write mode, and
> adding
> -		 * items to the list requires either the
> @userptr.notifer_lock in
> +		 * items to the list requires either the
> @userptr.notifier_lock in
> =C2=A0		 * write mode, OR @lock in write mode.
> =C2=A0		 */
> =C2=A0		struct list_head invalidated;


