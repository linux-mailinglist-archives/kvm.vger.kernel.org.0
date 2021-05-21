Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847DF38C7E7
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 15:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhEUN1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 09:27:03 -0400
Received: from foss.arm.com ([217.140.110.172]:47306 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235201AbhEUN05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 09:26:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55B3811B3;
        Fri, 21 May 2021 06:25:34 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.33.243])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 795FC3F73B;
        Fri, 21 May 2021 06:25:28 -0700 (PDT)
Date:   Fri, 21 May 2021 14:25:19 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Joe Richey <joerichey94@gmail.com>
Cc:     trivial@kernel.org, Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Lei Cao <lei.cao@stratus.com>,
        Peter Xu <peterx@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [PATCH v2 3/7] drivers: firmware: psci:  Use _BITUL() macro in
 UAPI headers
Message-ID: <20210521132519.GA7325@C02TD0UTHF1T.local>
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <20210521085849.37676-1-joerichey94@gmail.com>
 <20210521085849.37676-4-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521085849.37676-4-joerichey94@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 01:58:44AM -0700, Joe Richey wrote:
> From: Joe Richey <joerichey@google.com>
> 
> Replace BIT() in psci's UPAI header with _BITUL(). BIT() is not defined
> in the UAPI headers and its usage may cause userspace build errors.
> 
> Fixes: 60dd1ead65e8 ("drivers: firmware: psci: Announce support for OS initiated suspend mode")
> Signed-off-by: Joe Richey <joerichey@google.com>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  include/uapi/linux/psci.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
> index 2fcad1dd0b0e..87afdeb95096 100644
> --- a/include/uapi/linux/psci.h
> +++ b/include/uapi/linux/psci.h
> @@ -12,6 +12,8 @@
>  #ifndef _UAPI_LINUX_PSCI_H
>  #define _UAPI_LINUX_PSCI_H
>  
> +#include <linux/const.h>
> +
>  /*
>   * PSCI v0.1 interface
>   *
> @@ -100,7 +102,7 @@
>  #define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_MASK	\
>  			(0x1 << PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT)
>  
> -#define PSCI_1_0_OS_INITIATED			BIT(0)
> +#define PSCI_1_0_OS_INITIATED			_BITUL(0)
>  #define PSCI_1_0_SUSPEND_MODE_PC		0
>  #define PSCI_1_0_SUSPEND_MODE_OSI		1
>  
> -- 
> 2.31.1
> 
