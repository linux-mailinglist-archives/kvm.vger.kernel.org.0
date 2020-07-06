Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096E1215663
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 13:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgGFL3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 07:29:01 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:13192 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgGFL3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 07:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594034940; x=1625570940;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mRr0O6TaoOSD4wC+mXJIuv+LEUU0XRuAYgb7yAKzoIM=;
  b=nT+s8a///Hel3kSognMPQ7K4gj6Cc8DTgZa5vTwmxiCDcDET/r5G4Fud
   9u34cDBChux0VmdzH84pOsvwssL6OqO11/qN/3cXPaeerkH5KO5A3Ucnv
   ZN9RQDCMFB4yE7ZIIH5MzAGaS5JGUc8DnzVH7biF3GVlFJT8ZMVsmJ8mC
   s=;
IronPort-SDR: OiGbs+Yy6tDcmbAeuB4uhipDt8XAeSJSDgwjEP3FC+3Px0eQawXZO5CsgDNjMQ3KykAeVFkSXm
 pixhiIZoH/ig==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="57612227"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Jul 2020 11:28:59 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 401F7A2874;
        Mon,  6 Jul 2020 11:28:57 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:28:56 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.26) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 11:28:47 +0000
Subject: Re: [PATCH v4 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-15-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <0576a41d-f915-24b3-e6f9-0bc3616fd75b@amazon.de>
Date:   Mon, 6 Jul 2020 13:28:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-15-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v3 -> v4
> =

> * Add PCI and SMP dependencies.
> =

> v2 -> v3
> =

> * Remove the GPL additional wording as SPDX-License-Identifier is
>    already in place.
> =

> v1 -> v2
> =

> * Update path to Kconfig to match the drivers/virt/nitro_enclaves
>    directory.
> * Update help in Kconfig.
> ---
>   drivers/virt/Kconfig                |  2 ++
>   drivers/virt/nitro_enclaves/Kconfig | 16 ++++++++++++++++
>   2 files changed, 18 insertions(+)
>   create mode 100644 drivers/virt/nitro_enclaves/Kconfig
> =

> diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
> index cbc1f25c79ab..80c5f9c16ec1 100644
> --- a/drivers/virt/Kconfig
> +++ b/drivers/virt/Kconfig
> @@ -32,4 +32,6 @@ config FSL_HV_MANAGER
>   	     partition shuts down.
>   =

>   source "drivers/virt/vboxguest/Kconfig"
> +
> +source "drivers/virt/nitro_enclaves/Kconfig"
>   endif
> diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enc=
laves/Kconfig
> new file mode 100644
> index 000000000000..69e41aa2222d
> --- /dev/null
> +++ b/drivers/virt/nitro_enclaves/Kconfig
> @@ -0,0 +1,16 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> +
> +# Amazon Nitro Enclaves (NE) support.
> +# Nitro is a hypervisor that has been developed by Amazon.
> +
> +config NITRO_ENCLAVES
> +	tristate "Nitro Enclaves Support"
> +	depends on HOTPLUG_CPU && PCI && SMP

Let's also depend on ARM64 || X86, so that we don't burden all of the =

other archs that are not available in EC2 today with an additional =

config option to think about.

Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



