Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D811F4C7C
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 06:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgFJEpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 00:45:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43233 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726081AbgFJEpM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 00:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591764310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VxmhQ3VVJqCwy8aaYD5pSLwJjZ0VIqyd7EjfATRpmNc=;
        b=N4FQ1E4sY/97yjIcbn4mLhxfA7ua4XGg5sJe0dsnbOY5hDWjjOZIgJKYMAwTE8eixYdi5M
        k+AvEgkbmWe2k1YeKhzKGX3KBy6u9DG+E0gFabINgfNxUjxGtz0EtCAuGPEm70rjcjKng2
        BYoUPqTiJTHLeliUlIelw+e59ewuHRA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-bW36XoevOTOY_M9HXwOAfg-1; Wed, 10 Jun 2020 00:45:07 -0400
X-MC-Unique: bW36XoevOTOY_M9HXwOAfg-1
Received: by mail-wr1-f70.google.com with SMTP id r5so528443wrt.9
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 21:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VxmhQ3VVJqCwy8aaYD5pSLwJjZ0VIqyd7EjfATRpmNc=;
        b=kDPszzKKQJ79n7n9pG1djzQnclsWw4Kwlwlz2RlP4eSpSKShimgdU4k/ZZULxE77Ze
         0UuK0S8zJP+16aL7jxgzflCOYF9kQ9Ejvxa/AK1AB23xuGONP46tsAdPuimk5UqE4VZF
         y9ptre42jKwpmrk/CUStRLTKaDrlQYJJyjv0mTccx7to2RhLy9R0H/nkAWnoOC3E5Nt4
         bKMm/Hmk0Z+4ZmtCR9gJmicRQqCN+3toJIMrz2HhWB64kkX7i+xSp3zajXD4jR6+kdyM
         HXfM62Rw55wpDJwEPxCYTYiiPpMUzXdJ/ejy8tQCdTvrVpvqnvtsHzzuIJ77iphjlPXq
         /UvA==
X-Gm-Message-State: AOAM531tXIemWO6HFg1WP3Xnixm+0tnInVOs2AbWK+hf8Mq+gFxVNDbW
        fsWqvshGVwXKvHpfVtbawPUbNYYZsbmL4j07fnwAF2C9Wo4g13DqXzsVpJ+SPoveVw7ZF8AGQfL
        hyKIhY/NyJ9YV
X-Received: by 2002:a5d:5001:: with SMTP id e1mr1496107wrt.56.1591764305573;
        Tue, 09 Jun 2020 21:45:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywRytP6FIoM+W4oWypswZZXFPjrrjECTCkbmv+pP0bloGWVKqtSdiGopJ/ccnY8HzNdJNBwg==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr1496086wrt.56.1591764305280;
        Tue, 09 Jun 2020 21:45:05 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id q128sm5199346wma.38.2020.06.09.21.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 21:45:04 -0700 (PDT)
Date:   Wed, 10 Jun 2020 00:44:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        anshuman.khandual@arm.com, anthony.yznaga@oracle.com,
        arei.gonglei@huawei.com, cai@lca.pw, clabbe@baylibre.com,
        dan.j.williams@intel.com, davem@davemloft.net, david@redhat.com,
        dyoung@redhat.com, elfring@users.sourceforge.net,
        glider@google.com, gregkh@linuxfoundation.org,
        guennadi.liakhovetski@linux.intel.com, hannes@cmpxchg.org,
        herbert@gondor.apana.org.au, hulkci@huawei.com,
        imammedo@redhat.com, jasowang@redhat.com, jgross@suse.com,
        kernelfans@gmail.com, konrad.wilk@oracle.com, lenb@kernel.org,
        lingshan.zhu@intel.com, linux-acpi@vger.kernel.org, lkp@intel.com,
        longpeng2@huawei.com, matej.genci@nutanix.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com,
        mst@redhat.com, osalvador@suse.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com,
        pavel.tatashin@microsoft.com, rafael@kernel.org,
        richard.weiyang@gmail.com, rjw@rjwysocki.net, rppt@linux.ibm.com,
        stable@vger.kernel.org, stefanha@redhat.com,
        teawaterz@linux.alibaba.com, vbabka@suse.cz, zou_wei@huawei.com
