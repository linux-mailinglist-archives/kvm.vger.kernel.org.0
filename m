Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B124D8AD7
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 18:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbiCNReL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 13:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiCNReJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 13:34:09 -0400
X-Greylist: delayed 901 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 10:32:55 PDT
Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC62BED
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 10:32:52 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.136])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id F3D6CE9D33AE;
        Mon, 14 Mar 2022 18:06:17 +0100 (CET)
Received: from kaod.org (37.59.142.106) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 14 Mar
 2022 18:06:15 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-106R006711b171a-688b-46e4-a7cc-d210997aca55,
                    00B622A560025FB732B9BA5E5C4E2A2293E53F9D) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <286084fe-dec4-2473-db64-4bbe7bd9145e@kaod.org>
Date:   Mon, 14 Mar 2022 18:06:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 3/3] Use g_new() & friends where that makes obvious sense
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>, <qemu-devel@nongnu.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <xen-devel@lists.xenproject.org>,
        <qemu-ppc@nongnu.org>, <qemu-block@nongnu.org>,
        <haxm-team@intel.com>, <qemu-s390x@nongnu.org>
References: <20220314160108.1440470-1-armbru@redhat.com>
 <20220314160108.1440470-4-armbru@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20220314160108.1440470-4-armbru@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.106]
X-ClientProxiedBy: DAG8EX2.mxp5.local (172.16.2.72) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 1f43e3ab-c662-4fb9-88a2-4f7a133485e2
X-Ovh-Tracer-Id: 8505329372638186397
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedgleehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepieegvdffkeegfeetuddttddtveduiefhgeduffekiedtkeekteekhfffleevleelnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepghhrohhugheskhgrohgurdhorhhg
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 17:01, Markus Armbruster wrote:
> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
> 
> This commit only touches allocations with size arguments of the form
> sizeof(T).
> 
> Patch created mechanically with:
> 
>      $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
> 	     --macro-file scripts/cocci-macro-file.h FILES...
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   include/qemu/timer.h                     |  2 +-
>   accel/kvm/kvm-all.c                      |  6 ++--
>   accel/tcg/tcg-accel-ops-mttcg.c          |  2 +-
>   accel/tcg/tcg-accel-ops-rr.c             |  4 +--
>   audio/audio.c                            |  4 +--
>   audio/audio_legacy.c                     |  6 ++--
>   audio/dsoundaudio.c                      |  2 +-
>   audio/jackaudio.c                        |  6 ++--
>   audio/paaudio.c                          |  4 +--
>   backends/cryptodev.c                     |  2 +-
>   contrib/vhost-user-gpu/vhost-user-gpu.c  |  2 +-
>   cpus-common.c                            |  4 +--
>   dump/dump.c                              |  2 +-
>   hw/acpi/hmat.c                           |  2 +-
>   hw/audio/intel-hda.c                     |  2 +-
>   hw/char/parallel.c                       |  2 +-
>   hw/char/riscv_htif.c                     |  2 +-
>   hw/char/virtio-serial-bus.c              |  6 ++--
>   hw/core/irq.c                            |  2 +-
>   hw/core/reset.c                          |  2 +-
>   hw/display/pxa2xx_lcd.c                  |  2 +-
>   hw/display/tc6393xb.c                    |  2 +-
>   hw/display/virtio-gpu.c                  |  4 +--
>   hw/display/xenfb.c                       |  4 +--
>   hw/dma/rc4030.c                          |  4 +--
>   hw/i2c/core.c                            |  4 +--
>   hw/i2c/i2c_mux_pca954x.c                 |  2 +-
>   hw/i386/amd_iommu.c                      |  4 +--
>   hw/i386/intel_iommu.c                    |  2 +-
>   hw/i386/xen/xen-hvm.c                    | 10 +++---
>   hw/i386/xen/xen-mapcache.c               | 14 ++++----
>   hw/input/lasips2.c                       |  2 +-
>   hw/input/pckbd.c                         |  2 +-
>   hw/input/ps2.c                           |  4 +--
>   hw/input/pxa2xx_keypad.c                 |  2 +-
>   hw/input/tsc2005.c                       |  3 +-
>   hw/intc/riscv_aclint.c                   |  6 ++--
>   hw/intc/xics.c                           |  2 +-
>   hw/m68k/virt.c                           |  2 +-
>   hw/mips/mipssim.c                        |  2 +-
>   hw/misc/applesmc.c                       |  2 +-
>   hw/misc/imx6_src.c                       |  2 +-
>   hw/misc/ivshmem.c                        |  4 +--
>   hw/net/virtio-net.c                      |  4 +--
>   hw/nvme/ns.c                             |  2 +-
>   hw/pci-host/pnv_phb3.c                   |  2 +-
>   hw/pci-host/pnv_phb4.c                   |  2 +-
>   hw/pci/pcie_sriov.c                      |  2 +-
>   hw/ppc/e500.c                            |  2 +-
>   hw/ppc/ppc.c                             |  8 ++---
>   hw/ppc/ppc405_boards.c                   |  4 +--
>   hw/ppc/ppc405_uc.c                       | 18 +++++-----
>   hw/ppc/ppc4xx_devs.c                     |  2 +-
>   hw/ppc/ppc_booke.c                       |  4 +--
>   hw/ppc/spapr.c                           |  2 +-
>   hw/ppc/spapr_events.c                    |  2 +-
>   hw/ppc/spapr_hcall.c                     |  2 +-
>   hw/ppc/spapr_numa.c                      |  3 +-
>   hw/rdma/vmw/pvrdma_dev_ring.c            |  2 +-
>   hw/rdma/vmw/pvrdma_qp_ops.c              |  6 ++--
>   hw/sh4/r2d.c                             |  4 +--
>   hw/sh4/sh7750.c                          |  2 +-
>   hw/sparc/leon3.c                         |  2 +-
>   hw/sparc64/sparc64.c                     |  4 +--
>   hw/timer/arm_timer.c                     |  2 +-
>   hw/timer/slavio_timer.c                  |  2 +-
>   hw/vfio/pci.c                            |  4 +--
>   hw/vfio/platform.c                       |  4 +--
>   hw/virtio/virtio-crypto.c                |  2 +-
>   hw/virtio/virtio-iommu.c                 |  2 +-
>   hw/virtio/virtio.c                       |  5 ++-
>   hw/xtensa/xtfpga.c                       |  2 +-
>   linux-user/syscall.c                     |  2 +-
>   migration/dirtyrate.c                    |  4 +--
>   migration/multifd-zlib.c                 |  4 +--
>   migration/ram.c                          |  2 +-
>   monitor/misc.c                           |  2 +-
>   monitor/qmp-cmds.c                       |  2 +-
>   qga/commands-win32.c                     |  8 ++---
>   qga/commands.c                           |  2 +-
>   qom/qom-qmp-cmds.c                       |  2 +-
>   replay/replay-char.c                     |  4 +--
>   replay/replay-events.c                   | 10 +++---
>   scripts/coverity-scan/model.c            |  2 +-
>   semihosting/config.c                     |  2 +-
>   softmmu/bootdevice.c                     |  4 +--
>   softmmu/dma-helpers.c                    |  4 +--
>   softmmu/memory_mapping.c                 |  2 +-
>   target/i386/cpu-sysemu.c                 |  2 +-
>   target/i386/hax/hax-accel-ops.c          |  4 +--
>   target/i386/nvmm/nvmm-accel-ops.c        |  4 +--
>   target/i386/whpx/whpx-accel-ops.c        |  4 +--
>   target/i386/whpx/whpx-all.c              |  2 +-
>   target/s390x/cpu-sysemu.c                |  2 +-
>   tests/unit/test-hbitmap.c                |  2 +-
>   tests/unit/test-qmp-cmds.c               | 14 ++++----
>   tests/unit/test-qobject-output-visitor.c |  2 +-
>   tests/unit/test-vmstate.c                | 42 ++++++++++++------------
>   ui/vnc-enc-tight.c                       |  2 +-
>   util/envlist.c                           |  2 +-
>   util/hbitmap.c                           |  2 +-
>   util/main-loop.c                         |  2 +-
>   util/qemu-timer.c                        |  2 +-
>   util/vfio-helpers.c                      |  4 +--
>   104 files changed, 197 insertions(+), 202 deletions(-)

PPC part:
  Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

