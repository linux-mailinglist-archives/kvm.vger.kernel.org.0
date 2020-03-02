Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5E3176233
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 19:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgCBSPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 13:15:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39178 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgCBSPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 13:15:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583172939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=K5tYutS5LyyCEQewOnTkc4sNJgGJUnwQiq/O+gz1xUU=;
        b=B/+wxxPJNwp4CN27X556cnGDu5MnNp9RDcJzWWlpkRVhaE9+D1jYc9BDRzTtOI6hzLruu3
        I/MSk6TGHWkZgNdMCWsOIQRRy98YX4y0X2XFGqIUi1heKW6CO5m+mYn1ywvfwIVCrKVN0M
        a7uCxBMmxbFqxKLAPstEsI83//E2X6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-tvOQceu-NwairZLijYS2oQ-1; Mon, 02 Mar 2020 13:15:35 -0500
X-MC-Unique: tvOQceu-NwairZLijYS2oQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C12718B9F80;
        Mon,  2 Mar 2020 18:15:30 +0000 (UTC)
Received: from [10.36.116.60] (ovpn-116-60.ams2.redhat.com [10.36.116.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B99E19C7F;
        Mon,  2 Mar 2020 18:15:10 +0000 (UTC)
Subject: Re: [PATCH v1 00/11] virtio-mem: paravirtualized memory
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>,
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
References: <20200302134941.315212-1-david@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <7f8a9225-99f2-b00d-241f-ef934395c667@redhat.com>
Date:   Mon, 2 Mar 2020 19:15:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302134941.315212-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.20 14:49, David Hildenbrand wrote:
> This series is based on latest linux-next. The patches are located at:
>     https://github.com/davidhildenbrand/linux.git virtio-mem-v1
> 
> The basic idea of virtio-mem is to provide a flexible,
> cross-architecture memory hot(un)plug solution that avoids many limitations
> imposed by existing technologies, architectures, and interfaces. More
> details can be found below and in linked material.
> 
> It's currently only enabled for x86-64, however, should theoretically work
> on any architecture that supports virtio and implements memory hot(un)plug
> under Linux - like s390x, powerpc64, and arm64. On x86-64, it is currently
> possible to add/remove memory to the system in >= 4MB granularity.
> Memory hotplug works very reliably. For memory unplug, there are no
> guarantees how much memory can actually get unplugged, it depends on the
> setup (especially: fragmentation of physical memory).
> 
> I am currently getting the QEMU side into shape (which will be posted as
> RFC soon, see below for a link to the current state). Experimental Kata
> support is in the works [4]. Also, a cloud-hypervisor implementation is
> under discussion [5].
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
>     Each virtio-mem device manages a dedicated region in physical address
>     space. Each device can belong to a single NUMA node, multiple devices
>     for a single NUMA node are possible. A virtio-mem device is like a
>     "resizable DIMM" consisting of small memory blocks that can be plugged
>     or unplugged. The device driver is responsible for (un)plugging memory
>     blocks on demand.
> 
>     Virtio-mem devices can only operate on their assigned memory region in
>     order to (un)plug memory. A device cannot (un)plug memory belonging to
>     other devices.
> 
>     The "region_size" corresponds to the maximum amount of memory that can
>     be provided by a device. The "size" corresponds to the amount of memory
>     that is currently plugged. "requested_size" corresponds to a request
>     from the device to the device driver to (un)plug blocks. The
>     device driver should try to (un)plug blocks in order to reach the
>     "requested_size". It is impossible to plug more memory than requested.
> 
>     The "usable_region_size" represents the memory region that can actually
>     be used to (un)plug memory. It is always at least as big as the
>     "requested_size" and will grow dynamically. It will only shrink when
>     explicitly triggered (VIRTIO_MEM_REQ_UNPLUG).
> 
>     There are no guarantees what will happen if unplugged memory is
>     read/written. Such memory should, in general, not be touched. E.g.,
>     even writing might succeed, but the values will simply be discarded at
>     random points in time.
> 
>     It can happen that the device cannot process a request, because it is
>     busy. The device driver has to retry later.
> 
>     Usually, during system resets all memory will get unplugged, so the
>     device driver can start with a clean state. However, in specific
>     scenarios (if the device is busy) it can happen that the device still
>     has memory plugged. The device driver can request to unplug all memory
>     (VIRTIO_MEM_REQ_UNPLUG) - which might take a while to succeed if the
>     device is busy.
> 
> --------------------------------------------------------------------------
> 2. Linux Implementation
> --------------------------------------------------------------------------
> 
> Memory blocks (e.g., 128MB) are added/removed on demand. Within these
> memory blocks, subblocks (e.g., 4MB) are plugged/unplugged. The sizes
> depend on the target architecture, MAX_ORDER, pageblock_order, and
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
> --------------------------------------------------------------------------
> 3. Changes RFC v4 -> v1
> --------------------------------------------------------------------------
> 
> Only minor things changed, especially, nothing on the virtio side.
> - "virtio-mem: Paravirtualized memory hotplug"
> -- Fix compilation without CONFIG_ACPI_NUMA
> -- Minor code simplifications
> -- Better lockdep handling
> -- Fix retry handling when getting a config update while processing work
> - "virtio-mem: Paravirtualized memory hotunplug part 1"
> - "virtio-mem: Paravirtualized memory hotunplug part 2"
> -- Unplug memory from highest to lowest, as we plug from lowest to highest
> - "mm: Allow to offline unmovable PageOffline() pages via
>    MEM_GOING_OFFLINE"
> -- Optimized comments/description
> - "mm/memory_hotplug: Introduce offline_and_remove_memory()"
> -- Rephrased description
> - Drop the drop_slab() functionality for now
> - Added "MAINTAINERS: Add myself as virtio-mem maintainer"
> - Fixed many spelling issues. checkpatch mostly complains about BUG_ONs
>   and two macros, which is fine.
> 
> --------------------------------------------------------------------------
> 4. Future work
> --------------------------------------------------------------------------
> 
> virtio-mem extensions (via new feature flags):
> - Indicate the guest status (e.g., initialized, working, all memory is
>   busy when unplugging, too many memory blocks are offline when plugging,
>   etc.)
> - Guest-triggered shrinking of the usable region (e.g., whenever the
>   highest memory block is removed).
> - Exchange of plugged<->unplugged block for defragmentation.
> 
> Memory hotplug:
> - Reduce the amount of memory resources if that tunes out to be an
>   issue. Or try to speed up relevant code paths to deal with many
>   resources.
> - Allocate vmemmap from added memory.
> 
> Memory hotunplug:
> - Performance improvements:
> -- Sense (lockless) if it make sense to try alloc_contig_range() at all
>    before directly trying to isolate and taking locks.
> -- Try to unplug bigger chunks within a memory block first.
> - Make unplug more likely to succeed:
> -- There are various idea to limit fragmentation on memory block
>    granularity. (e.g., ZONE_PREFER_MOVABLE and smart balancing)
> -- Allocate vmemmap from added memory.
> - OOM handling, e.g., via an OOM handler.
> - Defragmentation
> 
> --------------------------------------------------------------------------
> 5. Example Usage
> --------------------------------------------------------------------------
> 
> A QEMU implementation (without protection of unplugged memory, but with
> resizable memory regions and optimized migration) is available at (kept
> updated):
>     https://github.com/davidhildenbrand/qemu.git virtio-mem
> 
> Start QEMU with two virtio-mem devices (one per NUMA node):
>  $ qemu-system-x86_64 -m 4G,maxmem=204G \
>   -smp sockets=2,cores=2 \
>   -numa node,nodeid=0,cpus=0-1 -numa node,nodeid=1,cpus=2-3 \
>   [...]
>   -object memory-backend-ram,id=mem0,size=100G,managed-size=on \
>   -device virtio-mem-pci,id=vm0,memdev=mem0,node=0,requested-size=0M \
>   -object memory-backend-ram,id=mem1,size=100G,managed-size=on \
>   -device virtio-mem-pci,id=vm1,memdev=mem1,node=1,requested-size=1G
> 
> Query the configuration:
>  QEMU 4.2.50 monitor - type 'help' for more information
>  (qemu) info memory-devices
>  Memory device [virtio-mem]: "vm0"
>    memaddr: 0x140000000
>    node: 0
>    requested-size: 0
>    size: 0
>    max-size: 107374182400
>    block-size: 2097152
>    memdev: /objects/mem0
>  Memory device [virtio-mem]: "vm1"
>    memaddr: 0x1a40000000
>    node: 1
>    requested-size: 1073741824
>    size: 1073741824
>    max-size: 107374182400
>    block-size: 2097152
>    memdev: /objects/mem1
> 
> Add some memory to node 0:
>  QEMU 4.2.50 monitor - type 'help' for more information
>  (qemu) qom-set vm0 requested-size 1G
> 
> Remove some memory from node 1:
>  QEMU 4.2.50 monitor - type 'help' for more information
>  (qemu) qom-set vm1 requested-size 64M
> 
> Query the configuration again:
>  QEMU 4.2.50 monitor - type 'help' for more information
>  (qemu) info memory-devices
>  Memory device [virtio-mem]: "vm0"
>    memaddr: 0x140000000
>    node: 0
>    requested-size: 1073741824
>    size: 1073741824
>    max-size: 107374182400
>    block-size: 2097152
>    memdev: /objects/mem0
>  Memory device [virtio-mem]: "vm1"
>    memaddr: 0x1a40000000
>    node: 1
>    requested-size: 67108864
>    size: 67108864
>    max-size: 107374182400
>    block-size: 2097152
>    memdev: /objects/mem1
> 
> --------------------------------------------------------------------------
> 6. Q/A
> --------------------------------------------------------------------------
> 
> Q: Why add/remove parts ("subblocks") of memory blocks/sections?
> A: Flexibility (section size depends on the architecture) - e.g., some
>    architectures have a section size of 2GB. Also, the memory block size
>    is variable (e.g., on x86-64). I want to avoid any such restrictions.
>    Some use cases want to add/remove memory in smaller granularity to a
>    VM (e.g., the Hyper-V balloon also implements this) - especially smaller
>    VMs like used for kata containers. Also, on memory unplug, it is more
>    reliable to free-up and unplug multiple small chunks instead
>    of one big chunk. E.g., if one page of a DIMM is either unmovable or
>    pinned, the DIMM can't get unplugged. This approach is basically a
>    compromise between DIMM-based memory hot(un)plug and balloon
>    inflation/deflation, which works mostly on page granularity.
> 
> Q: Why care about memory blocks?
> A: They are the way to tell user space about new memory. This way,
>    memory can get onlined/offlined by user space. Also, e.g., kdump
>    relies on udev events to reload kexec when memory blocks are
>    onlined/offlined. Memory blocks are the "real" memory hot(un)plug
>    granularity. Everything that's smaller has to be emulated "on top".
> 
> Q: Won't memory unplug of subblocks fragment memory?
> A: Yes and no. Unplugging e.g., >=4MB subblocks on x86-64 will not really
>    fragment memory like unplugging random pages like a balloon driver does.
>    Buddy merging will not be limited. However, any allocation that requires
>    bigger consecutive memory chunks (e.g., gigantic pages) might observe
>    the fragmentation. Possible solutions: Allocate gigantic huge pages
>    before unplugging memory, don't unplug memory, combine virtio-mem with
>    DIMM based memory or bigger initial memory. Remember, a virtio-mem
>    device will only unplug on the memory range it manages, not on other
>    DIMMs. Unplug of single memory blocks will result in similar
>    fragmentation in respect to gigantic huge pages.
> 
> Q: How reliable is memory unplug?
> A: There are no guarantees on how much memory can get unplugged
>    again. However, it is more likely to find 4MB chunks to unplug than
>    e.g., 128MB chunks. If memory is terribly fragmented, there is nothing
>    we can do - for now. I consider memory hotplug the first primary use
>    of virtio-mem. Memory unplug might usually work, but we want to improve
>    the performance and the amount of memory we can actually unplug later.
> 
> Q: Why not unplug from the ZONE_MOVABLE?
> A: Unplugged memory chunks are unmovable. Unmovable data must not end up
>    on the ZONE_MOVABLE - similar to gigantic pages - they will never be
>    allocated from ZONE_MOVABLE. virtio-mem added memory can be onlined
>    to the ZONE_MOVABLE, but subblocks will not get unplugged from it.
> 
> Q: How big should the initial (!virtio-mem) memory of a VM be?
> A: virtio-mem memory will not go to the DMA zones. So to avoid running out
>    of DMA memory, I suggest something like 2-3GB on x86-64. But many
>    VMs can most probably deal with less DMA memory - depends on the use
>    case.
> 
> [1] https://events.linuxfoundation.org/wp-content/uploads/2017/12/virtio-mem-Paravirtualized-Memory-David-Hildenbrand-Red-Hat-1.pdf
> [2] https://lkml.kernel.org/r/20190919142228.5483-1-david@redhat.com
> [3] https://lkml.kernel.org/r/547865a9-d6c2-7140-47e2-5af01e7d761d@redhat.com
> [4] https://github.com/kata-containers/documentation/pull/592
> [5] https://github.com/cloud-hypervisor/cloud-hypervisor/pull/837
> 
> Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Cc: Samuel Ortiz <samuel.ortiz@intel.com>
> Cc: Robert Bradford <robert.bradford@intel.com>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: teawater <teawaterz@linux.alibaba.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> David Hildenbrand (11):
>   ACPI: NUMA: export pxm_to_node
>   virtio-mem: Paravirtualized memory hotplug
>   virtio-mem: Paravirtualized memory hotunplug part 1
>   mm: Export alloc_contig_range() / free_contig_range()
>   virtio-mem: Paravirtualized memory hotunplug part 2
>   mm: Allow to offline unmovable PageOffline() pages via
>     MEM_GOING_OFFLINE
>   virtio-mem: Allow to offline partially unplugged memory blocks
>   mm/memory_hotplug: Introduce offline_and_remove_memory()
>   virtio-mem: Offline and remove completely unplugged memory blocks
>   virtio-mem: Better retry handling
>   MAINTAINERS: Add myself as virtio-mem maintainer

As requested by Michal, I will squash some patches.

I'll pull out the NID thingies from "virtio-mem: Paravirtualized memory
hotplug" and squash "ACPI: NUMA: export pxm_to_node" into that change.

Also, I'll squash "mm: Export alloc_contig_range() /
free_contig_range()" into "virtio-mem: Paravirtualized memory hotunplug
part 2". I'll not squash the other, more involved, MM patches.

Thanks!

-- 
Thanks,

David / dhildenb

