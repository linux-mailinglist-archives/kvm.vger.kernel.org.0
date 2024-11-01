Return-Path: <kvm+bounces-30279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0A79B8B2F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 07:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E9DE1C21564
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 06:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C8D14E2DA;
	Fri,  1 Nov 2024 06:23:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C5014B97E
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 06:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730442200; cv=none; b=Qhgm+NvY1cYZGMD8kBBgtuCfGCdhg8j7Une7yoCrlFJ7S3CzvLONSpGBuvJ9I55Hb+7zl3mDjFptC8m4rtzFsPv/SZQtvq7HTFsZt1sUUKPRljW6qEjiiZy0PpMeGQGsyz2JT5pnMqLuEU9Efpfjifpn8tgQbdZ2lN8W+ZsjJ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730442200; c=relaxed/simple;
	bh=bYd1IiYA/Juj/GlHhnfablnCErzJSl70VKCZaigMzGM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mWgj+Ehy8qPMCdFx3FJ2nTO+HNiaMCJk774+ZkjlaTdB3W8pm32EplhuniB4uAa+fwB0i+OpiRQd7Jl/YnM2Jjqeiq4I+5X5lT/IDTr+G41dxKw9j89+y4WggetfLG8HKOWbMhCJ2xHN0kDN0Vr9DbMHO0EEUI7mBTdlEGEF2Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8AxaeDRcyRnPssjAA--.52607S3;
	Fri, 01 Nov 2024 14:23:13 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowMCxDuHNcyRnt+kwAA--.12824S3;
	Fri, 01 Nov 2024 14:23:12 +0800 (CST)
Subject: Re: [PATCH v3 0/3] linux-headers: Update to Linux v6.12-rc5
To: Bibo Mao <maobibo@loongson.cn>, "Michael S . Tsirkin" <mst@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alistair Francis <alistair.francis@wdc.com>,
 Bin Meng <bmeng.cn@gmail.com>, Cornelia Huck <cohuck@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241028023809.1554405-1-maobibo@loongson.cn>
From: gaosong <gaosong@loongson.cn>
Message-ID: <37889235-1351-8702-5a6a-f6cb7ece55fd@loongson.cn>
Date: Fri, 1 Nov 2024 14:24:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241028023809.1554405-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowMCxDuHNcyRnt+kwAA--.12824S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxur45Wr1kAry7GF43uF15GFX_yoW5GFWfp3
	srCr15Wr98GF9xJFsIvF12qrs5XF4kC3ZI9Fy7X3s2krWY93W8Xwn7C3WkWrsrt34UAFy8
	XFsxJryDCF97ArgCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jOa93UUU
	UU=

ÔÚ 2024/10/28 ÉÏÎç10:38, Bibo Mao Ð´µÀ:
> Add unistd_64.h on arm64,loongarch and riscv platform, and update
> linux headers to Linux v6.12-rc5.
>
> Pass to compile on aarch64, arm, loongarch64, x86_64, i386, riscv64,
> riscv32 softmmu and linux-user.
>
> ---
> v2 ... v3:
>    1. Add unistd_64.h on arm64 and riscv platform also
>    2. Update header files to Linux v6.12-rc5
>
> v1 ... v2:
>    1. update header files in directory linux-headers to v6.12-rc3
> ---
>
> Bibo Mao (3):
>    linux-headers: Add unistd_64.h
>    linux-headers: loongarch: Add kvm_para.h
>    linux-headers: Update to Linux v6.12-rc5
>
>   include/standard-headers/drm/drm_fourcc.h     |  43 +++
>   include/standard-headers/linux/const.h        |  17 +
>   include/standard-headers/linux/ethtool.h      | 226 ++++++++++++
>   include/standard-headers/linux/fuse.h         |  22 +-
>   .../linux/input-event-codes.h                 |   2 +
>   include/standard-headers/linux/pci_regs.h     |  41 ++-
>   .../standard-headers/linux/virtio_balloon.h   |  16 +-
>   include/standard-headers/linux/virtio_gpu.h   |   1 +
>   linux-headers/asm-arm64/mman.h                |   9 +
>   linux-headers/asm-arm64/unistd.h              |  25 +-
>   linux-headers/asm-arm64/unistd_64.h           | 324 +++++++++++++++++
>   linux-headers/asm-generic/unistd.h            |   6 +-
>   linux-headers/asm-loongarch/kvm.h             |  24 ++
>   linux-headers/asm-loongarch/kvm_para.h        |  21 ++
>   linux-headers/asm-loongarch/unistd.h          |   4 +-
>   linux-headers/asm-loongarch/unistd_64.h       | 320 +++++++++++++++++
>   linux-headers/asm-riscv/kvm.h                 |   7 +
>   linux-headers/asm-riscv/unistd.h              |  41 +--
>   linux-headers/asm-riscv/unistd_32.h           | 315 +++++++++++++++++
>   linux-headers/asm-riscv/unistd_64.h           | 325 ++++++++++++++++++
>   linux-headers/asm-x86/kvm.h                   |   2 +
>   linux-headers/asm-x86/unistd_64.h             |   1 +
>   linux-headers/asm-x86/unistd_x32.h            |   1 +
>   linux-headers/linux/bits.h                    |   3 +
>   linux-headers/linux/const.h                   |  17 +
>   linux-headers/linux/iommufd.h                 | 143 +++++++-
>   linux-headers/linux/kvm.h                     |  23 +-
>   linux-headers/linux/mman.h                    |   1 +
>   linux-headers/linux/psp-sev.h                 |  28 ++
>   scripts/update-linux-headers.sh               |   7 +
>   30 files changed, 1922 insertions(+), 93 deletions(-)
>   create mode 100644 linux-headers/asm-arm64/unistd_64.h
>   create mode 100644 linux-headers/asm-loongarch/kvm_para.h
>   create mode 100644 linux-headers/asm-loongarch/unistd_64.h
>   create mode 100644 linux-headers/asm-riscv/unistd_32.h
>   create mode 100644 linux-headers/asm-riscv/unistd_64.h
>
>
> base-commit: cea8ac78545a83e1f01c94d89d6f5a3f6b5c05d2
Acked-by: Song Gao <gaosong@loongson.cn>

Thanks.
Song Gao


