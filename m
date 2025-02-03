Return-Path: <kvm+bounces-37123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 857C5A2575E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 11:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D457166BD5
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1C4202C23;
	Mon,  3 Feb 2025 10:51:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B113F201260;
	Mon,  3 Feb 2025 10:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738579898; cv=none; b=aoZMd9qoLYDU8YjehGxx3Xiex7VBD4QWJQ40Zb/+ls6ZyomLxGgEG+8oRhW8iWMm3o3it43dMBNMhubCj0S15Dfvv0jsl8SFuSS1912GSjYu+0V4H3FzU0CHml7K90baXHh8swTkyPCg4rIhYGiYWUgyqA2rs+PzI7VTwvt6kPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738579898; c=relaxed/simple;
	bh=Tcm1tgf+wFlL9ZR/08nbApxKjd0Y4nSMbFU82/geICs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJAROv+3KWnXemLuaubelurIFXz56CYYnzVtJVT5euwBWX0U213WvjJ7x6xCzh+hLtaHXfyweOOIqOcOl+RUKjx5GYscNAvHmk8JzeKy9XCoBbsEqIdgCZjxxepnBKofRb82jMFwvFy5oEZDt2701ABpZOSJKwUVlun+h/sdRi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Ymjsp2pBRz6L4wL;
	Mon,  3 Feb 2025 18:49:02 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 181E1140A34;
	Mon,  3 Feb 2025 18:51:34 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Feb
 2025 11:51:33 +0100
Date: Mon, 3 Feb 2025 10:51:32 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC: Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, Shiju Jose <shiju.jose@huawei.com>, <qemu-arm@nongnu.org>,
	<qemu-devel@nongnu.org>, Ani Sinha <anisinha@redhat.com>, Dongjiu Geng
	<gengdongjiu1@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Peter
 Maydell" <peter.maydell@linaro.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/14] acpi/ghes: Cleanup the code which gets ghes
 ged state
Message-ID: <20250203105132.00007af7@huawei.com>
In-Reply-To: <46ef959f50967b6e65310f81b795c60e6ff97be3.1738345063.git.mchehab+huawei@kernel.org>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<46ef959f50967b6e65310f81b795c60e6ff97be3.1738345063.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Fri, 31 Jan 2025 18:42:49 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Move the check logic into a common function and simplify the
> code which checks if GHES is enabled and was properly setup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by:  Igor Mammedov <imammedo@redhat.com>

One minor comment inline on a change I think should be in an earlier
patch.

> -void ghes_record_cper_errors(const void *cper, size_t len,
> +void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
>                               uint16_t source_id, Error **errp)
>  {
>      uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
> -    AcpiGedState *acpi_ged_state;
> -    AcpiGhesState *ags;
>  
>      if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
>          error_setg(errp, "GHES CPER record is too big: %zd", len);
>          return;
>      }
>  
> -    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> -                                                       NULL));
> -    if (!acpi_ged_state) {
> -        error_setg(errp, "Can't find ACPI_GED object");
> -        return;
> -    }
> -    ags = &acpi_ged_state->ghes_state;
> -
> -    if (!ags->hest_addr_le) {
> +    if (!ags->use_hest_addr) {

Should this change be moved back to patch 3?  use_hest_addr was available
at that point and it would reduce churn a tiny bit.

>          get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
>                               &cper_addr, &read_ack_register_addr);
>      } else {
> @@ -547,11 +531,6 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>                                  &cper_addr, &read_ack_register_addr, errp);
>      }
>  
> -    if (!cper_addr) {
> -        error_setg(errp, "can not find Generic Error Status Block");
> -        return;
> -    }
> -
>      cpu_physical_memory_read(read_ack_register_addr,
>                               &read_ack_register, sizeof(read_ack_register));
>  

