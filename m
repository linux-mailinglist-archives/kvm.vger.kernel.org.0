Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA0E129E4F
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 07:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfLXG7G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 24 Dec 2019 01:59:06 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:5614 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbfLXG7G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Dec 2019 01:59:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=teawaterz@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0TloLelT_1577170736;
Received: from 30.30.208.105(mailfrom:teawaterz@linux.alibaba.com fp:SMTPD_---0TloLelT_1577170736)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 Dec 2019 14:58:58 +0800
Content-Type: text/plain;
        charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH RFC v4 00/13] virtio-mem: paravirtualized memory
From:   teawater <teawaterz@linux.alibaba.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
Date:   Tue, 24 Dec 2019 14:58:56 +0800
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
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
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <91ED8152-61FC-4E87-9F7B-44CD05C77279@linux.alibaba.com>
References: <20191212171137.13872-1-david@redhat.com>
To:     David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thanks for your work.

I Got following build fail if X86_64_ACPI_NUMA is n with rfc3 and rfc4:
make -j8 bzImage
  GEN     Makefile
  DESCEND  objtool
  CALL    /home/teawater/kernel/linux-upstream3/scripts/atomic/check-atomics.sh
  CALL    /home/teawater/kernel/linux-upstream3/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      drivers/virtio/virtio_mem.o
/home/teawater/kernel/linux-upstream3/drivers/virtio/virtio_mem.c: In function ‘virtio_mem_translate_node_id’:
/home/teawater/kernel/linux-upstream3/drivers/virtio/virtio_mem.c:478:10: error: implicit declaration of function ‘pxm_to_node’ [-Werror=implicit-function-declaration]
   node = pxm_to_node(node_id);
          ^~~~~~~~~~~
cc1: some warnings being treated as errors
/home/teawater/kernel/linux-upstream3/scripts/Makefile.build:265: recipe for target 'drivers/virtio/virtio_mem.o' failed
make[3]: *** [drivers/virtio/virtio_mem.o] Error 1
/home/teawater/kernel/linux-upstream3/scripts/Makefile.build:503: recipe for target 'drivers/virtio' failed
make[2]: *** [drivers/virtio] Error 2
/home/teawater/kernel/linux-upstream3/Makefile:1649: recipe for target 'drivers' failed
make[1]: *** [drivers] Error 2
/home/teawater/kernel/linux-upstream3/Makefile:179: recipe for target 'sub-make' failed
make: *** [sub-make] Error 2

Best,
Hui

