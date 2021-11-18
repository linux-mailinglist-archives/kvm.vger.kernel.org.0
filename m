Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F62145644E
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 21:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhKRUh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 15:37:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232131AbhKRUh1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 15:37:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637267666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/ZyGwagvx98okk9jPku9lIzmfCgQaYEieKJ85brleo=;
        b=ZXnX6gt3dX30aipqUp6KDlB34/RGLDwF1zLjJKHNDeKEF69Qbz7oPTQWD43/z/pZbFdc8S
        3Px6+BOrxOk+Zscp/q+zMDKe9sijuWRYXRMUPphQ/sFT84CiFkZTnAVhuKf1SS72E+6aZZ
        dw85tk/fddEzWfgbe7OfuEOY/xqloE8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-129-Iw_kd8gDOXWFo6_dnkYe9w-1; Thu, 18 Nov 2021 15:34:24 -0500
X-MC-Unique: Iw_kd8gDOXWFo6_dnkYe9w-1
Received: by mail-ed1-f72.google.com with SMTP id q17-20020aa7da91000000b003e7c0641b9cso6373132eds.12
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 12:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/ZyGwagvx98okk9jPku9lIzmfCgQaYEieKJ85brleo=;
        b=YEL5/a5KEk/tgwlrpFS4D4QgEbAjISmNqCkQXgdUy8pXdcz+KmpoonA6+E1BnqoTsV
         8t7KUYpKMZHG3DE1SIpcZV62qojlpxcPDdpL3DTwnvqXTT1zdMi3wL8WFtVXDEbC68Lc
         DPE0JMIff2JohkjJKPr4TxgGh7FZsvPC1hckOynCd2SkJbLsnjYr6pBNm8OcOGnrigyU
         HWGNajFxwFLCss9oLksV2hJVQ5ctl8c28zjpVOuMc00aTb0Jh9AV8uf5k5Jd1+mfPC2a
         bKP6e9aJtbWHQ3LP/04xvwa99MtZjOlvcYvoBJn2Rbo3jCf4EW2my8x9IH9Yqss4zit/
         CpHA==
X-Gm-Message-State: AOAM532dx19ZxYV5FVEGYpEUFviA4B5T9p0IL+m9OCWOf3IX3dfXR2AE
        HWm+Gk9VQ2zPfLqBcYqE0eX35MglsiysN2onpsRFVNoQuX5/cIDdg0uoHDthlcYzKCAKZuZEmKW
        7ZTdMfO6QikR1
X-Received: by 2002:aa7:d051:: with SMTP id n17mr15720608edo.79.1637267663416;
        Thu, 18 Nov 2021 12:34:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnf1ohWQYGRcDl3fwsoslphq0uFX/v5dsKiSp7cpOWO+zJkZT/s8VuftP2E6G0NfYCB4n+rg==
X-Received: by 2002:aa7:d051:: with SMTP id n17mr15720540edo.79.1637267662981;
        Thu, 18 Nov 2021 12:34:22 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id kx3sm331499ejc.112.2021.11.18.12.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 12:34:22 -0800 (PST)
Subject: Re: [RFC PATCH v3 29/29] KVM: arm64: selftests: Introduce id_reg_test
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-30-reijiw@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <a695d763-b631-e639-3708-2623f4842064@redhat.com>
Date:   Thu, 18 Nov 2021 21:34:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-30-reijiw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> Introduce a test for aarch64 to validate basic behavior of
> KVM_GET_ONE_REG and KVM_SET_ONE_REG for ID registers.
> 
> This test runs only when KVM_CAP_ARM_ID_REG_CONFIGURABLE is supported.

That's great to get those tests along with the series.

