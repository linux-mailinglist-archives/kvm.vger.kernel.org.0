Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A571D2A99
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENIsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:48:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58479 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725999AbgENIsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589446113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=LQrKfZO1fcuI+nb6eAF+CfoZHKCUlkNNBNIC0Uw7KkA=;
        b=WpoJII+GmKarEcQbHMRc/N7zj7uRc9Lm6ZA078Zlq5OHQJJqRc74F48oG+/RarcbAdZYfA
        5RGdfyE88uNKyowAUS9uNxUpUfAHfoSeYaADiwesqTzAdd16BMfb08bNKxOyZcLeNu0Q3s
        KCtDZnjouykv/0I21onM5KgmUugnpI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-nbyB54ArPFe5JQU_X5H1dQ-1; Thu, 14 May 2020 04:48:26 -0400
X-MC-Unique: nbyB54ArPFe5JQU_X5H1dQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 550008014D7;
        Thu, 14 May 2020 08:48:22 +0000 (UTC)
Received: from [10.36.114.168] (ovpn-114-168.ams2.redhat.com [10.36.114.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C983C39E;
        Thu, 14 May 2020 08:48:02 +0000 (UTC)
Subject: Re: [virtio-dev] [PATCH v3 00/15] virtio-mem: paravirtualized memory
To:     teawater <teawaterz@linux.alibaba.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
References: <20200507103119.11219-1-david@redhat.com>
 <7848642F-6AA7-4B5E-AE0E-DB0857C94A93@linux.alibaba.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <31c5d2f9-c104-53e8-d9c8-cb45f7507c85@redhat.com>
Date:   Thu, 14 May 2020 10:48:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7848642F-6AA7-4B5E-AE0E-DB0857C94A93@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.05.20 08:44, teawater wrote:
> Hi David,
> 
> I got a kernel warning with v2 and v3.

Hi Hui,

thanks for playing with the latest versions. Surprisingly, I can
reproduce even by hotplugging a DIMM instead as well - that's good, so
it's not related to virtio-mem, lol. Seems to be some QEMU setup issue
with older machine types.

Can you switch to a newer qemu machine version, especially
pc-i440fx-5.0? Both, hotplugging DIMMs and virtio-mem works for me with
that QEMU machine just fine.

What also seems to make it work with pc-i440fx-2.1, is giving the
machine 4G of initial memory (-m 4g,slots=10,maxmem=5G).

Cheers!


> // start a QEMU that is get from https://github.com/davidhildenbrand/qemu/tree/virtio-mem-v2 and setup a file as a ide disk.
> /home/teawater/qemu/qemu/x86_64-softmmu/qemu-system-x86_64 -machine pc-i440fx-2.1,accel=kvm,usb=off -cpu host -no-reboot -nographic -device ide-hd,drive=hd -drive if=none,id=hd,file=/home/teawater/old.img,format=raw -kernel /home/teawater/kernel/bk2/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/sda nokaslr swiotlb=noforce" -m 1g,slots=10,maxmem=2G -smp 1 -s -monitor unix:/home/teawater/qemu/m,server,nowait
> 
> // Setup virtio-mem and plug 256m memory in qemu monitor:
> object_add memory-backend-ram,id=mem1,size=256m
> device_add virtio-mem-pci,id=vm0,memdev=mem1
> qom-set vm0 requested-size 256M
> 
> // Go back to the terminal and access file system will got following kernel warning.
> [   19.515549] pci 0000:00:04.0: [1af4:1015] type 00 class 0x00ff00
> [   19.516227] pci 0000:00:04.0: reg 0x10: [io  0x0000-0x007f]
> [   19.517196] pci 0000:00:04.0: BAR 0: assigned [io  0x1000-0x107f]
> [   19.517843] virtio-pci 0000:00:04.0: enabling device (0000 -> 0001)
> [   19.535957] PCI Interrupt Link [LNKD] enabled at IRQ 11
> [   19.536507] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
> [   19.537528] virtio_mem virtio0: start address: 0x100000000
> [   19.538094] virtio_mem virtio0: region size: 0x10000000
> [   19.538621] virtio_mem virtio0: device block size: 0x200000
> [   19.539186] virtio_mem virtio0: memory block size: 0x8000000
> [   19.539752] virtio_mem virtio0: subblock size: 0x400000
> [   19.540357] virtio_mem virtio0: plugged size: 0x0
> [   19.540834] virtio_mem virtio0: requested size: 0x0
> [   20.170441] virtio_mem virtio0: plugged size: 0x0
> [   20.170933] virtio_mem virtio0: requested size: 0x10000000
> [   20.172247] Built 1 zonelists, mobility grouping on.  Total pages: 266012
> [   20.172955] Policy zone: Normal
> 
> / # ls
> [   26.724565] ------------[ cut here ]------------
> [   26.725047] ata_piix 0000:00:01.1: DMA addr 0x000000010fc14000+49152 overflow (mask ffffffff, bus limit 0).
> [   26.726024] WARNING: CPU: 0 PID: 179 at /home/teawater/kernel/linux2/kernel/dma/direct.c:364 dma_direct_map_page+0x118/0x130
> [   26.727141] Modules linked in:
> [   26.727456] CPU: 0 PID: 179 Comm: ls Not tainted 5.6.0-rc5-next-20200311+ #9
> [   26.728163] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [   26.729305] RIP: 0010:dma_direct_map_page+0x118/0x130
> [   26.729825] Code: 8b 1f e8 3b 70 59 00 48 8d 4c 24 08 48 89 c6 4c 89 2c 24 4d 89 e1 49 89 e8 48 89 da 48 c7 c7 08 6c 34 82 31 c0 e8 d8 8e f7 ff <00
> [   26.731683] RSP: 0000:ffffc90000213838 EFLAGS: 00010082
> [   26.732205] RAX: 0000000000000000 RBX: ffff88803ebeb1b0 RCX: ffffffff82665148
> [   26.732913] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 0000000000000046
> [   26.733621] RBP: 000000000000c000 R08: 00000000000001df R09: 00000000000001df
> [   26.734338] R10: 0000000000000000 R11: ffffc900002135a8 R12: 00000000ffffffff
> [   26.735054] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88803d55f5b0
> [   26.735772] FS:  00000000024e9880(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
> [   26.736579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   26.737162] CR2: 00000000005bfc7f CR3: 0000000107e12004 CR4: 0000000000360ef0
> [   26.737879] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   26.738591] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   26.739307] Call Trace:
> [   26.739564]  dma_direct_map_sg+0x64/0xb0
> [   26.739969]  ? ata_scsi_write_same_xlat+0x350/0x350
> [   26.740461]  ata_qc_issue+0x214/0x260
> [   26.740839]  ata_scsi_queuecmd+0x16a/0x490
> [   26.741255]  scsi_queue_rq+0x679/0xa60
> [   26.741639]  blk_mq_dispatch_rq_list+0x90/0x510
> [   26.742099]  ? elv_rb_del+0x1f/0x30
> [   26.742456]  ? deadline_remove_request+0x6a/0xb0
> [   26.742926]  blk_mq_do_dispatch_sched+0x78/0x100
> [   26.743397]  blk_mq_sched_dispatch_requests+0xf9/0x170
> [   26.743924]  __blk_mq_run_hw_queue+0x7e/0x130
> [   26.744365]  __blk_mq_delay_run_hw_queue+0x107/0x150
> [   26.744874]  blk_mq_run_hw_queue+0x61/0x100
> [   26.745299]  blk_mq_sched_insert_requests+0x71/0x110
> [   26.745798]  blk_mq_flush_plug_list+0x14b/0x210
> [   26.746258]  blk_flush_plug_list+0xbf/0xe0
> [   26.746675]  blk_finish_plug+0x27/0x40
> [   26.747056]  read_pages+0x7c/0x190
> [   26.747399]  __do_page_cache_readahead+0x19c/0x1b0
> [   26.747886]  filemap_fault+0x54e/0x9a0
> [   26.748268]  ? alloc_set_pte+0x102/0x610
> [   26.748673]  ? walk_component+0x64/0x2e0
> [   26.749072]  ? filemap_map_pages+0xfa/0x3f0
> [   26.749498]  ext4_filemap_fault+0x2c/0x3b
> [   26.749911]  __do_fault+0x38/0xb0
> [   26.750251]  __handle_mm_fault+0xd2a/0x16d0
> [   26.750678]  handle_mm_fault+0xe2/0x1f0
> [   26.751069]  do_page_fault+0x250/0x590
> [   26.751448]  async_page_fault+0x34/0x40
> [   26.751841] RIP: 0033:0x5bfc7f
> [   26.752155] Code: Bad RIP value.
> [   26.752481] RSP: 002b:00007ffef0289cd8 EFLAGS: 00010246
> [   26.752999] RAX: 0000000000000001 RBX: 00007ffef028af81 RCX: 00007ffef028af84
> [   26.753715] RDX: 00007ffef0289e01 RSI: 00007ffef0289ea8 RDI: 0000000000000001
> [   26.754424] RBP: 00000000000000ac R08: 0000000000000001 R09: 0000000000000006
> [   26.755144] R10: 000000000089fc18 R11: 0000000000000246 R12: 00007ffef0289ea8
> [   26.755853] R13: 000000000043a5f0 R14: 0000000000000000 R15: 0000000000000000
> [   26.756560] ---[ end trace 23cc3e9021358587 ]---
> [   26.778034] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.778690] ata2.00: failed command: READ DMA
> [   26.779131] ata2.00: cmd c8/00:e8:92:ad:00/00:00:00:00:00/e0 tag 0 dma 118784 in
> [   26.779131]          res 50/00:00:0a:80:03/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.780691] ata2.00: status: { DRDY }
> [   26.781603] ata2.00: configured for MWDMA2
> [   26.782034] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
> [   26.782958] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
> [   26.783646] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
> [   26.784321] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad 92 00 00 e8 00
> [   26.785056] blk_update_request: I/O error, dev sda, sector 44434 op 0x0:(READ) flags 0x80700 phys_seg 3 prio class 0
> [   26.786118] ata2: EH complete
> [   26.810033] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.810690] ata2.00: failed command: READ DMA
> [   26.811133] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.811133]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.812681] ata2.00: status: { DRDY }
> [   26.813569] ata2.00: configured for MWDMA2
> [   26.813992] ata2: EH complete
> [   26.826031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.826687] ata2.00: failed command: READ DMA
> [   26.827131] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.827131]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.828668] ata2.00: status: { DRDY }
> [   26.829552] ata2.00: configured for MWDMA2
> [   26.829972] ata2: EH complete
> [   26.842030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.842686] ata2.00: failed command: READ DMA
> [   26.843127] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.843127]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.844656] ata2.00: status: { DRDY }
> [   26.845538] ata2.00: configured for MWDMA2
> [   26.845961] ata2: EH complete
> [   26.858030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.858690] ata2.00: failed command: READ DMA
> [   26.859132] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.859132]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.860656] ata2.00: status: { DRDY }
> [   26.861542] ata2.00: configured for MWDMA2
> [   26.861960] ata2: EH complete
> [   26.874030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.874693] ata2.00: failed command: READ DMA
> [   26.875131] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.875131]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.876675] ata2.00: status: { DRDY }
> [   26.877554] ata2.00: configured for MWDMA2
> [   26.877976] ata2: EH complete
> [   26.890030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.890655] ata2.00: failed command: READ DMA
> [   26.891082] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.891082]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.892544] ata2.00: status: { DRDY }
> [   26.893408] ata2.00: configured for MWDMA2
> [   26.893812] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
> [   26.894698] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
> [   26.895356] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
> [   26.895993] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad fa 00 00 08 00
> [   26.896693] blk_update_request: I/O error, dev sda, sector 44538 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> [   26.897668] ata2: EH complete
> [   26.922032] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.922652] ata2.00: failed command: READ DMA
> [   26.923080] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.923080]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.924538] ata2.00: status: { DRDY }
> [   26.925404] ata2.00: configured for MWDMA2
> [   26.925807] ata2: EH complete
> [   26.938031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.938650] ata2.00: failed command: READ DMA
> [   26.939076] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.939076]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.940529] ata2.00: status: { DRDY }
> [   26.941391] ata2.00: configured for MWDMA2
> [   26.941793] ata2: EH complete
> [   26.954031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.954652] ata2.00: failed command: READ DMA
> [   26.955079] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.955079]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.956536] ata2.00: status: { DRDY }
> [   26.957400] ata2.00: configured for MWDMA2
> [   26.957800] ata2: EH complete
> [   26.970031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.970653] ata2.00: failed command: READ DMA
> [   26.971079] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.971079]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.972536] ata2.00: status: { DRDY }
> [   26.973402] ata2.00: configured for MWDMA2
> [   26.973804] ata2: EH complete
> [   26.986030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   26.986654] ata2.00: failed command: READ DMA
> [   26.987082] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   26.987082]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   26.988541] ata2.00: status: { DRDY }
> [   26.989406] ata2.00: configured for MWDMA2
> [   26.989807] ata2: EH complete
> [   27.002031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [   27.002653] ata2.00: failed command: READ DMA
> [   27.003083] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> [   27.003083]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
> [   27.004541] ata2.00: status: { DRDY }
> [   27.005404] ata2.00: configured for MWDMA2
> [   27.005806] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
> [   27.006688] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
> [   27.007346] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
> [   27.007982] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad fa 00 00 08 00
> [   27.008680] blk_update_request: I/O error, dev sda, sector 44538 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> [   27.009649] ata2: EH complete
> Bus error
> 
> I cannot reproduce this warning with set file as nvdimm with following command.
> sudo /home/teawater/qemu/qemu/x86_64-softmmu/qemu-system-x86_64 -machine pc,accel=kvm,kernel_irqchip,nvdimm -no-reboot -nographic -kernel /home/teawater/kernel/bk2/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/pmem0 swiotlb=noforce" -m 1g,slots=1,maxmem=2G -smp 1 -device nvdimm,id=nv0,memdev=mem0 -object memory-backend-file,id=mem0,mem-path=/home/teawater/old.img,size=268435456 -monitor unix:/home/teawater/qemu/m,server,nowait
> 
> Best,
> Hui


-- 
Thanks,

David / dhildenb

