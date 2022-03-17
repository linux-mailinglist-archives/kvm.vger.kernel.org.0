Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3484DC509
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 12:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiCQLuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 07:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiCQLuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 07:50:06 -0400
Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42171567A0
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 04:48:49 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.35])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 44086EB32323;
        Thu, 17 Mar 2022 12:31:09 +0100 (CET)
Received: from kaod.org (37.59.142.102) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 17 Mar
 2022 12:31:07 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-102R0040d7befd2-d587-4337-9758-2bcf085c86e9,
                    0530BE337510AE92842F4B01C4CA167143738EB5) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <1b0f4be3-84e3-3188-63c9-8235e4dfc5ce@kaod.org>
Date:   Thu, 17 Mar 2022 12:31:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 10/27] Replace config-time define HOST_WORDS_BIGENDIAN
Content-Language: en-US
To:     <marcandre.lureau@redhat.com>, <qemu-devel@nongnu.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Vikram Garhwal <fnu.vikram@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        "open list:ARM PrimeCell and..." <qemu-arm@nongnu.org>,
        "open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>,
        "open list:PowerPC TCG CPUs" <qemu-ppc@nongnu.org>,
        "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
        "open list:virtio-blk" <qemu-block@nongnu.org>
References: <20220316095308.2613651-1-marcandre.lureau@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20220316095308.2613651-1-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.102]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 66bfd7d2-5c46-48ea-8d2c-a21dc2d819c4
X-Ovh-Tracer-Id: 2016768211438242587
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedgvdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepieegvdffkeegfeetuddttddtveduiefhgeduffekiedtkeekteekhfffleevleelnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepghhrohhugheskhgrohgurdhorhhg
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/22 10:53, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Replace a config-time define with a compile time condition
> define (compatible with clang and gcc) that must be declared prior to
> its usage. This avoids having a global configure time define, but also
> prevents from bad usage, if the config header wasn't included before.
> 
> This can help to make some code independent from qemu too.
> 
> gcc supports __BYTE_ORDER__ from about 4.6 and clang from 3.2.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   meson.build                             |  1 -
>   accel/tcg/atomic_template.h             |  4 +-
>   audio/audio.h                           |  2 +-
>   hw/display/pl110_template.h             |  6 +--
>   hw/net/can/ctucan_core.h                |  2 +-
>   hw/net/vmxnet3.h                        |  4 +-
>   include/exec/cpu-all.h                  |  4 +-
>   include/exec/cpu-common.h               |  2 +-
>   include/exec/memop.h                    |  2 +-
>   include/exec/memory.h                   |  2 +-
>   include/fpu/softfloat-types.h           |  2 +-
>   include/hw/core/cpu.h                   |  2 +-
>   include/hw/i386/intel_iommu.h           |  6 +--
>   include/hw/i386/x86-iommu.h             |  4 +-
>   include/hw/virtio/virtio-access.h       |  6 +--
>   include/hw/virtio/virtio-gpu-bswap.h    |  2 +-
>   include/libdecnumber/dconfig.h          |  2 +-
>   include/net/eth.h                       |  2 +-
>   include/qemu/bswap.h                    |  8 ++--
>   include/qemu/compiler.h                 |  2 +
>   include/qemu/host-utils.h               |  2 +-
>   include/qemu/int128.h                   |  2 +-
>   include/ui/qemu-pixman.h                |  2 +-
>   net/util.h                              |  2 +-
>   target/arm/cpu.h                        |  8 ++--
>   target/arm/translate-a64.h              |  2 +-
>   target/arm/vec_internal.h               |  2 +-
>   target/i386/cpu.h                       |  2 +-
>   target/mips/cpu.h                       |  2 +-
>   target/ppc/cpu.h                        |  2 +-
>   target/s390x/tcg/vec.h                  |  2 +-
>   target/xtensa/cpu.h                     |  2 +-
>   tests/fp/platform.h                     |  4 +-
>   accel/kvm/kvm-all.c                     |  4 +-
>   audio/dbusaudio.c                       |  2 +-
>   disas.c                                 |  2 +-
>   hw/core/loader.c                        |  4 +-
>   hw/display/artist.c                     |  6 +--
>   hw/display/pxa2xx_lcd.c                 |  2 +-
>   hw/display/vga.c                        | 12 +++---
>   hw/display/virtio-gpu-gl.c              |  2 +-
>   hw/s390x/event-facility.c               |  2 +-
>   hw/virtio/vhost.c                       |  2 +-
>   linux-user/arm/nwfpe/double_cpdo.c      |  4 +-
>   linux-user/arm/nwfpe/fpa11_cpdt.c       |  4 +-
>   linux-user/ppc/signal.c                 |  3 +-
>   linux-user/syscall.c                    |  6 +--
>   net/net.c                               |  4 +-
>   target/alpha/translate.c                |  2 +-
>   target/arm/crypto_helper.c              |  2 +-
>   target/arm/helper.c                     |  2 +-
>   target/arm/kvm64.c                      |  4 +-
>   target/arm/neon_helper.c                |  2 +-
>   target/arm/sve_helper.c                 |  4 +-
>   target/arm/translate-sve.c              |  6 +--
>   target/arm/translate-vfp.c              |  2 +-
>   target/arm/translate.c                  |  2 +-
>   target/hppa/translate.c                 |  2 +-
>   target/i386/tcg/translate.c             |  2 +-
>   target/mips/tcg/lmmi_helper.c           |  2 +-
>   target/mips/tcg/msa_helper.c            | 54 ++++++++++++-------------
>   target/ppc/arch_dump.c                  |  2 +-
>   target/ppc/int_helper.c                 | 22 +++++-----
>   target/ppc/kvm.c                        |  4 +-
>   target/ppc/mem_helper.c                 |  2 +-
>   target/riscv/vector_helper.c            |  2 +-
>   target/s390x/tcg/translate.c            |  2 +-
>   target/sparc/vis_helper.c               |  4 +-
>   tcg/tcg-op.c                            |  4 +-
>   tcg/tcg.c                               | 12 +++---
>   tests/qtest/vhost-user-blk-test.c       |  2 +-
>   tests/qtest/virtio-blk-test.c           |  2 +-
>   ui/vdagent.c                            |  2 +-
>   ui/vnc.c                                |  2 +-
>   util/bitmap.c                           |  2 +-
>   util/host-utils.c                       |  2 +-
>   target/ppc/translate/vmx-impl.c.inc     |  4 +-
>   target/ppc/translate/vsx-impl.c.inc     |  2 +-
>   target/riscv/insn_trans/trans_rvv.c.inc |  4 +-
>   target/s390x/tcg/translate_vx.c.inc     |  2 +-
>   tcg/aarch64/tcg-target.c.inc            |  4 +-
>   tcg/arm/tcg-target.c.inc                |  4 +-
>   tcg/mips/tcg-target.c.inc               |  2 +-
>   tcg/ppc/tcg-target.c.inc                | 10 ++---
>   tcg/riscv/tcg-target.c.inc              |  4 +-
>   85 files changed, 173 insertions(+), 173 deletions(-)

For the ppc part:

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

