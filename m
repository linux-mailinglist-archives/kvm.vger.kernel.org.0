Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674FA1B2F90
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgDUSub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgDUSub (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 14:50:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55082C0610D5;
        Tue, 21 Apr 2020 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=yPMqIkcWHkz3THVCYl7z3197UQiTeNurLglX61WGoIM=; b=fHCnLkAF8AouzjXU7Dj/vz9FUM
        WbpqZebgK96Zl5Bha1aTo+i3oNH3cuMDbTcwKr8spRxjEibY/7E5E/XaunV8yfY7dZuZNA3LVtneo
        j2sMbpcr0hqv1D4wV2QpcSqt0fZUI/HV+USDwGfqMtPAM1Xb4Wx1gsfdJ4oCqugI87g1Woxnpqa5i
        8pICEEkAu9/rHO2oaNGskK7QZ6cMgIy2ssRmYSo/p3rUMK3pLx2BoVwlCu6AuV1ou7mPMkEw0hqiS
        FW9UWNgJL852hHFlDJMNCCn6YhF4OG7o3B/DSiK8EbdITSGaxah0kQgiLvmjBXVDZMYP1a2YLcE6b
        l+Es1AXA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQxyY-0001SO-Ft; Tue, 21 Apr 2020 18:50:30 +0000
Subject: Re: [PATCH v1 13/15] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
To:     Andra Paraschiv <andraprs@amazon.com>, linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-14-andraprs@amazon.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0b169445-a0c6-8eef-86b8-71a09021e143@infradead.org>
Date:   Tue, 21 Apr 2020 11:50:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421184150.68011-14-andraprs@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi--

On 4/21/20 11:41 AM, Andra Paraschiv wrote:
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  drivers/virt/Kconfig        |  2 ++
>  drivers/virt/amazon/Kconfig | 28 ++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>  create mode 100644 drivers/virt/amazon/Kconfig
> 
> diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
> index 363af2eaf2ba..06bb5cfa191d 100644
> --- a/drivers/virt/Kconfig
> +++ b/drivers/virt/Kconfig
> @@ -32,4 +32,6 @@ config FSL_HV_MANAGER
>  	     partition shuts down.
>  
>  source "drivers/virt/vboxguest/Kconfig"
> +
> +source "drivers/virt/amazon/Kconfig"
>  endif
> diff --git a/drivers/virt/amazon/Kconfig b/drivers/virt/amazon/Kconfig
> new file mode 100644
> index 000000000000..57fd0aa58803
> --- /dev/null
> +++ b/drivers/virt/amazon/Kconfig
> @@ -0,0 +1,28 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or modify it
> +# under the terms and conditions of the GNU General Public License,
> +# version 2, as published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, see <http://www.gnu.org/licenses/>.
> +
> +# Amazon Nitro Enclaves (NE) support.
> +# Nitro is a hypervisor that has been developed by Amazon.
> +
> +config NITRO_ENCLAVES
> +	tristate "Nitro Enclaves Support"
> +	depends on HOTPLUG_CPU
> +	---help---

For v2:
We are moving away from the use of "---help---" to just "help".

> +	  This driver consists of support for enclave lifetime management
> +	  for Nitro Enclaves (NE).
> +
> +	  To compile this driver as a module, choose M here.
> +	  The module will be called nitro_enclaves.
> 

thanks.
-- 
~Randy