> 在 2019年12月13日，01:11，David Hildenbrand <david@redhat.com> 写道：
> 
> This series is based on latest linux-next. The patches are located at:
>    https://github.com/davidhildenbrand/linux.git virtio-mem-rfc-v4
> 
> The basic idea of virtio-mem is to provide a flexible,
> cross-architecture memory hot(un)plug solution that avoids many limitations
> imposed by existing technologies, architectures, and interfaces. More
> details can be found below and in linked material.
> 
> This RFC is limited to x86-64, however, should theoretically work on any
> architecture that supports virtio and implements memory hot(un)plug under
> Linux - like s390x, powerpc64 and arm64. On x86-64, it is currently
> possible to add/remove memory to the system in >= 4MB granularity.
> Memory hotplug works very reliably. For memory unplug, there are no
> guarantees how much memory can actually get unplugged, it depends on the
> setup (especially: fragmentation of (unmovable) memory). I have plans to
> improve that in the future.
> 
> --------------------------------------------------------------------------
> 1. virtio-mem
> --------------------------------------------------------------------------
> 
> The basic idea behind virtio-mem was presented at KVM Forum 2018. The
> slides can be found at [1]. The previous RFC can be found at [2]. The
> first RFC can be found at [3]. However, the concept evolved over time. The
> KVM Forum slides roughly match the current design.
> 
> Patch #2 ("virtio-mem: Paravirtualized memory hotplug") contains quite some
> information, especially in "include/uapi/linux/virtio_mem.h":
> 
>  Each virtio-mem device manages a dedicated region in physical address
>  space. Each device can belong to a single NUMA node, multiple devices
>  for a single NUMA node are possible. A virtio-mem device is like a
>  "resizable DIMM" consisting of small memory blocks that can be plugged
>  or unplugged. The device driver is responsible for (un)plugging memory
>  blocks on demand.
> 
>  Virtio-mem devices can only operate on their assigned memory region in
>  order to (un)plug memory. A device cannot (un)plug memory belonging to
>  other devices.
> 
>  The "region_size" corresponds to the maximum amount of memory that can
>  be provided by a device. The "size" corresponds to the amount of memory
>  that is currently plugged. "requested_size" corresponds to a request
>  from the device to the device driver to (un)plug blocks. The
>  device driver should try to (un)plug blocks in order to reach the
>  "requested_size". It is impossible to plug more memory than requested.
> 
>  The "usable_region_size" represents the memory region that can actually
>  be used to (un)plug memory. It is always at least as big as the
>  "requested_size" and will grow dynamically. It will only shrink when
>  explicitly triggered (VIRTIO_MEM_REQ_UNPLUG).
> 
>  Memory in the usable region can usually be read, however, there are no
>  guarantees. It can happen that the device cannot process a request,
>  because it is busy. The device driver has to retry later.
> 
>  Usually, during system resets all memory will get unplugged, so the
>  device driver can start with a clean state. However, in specific
>  scenarios (if the device is busy) it can happen that the device still
>  has memory plugged. The device driver can request to unplug all memory
>  (VIRTIO_MEM_REQ_UNPLUG) - which might take a while to succeed if the
>  device is busy.
> 
> --------------------------------------------------------------------------
> 2. Linux Implementation
> --------------------------------------------------------------------------
> 
> This RFC reuses quite some existing MM infrastructure, however, has to
> expose some additional functionality.
> 
> Memory blocks (e.g., 128MB) are added/removed on demand. Within these
> memory blocks, subblocks (e.g., 4MB) are plugged/unplugged. The sizes
> depend on the target architecture, MAX_ORDER + pageblock_order, and
> the block size of a virtio-mem device.
> 
> add_memory()/try_remove_memory() is used to add/remove memory blocks.
> virtio-mem will not online memory blocks itself. This has to be done by
> user space, or configured into the kernel
> (CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE). virtio-mem will only unplug memory
> that was online to the ZONE_NORMAL. Memory is suggested to be onlined to
> the ZONE_NORMAL for now.
> 
> The memory hotplug notifier is used to properly synchronize against
> onlining/offlining of memory blocks and to track the states of memory
> blocks (including the zone memory blocks are onlined to).
> 
> The set_online_page() callback is used to keep unplugged subblocks
> of a memory block fake-offline when onlining the memory block.
> generic_online_page() is used to fake-online plugged subblocks. This
> handling is similar to the Hyper-V balloon driver.
> 
> PG_offline is used to mark unplugged subblocks as offline, so e.g.,
> dumping tools (makedumpfile) will skip these pages. This is similar to
> other balloon drivers like virtio-balloon and Hyper-V.
> 
> Memory offlining code is extended to allow drivers to drop their reference
> to PG_offline pages when MEM_GOING_OFFLINE, so these pages can be skipped
> when offlining memory blocks. This allows to offline memory blocks that
> have partially unplugged (allocated e.g., via alloc_contig_range())
> subblocks - or are completely unplugged.
> 
> alloc_contig_range()/free_contig_range() [now exposed] is used to
> unplug/plug subblocks of memory blocks the are already exposed to Linux.
> 
> offline_and_remove_memory() [new] is used to offline a fully unplugged
> memory block and remove it from Linux.
> 
> 
> A lot of additional information can be found in the separate patches and
> as comments in the code itself.
> 
> --------------------------------------------------------------------------
> 3. Changes RFC v2 -> v3
> --------------------------------------------------------------------------
> 
> A lot of things changed, especially also on the QEMU + virtio side. The
> biggest changes on the Linux driver side are:
> - Onlining/offlining of subblocks is now emulated on top of memory blocks.
>  set_online_page()+alloc_contig_range()+free_contig_range() is now used
>  for that. Core MM does not have to be modified and will continue to
>  online/offline full memory blocks.
> - Onlining/offlining of memory blocks is no longer performed by virtio-mem.
> - Pg_offline is upstream and can be used. It is also used to allow
>  offlining of partially unplugged memory blocks.
> - Memory block states + subblocks are now tracked more space-efficient.
> - Proper kexec(), kdump(), driver unload, driver reload, ZONE_MOVABLE, ...
>  handling.
> 
> --------------------------------------------------------------------------
> 4. Changes RFC v3 -> RFC v4
> --------------------------------------------------------------------------
> 
> Only minor things changed, especially nothing on the QEMU + virtio side.
> Interresting changes on the Linux driver side are:
> - "mm: Allow to offline unmovable PageOffline() pages via
>   MEM_GOING_OFFLINE"
> -- Rework to Michals suggestion (allow to isolate all PageOffline() pages
>   by skipping all PageOffline() pages in has_unmovable_pages(). Fail
>   offlining later if the pages cannot be offlined/migrated).
> - "virtio-mem: Allow to offline partially unplugged memory blocks"
> -- Adapt to Michals suggestion on core-mm part.
> - "virtio-mem: Better retry handling"
> -- Optimize retry intervals
> - "virtio-mem: Drop slab objects when unplug continues to fail"
> -- Call drop_slab()/drop_slab_node() when unplug keeps failing for a longer
>   time.
> - Multiple cleanups and fixes.
> 
> --------------------------------------------------------------------------
> 5. Future work
> --------------------------------------------------------------------------
> 
> The separate patches contain a lot of future work items. One of the next
> steps is to make memory unplug more likely to succeed - currently, there
> are no guarantees on how much memory can get unplugged again. I have
> various ideas on how to limit fragmentation of all memory blocks that
> virtio-mem added.
> 
> Memory hotplug:
> - Reduce the amount of memory resources if that turnes out to be an
>  issue. Or try to speed up relevant code paths to deal with many
>  resources.
> - Allocate the vmemmap from the added memory. Makes hotplug more likely
>  to succeed, the vmemmap is stored on the same NUMA node and that
>  unmovable memory will later not hinder unplug.
> 
> Memory hotunplug:
> - Performance improvements:
> -- Sense (lockless) if it make sense to try alloc_contig_range() at all
>   before directly trying to isolate and taking locks.
> -- Try to unplug bigger chunks if possible first.
> -- Identify free areas first, that don't have to be evacuated.
> - Make unplug more likely to succeed:
> -- There are various idea to limit fragmentation on memory block
>   granularity. (e.g., ZONE_PREFER_MOVABLE and smart balancing)
> -- Allocate memmap from added memory. This way, less unmovable data can
>   end up on the memory blocks.
> - OOM handling, e.g., via an OOM handler.
> - Defragmentation
> -- Will require a new virtio-mem CMD to exchange plugged<->unplugged blocks
> 
> --------------------------------------------------------------------------
> 6. Example Usage
> --------------------------------------------------------------------------
> 
> A very basic QEMU prototype (kept updated) is available at:
>    https://github.com/davidhildenbrand/qemu.git virtio-mem
> 
> It lacks various features, however, works to test the guest driver side:
> - No support for resizable memory regions / memory backends yet
> - No protection of unplugged memory (esp., userfaultfd-wp) yet
> - No dump/migration/XXX optimizations to skip unplugged memory (and avoid
>  touching it)
> 
> Start QEMU with two virtio-mem devices (one per NUMA node):
> $ qemu-system-x86_64 -m 4G,maxmem=20G \
>  -smp sockets=2,cores=2 \
>  -numa node,nodeid=0,cpus=0-1 -numa node,nodeid=1,cpus=2-3 \
>  [...]
>  -object memory-backend-ram,id=mem0,size=8G \
>  -device virtio-mem-pci,id=vm0,memdev=mem0,node=0,requested-size=128M \
>  -object memory-backend-ram,id=mem1,size=8G \
>  -device virtio-mem-pci,id=vm1,memdev=mem1,node=1,requested-size=80M
> 
> Query the configuration:
> QEMU 4.1.95 monitor - type 'help' for more information
> (qemu) info memory-devices
> Memory device [virtio-mem]: "vm0"
>   memaddr: 0x140000000
>   node: 0
>   requested-size: 134217728
>   size: 134217728
>   max-size: 8589934592
>   block-size: 2097152
>   memdev: /objects/mem0
> Memory device [virtio-mem]: "vm1"
>   memaddr: 0x340000000
>   node: 1
>   requested-size: 83886080
>   size: 83886080
>   max-size: 8589934592
>   block-size: 2097152
>   memdev: /objects/mem1
> 
> Add some memory to node 1:
> QEMU 4.1.95 monitor - type 'help' for more information
> (qemu) qom-set vm1 requested-size 1G
> 
> Remove some memory from node 0:
> QEMU 4.1.95 monitor - type 'help' for more information
> (qemu) qom-set vm0 requested-size 64M
> 
> Query the configuration again:
> (qemu) info memory-devices
> Memory device [virtio-mem]: "vm0"
>   memaddr: 0x140000000
>   node: 0
>   requested-size: 67108864
>   size: 67108864
>   max-size: 8589934592
>   block-size: 2097152
>   memdev: /objects/mem0
> Memory device [virtio-mem]: "vm1"
>   memaddr: 0x340000000
>   node: 1
>   requested-size: 1073741824
>   size: 1073741824
>   max-size: 8589934592
>   block-size: 2097152
>   memdev: /objects/mem1
> 
> --------------------------------------------------------------------------
> 7. Q/A
> --------------------------------------------------------------------------
> 
> Q: Why add/remove parts ("subblocks") of memory blocks/sections?
> A: Flexibility (section size depends on the architecture) - e.g., some
>   architectures have a section size of 2GB. Also, the memory block size
>   is variable (e.g., on x86-64). I want to avoid any such restrictions.
>   Some use cases want to add/remove memory in smaller granularities to a
>   VM (e.g., the Hyper-V balloon also implements this) - especially smaller
>   VMs like used for kata containers. Also, on memory unplug, it is more
>   reliable to free-up and unplug multiple small chunks instead
>   of one big chunk. E.g., if one page of a DIMM is either unmovable or
>   pinned, the DIMM can't get unplugged. This approach is basically a
>   compromise between DIMM-based memory hot(un)plug and balloon
>   inflation/deflation, which works mostly on page granularity.
> 
> Q: Why care about memory blocks?
> A: They are the way to tell user space about new memory. This way,
>   memory can get onlined/offlined by user space. Also, e.g., kdump
>   relies on udev events to reload kexec when memory blocks are
>   onlined/offlined. Memory blocks are the "real" memory hot(un)plug
>   granularity. Everything that's smaller has to be emulated "on top".
> 
> Q: Won't memory unplug of subblocks fragment memory?
> A: Yes and no. Unplugging e.g., >=4MB subblocks on x86-64 will not really
>   fragment memory like unplugging random pages like a balloon driver does.
>   Buddy merging will not be limited. However, any allocation that requires
>   bigger consecutive memory chunks (e.g., gigantic pages) might observe
>   the fragmentation. Possible solutions: Allocate gigantic huge pages
>   before unplugging memory, don't unplug memory, combine virtio-mem with
>   DIMM based memory or bigger initial memory. Remember, a virtio-mem
>   device will only unplug on the memory range it manages, not on other
>   DIMMs. Unplug of single memory blocks will result in similar
>   fragmentation in respect to gigantic huge pages. I ahve plans for a
>   virtio-mem defragmentation feature in the future.
> 
> Q: How reliable is memory unplug?
> A: There are no guarantees on how much memory can get unplugged
>   again. However, it is more likely to find 4MB chunks to unplug than
>   e.g., 128MB chunks. If memory is terribly fragmented, there is nothing
>   we can do - for now. I consider memory hotplug the first primary use
>   of virtio-mem. Memory unplug might usually work, but we want to improve
>   the performance and the amount of memory we can actually unplug later.
> 
> Q: Why not unplug from the ZONE_MOVABLE?
> A: Unplugged memory chunks are unmovable. Unmovable data must not end up
>   on the ZONE_MOVABLE - similar to gigantic pages - they will never be
>   allocated from ZONE_MOVABLE. virtio-mem added memory can be onlined
>   to the ZONE_MOVABLE, but subblocks will not get unplugged from it.
> 
> Q: How big should the initial (!virtio-mem) memory of a VM be?
> A: virtio-mem memory will not go to the DMA zones. So to avoid running out
>   of DMA memory, I suggest something like 2-3GB on x86-64. But many
>   VMs can most probably deal with less DMA memory - depends on the use
>   case.
> 
> [1] https://events.linuxfoundation.org/wp-content/uploads/2017/12/virtio-mem-Paravirtualized-Memory-David-Hildenbrand-Red-Hat-1.pdf
> [2] https://lkml.kernel.org/r/20190919142228.5483-1-david@redhat.com
> [3] https://lkml.kernel.org/r/547865a9-d6c2-7140-47e2-5af01e7d761d@redhat.com
> 
> Cc: Sebastien Boeuf  <sebastien.boeuf@intel.com>
> Cc: Samuel Ortiz <samuel.ortiz@intel.com>
> Cc: Robert Bradford <robert.bradford@intel.com>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> 
> David Hildenbrand (13):
>  ACPI: NUMA: export pxm_to_node
>  virtio-mem: Paravirtualized memory hotplug
>  virtio-mem: Paravirtualized memory hotunplug part 1
>  mm: Export alloc_contig_range() / free_contig_range()
>  virtio-mem: Paravirtualized memory hotunplug part 2
>  mm: Allow to offline unmovable PageOffline() pages via
>    MEM_GOING_OFFLINE
>  virtio-mem: Allow to offline partially unplugged memory blocks
>  mm/memory_hotplug: Introduce offline_and_remove_memory()
>  virtio-mem: Offline and remove completely unplugged memory blocks
>  virtio-mem: Better retry handling
>  mm/vmscan: Move count_vm_event(DROP_SLAB) into drop_slab()
>  mm/vmscan: Export drop_slab() and drop_slab_node()
>  virtio-mem: Drop slab objects when unplug continues to fail
> 
> drivers/acpi/numa/srat.c        |    1 +
> drivers/virtio/Kconfig          |   18 +
> drivers/virtio/Makefile         |    1 +
> drivers/virtio/virtio_mem.c     | 1939 +++++++++++++++++++++++++++++++
> fs/drop_caches.c                |    4 +-
> include/linux/memory_hotplug.h  |    1 +
> include/linux/mm.h              |    4 +-
> include/linux/page-flags.h      |   10 +
> include/uapi/linux/virtio_ids.h |    1 +
> include/uapi/linux/virtio_mem.h |  204 ++++
> mm/memory_hotplug.c             |   76 +-
> mm/page_alloc.c                 |   26 +
> mm/page_isolation.c             |    9 +
> mm/vmscan.c                     |    3 +
> 14 files changed, 2282 insertions(+), 15 deletions(-)
> create mode 100644 drivers/virtio/virtio_mem.c
> create mode 100644 include/uapi/linux/virtio_mem.h
> 
> -- 
> 2.23.0