Subject: [GIT PULL] virtio: features, fixes
Message-ID: <20200610004455-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's a single commit here that I tweaked since linux-next - the
change is in printk format string which I consider trivial enough not
force wait for more testing. A couple of hashes are different from
what's in linux-next though.  I also upgraded the machine I used to sign
the tag (didn't change the key) - hope the signature is still ok. If not
pls let me know!

The following changes since commit 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162:

  Linux 5.7 (2020-05-31 16:49:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 044e4b09223039e571e6ec540e25552054208765:

  vhost/test: fix up after API change (2020-06-09 06:42:06 -0400)

----------------------------------------------------------------
virtio: features, fixes

virtio-mem
doorbell mapping for vdpa
config interrupt support in ifc
fixes all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alexander Duyck (1):
      virtio-balloon: Disable free page reporting if page poison reporting is not enabled

David Hildenbrand (17):
      MAINTAINERS: Add myself as virtio-balloon co-maintainer
      virtio-mem: Paravirtualized memory hotplug
      MAINTAINERS: Add myself as virtio-mem maintainer
      virtio-mem: Allow to specify an ACPI PXM as nid
      virtio-mem: Paravirtualized memory hotunplug part 1
      virtio-mem: Paravirtualized memory hotunplug part 2
      mm: Allow to offline unmovable PageOffline() pages via MEM_GOING_OFFLINE
      virtio-mem: Allow to offline partially unplugged memory blocks
      mm/memory_hotplug: Introduce offline_and_remove_memory()
      virtio-mem: Offline and remove completely unplugged memory blocks
      virtio-mem: Better retry handling
      virtio-mem: Add parent resource for all added "System RAM"
      virtio-mem: Drop manual check for already present memory
      virtio-mem: Unplug subblocks right-to-left
      virtio-mem: Use -ETXTBSY as error code if the device is busy
      virtio-mem: Try to unplug the complete online memory block first
      virtio-mem: Don't rely on implicit compiler padding for requests

Guennadi Liakhovetski (1):
      vhost: (cosmetic) remove a superfluous variable initialisation

Jason Wang (4):
      vhost: allow device that does not depend on vhost worker
      vhost: use mmgrab() instead of mmget() for non worker device
      vdpa: introduce get_vq_notification method
      vhost_vdpa: support doorbell mapping via mmap

Longpeng(Mike) (3):
      crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()
      crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()
      crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()

Markus Elfring (1):
      virtio-mmio: Delete an error message in vm_find_vqs()

Matej Genci (1):
      virtio: add VIRTIO_RING_NO_LEGACY

Michael S. Tsirkin (6):
      virtio: force spec specified alignment on types
      vhost: revert "vhost: disable for OABI"
      vhost_vdpa: disable doorbell mapping for !MMU
      virtio-mem: drop unnecessary initialization
      virtio_mem: convert device block size into 64bit
      vhost/test: fix up after API change

Samuel Zou (1):
      vdpasim: Fix some coccinelle warnings

Zhu Lingshan (5):
      ifcvf: move IRQ request/free to status change handlers
      ifcvf: ignore continuous setting same status value
      vhost_vdpa: Support config interrupt in vdpa
      vhost: replace -1 with VHOST_FILE_UNBIND in ioctls
      ifcvf: implement config interrupt in IFCVF

 MAINTAINERS                                |   18 +-
 drivers/acpi/numa/srat.c                   |    1 +
 drivers/crypto/virtio/virtio_crypto_algs.c |   21 +-
 drivers/misc/mic/Kconfig                   |    2 +-
 drivers/net/caif/Kconfig                   |    2 +-
 drivers/vdpa/Kconfig                       |    2 +-
 drivers/vdpa/ifcvf/ifcvf_base.c            |    3 +
 drivers/vdpa/ifcvf/ifcvf_base.h            |    4 +
 drivers/vdpa/ifcvf/ifcvf_main.c            |  146 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c           |    7 +-
 drivers/vhost/Kconfig                      |   17 +-
 drivers/vhost/net.c                        |    2 +-
 drivers/vhost/scsi.c                       |    2 +-
 drivers/vhost/test.c                       |    2 +-
 drivers/vhost/vdpa.c                       |  112 +-
 drivers/vhost/vhost.c                      |  100 +-
 drivers/vhost/vhost.h                      |    8 +-
 drivers/vhost/vringh.c                     |    6 +-
 drivers/vhost/vsock.c                      |    2 +-
 drivers/virtio/Kconfig                     |   17 +
 drivers/virtio/Makefile                    |    1 +
 drivers/virtio/virtio_balloon.c            |    9 +-
 drivers/virtio/virtio_mem.c                | 1965 ++++++++++++++++++++++++++++
 drivers/virtio/virtio_mmio.c               |    4 +-
 drivers/virtio/virtio_pci_modern.c         |    1 +
 include/linux/memory_hotplug.h             |    1 +
 include/linux/page-flags.h                 |   10 +
 include/linux/vdpa.h                       |   16 +
 include/linux/vringh.h                     |    6 +-
 include/uapi/linux/vhost.h                 |    4 +
 include/uapi/linux/virtio_ids.h            |    1 +
 include/uapi/linux/virtio_mem.h            |  211 +++
 include/uapi/linux/virtio_ring.h           |   48 +-
 mm/memory_hotplug.c                        |   81 +-
 mm/page_alloc.c                            |   26 +
 mm/page_isolation.c                        |    9 +
 36 files changed, 2723 insertions(+), 144 deletions(-)
 create mode 100644 drivers/virtio/virtio_mem.c
 create mode 100644 include/uapi/linux/virtio_mem.h

