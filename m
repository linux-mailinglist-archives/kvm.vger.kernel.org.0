Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C861B7C5402
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 14:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjJKMbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 08:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjJKMbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 08:31:51 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5018F
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:31:49 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-523100882f2so11088583a12.2
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697027508; x=1697632308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=recTgP2Y7PcpsL0p5G+CcwbO2WQASP0/e+EofPLlj74=;
        b=wBUz+S7MJ4YWURqTuj6v3kOH6iYb9OIh1K4Ti10JmcPzl/M9xT4amfbEKAIcNxwoFp
         IT3OpwZSOpcZZfo8nLxnhB6BdG5XHTLdjUo/4rPjvdYtliWn4AXMqJDDiniu7q9go5Xj
         FLBja1rvI9gkyp6DaEPidF24jfid6F2EP1+zwgIpIk5SI5ANv4PFVFl6E4F/gB422JFf
         n4hqvC5hzNm7RdTQzNuLkJ+hEpCB3YTzzhlzwVNGk7xJaflIoi9a93V8TTGVG1tpDtmb
         y34xnxJIiQK/3t6yz138fcOI7yp35PZeWgJR83eHZrcq3BD4Oax3D6RBMiwMDeVMOQDl
         nYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697027508; x=1697632308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=recTgP2Y7PcpsL0p5G+CcwbO2WQASP0/e+EofPLlj74=;
        b=ANGPdWlruWtO6dgnI1UtfJzHtEM9wwG0b0xGVJyyyRXAO5nIMqP/jAQk7UnvItuExM
         gp0WWSPCDStfmAG8Lci4k5X7e3cwkUpMPt5j+igHllwUZlWGZ0LdhZO10UGPUNoukuBu
         J4tcKzbcACLKX9B/g65YF2mmUA7hs07p90ghguoYj+WBNSHeOSzWdNFJet3cWK26OlKd
         7Bwb2GjnmbJMxN/C1FBmkGqOpnl4s2WfeTDeJFk0kHC05PTSK4jM6wYY1INxvdeuWDSu
         p/Sg9Xknn/v15nuRR0zZ100Uc4U8l2jLr04eEQCTQkZPaWebqKxfwBZpVa17JsqKvLS5
         fo8w==
X-Gm-Message-State: AOJu0YyUpxJskRXwmCXoHcw835ZGbBDsowlNsSIQTu8Lfc3aFs1wufuQ
        cpGekaJllM71J/lGLn4/X+v/9w==
X-Google-Smtp-Source: AGHT+IHKXSzBKMi0yk1tnEqTXKNM0g3SQ4T2hGlPTrVloRNhlJ3IgtkjlrNmhIUwRTXzWQl0jiPkvQ==
X-Received: by 2002:a17:906:10ce:b0:9a1:e233:e627 with SMTP id v14-20020a17090610ce00b009a1e233e627mr20512374ejv.42.1697027508264;
        Wed, 11 Oct 2023 05:31:48 -0700 (PDT)
Received: from [192.168.69.115] (mdq11-h01-176-173-161-48.dsl.sta.abo.bbox.fr. [176.173.161.48])
        by smtp.gmail.com with ESMTPSA id w13-20020a170906480d00b0098d2d219649sm9868746ejq.174.2023.10.11.05.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 05:31:46 -0700 (PDT)
Message-ID: <e9f0c004-cb23-0985-30ca-394197d6bf94@linaro.org>
Date:   Wed, 11 Oct 2023 14:31:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH RFC v4 0/9] Add loongarch kvm accel support
Content-Language: en-US
To:     xianglai li <lixianglai@loongson.cn>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Tianrui Zhao <zhaotianrui@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <cover.1696841645.git.lixianglai@loongson.cn>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <cover.1696841645.git.lixianglai@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/10/23 11:01, xianglai li wrote:
> This series add loongarch kvm support, mainly implement
> some interfaces used by kvm such as kvm_arch_get/set_regs,
> kvm_arch_handle_exit, kvm_loongarch_set_interrupt, etc.
> 
> Currently, we are able to boot LoongArch KVM Linux Guests.
> In loongarch VM, mmio devices and iocsr devices are emulated
> in user space such as APIC, IPI, pci devices, etc, other
> hardwares such as MMU, timer and csr are emulated in kernel.
> 
> It is based on temporarily unaccepted linux kvm:
> https://github.com/loongson/linux-loongarch-kvm
> And We will remove the RFC flag until the linux kvm patches
> are merged.
> 
> The running environment of LoongArch virt machine:
> 1. Get the linux source by the above mentioned link.
>     git checkout kvm-loongarch
>     make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- loongson3_defconfig
>     make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu-
> 2. Get the qemu source: https://github.com/loongson/qemu
>     git checkout kvm-loongarch
>     ./configure --target-list="loongarch64-softmmu"  --enable-kvm
>     make
> 3. Get uefi bios of LoongArch virt machine:
>     Link: https://github.com/tianocore/edk2-platforms/tree/master/Platform/Loongson/LoongArchQemuPkg#readme
> 4. Also you can access the binary files we have already build:
>     https://github.com/yangxiaojuan-loongson/qemu-binary
> 
> The command to boot loongarch virt machine:
>     $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
>     -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
>     -serial stdio   -monitor telnet:localhost:4495,server,nowait \
>     -append "root=/dev/ram rdinit=/sbin/init console=ttyS0,115200" \
>     --nographic

2 years ago Song helped with an access to a LoongArch 3a5000 machine but
it stopped working (IP was x.242.206.180).

Would it be possible to add a Loongarch64 runner to our CI
(ideally with KVM support, but that can come later)? See:
https://www.qemu.org/docs/master/devel/ci.html#jobs-on-custom-runners

Regards,

Phil.
