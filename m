Return-Path: <kvm+bounces-53103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 928E4B0D5AA
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4832B188367E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728E02DAFB8;
	Tue, 22 Jul 2025 09:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Fx0ixECH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE21C227E8F
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753175895; cv=none; b=oitPZHYIcvFzp9iPTmOr4vIfJw7CKpBCYqbYgrbejrXrEWPTRd+CZPXlTvjhnrSnI2Xskm8P9V//VmHSzOfobNfBTXzElfV7RjwpngDW5s0RxOOA8jtK/lDvDZjeaZ8TTsWaH+8kJHMVeo39iImgKZnefEHlsqsmIHGFzd71+PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753175895; c=relaxed/simple;
	bh=hhQufx2HD4Ts5oBIe9054Ablz+7kZBZZDBYP7X7WX8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaybuvNXo6ASlVDMynnONodak4wIDLc4eS7MvulEshEExHrmV9BI+hYxqFYm2kg6ZkP6gKt+V3QdBM7yZkExJ4GjRPSJ+5Yd63hnbCr2QXhgBjPSEssRJWkYogoHI4sjjXmCHiQ81omQijxkokYtDQDYgibNZGaCmAzn3HdVPNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Fx0ixECH; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a503d9ef59so3755471f8f.3
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 02:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1753175892; x=1753780692; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PHFy2ib8R7VJ1RgEKC7LoLc8P9a6wfUZ5RjA5auf7Xg=;
        b=Fx0ixECHumfJi5nWtnbjmk+Af60kjKKZDYiDS7KVN/ewMRwgEdsb5MoNOFHwpX/aCx
         UKY+/h+GP5Hj3Ifl9afnojyNnHuSvxkmpr5yx6TXD9wmoQt/zGUuEvgRvP7UQfi7My8l
         nINTP52B7rtB8y8yAnmlDT5HD4mloYAPq+SkSwRcobdM6uqhp5krJVKysIRWzhC/7Mk1
         RcDAwX7qORZObPLsD6yz2jcbxErG66sN/MGuzzPPsua00sSpVPHQ7YMGRQbgwhZ2a2hN
         OadDxfk69nCfuqbY6HKmUoWmk5CBE+oZGTftm09m2cr7CmPZKwTofz1K2xfC7xzroPZe
         xzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753175892; x=1753780692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHFy2ib8R7VJ1RgEKC7LoLc8P9a6wfUZ5RjA5auf7Xg=;
        b=rR8TysMJWDTbFOlrJvb48P1vIob7ooRQ8fI2kf2fCIOtRGZG+063ja2yxTvMMMKc16
         kRUcvsGaRN/sME3nn3mdbl3bJulpsvYfJJi8dAEfRr994VQOMsD2wAE+QK4DRJch7i7V
         NN7CciCjRPO5IJt+FqlTnz+du3ylRtYFXJ8ymYuUIQSF0WQiDt39uEzwoGM/Q4745y7s
         Jz8d9W0DMKJeqmO9YUHdgAmHbvcaCaS+QQ3Yglesq3Kdh+dpu+i7oU/8Lrwi94v9PfOZ
         2+5kRh2WaW6mquzTdaCl/gmMw4j7onDcSHhaxcsTKUyC4DW6gfslb6XYaBTHWz2PDCZh
         WTug==
X-Forwarded-Encrypted: i=1; AJvYcCVIsr8euUmMH3nGN8DizHILhffJi7fMpcGHYMyDBwq8io7Y9f3E4UnsAfhDkut7lfTi2o0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXSNJ46jgyd78G5+l8+E2ZxZ32fVRD1jIGVm0EdJU7n9Sw4JeZ
	GmUN/bLcoEYfDZyt89XYCpRnaQ7xY77k2JZNdTCKjbR8MZeRkouyvH31UMYa9wa6YUk=
X-Gm-Gg: ASbGnctbbFAE/XLGZZ407Yi9SPLf9iUVDn5fsH31k5QFe7dmMzg3RBtTEKxmqpGg+Jw
	ffLdbzdYMMbf2jtLzyhuDBo+Vw4vIMqHwKiCBC2mSWT/QpXM7HnNefL0CzcsW/s5FH0SopdabGy
	39y1MGvgiYgreRE6PkrNSDFBGBdpvBDZCIRKr4KQ0ktC2Hvk65aYoVnssyOoRksiMQ9q2imu/VC
	0HAwgPDFIBMJIjrIIEvuOWd+n//eDqsO87ATQKkMe+/MwpOZ8cu4fBRB560BzpmC/ZjKZJWm8YU
	VN4EyaNwoW96aKdw1eDtY54HPNZ7qb34DEbmkEj7ZvO4mw4IofN92bRQOUxtj+fytkM2WHp1QUU
	u1X6dFndnjA==
