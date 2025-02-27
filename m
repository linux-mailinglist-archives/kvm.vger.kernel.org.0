Return-Path: <kvm+bounces-39566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29EC3A47E27
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05C951622CE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 12:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB00F22D7B4;
	Thu, 27 Feb 2025 12:46:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88CFA48;
	Thu, 27 Feb 2025 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740660377; cv=none; b=TWA81HnAadRl2OuCEVEWOQuPRVhvWFRUv3X8bmTktFXuz5WH3WyNyQTstPAEWXDCGoixveRkA9wXqtTTrSg8ZyJcyq9Wiwif25DXworTiYbKZrnBsdT/s48I1Po3jlqvJp68iHIrlB0I2C//qYoK2EfHKygYc9nqLKWp+RKw/nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740660377; c=relaxed/simple;
	bh=vyeS/IwiUlda8zCLrI2wORo53ZhuYkNx2sKDFaPcHPU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fBIo+DRY6XFCo78rkN0+gvRQh6Tf8Cy2EjxiMqr9m3S1itWmeZ7u+twWcfyxnkLOj6CmJTz2CJ69HR8H1IraUuP8J4fJ17RGivcwAq4oxwbsjnQe4DFt78OBQvBWsdSVMMACjH8oBIfReoR61UVhbTxMvpqsI7dT2yyW+ZFDpiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 4E7C182475;
	Thu, 27 Feb 2025 20:45:59 +0800 (CST)
Received: from smtpclient.apple (unknown [222.67.181.225])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 0B29B3FC5E9;
	Thu, 27 Feb 2025 20:45:56 +0800 (CST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 6/7] x86, lib: Add wbinvd and wbnoinvd helpers to target
 multiple CPUs
From: Zheyun Shen <szy0127@sjtu.edu.cn>
In-Reply-To: <20250227014858.3244505-7-seanjc@google.com>
Date: Thu, 27 Feb 2025 20:45:45 +0800
Cc: linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <725F7D42-D23D-4033-AF52-7B4013B04992@sjtu.edu.cn>
References: <20250227014858.3244505-1-seanjc@google.com>
 <20250227014858.3244505-7-seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3826.200.121)

Hi Sean,
Thank you for reviewing and combining the codes. 
> +static inline wbnoinvd_on_many_cpus(struct cpumask *cpus)
> +{
> + wbnoinvd();
> +}
The code above is missing the void return type.

Thank you!