There are several tests actually. I would encourage you to drop a short
comment along with the each main test to summarize what it does.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/arch/arm64/include/asm/sysreg.h         |    1 +
>  tools/testing/selftests/kvm/.gitignore        |    1 +
>  tools/testing/selftests/kvm/Makefile          |    1 +
>  .../selftests/kvm/aarch64/id_reg_test.c       | 1128 +++++++++++++++++
>  4 files changed, 1131 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c
> 
> diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
> index 7640fa27be94..be3947c125f1 100644
> --- a/tools/arch/arm64/include/asm/sysreg.h
> +++ b/tools/arch/arm64/include/asm/sysreg.h
> @@ -793,6 +793,7 @@
>  #define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
>  
>  /* id_aa64pfr1 */
> +#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
>  #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
>  #define ID_AA64PFR1_RASFRAC_SHIFT	12
>  #define ID_AA64PFR1_MTE_SHIFT		8
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index d4a830139683..5daf1400f0cf 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -2,6 +2,7 @@
>  /aarch64/arch_timer
>  /aarch64/debug-exceptions
>  /aarch64/get-reg-list
> +/aarch64/id_reg_test
>  /aarch64/psci_cpu_on_test
>  /aarch64/vgic_init
>  /s390x/memop
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c4e34717826a..fee6ba13019c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -92,6 +92,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> +TEST_GEN_PROGS_aarch64 += aarch64/id_reg_test
>  TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
> diff --git a/tools/testing/selftests/kvm/aarch64/id_reg_test.c b/tools/testing/selftests/kvm/aarch64/id_reg_test.c
> new file mode 100644
> index 000000000000..50d60d120e2e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/id_reg_test.c
> @@ -0,0 +1,1128 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#define _GNU_SOURCE
> +
> +#include <stdlib.h>
> +#include <time.h>
> +#include <pthread.h>
> +#include <linux/kvm.h>
> +#include <linux/sizes.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "vgic.h"
> +
> +/*
> + * id_reg_test.c - Tests reading/writing the aarch64's ID registers
> + *
> + * The test validates KVM_SET_ONE_REG/KVM_GET_ONE_REG ioctl for ID
> + * registers as well as reading ID register from the guest works fine.
> + */
> +
> +/* Reserved ID registers */
> +#define	SYS_ID_REG_3_3_EL1		sys_reg(3, 0, 0, 3, 3)
> +#define	SYS_ID_REG_3_7_EL1		sys_reg(3, 0, 0, 3, 7)
> +
> +#define	SYS_ID_REG_4_2_EL1		sys_reg(3, 0, 0, 4, 2)
> +#define	SYS_ID_REG_4_3_EL1		sys_reg(3, 0, 0, 4, 3)
> +#define	SYS_ID_REG_4_5_EL1		sys_reg(3, 0, 0, 4, 5)
> +#define	SYS_ID_REG_4_6_EL1		sys_reg(3, 0, 0, 4, 6)
> +#define	SYS_ID_REG_4_7_EL1		sys_reg(3, 0, 0, 4, 7)
> +
> +#define	SYS_ID_REG_5_2_EL1		sys_reg(3, 0, 0, 5, 2)
> +#define	SYS_ID_REG_5_3_EL1		sys_reg(3, 0, 0, 5, 3)
> +#define	SYS_ID_REG_5_6_EL1		sys_reg(3, 0, 0, 5, 6)
> +#define	SYS_ID_REG_5_7_EL1		sys_reg(3, 0, 0, 5, 7)
> +
> +#define	SYS_ID_REG_6_2_EL1		sys_reg(3, 0, 0, 6, 2)
> +#define	SYS_ID_REG_6_3_EL1		sys_reg(3, 0, 0, 6, 3)
> +#define	SYS_ID_REG_6_4_EL1		sys_reg(3, 0, 0, 6, 4)
> +#define	SYS_ID_REG_6_5_EL1		sys_reg(3, 0, 0, 6, 5)
> +#define	SYS_ID_REG_6_6_EL1		sys_reg(3, 0, 0, 6, 6)
> +#define	SYS_ID_REG_6_7_EL1		sys_reg(3, 0, 0, 6, 7)
> +
> +#define	SYS_ID_REG_7_3_EL1		sys_reg(3, 0, 0, 7, 3)
> +#define	SYS_ID_REG_7_4_EL1		sys_reg(3, 0, 0, 7, 4)
> +#define	SYS_ID_REG_7_5_EL1		sys_reg(3, 0, 0, 7, 5)
> +#define	SYS_ID_REG_7_6_EL1		sys_reg(3, 0, 0, 7, 6)
> +#define	SYS_ID_REG_7_7_EL1		sys_reg(3, 0, 0, 7, 7)
> +
> +#define	READ_ID_REG_FN(name)	read_## name ## _EL1
> +
> +#define	DEFINE_READ_SYS_REG(reg_name)			\
> +uint64_t read_##reg_name(void)				\
> +{							\
> +	return read_sysreg_s(SYS_##reg_name);		\
> +}
> +
> +#define DEFINE_READ_ID_REG(name)	\
> +	DEFINE_READ_SYS_REG(name ## _EL1)
> +
> +#define	__ID_REG(reg_name)		\
> +	.name = #reg_name,		\
> +	.id = SYS_## reg_name ##_EL1,	\
> +	.read_reg = READ_ID_REG_FN(reg_name),
> +
> +#define	ID_REG_ENT(reg_name)	\
> +	[ID_IDX(reg_name)] = { __ID_REG(reg_name) }
> +
> +/* Functions to read each ID register */
> +/* CRm=1 */
> +DEFINE_READ_ID_REG(ID_PFR0)
> +DEFINE_READ_ID_REG(ID_PFR1)
> +DEFINE_READ_ID_REG(ID_DFR0)
> +DEFINE_READ_ID_REG(ID_AFR0)
> +DEFINE_READ_ID_REG(ID_MMFR0)
> +DEFINE_READ_ID_REG(ID_MMFR1)
> +DEFINE_READ_ID_REG(ID_MMFR2)
> +DEFINE_READ_ID_REG(ID_MMFR3)
> +
> +/* CRm=2 */
> +DEFINE_READ_ID_REG(ID_ISAR0)
> +DEFINE_READ_ID_REG(ID_ISAR1)
> +DEFINE_READ_ID_REG(ID_ISAR2)
> +DEFINE_READ_ID_REG(ID_ISAR3)
> +DEFINE_READ_ID_REG(ID_ISAR4)
> +DEFINE_READ_ID_REG(ID_ISAR5)
> +DEFINE_READ_ID_REG(ID_MMFR4)
> +DEFINE_READ_ID_REG(ID_ISAR6)
> +
> +/* CRm=3 */
> +DEFINE_READ_ID_REG(MVFR0)
> +DEFINE_READ_ID_REG(MVFR1)
> +DEFINE_READ_ID_REG(MVFR2)
> +DEFINE_READ_ID_REG(ID_REG_3_3)
> +DEFINE_READ_ID_REG(ID_PFR2)
> +DEFINE_READ_ID_REG(ID_DFR1)
> +DEFINE_READ_ID_REG(ID_MMFR5)
> +DEFINE_READ_ID_REG(ID_REG_3_7)
> +
> +/* CRm=4 */
> +DEFINE_READ_ID_REG(ID_AA64PFR0)
> +DEFINE_READ_ID_REG(ID_AA64PFR1)
> +DEFINE_READ_ID_REG(ID_REG_4_2)
> +DEFINE_READ_ID_REG(ID_REG_4_3)
> +DEFINE_READ_ID_REG(ID_AA64ZFR0)
> +DEFINE_READ_ID_REG(ID_REG_4_5)
> +DEFINE_READ_ID_REG(ID_REG_4_6)
> +DEFINE_READ_ID_REG(ID_REG_4_7)
> +
> +/* CRm=5 */
> +DEFINE_READ_ID_REG(ID_AA64DFR0)
> +DEFINE_READ_ID_REG(ID_AA64DFR1)
> +DEFINE_READ_ID_REG(ID_REG_5_2)
> +DEFINE_READ_ID_REG(ID_REG_5_3)
> +DEFINE_READ_ID_REG(ID_AA64AFR0)
> +DEFINE_READ_ID_REG(ID_AA64AFR1)
> +DEFINE_READ_ID_REG(ID_REG_5_6)
> +DEFINE_READ_ID_REG(ID_REG_5_7)
> +
> +/* CRm=6 */
> +DEFINE_READ_ID_REG(ID_AA64ISAR0)
> +DEFINE_READ_ID_REG(ID_AA64ISAR1)
> +DEFINE_READ_ID_REG(ID_REG_6_2)
> +DEFINE_READ_ID_REG(ID_REG_6_3)
> +DEFINE_READ_ID_REG(ID_REG_6_4)
> +DEFINE_READ_ID_REG(ID_REG_6_5)
> +DEFINE_READ_ID_REG(ID_REG_6_6)
> +DEFINE_READ_ID_REG(ID_REG_6_7)
> +
> +/* CRm=7 */
> +DEFINE_READ_ID_REG(ID_AA64MMFR0)
> +DEFINE_READ_ID_REG(ID_AA64MMFR1)
> +DEFINE_READ_ID_REG(ID_AA64MMFR2)
> +DEFINE_READ_ID_REG(ID_REG_7_3)
> +DEFINE_READ_ID_REG(ID_REG_7_4)
> +DEFINE_READ_ID_REG(ID_REG_7_5)
> +DEFINE_READ_ID_REG(ID_REG_7_6)
> +DEFINE_READ_ID_REG(ID_REG_7_7)
> +
> +#define	ID_IDX(name)	REG_IDX_## name
> +
> +enum id_reg_idx {
> +	/* CRm=1 */
> +	ID_IDX(ID_PFR0) = 0,
> +	ID_IDX(ID_PFR1),
> +	ID_IDX(ID_DFR0),
> +	ID_IDX(ID_AFR0),
> +	ID_IDX(ID_MMFR0),
> +	ID_IDX(ID_MMFR1),
> +	ID_IDX(ID_MMFR2),
> +	ID_IDX(ID_MMFR3),
> +
> +	/* CRm=2 */
> +	ID_IDX(ID_ISAR0),
> +	ID_IDX(ID_ISAR1),
> +	ID_IDX(ID_ISAR2),
> +	ID_IDX(ID_ISAR3),
> +	ID_IDX(ID_ISAR4),
> +	ID_IDX(ID_ISAR5),
> +	ID_IDX(ID_MMFR4),
> +	ID_IDX(ID_ISAR6),
> +
> +	/* CRm=3 */
> +	ID_IDX(MVFR0),
> +	ID_IDX(MVFR1),
> +	ID_IDX(MVFR2),
> +	ID_IDX(ID_REG_3_3),
> +	ID_IDX(ID_PFR2),
> +	ID_IDX(ID_DFR1),
> +	ID_IDX(ID_MMFR5),
> +	ID_IDX(ID_REG_3_7),
> +
> +	/* CRm=4 */
> +	ID_IDX(ID_AA64PFR0),
> +	ID_IDX(ID_AA64PFR1),
> +	ID_IDX(ID_REG_4_2),
> +	ID_IDX(ID_REG_4_3),
> +	ID_IDX(ID_AA64ZFR0),
> +	ID_IDX(ID_REG_4_5),
> +	ID_IDX(ID_REG_4_6),
> +	ID_IDX(ID_REG_4_7),
> +
> +	/* CRm=5 */
> +	ID_IDX(ID_AA64DFR0),
> +	ID_IDX(ID_AA64DFR1),
> +	ID_IDX(ID_REG_5_2),
> +	ID_IDX(ID_REG_5_3),
> +	ID_IDX(ID_AA64AFR0),
> +	ID_IDX(ID_AA64AFR1),
> +	ID_IDX(ID_REG_5_6),
> +	ID_IDX(ID_REG_5_7),
> +
> +	/* CRm=6 */
> +	ID_IDX(ID_AA64ISAR0),
> +	ID_IDX(ID_AA64ISAR1),
> +	ID_IDX(ID_REG_6_2),
> +	ID_IDX(ID_REG_6_3),
> +	ID_IDX(ID_REG_6_4),
> +	ID_IDX(ID_REG_6_5),
> +	ID_IDX(ID_REG_6_6),
> +	ID_IDX(ID_REG_6_7),
> +
> +	/* CRm=7 */
> +	ID_IDX(ID_AA64MMFR0),
> +	ID_IDX(ID_AA64MMFR1),
> +	ID_IDX(ID_AA64MMFR2),
> +	ID_IDX(ID_REG_7_3),
> +	ID_IDX(ID_REG_7_4),
> +	ID_IDX(ID_REG_7_5),
> +	ID_IDX(ID_REG_7_6),
> +	ID_IDX(ID_REG_7_7),
> +};
> +
> +struct id_reg_test_info {
> +	char		*name;
> +	uint32_t	id;
> +	bool		can_clear;
> +	uint64_t	fixed_mask;
> +	uint64_t	org_val;
nit: original_val? or default_val?
> +	uint64_t	user_val;
> +	uint64_t	(*read_reg)(void);
> +};
> +
> +#define	ID_REG_INFO(name)	(&id_reg_list[ID_IDX(name)])
> +static struct id_reg_test_info id_reg_list[] = {
> +	/* CRm=1 */
> +	ID_REG_ENT(ID_PFR0),
> +	ID_REG_ENT(ID_PFR1),
> +	ID_REG_ENT(ID_DFR0),
> +	ID_REG_ENT(ID_AFR0),
> +	ID_REG_ENT(ID_MMFR0),
> +	ID_REG_ENT(ID_MMFR1),
> +	ID_REG_ENT(ID_MMFR2),
> +	ID_REG_ENT(ID_MMFR3),
> +
> +	/* CRm=2 */
> +	ID_REG_ENT(ID_ISAR0),
> +	ID_REG_ENT(ID_ISAR1),
> +	ID_REG_ENT(ID_ISAR2),
> +	ID_REG_ENT(ID_ISAR3),
> +	ID_REG_ENT(ID_ISAR4),
> +	ID_REG_ENT(ID_ISAR5),
> +	ID_REG_ENT(ID_MMFR4),
> +	ID_REG_ENT(ID_ISAR6),
> +
> +	/* CRm=3 */
> +	ID_REG_ENT(MVFR0),
> +	ID_REG_ENT(MVFR1),
> +	ID_REG_ENT(MVFR2),
> +	ID_REG_ENT(ID_REG_3_3),
> +	ID_REG_ENT(ID_PFR2),
> +	ID_REG_ENT(ID_DFR1),
> +	ID_REG_ENT(ID_MMFR5),
> +	ID_REG_ENT(ID_REG_3_7),
> +
> +	/* CRm=4 */
> +	ID_REG_ENT(ID_AA64PFR0),
> +	ID_REG_ENT(ID_AA64PFR1),
> +	ID_REG_ENT(ID_REG_4_2),
> +	ID_REG_ENT(ID_REG_4_3),
> +	ID_REG_ENT(ID_AA64ZFR0),
> +	ID_REG_ENT(ID_REG_4_5),
> +	ID_REG_ENT(ID_REG_4_6),
> +	ID_REG_ENT(ID_REG_4_7),
> +
> +	/* CRm=5 */
> +	ID_REG_ENT(ID_AA64DFR0),
> +	ID_REG_ENT(ID_AA64DFR1),
> +	ID_REG_ENT(ID_REG_5_2),
> +	ID_REG_ENT(ID_REG_5_3),
> +	ID_REG_ENT(ID_AA64AFR0),
> +	ID_REG_ENT(ID_AA64AFR1),
> +	ID_REG_ENT(ID_REG_5_6),
> +	ID_REG_ENT(ID_REG_5_7),
> +
> +	/* CRm=6 */
> +	ID_REG_ENT(ID_AA64ISAR0),
> +	ID_REG_ENT(ID_AA64ISAR1),
> +	ID_REG_ENT(ID_REG_6_2),
> +	ID_REG_ENT(ID_REG_6_3),
> +	ID_REG_ENT(ID_REG_6_4),
> +	ID_REG_ENT(ID_REG_6_5),
> +	ID_REG_ENT(ID_REG_6_6),
> +	ID_REG_ENT(ID_REG_6_7),
> +
> +	/* CRm=7 */
> +	ID_REG_ENT(ID_AA64MMFR0),
> +	ID_REG_ENT(ID_AA64MMFR1),
> +	ID_REG_ENT(ID_AA64MMFR2),
> +	ID_REG_ENT(ID_REG_7_3),
> +	ID_REG_ENT(ID_REG_7_4),
> +	ID_REG_ENT(ID_REG_7_5),
> +	ID_REG_ENT(ID_REG_7_6),
> +	ID_REG_ENT(ID_REG_7_7),
> +};
> +
> +/* Utilities to get a feature field from ID register value */
> +static inline int
> +cpuid_signed_field_width(uint64_t id_val, int field, int width)
> +{
> +	return (s64)(id_val << (64 - width - field)) >> (64 - width);
> +}
> +
> +static unsigned int
> +cpuid_unsigned_field_width(uint64_t id_val, int field, int width)
> +{
> +	return (uint64_t)(id_val << (64 - width - field)) >> (64 - width);
> +}
> +
> +static inline int __attribute_const__
> +cpuid_extract_field_width(uint64_t id_val, int field, int width, bool sign)
> +{
> +	return (sign) ? cpuid_signed_field_width(id_val, field, width) :
> +			cpuid_unsigned_field_width(id_val, field, width);
> +}
> +
> +#define	GET_ID_FIELD(regval, shift, is_signed)	\
> +	cpuid_extract_field_width(regval, shift, 4, is_signed)
> +
> +#define	GET_ID_UFIELD(regval, shift)	\
> +	cpuid_unsigned_field_width(regval, shift, 4)
> +
> +#define	UPDATE_ID_UFIELD(regval, shift, fval)	\
> +	(((regval) & ~(0xfULL << (shift))) |	\
> +	 (((uint64_t)((fval) & 0xf)) << (shift)))
> +
> +void test_pmu_init(struct kvm_vm *vm, uint32_t vcpu)
I would remove the test_ prefix as it does not test anything but
enhances the initialization instead
> +{
> +	struct kvm_device_attr attr = {
> +		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
> +		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
> +	};
> +	vcpu_ioctl(vm, vcpu, KVM_SET_DEVICE_ATTR, &attr);
> +}
> +
> +void test_sve_init(struct kvm_vm *vm, uint32_t vcpu)
> +{
> +	int feature = KVM_ARM_VCPU_SVE;
> +
> +	vcpu_ioctl(vm, vcpu, KVM_ARM_VCPU_FINALIZE, &feature);
> +}
> +
> +#define GICD_BASE_GPA			0x8000000ULL
> +#define GICR_BASE_GPA			0x80A0000ULL
> +
> +void test_vgic_init(struct kvm_vm *vm, uint32_t vcpu)
> +{
> +	/* We jsut need to configure gic v3 (we don't use it though) */
> +	vgic_v3_setup(vm, 1, GICD_BASE_GPA, GICR_BASE_GPA);
> +}
> +
> +#define	MAX_CAPS	2
> +struct feature_test_info {
> +	char	*name;	/* Feature Name (Debug information) */
> +	struct id_reg_test_info	*sreg;	/* ID register for the feature */
ID register comprising the feature?
> +	int	shift;	/* Field of the ID register for the feature */
I guess you mean feature field bit shift
> +	int	min;	/* Min value to indicate the feature */
Min value that can be assigned to the feature field?
> +	bool	is_sign;	/* Is the field signed or unsigned ? */
> +	int	ncaps;		/* Number of valid Capabilities in caps[] */
> +	long	caps[MAX_CAPS];	/* Capabilities to indicate this feature */
I suggest: KVM_CAP_* capabilities requested to test this feature
> +	/* struct kvm_enable_cap to use the capability if needed */
> +	struct kvm_enable_cap	*opt_in_cap;
> +	bool	run_test;	/* Does guest run test for this feature ? */
s/run_test/guest_run?
> +	/* Initialization function for the feature as needed */
extra init sequence needed besides KVM CAP setting?
> +	void	(*init_feature)(struct kvm_vm *vm, uint32_t vcpuid);
> +	/* struct kvm_vcpu_init to opt-in the feature if needed */
> +	struct kvm_vcpu_init	*vcpu_init;
> +};
> +
> +/* Test for optin CPU features */
opt-in?
> +static struct feature_test_info feature_test_info_table[] = {
> +	{
> +		.name = "SVE",
> +		.sreg = ID_REG_INFO(ID_AA64PFR0),
> +		.shift = ID_AA64PFR0_SVE_SHIFT,
> +		.min = 1,
> +		.caps = {KVM_CAP_ARM_SVE},
> +		.ncaps = 1,
> +		.init_feature = test_sve_init,
> +		.vcpu_init = &(struct kvm_vcpu_init) {
> +			.features = {1ULL << KVM_ARM_VCPU_SVE},
> +		},
> +	},
> +	{
> +		.name = "GIC",
> +		.sreg = ID_REG_INFO(ID_AA64PFR0),
> +		.shift = ID_AA64PFR0_GIC_SHIFT,
> +		.min = 1,
> +		.caps = {KVM_CAP_IRQCHIP},
> +		.ncaps = 1,
> +		.init_feature = test_vgic_init,
> +	},
> +	{
> +		.name = "MTE",
> +		.sreg = ID_REG_INFO(ID_AA64PFR1),
> +		.shift = ID_AA64PFR1_MTE_SHIFT,
> +		.min = 2,
> +		.caps = {KVM_CAP_ARM_MTE},
> +		.ncaps = 1,
> +		.opt_in_cap = &(struct kvm_enable_cap) {
> +				.cap = KVM_CAP_ARM_MTE,
> +		},
> +	},
> +	{
> +		.name = "PMUV3",
> +		.sreg = ID_REG_INFO(ID_AA64DFR0),
> +		.shift = ID_AA64DFR0_PMUVER_SHIFT,
> +		.min = 1,
> +		.init_feature = test_pmu_init,
> +		.caps = {KVM_CAP_ARM_PMU_V3},
> +		.ncaps = 1,
> +		.vcpu_init = &(struct kvm_vcpu_init) {
> +			.features = {1ULL << KVM_ARM_VCPU_PMU_V3},
> +		},
> +	},
> +	{
> +		.name = "PERFMON",
> +		.sreg = ID_REG_INFO(ID_DFR0),
> +		.shift = ID_DFR0_PERFMON_SHIFT,
> +		.min = 3,
> +		.init_feature = test_pmu_init,
> +		.caps = {KVM_CAP_ARM_PMU_V3},
> +		.ncaps = 1,
> +		.vcpu_init = &(struct kvm_vcpu_init) {
> +			.features = {1ULL << KVM_ARM_VCPU_PMU_V3},
> +		},
> +	},
> +};
> +
> +static int walk_id_reg_list(int (*fn)(struct id_reg_test_info *sreg, void *arg),
> +			    void *arg)
> +{
> +	int ret = 0, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(id_reg_list); i++) {
> +		ret = fn(&id_reg_list[i], arg);
> +		if (ret)
> +			break;
none of your fn() function does return something != 0
> +	}
> +	return ret;
> +}
> +
> +static int guest_code_id_reg_check_one(struct id_reg_test_info *sreg, void *arg)
> +{
> +	uint64_t val = sreg->read_reg();
> +
> +	GUEST_ASSERT_2(val == sreg->user_val, sreg->name, sreg->user_val);
> +	return 0;
> +}
> +
> +static void guest_code_id_reg_check_all(uint32_t cpu)
> +{
> +	walk_id_reg_list(guest_code_id_reg_check_one, NULL);
> +	GUEST_DONE();
> +}
> +
> +static void guest_code_do_nothing(uint32_t cpu)
> +{
> +	GUEST_DONE();
> +}
> +
> +static void guest_code_feature_check(uint32_t cpu)
> +{
> +	int i;
> +	struct feature_test_info *finfo;
> +
> +	for (i = 0; i < ARRAY_SIZE(feature_test_info_table); i++) {
> +		finfo = &feature_test_info_table[i];
> +		if (finfo->run_test)
> +			guest_code_id_reg_check_one(finfo->sreg, NULL);
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_code_ptrauth_check(uint32_t cpuid)
> +{
> +	struct id_reg_test_info *sreg = ID_REG_INFO(ID_AA64ISAR1);
> +	uint64_t val = sreg->read_reg();
> +
> +	GUEST_ASSERT_2(val == sreg->user_val, "PTRAUTH", val);
> +	GUEST_DONE();
> +}
> +
> +static int reset_id_reg_info_one(struct id_reg_test_info *sreg, void *arg)
reset_id_reg_user_val_one()?
> +{
> +	sreg->user_val = sreg->org_val;
> +	return 0;
> +}
> +
> +static void reset_id_reg_info(void)
reset_id_reg_user_val()?
> +{
> +	walk_id_reg_list(reset_id_reg_info_one, NULL);
> +}
> +
> +static struct kvm_vm *test_vm_create_cap(uint32_t nvcpus,
> +		void (*guest_code)(uint32_t), struct kvm_vcpu_init *init,
> +		struct kvm_enable_cap *cap)
> +{
> +	struct kvm_vm *vm;
> +	uint32_t cpuid;
> +	uint64_t mem_pages;
> +
> +	mem_pages = DEFAULT_GUEST_PHY_PAGES + DEFAULT_STACK_PGS * nvcpus;
> +	mem_pages += mem_pages / (PTES_PER_MIN_PAGE * 2);
> +	mem_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, mem_pages);


> +
> +	vm = vm_create(VM_MODE_DEFAULT,
> +		DEFAULT_GUEST_PHY_PAGES + (DEFAULT_STACK_PGS * nvcpus),
> +		O_RDWR);
mem_pages must be used instead

augere@virtlab-arm04:~/UPSTREAM/ML/tools/testing/selftests/kvm#
./aarch64/id_reg_test
==== Test Assertion Failure ====
  lib/kvm_util.c:825: vm_adjust_num_guest_pages(vm->mode, npages) == npages
  pid=11439 tid=11439 errno=0 - Success
     1	0x00000000004068cb: vm_userspace_mem_region_add at kvm_util.c:823
     2	0x00000000004071af: vm_create at kvm_util.c:319
     3	0x0000000000401afb: test_vm_create_cap at id_reg_test.c:508
     4	0x00000000004014a3: test_vm_create at id_reg_test.c:541
     5	 (inlined by) init_id_reg_info at id_reg_test.c:1110
     6	 (inlined by) main at id_reg_test.c:1125
     7	0x000003ffa7220de3: ?? ??:0
     8	0x00000000004015eb: _start at :?
  Number of guest pages is not compatible with the host. Try npages=528


Don't you want to check the cap in a first place using kvm_check_cap and
cap->cap
> +	if (cap)
> +		vm_enable_cap(vm, cap);
> +
> +	kvm_vm_elf_load(vm, program_invocation_name);
> +
> +	if (init && init->target == -1) {
> +		struct kvm_vcpu_init preferred;
> +
> +		vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
> +		init->target = preferred.target;
> +	}
> +
> +	vm_init_descriptor_tables(vm);
> +	for (cpuid = 0; cpuid < nvcpus; cpuid++) {
> +		if (init)
> +			aarch64_vcpu_add_default(vm, cpuid, init, guest_code);
> +		else
> +			vm_vcpu_add_default(vm, cpuid, guest_code);
nit: vm_vcpu_add_default calls aarch64_vcpu_add_default(vm, vcpuid,
NULL, guest_code) so you can unconditionnaly call
aarch64_vcpu_add_default(vm, cpuid, init, guest_code)
> +
> +		vcpu_init_descriptor_tables(vm, cpuid);
> +	}
> +
> +	ucall_init(vm, NULL);
> +	return vm;
> +}
> +
> +static struct kvm_vm *test_vm_create(uint32_t nvcpus,
> +				     void (*guest_code)(uint32_t),
> +				     struct kvm_vcpu_init *init)
> +{
> +	return test_vm_create_cap(nvcpus, guest_code, init, NULL);
> +}
nit: not sure test_vm_create is needed. By the way it is already called
with init = NULL so we can call test_vm_create_cap with 2 NULL args
> +
> +static void test_vm_free(struct kvm_vm *vm)
> +{
> +	ucall_uninit(vm);
> +	kvm_vm_free(vm);
> +}
> +
> +#define	TEST_RUN(vm, cpu)	\
> +	(test_vcpu_run(__func__, __LINE__, vm, cpu, true))
> +
> +#define	TEST_RUN_NO_SYNC_DATA(vm, cpu)	\
> +	(test_vcpu_run(__func__, __LINE__, vm, cpu, false))
> +
> +static int test_vcpu_run(const char *test_name, int line,
> +			 struct kvm_vm *vm, uint32_t vcpuid, bool sync_data)
> +{
> +	struct ucall uc;
> +	int ret;
> +
> +	if (sync_data) {
> +		sync_global_to_guest(vm, id_reg_list);
> +		sync_global_to_guest(vm, feature_test_info_table);
> +	}
> +
> +	vcpu_args_set(vm, vcpuid, 1, vcpuid);
> +
> +	ret = _vcpu_run(vm, vcpuid);
> +	if (ret) {
> +		ret = errno;
> +		goto sync_exit;
> +	}
> +
> +	switch (get_ucall(vm, vcpuid, &uc)) {
> +	case UCALL_SYNC:
> +	case UCALL_DONE:
> +		ret = 0;
> +		break;
> +	case UCALL_ABORT:
> +		TEST_FAIL(
> +		    "%s (%s) at line %d (user %s at line %d), args[3]=0x%lx",
> +		    (char *)uc.args[0], (char *)uc.args[2], (int)uc.args[1],
> +		    test_name, line, uc.args[3]);
> +		break;
> +	default:
> +		TEST_FAIL("Unexpected guest exit\n");
> +	}
> +
> +sync_exit:
> +	if (sync_data) {
> +		sync_global_from_guest(vm, id_reg_list);
> +		sync_global_from_guest(vm, feature_test_info_table);
> +	}
> +	return ret;
> +}
> +
> +static int set_id_regs_after_run_test_one(struct id_reg_test_info *sreg,
> +					  void *arg)
> +{
> +	struct kvm_vm *vm = arg;
> +	struct kvm_one_reg one_reg;
> +	uint32_t vcpuid = 0;
> +	uint64_t reg_val;
> +	int ret;
> +
> +	one_reg.addr = (uint64_t)&reg_val;
> +	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
> +
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
> +	if ((reg_val != 0) && (sreg->can_clear)) {
> +		reg_val = 0;
> +		ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
> +		TEST_ASSERT(ret && errno == EINVAL,
> +			    "Changing ID reg value should fail\n");
> +	}
> +
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
> +	TEST_ASSERT(ret == 0, "Setting the same ID reg value should work\n");
> +
> +	return 0;
> +}
> +
> +static int set_id_regs_test_one(struct id_reg_test_info *sreg, void *arg)
if it is a test use test_ prefix
> +{
> +	struct kvm_vm *vm = arg;
> +	struct kvm_one_reg one_reg;
> +	uint32_t vcpuid = 0;
> +	uint64_t reg_val;
> +
> +	one_reg.addr = (uint64_t)&reg_val;
> +	reset_id_reg_info();
> +
> +	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
> +	if (sreg->can_clear) {
> +		/* Change the register to 0 when possible */
> +		reg_val = 0;
> +		vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
> +		vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
> +		TEST_ASSERT(reg_val == 0,
> +		    "GET(%s) didn't return 0 but 0x%lx", sreg->name, reg_val);
> +	}
> +
> +	/* Check if we can restore the initial value */
> +	reg_val = sreg->org_val;
> +	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
> +	TEST_ASSERT(reg_val == sreg->org_val,
> +		    "GET(%s) didn't return 0x%lx but 0x%lx",
> +		    sreg->name, sreg->org_val, reg_val);
> +	sreg->user_val = sreg->org_val;
> +	return 0;
> +}
> +
> +static void set_id_regs_test(void)
if it is a test use test_ prefix
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	reset_id_reg_info();
> +	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL);
add test_vm_free()
> +
> +	ret = walk_id_reg_list(set_id_regs_test_one, vm);
> +	assert(!ret);
> +
> +	ret = TEST_RUN(vm, 0);
> +	TEST_ASSERT(!ret, "%s TEST_RUN failed, ret=0x%x", __func__, ret);
> +
> +	ret = walk_id_reg_list(set_id_regs_after_run_test_one, vm);
> +	assert(!ret);
> +}
> +
> +static bool caps_are_supported(long *caps, int ncaps)
> +{
> +	int i;
> +
> +	for (i = 0; i < ncaps; i++) {
> +		if (kvm_check_cap(caps[i]) <= 0)
> +			return false;
> +	}
> +	return true;
> +}
> +
> +static void test_feature_ptrauth(void)
> +{
> +	struct kvm_one_reg one_reg;
> +	struct kvm_vcpu_init init;
> +	struct kvm_vm *vm = NULL;
> +	struct id_reg_test_info *sreg = ID_REG_INFO(ID_AA64ISAR1);
> +	uint32_t vcpu = 0;
> +	int64_t rval;
> +	int ret;
> +	int apa, api, gpa, gpi;
> +	char *name = "PTRAUTH";
> +	long caps[2] = {KVM_CAP_ARM_PTRAUTH_ADDRESS,
> +			KVM_CAP_ARM_PTRAUTH_GENERIC};
> +
> +	reset_id_reg_info();
> +	one_reg.addr = (uint64_t)&rval;
> +	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
> +
> +	if (caps_are_supported(caps, 2)) {
> +
> +		/* Test with feature enabled */
> +		memset(&init, 0, sizeof(init));
> +		init.target = -1;
> +		init.features[0] = (1ULL << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
> +				    1ULL << KVM_ARM_VCPU_PTRAUTH_GENERIC);
> +		vm = test_vm_create_cap(1, guest_code_ptrauth_check, &init,
> +					NULL);
> +		vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
> +		apa = GET_ID_UFIELD(rval, ID_AA64ISAR1_APA_SHIFT);
> +		api = GET_ID_UFIELD(rval, ID_AA64ISAR1_API_SHIFT);
> +		gpa = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPA_SHIFT);
> +		gpi = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPI_SHIFT);
> +
> +		TEST_ASSERT((apa > 0) || (api > 0),
> +			    "Either apa(0x%x) or api(0x%x) must be available",
> +			    apa, gpa);
> +		TEST_ASSERT((gpa > 0) || (gpi > 0),
> +			    "Either gpa(0x%x) or gpi(0x%x) must be available",
> +			    gpa, gpi);
> +
> +		TEST_ASSERT((apa > 0) ^ (api > 0),
> +			    "Both apa(0x%x) and api(0x%x) must not be available",
> +			    apa, api);
> +		TEST_ASSERT((gpa > 0) ^ (gpi > 0),
> +			    "Both gpa(0x%x) and gpi(0x%x) must not be available",
> +			    gpa, gpi);
> +
> +		sreg->user_val = rval;
> +
> +		pr_debug("%s: Test with %s enabled (%s: 0x%lx)\n",
> +			 __func__, name, sreg->name, sreg->user_val);
> +		ret = TEST_RUN(vm, vcpu);
> +		TEST_ASSERT(!ret, "%s:KVM_RUN failed with %s enabled",
> +			    __func__, name);
> +		test_vm_free(vm);
> +	}
> +
> +	/* Test with feature disabled */
> +	reset_id_reg_info();
> +
> +	vm = test_vm_create(1, guest_code_feature_check, NULL);
> +	vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
> +
> +	apa = GET_ID_UFIELD(rval, ID_AA64ISAR1_APA_SHIFT);
> +	api = GET_ID_UFIELD(rval, ID_AA64ISAR1_API_SHIFT);
> +	gpa = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPA_SHIFT);
> +	gpi = GET_ID_UFIELD(rval, ID_AA64ISAR1_GPI_SHIFT);
> +	TEST_ASSERT(!apa && !api && !gpa && !gpi,
> +	    "apa(0x%x), api(0x%x), gpa(0x%x), gpi(0x%x) must be zero",
> +	    apa, api, gpa, gpi);
> +
> +	pr_debug("%s: Test with %s disabled (%s: 0x%lx)\n",
> +		 __func__, name, sreg->name, sreg->user_val);
> +
> +	ret = TEST_RUN(vm, vcpu);
> +	TEST_ASSERT(!ret, "%s TEST_RUN failed with %s enabled, ret=0x%x",
> +		    __func__, name, ret);
> +
> +	test_vm_free(vm);
> +}
> +
> +static bool feature_caps_are_available(struct feature_test_info *finfo)
> +{
> +	return ((finfo->ncaps > 0) &&
> +		caps_are_supported(finfo->caps, finfo->ncaps));
> +}
> +
comment with short explanation of what the test does
> +static void test_feature(struct feature_test_info *finfo)
> +{
> +	struct id_reg_test_info *sreg = finfo->sreg;
> +	struct kvm_one_reg one_reg;
> +	struct kvm_vcpu_init init, *initp = NULL;
> +	struct kvm_vm *vm = NULL;
> +	int64_t fval, reg_val;
> +	uint32_t vcpu = 0;
> +	bool is_sign = finfo->is_sign;
> +	int min = finfo->min;
> +	int shift = finfo->shift;
> +	int ret;
> +
> +	pr_debug("%s: %s (reg %s)\n", __func__, finfo->name, sreg->name);
> +
> +	reset_id_reg_info();
> +	finfo->run_test = 1;	/* Indicate that guest runs the test on it */
> +	one_reg.addr = (uint64_t)&reg_val;
> +	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
> +
> +	/* Test with feature enabled if the feature is available */
s/if the feature is available/if the feature is exposed in the default
ID_REG value and if the capabilities are supported at KVM level
> +	if ((GET_ID_FIELD(sreg->org_val, shift, is_sign) >= min) ||
> +	    feature_caps_are_available(finfo)) {
> +		if (finfo->vcpu_init) {
> +			/*
> +			 * Need to enable the feature via
> +			 * KVM_ARM_VCPU_INIT.
> +			 */
> +			memset(&init, 0, sizeof(init));
> +			init = *finfo->vcpu_init;
> +			init.target = -1;
> +			initp = &init;
> +		}
> +
> +		vm = test_vm_create_cap(1, guest_code_feature_check, initp,
> +					finfo->opt_in_cap);
> +		if (finfo->init_feature)
> +			/* Run any required extra process to use the feature */
> +			finfo->init_feature(vm, vcpu);
> +
> +		/* Check if the ID register value indicates the feature */
> +		vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
> +		fval = GET_ID_FIELD(reg_val, shift, is_sign);
> +		TEST_ASSERT(fval >= min, "%s field of %s is too small (%ld)",
> +			    finfo->name, sreg->name, fval);
> +		sreg->user_val = reg_val;
> +
> +		pr_debug("%s: Test with %s enabled (%s: 0x%lx)\n",
> +			 __func__, finfo->name, sreg->name, sreg->user_val);
> +
> +		ret = TEST_RUN(vm, vcpu);
> +		TEST_ASSERT(!ret, "%s:TEST_RUN failed with %s enabled",
> +			    __func__, finfo->name);
> +		test_vm_free(vm);
> +	}
> +
> +	/* Test with feature disabled */
> +	reset_id_reg_info();
> +
> +	vm = test_vm_create(1, guest_code_feature_check, NULL);
> +	vcpu_ioctl(vm, vcpu, KVM_GET_ONE_REG, &one_reg);
> +	fval = GET_ID_FIELD(reg_val, shift, is_sign);
> +	if (finfo->vcpu_init || finfo->opt_in_cap) {
> +		/*
> +		 * If the feature needs to be enabled with KVM_ARM_VCPU_INIT
> +		 * or opt-in capabilities, the default value of the ID register
> +		 * shouldn't indicate the feature.
> +		 */
> +		TEST_ASSERT(fval < min, "%s field of %s is too big (%ld)",
> +		    finfo->name, sreg->name, fval);
> +	} else {
> +		/* Update the relevant field to hide the feature. */
> +		fval = is_sign ? 0xf : 0x0;
> +		reg_val = UPDATE_ID_UFIELD(reg_val, shift, fval);
> +		ret = _vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
> +		TEST_ASSERT(ret == 0, "Disabling %s failed %d\n",
> +			    finfo->name, ret);
> +		sreg->user_val = reg_val;
> +	}
> +
> +	pr_debug("%s: Test with %s disabled (%s: 0x%lx)\n",
> +		 __func__, finfo->name, sreg->name, sreg->user_val);
> +
> +	ret = TEST_RUN(vm, vcpu);
> +	finfo->run_test = 0;
> +	test_vm_free(vm);
> +}
> +
> +static void test_feature_all(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(feature_test_info_table); i++)
> +		test_feature(&feature_test_info_table[i]);
> +}
> +
> +int test_set_reg(struct id_reg_test_info *sreg, uint64_t new_val,
> +		 bool guest_run)
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +	uint32_t vcpu = 0;
> +	uint64_t reg_val;
> +	struct kvm_one_reg one_reg;
> +
> +	reset_id_reg_info();
> +
> +	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL);
> +	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
> +	one_reg.addr = (uint64_t)&reg_val;
> +
> +	reg_val = new_val;
> +	ret = _vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
> +	if (!guest_run)
> +		return ret;
> +
> +	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
> +		    sreg->name, new_val, ret);
> +	sreg->user_val = new_val;
> +	ret = TEST_RUN(vm, vcpu);
> +	test_vm_free(vm);
> +	return ret;
> +}
> +
> +int test_feature_frac_vm(struct id_reg_test_info *sreg, uint64_t new_val,
> +		      struct id_reg_test_info *frac_sreg, uint64_t frac_new_val)
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +	uint32_t vcpu = 0;
> +	uint64_t reg_val;
> +	struct kvm_one_reg one_reg;
> +
> +	reset_id_reg_info();
> +
> +	vm = test_vm_create(1, guest_code_id_reg_check_all, NULL);
> +
> +	/* Set feature reg field */
> +	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
> +	one_reg.addr = (uint64_t)&reg_val;
> +	reg_val = new_val;
> +	ret = _vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
> +	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
> +		    sreg->name, new_val, ret);
> +	sreg->user_val = new_val;
> +
> +	/* Set fractional reg field */
> +	one_reg.id = KVM_ARM64_SYS_REG(frac_sreg->id);
> +	one_reg.addr = (uint64_t)&reg_val;
> +	reg_val = frac_new_val;
> +	vcpu_ioctl(vm, vcpu, KVM_SET_ONE_REG, &one_reg);
> +	TEST_ASSERT(!ret, "SET_REG(%s=0x%lx) failed, ret=0x%x",
> +		    frac_sreg->name, frac_new_val, ret);
> +
> +	frac_sreg->user_val = frac_new_val;
> +	ret = TEST_RUN(vm, vcpu);
> +	test_vm_free(vm);
> +	return ret;
> +}
> +
> +struct frac_info {
> +	char	*name;
> +	struct id_reg_test_info *sreg;
> +	struct id_reg_test_info *frac_sreg;
> +	int	shift;
> +	int	frac_shift;
> +};
> +
> +struct frac_info frac_info_table[] = {
> +	{
> +		.name = "RAS",
> +		.sreg = ID_REG_INFO(ID_AA64PFR0),
> +		.shift = ID_AA64PFR0_RAS_SHIFT,
> +		.frac_sreg = ID_REG_INFO(ID_AA64PFR1),
> +		.frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
> +	},
> +	{
> +		.name = "MPAM",
> +		.sreg = ID_REG_INFO(ID_AA64PFR0),
> +		.shift = ID_AA64PFR0_MPAM_SHIFT,
> +		.frac_sreg = ID_REG_INFO(ID_AA64PFR1),
> +		.frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
> +	},
> +	{
> +		.name = "CSV2",
> +		.sreg = ID_REG_INFO(ID_AA64PFR0),
> +		.shift = ID_AA64PFR0_CSV2_SHIFT,
> +		.frac_sreg = ID_REG_INFO(ID_AA64PFR1),
> +		.frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
> +	},
> +};
> +
> +void test_feature_frac_one(struct frac_info *frac)
> +{
> +	uint64_t reg_val, org_fval, frac_reg_val, frac_org_fval;
> +	int ret, shift, frac_shift;
> +	struct id_reg_test_info *sreg, *frac_sreg;
> +
> +	reset_id_reg_info();
> +
> +	sreg = frac->sreg;
> +	shift = frac->shift;
> +	frac_sreg = frac->frac_sreg;
> +	frac_shift = frac->frac_shift;
> +
> +	pr_debug("%s(%s Frac) reg:%s(shift:%d) frac reg:%s(shift:%d)\n",
> +		__func__, frac->name, sreg->name, shift,
> +		frac_sreg->name, frac_shift);
> +
> +	frac_org_fval = GET_ID_UFIELD(frac_sreg->org_val, frac_shift);
> +	if (frac_org_fval > 0) {
> +		/* Test with smaller frac value */
> +		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val,
> +						frac_shift, frac_org_fval - 1);
> +		ret = test_set_reg(frac_sreg, frac_reg_val, false);
> +		TEST_ASSERT(!ret, "SET smaller %s frac (val:%lx) failed(%d)",
> +			    frac->name, frac_reg_val, ret);
> +
> +		ret = test_feature_frac_vm(sreg, sreg->org_val,
> +					   frac_sreg, frac_reg_val);
> +		TEST_ASSERT(!ret, "Test smaller %s frac (val:%lx) failed(%d)",
> +			    frac->name, frac_reg_val, ret);
> +	}
> +
> +	reset_id_reg_info();
> +
> +	if (frac_org_fval != 0xf) {
> +		/* Test with larger frac value */
> +		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val, frac_shift,
> +						frac_org_fval + 1);
> +
> +		/* Setting larger frac shouldn't fail (at ioctl) */
> +		ret = test_set_reg(frac_sreg, frac_reg_val, false);
> +		TEST_ASSERT(!ret,
> +			"SET larger %s frac (%s org:%lx, val:%lx) failed(%d)",
> +			frac->name, frac_sreg->name, frac_sreg->org_val,
> +			frac_reg_val, ret);
> +
> +		/* KVM_RUN with larger frac should fail */
> +		ret = test_feature_frac_vm(sreg, sreg->org_val,
> +					   frac_sreg, frac_reg_val);
> +		TEST_ASSERT(ret,
> +			"Test with larger %s frac (%s org:%lx, val:%lx) worked",
> +			frac->name, frac_sreg->name, frac_sreg->org_val,
> +			frac_reg_val);
> +	}
> +
> +	reset_id_reg_info();
> +
> +	org_fval = GET_ID_UFIELD(sreg->org_val, shift);
> +	if (org_fval == 0) {
> +		/* Setting larger val for the feature should fail */
> +		reg_val = UPDATE_ID_UFIELD(sreg->org_val, shift, org_fval + 1);
> +		ret = test_set_reg(sreg, reg_val, false);
> +		TEST_ASSERT(ret, "SET larger %s (val:%lx) worked",
> +			    frac->name, reg_val);
> +		return;
> +	}
> +
> +	/* Test with smaller feature value */
> +	reg_val = UPDATE_ID_UFIELD(sreg->org_val, shift, org_fval - 1);
> +	ret = test_set_reg(sreg, reg_val, false);
> +	TEST_ASSERT(!ret, "SET smaller %s (val:%lx) failed(%d)",
> +		    frac->name, reg_val, ret);
> +
> +	ret = test_feature_frac_vm(sreg, reg_val, frac_sreg, frac_sreg->org_val);
> +	TEST_ASSERT(!ret, "Test with smaller %s (val:%lx) failed(%d)",
> +		    frac->name, reg_val, ret);
> +
> +	if (frac_org_fval > 0) {
> +		/* Test with smaller feature and frac value */
> +		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val,
> +						frac_shift, frac_org_fval - 1);
> +		ret = test_feature_frac_vm(sreg, reg_val, frac_sreg,
> +					   frac_reg_val);
> +		TEST_ASSERT(!ret,
> +		    "Test with smaller %s and frac (val:%lx) failed(%d)",
> +		    frac->name, reg_val, ret);
> +	}
> +
> +	if (frac_org_fval != 0xf) {
> +		/* Test with smaller feature and larger frac value */
> +		frac_reg_val = UPDATE_ID_UFIELD(frac_sreg->org_val,
> +						frac_shift, frac_org_fval + 1);
> +		ret = test_feature_frac_vm(sreg, reg_val, frac_sreg,
> +					   frac_reg_val);
> +		TEST_ASSERT(!ret,
> +		    "Test with smaller %s and larger frac (val:%lx) failed(%d)",
> +		    frac->name, reg_val, ret);
> +	}
> +}
> +
> +void test_feature_frac_all(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(frac_info_table); i++)
> +		test_feature_frac_one(&frac_info_table[i]);
> +}
> +
> +void run_test(void)
> +{
> +	set_id_regs_test();
> +	test_feature_all();
> +	test_feature_ptrauth();
> +	test_feature_frac_all();
> +}
> +
basic comment would be helpful: attempts to clear a given id_reg and
populate the id_reg with the original value, and can_clear flag?
> +static int init_id_reg_info_one(struct id_reg_test_info *sreg, void *arg)
> +{
> +	uint64_t reg_val;
> +	uint32_t vcpuid = 0;
> +	int ret;
> +	struct kvm_one_reg one_reg;
> +	struct kvm_vm *vm = arg;
> +
> +	one_reg.addr = (uint64_t)&reg_val;
> +	one_reg.id = KVM_ARM64_SYS_REG(sreg->id);
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, &one_reg);
> +	sreg->org_val = reg_val;
> +	sreg->user_val = reg_val;
nit: add a comment for user_val because it is not obvious why you set it
to reg_val.
> +	if (sreg->org_val) {
> +		reg_val = 0;
> +		ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &one_reg);
> +		if (!ret)
> +			sreg->can_clear = true;
> +	}
> +
> +	pr_debug("%s (0x%x): 0x%lx%s\n", sreg->name, sreg->id,
> +		 sreg->org_val, sreg->can_clear ? ", can clear" : "");
> +
> +	return 0;
> +}
> +
add a comment? loop over the idreg list and populates each regid info
with the default, user and can_clear value
> +static void init_id_reg_info(void)
> +{
> +	struct kvm_vm *vm;
> +
> +	vm = test_vm_create(1, guest_code_do_nothing, NULL);
> +	walk_id_reg_list(init_id_reg_info_one, vm);
> +	test_vm_free(vm);
> +}
> +
> +int main(void)
> +{
> +
> +	setbuf(stdout, NULL);
> +
> +	if (kvm_check_cap(KVM_CAP_ARM_ID_REG_CONFIGURABLE) <= 0) {
> +		print_skip("KVM_CAP_ARM_ID_REG_CONFIGURABLE is not supported\n");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	init_id_reg_info();
> +	run_test();
> +	return 0;
> +}
> 

After fixing the mem_pages stuff I get the following error on a cavium
machine.

augere@virtlab-arm04:~/UPSTREAM/ML/tools/testing/selftests/kvm#
./aarch64/id_reg_test
==== Test Assertion Failure ====
  aarch64/id_reg_test.c:814: fval >= min
  pid=11692 tid=11692 errno=4 - Interrupted system call
     1	0x00000000004028d3: test_feature at id_reg_test.c:813
     2	 (inlined by) test_feature_all at id_reg_test.c:863
     3	 (inlined by) run_test at id_reg_test.c:1073
     4	0x000000000040156f: main at id_reg_test.c:1124
     5	0x000003ffa9420de3: ?? ??:0
     6	0x00000000004015eb: _start at :?
  PERFMON field of ID_DFR0 is too small (0)

Fails on
test_feature: PERFMON (reg ID_DFR0)

I will do my utmost to further debug

Eric





