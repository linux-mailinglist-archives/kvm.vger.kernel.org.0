Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1417C6355
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 05:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbjJLDid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 23:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbjJLDiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 23:38:15 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF75FA9
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 20:38:11 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.32])
        by gateway (Coremail) with SMTP id _____8BxuOgiaidlhz8xAA--.59006S3;
        Thu, 12 Oct 2023 11:38:10 +0800 (CST)
Received: from [10.20.42.32] (unknown [10.20.42.32])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxvt4daidlAlQhAA--.3303S2;
        Thu, 12 Oct 2023 11:38:08 +0800 (CST)
Subject: Re: [PATCH RFC v4 0/9] Add loongarch kvm accel support
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
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
 <e9f0c004-cb23-0985-30ca-394197d6bf94@linaro.org>
From:   lixianglai <lixianglai@loongson.cn>
Message-ID: <3cbee563-23c2-ed96-8faa-c9b288e0add3@loongson.cn>
Date:   Thu, 12 Oct 2023 11:38:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e9f0c004-cb23-0985-30ca-394197d6bf94@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8Bxvt4daidlAlQhAA--.3303S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7CF4UWw45ArW3Kw18uw18CrX_yoW5JF15pF
        WY9Fy3Krs5Grn7Jw4vg3s8XayUXrs5CF9rJ3Z3KFy8CFWDZF1vqr48urZ0gFsrA395XF1j
        qryxXw17u3WUXFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
        67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
        AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
        7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
        8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
        CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
        1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
        daVFxhVjvjDU0xZFpf9x07j1MKZUUUUU=
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Philippe Mathieu-Daudé :
> Hi,
>
> On 9/10/23 11:01, xianglai li wrote:
>> This series add loongarch kvm support, mainly implement
>> some interfaces used by kvm such as kvm_arch_get/set_regs,
>> kvm_arch_handle_exit, kvm_loongarch_set_interrupt, etc.
>>
>> Currently, we are able to boot LoongArch KVM Linux Guests.
>> In loongarch VM, mmio devices and iocsr devices are emulated
>> in user space such as APIC, IPI, pci devices, etc, other
>> hardwares such as MMU, timer and csr are emulated in kernel.
>>
>> It is based on temporarily unaccepted linux kvm:
>> https://github.com/loongson/linux-loongarch-kvm
>> And We will remove the RFC flag until the linux kvm patches
>> are merged.
>>
>> The running environment of LoongArch virt machine:
>> 1. Get the linux source by the above mentioned link.
>>     git checkout kvm-loongarch
>>     make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- 
>> loongson3_defconfig
>>     make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu-
>> 2. Get the qemu source: https://github.com/loongson/qemu
>>     git checkout kvm-loongarch
>>     ./configure --target-list="loongarch64-softmmu" --enable-kvm
>>     make
>> 3. Get uefi bios of LoongArch virt machine:
>>     Link: 
>> https://github.com/tianocore/edk2-platforms/tree/master/Platform/Loongson/LoongArchQemuPkg#readme
>> 4. Also you can access the binary files we have already build:
>>     https://github.com/yangxiaojuan-loongson/qemu-binary
>>
>> The command to boot loongarch virt machine:
>>     $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
>>     -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
>>     -serial stdio   -monitor telnet:localhost:4495,server,nowait \
>>     -append "root=/dev/ram rdinit=/sbin/init console=ttyS0,115200" \
>>     --nographic
>
> 2 years ago Song helped with an access to a LoongArch 3a5000 machine but
> it stopped working (IP was x.242.206.180).
>
> Would it be possible to add a Loongarch64 runner to our CI
> (ideally with KVM support, but that can come later)? See:
> https://www.qemu.org/docs/master/devel/ci.html#jobs-on-custom-runners
>

Ok, Song Gao will rebuild the Loongarch64 runner environment in the next 
few days,

and we will publish it to the community as soon as it is completed.

Thanks,

Xianglai.



> Regards,
>
> Phil.

