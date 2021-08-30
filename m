Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E06D3FB98D
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbhH3QAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 12:00:16 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:23055 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbhH3QAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 12:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630339163; x=1661875163;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0yCDVIeT6P3oOabTyC7LJ9ujB/tzPO1yDqrxY+d4zUk=;
  b=A2Rso8eZgBf6z0y0Vi+I4sousiJeSKmIpfsmJHvz2PE61Su/B5pEK7lV
   Tj3ZcofHlGiUsMA9eu6iNXmNYVnTvbwMM1FMuZaWU/AKwNWBKWEtLC5YE
   nc4oJqsfLZU/POSeYgnPWyxhw72y1BZgZEe9yfJDQ2MubxZZio+QCWpQU
   M=;
X-IronPort-AV: E=Sophos;i="5.84,363,1620691200"; 
   d="scan'208";a="133235140"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 30 Aug 2021 15:59:22 +0000
Received: from EX13D46EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 5E910A1CFA;
        Mon, 30 Aug 2021 15:59:19 +0000 (UTC)
Received: from u90cef543d0ab5a.ant.amazon.com (10.43.160.90) by
 EX13D46EUB004.ant.amazon.com (10.43.166.65) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 15:59:13 +0000
Date:   Mon, 30 Aug 2021 18:59:08 +0300
From:   George-Aurelian Popescu <popegeo@amazon.com>
To:     Andra Paraschiv <andraprs@amazon.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v3 1/7] nitro_enclaves: Enable Arm64 support
Message-ID: <20210830155907.GG10224@u90cef543d0ab5a.ant.amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-2-andraprs@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D29UWA001.ant.amazon.com (10.43.160.187) To
 EX13D46EUB004.ant.amazon.com (10.43.166.65)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:24PM +0300, Andra Paraschiv wrote:
> Update the kernel config to enable the Nitro Enclaves kernel driver for
> Arm64 support.
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Acked-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> Changelog
> 
> v1 -> v2
> 
> * No changes.
> 
> v2 -> v3
> 
> * Move changelog after the "---" line.
> ---
>  drivers/virt/nitro_enclaves/Kconfig | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
> index 8c9387a232df8..f53740b941c0f 100644
> --- a/drivers/virt/nitro_enclaves/Kconfig
> +++ b/drivers/virt/nitro_enclaves/Kconfig
> @@ -1,17 +1,13 @@
>  # SPDX-License-Identifier: GPL-2.0
>  #
> -# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> +# Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>  
>  # Amazon Nitro Enclaves (NE) support.
>  # Nitro is a hypervisor that has been developed by Amazon.
>  
> -# TODO: Add dependency for ARM64 once NE is supported on Arm platforms. For now,
> -# the NE kernel driver can be built for aarch64 arch.
> -# depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
> -
>  config NITRO_ENCLAVES
>  	tristate "Nitro Enclaves Support"
> -	depends on X86 && HOTPLUG_CPU && PCI && SMP
> +	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
>  	help
>  	  This driver consists of support for enclave lifetime management
>  	  for Nitro Enclaves (NE).
> -- 
> 2.20.1 (Apple Git-117)
> 

Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>

Awesome,
George



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