X-Google-Smtp-Source: AGHT+IHQBAZgY70xI+dtP0yh6yvLOKV0BlM/uTMSPEIciqVVZwMQSsJNaHFcQVjMoLC9XYi1w0Ju7g==
X-Received: by 2002:a05:6000:2892:b0:3a4:f379:65bc with SMTP id ffacd0b85a97d-3b60e523efamr18492284f8f.40.1753175891891;
        Tue, 22 Jul 2025 02:18:11 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f15c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca48a2esm12946678f8f.51.2025.07.22.02.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 02:18:11 -0700 (PDT)
Date: Tue, 22 Jul 2025 11:18:10 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, jackabt@amazon.com
Subject: Re: [PATCH] KVM: arm64: selftest: Add standalone test checking for
 KVM's own UUID
Message-ID: <20250722-87ac9d7e0b27cf7c67a4fbd3@orel>
References: <20250721155136.892255-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721155136.892255-1-maz@kernel.org>

Hi Marc,

On Mon, Jul 21, 2025 at 04:51:36PM +0100, Marc Zyngier wrote:
> Tinkering with UUIDs is a perilious task, and the KVM UUID gets
> broken at times. In order to spot this early enough, add a selftest
> that will shout if the expected value isn't found.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20250721130558.50823-1-jackabt.amazon@gmail.com
> ---
>  tools/testing/selftests/kvm/Makefile.kvm     |  1 +
>  tools/testing/selftests/kvm/arm64/kvm-uuid.c | 67 ++++++++++++++++++++
>  2 files changed, 68 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/arm64/kvm-uuid.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index ce817a975e50a..e1eb1ba238a2a 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -167,6 +167,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_irq
>  TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
>  TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
>  TEST_GEN_PROGS_arm64 += arm64/no-vgic-v3
> +TEST_GEN_PROGS_arm64 += arm64/kvm-uuid
>  TEST_GEN_PROGS_arm64 += access_tracking_perf_test
>  TEST_GEN_PROGS_arm64 += arch_timer
>  TEST_GEN_PROGS_arm64 += coalesced_io_test
> diff --git a/tools/testing/selftests/kvm/arm64/kvm-uuid.c b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
> new file mode 100644
> index 0000000000000..89d9c8b182ae5
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
> @@ -0,0 +1,67 @@
> +#include <errno.h>
> +#include <linux/arm-smccc.h>
> +#include <asm/kvm.h>
> +#include <kvm_util.h>
> +
> +#include "processor.h"
> +
> +/*
> + * Do NOT redefine these constants, or try to replace them with some
> + * "common" version. They are hardcoded here to detect any potential
> + * breakage happening in the rest of the kernel.
> + *
> + * KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74
> + */
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
> +
> +static void guest_code(void)
> +{
> +	struct arm_smccc_res res = {};
> +
> +	smccc_hvc(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
> +
> +	__GUEST_ASSERT(res.a0 != SMCCC_RET_NOT_SUPPORTED, "a0 = %lx\n", res.a0);

Should this check res.a0 == SMCCC_RET_SUCCESS instead?

> +	__GUEST_ASSERT(res.a0 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 &&
> +		       res.a1 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 &&
> +		       res.a2 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 &&
> +		       res.a3 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3,
> +		       "Unexpected KVM-specific UID %lx %lx %lx %lx\n", res.a0, res.a1, res.a2, res.a3);
> +	GUEST_DONE();
> +}
> +
> +int main (int argc, char *argv[])
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	bool guest_done = false;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	while (!guest_done) {
> +		vcpu_run(vcpu);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			guest_done = true;
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_PRINTF:
> +			printf("%s", uc.buffer);
> +			break;
> +		default:
> +			TEST_FAIL("Unexpected guest exit");
> +		}
> +	}

This is becoming a very common and useful pattern. I wonder if it's time
for a ucall helper

static void ucall_vcpu_run(struct kvm_vcpu *vcpu,
                           void (*sync_func)(struct kvm_vcpu *, void *),
                           void *sync_data)
{
        bool guest_done = false;
        struct ucall uc;

        while (!guest_done) {
                vcpu_run(vcpu);

                switch (get_ucall(vcpu, &uc)) {
                case UCALL_SYNC:
                        if (sync_func)
                                sync_func(vcpu, sync_data);
                        break;
                case UCALL_DONE:
                        guest_done = true;
                        break;
                case UCALL_ABORT:
                        REPORT_GUEST_ASSERT(uc);
                        break;
                case UCALL_PRINTF:
                        printf("%s", uc.buffer);
                        break;
                default:
                        TEST_FAIL("Unexpected guest exit");
                }
        }
}

Thanks,
drew

> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> -- 
> 2.39.2
> 

