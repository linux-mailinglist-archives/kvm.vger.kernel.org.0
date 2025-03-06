Return-Path: <kvm+bounces-40273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C36FA55773
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 21:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A4F97AAC08
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 20:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD2F271295;
	Thu,  6 Mar 2025 20:29:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F314F9FF
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 20:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741292989; cv=none; b=leQ13uaZI7GZS0OHH8s0USTj59oTci8K4knW4uIUio7eRei8IXsmIl8aqIhEyLWERJY+O1WPxKtlikQc611EMYoTJORM6CBZqTmKc7raksiytNhNmwL6U6Y0hnjwXfhE2555W560p8FImRqtavWNiDpgNiRSNhMmEgzuXOQV9Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741292989; c=relaxed/simple;
	bh=bEzTC/FNdZ6y7K+2289Cp1MuHyT5sPRs52HFV/BNIuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YwX8B9eijqL4HGrgD3TRfDYxMQnijVsCpgyjx6W2pa0fkowQ6u/Ht34dK/lzOrySU63690tSkcTfRiy+I/Hqrd3e50n+kX+1GLMvNSx4gSfwy0+1verOiiptDLmP+TZyfvvQgRfHIxUBHgaw5xw1HyBhLFB0ZhqdLql3N/DkXxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1tqHqY-00000000PqO-3e91;
	Thu, 06 Mar 2025 21:29:34 +0100
Message-ID: <adadeb12-9eb7-4338-828e-62e77034b1dd@maciej.szmigiero.name>
Date: Thu, 6 Mar 2025 21:29:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] hw/hyperv/vmbus: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: kvm@vger.kernel.org, philmd@linaro.org, qemu-devel@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 richard.henderson@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-4-pierrick.bouvier@linaro.org>
Content-Language: en-US, pl-PL
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <20250306064118.3879213-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: mhej@vps-ovh.mhejs.net

On 6.03.2025 07:41, Pierrick Bouvier wrote:
> Replace TARGET_PAGE.* by runtime calls.

Seems like this patch subject/title is not aligned
well with its content, or a least incomplete.

Also, could you provide more detailed information
why TARGET_PAGE_SIZE is getting replaced by
qemu_target_page_size() please?

I don't see such information in the cover letter either.

Thanks,
Maciej
  
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/vmbus.c     | 50 +++++++++++++++++++++----------------------
>   hw/hyperv/meson.build |  2 +-
>   2 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
> index 12a7dc43128..109ac319caf 100644
> --- a/hw/hyperv/vmbus.c
> +++ b/hw/hyperv/vmbus.c
> @@ -18,7 +18,7 @@
>   #include "hw/hyperv/vmbus.h"
>   #include "hw/hyperv/vmbus-bridge.h"
>   #include "hw/sysbus.h"
> -#include "cpu.h"
> +#include "exec/target_page.h"
>   #include "trace.h"
>   
>   enum {
> @@ -309,7 +309,7 @@ void vmbus_put_gpadl(VMBusGpadl *gpadl)
>   
>   uint32_t vmbus_gpadl_len(VMBusGpadl *gpadl)
>   {
> -    return gpadl->num_gfns * TARGET_PAGE_SIZE;
> +    return gpadl->num_gfns * qemu_target_page_size();
>   }
>   
>   static void gpadl_iter_init(GpadlIter *iter, VMBusGpadl *gpadl,
> @@ -323,14 +323,14 @@ static void gpadl_iter_init(GpadlIter *iter, VMBusGpadl *gpadl,
>   
>   static inline void gpadl_iter_cache_unmap(GpadlIter *iter)
>   {
> -    uint32_t map_start_in_page = (uintptr_t)iter->map & ~TARGET_PAGE_MASK;
> -    uint32_t io_end_in_page = ((iter->last_off - 1) & ~TARGET_PAGE_MASK) + 1;
> +    uint32_t map_start_in_page = (uintptr_t)iter->map & ~qemu_target_page_mask();
> +    uint32_t io_end_in_page = ((iter->last_off - 1) & ~qemu_target_page_mask()) + 1;
>   
>       /* mapping is only done to do non-zero amount of i/o */
>       assert(iter->last_off > 0);
>       assert(map_start_in_page < io_end_in_page);
>   
> -    dma_memory_unmap(iter->as, iter->map, TARGET_PAGE_SIZE - map_start_in_page,
> +    dma_memory_unmap(iter->as, iter->map, qemu_target_page_size() - map_start_in_page,
>                        iter->dir, io_end_in_page - map_start_in_page);
>   }
>   
> @@ -348,17 +348,17 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
>       assert(iter->active);
>   
>       while (len) {
> -        uint32_t off_in_page = iter->off & ~TARGET_PAGE_MASK;
> -        uint32_t pgleft = TARGET_PAGE_SIZE - off_in_page;
> +        uint32_t off_in_page = iter->off & ~qemu_target_page_mask();
> +        uint32_t pgleft = qemu_target_page_size() - off_in_page;
>           uint32_t cplen = MIN(pgleft, len);
>           void *p;
>   
>           /* try to reuse the cached mapping */
>           if (iter->map) {
>               uint32_t map_start_in_page =
> -                (uintptr_t)iter->map & ~TARGET_PAGE_MASK;
> -            uint32_t off_base = iter->off & ~TARGET_PAGE_MASK;
> -            uint32_t mapped_base = (iter->last_off - 1) & ~TARGET_PAGE_MASK;
> +                (uintptr_t)iter->map & ~qemu_target_page_mask();
> +            uint32_t off_base = iter->off & ~qemu_target_page_mask();
> +            uint32_t mapped_base = (iter->last_off - 1) & ~qemu_target_page_mask();
>               if (off_base != mapped_base || off_in_page < map_start_in_page) {
>                   gpadl_iter_cache_unmap(iter);
>                   iter->map = NULL;
> @@ -368,10 +368,10 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
>           if (!iter->map) {
>               dma_addr_t maddr;
>               dma_addr_t mlen = pgleft;
> -            uint32_t idx = iter->off >> TARGET_PAGE_BITS;
> +            uint32_t idx = iter->off >> qemu_target_page_bits();
>               assert(idx < iter->gpadl->num_gfns);
>   
> -            maddr = (iter->gpadl->gfns[idx] << TARGET_PAGE_BITS) | off_in_page;
> +            maddr = (iter->gpadl->gfns[idx] << qemu_target_page_bits()) | off_in_page;
>   
>               iter->map = dma_memory_map(iter->as, maddr, &mlen, iter->dir,
>                                          MEMTXATTRS_UNSPECIFIED);
> @@ -382,7 +382,7 @@ static ssize_t gpadl_iter_io(GpadlIter *iter, void *buf, uint32_t len)
>               }
>           }
>   
> -        p = (void *)(uintptr_t)(((uintptr_t)iter->map & TARGET_PAGE_MASK) |
> +        p = (void *)(uintptr_t)(((uintptr_t)iter->map & qemu_target_page_mask()) |
>                   off_in_page);
>           if (iter->dir == DMA_DIRECTION_FROM_DEVICE) {
>               memcpy(p, buf, cplen);
> @@ -591,9 +591,9 @@ static void ringbuf_init_common(VMBusRingBufCommon *ringbuf, VMBusGpadl *gpadl,
>                                   uint32_t begin, uint32_t end)
>   {
>       ringbuf->as = as;
> -    ringbuf->rb_addr = gpadl->gfns[begin] << TARGET_PAGE_BITS;
> -    ringbuf->base = (begin + 1) << TARGET_PAGE_BITS;
> -    ringbuf->len = (end - begin - 1) << TARGET_PAGE_BITS;
> +    ringbuf->rb_addr = gpadl->gfns[begin] << qemu_target_page_bits();
> +    ringbuf->base = (begin + 1) << qemu_target_page_bits();
> +    ringbuf->len = (end - begin - 1) << qemu_target_page_bits();
>       gpadl_iter_init(&ringbuf->iter, gpadl, as, dir);
>   }
>   
> @@ -734,7 +734,7 @@ static int vmbus_channel_notify_guest(VMBusChannel *chan)
>       unsigned long *int_map, mask;
>       unsigned idx;
>       hwaddr addr = chan->vmbus->int_page_gpa;
> -    hwaddr len = TARGET_PAGE_SIZE / 2, dirty = 0;
> +    hwaddr len = qemu_target_page_size() / 2, dirty = 0;
>   
>       trace_vmbus_channel_notify_guest(chan->id);
>   
> @@ -743,7 +743,7 @@ static int vmbus_channel_notify_guest(VMBusChannel *chan)
>       }
>   
>       int_map = cpu_physical_memory_map(addr, &len, 1);
> -    if (len != TARGET_PAGE_SIZE / 2) {
> +    if (len != qemu_target_page_size() / 2) {
>           res = -ENXIO;
>           goto unmap;
>       }
> @@ -1038,14 +1038,14 @@ static int sgl_from_gpa_ranges(QEMUSGList *sgl, VMBusDevice *dev,
>           }
>           len -= sizeof(range);
>   
> -        if (range.byte_offset & TARGET_PAGE_MASK) {
> +        if (range.byte_offset & qemu_target_page_mask()) {
>               goto eio;
>           }
>   
>           for (; range.byte_count; range.byte_offset = 0) {
>               uint64_t paddr;
>               uint32_t plen = MIN(range.byte_count,
> -                                TARGET_PAGE_SIZE - range.byte_offset);
> +                                qemu_target_page_size() - range.byte_offset);
>   
>               if (len < sizeof(uint64_t)) {
>                   goto eio;
> @@ -1055,7 +1055,7 @@ static int sgl_from_gpa_ranges(QEMUSGList *sgl, VMBusDevice *dev,
>                   goto err;
>               }
>               len -= sizeof(uint64_t);
> -            paddr <<= TARGET_PAGE_BITS;
> +            paddr <<= qemu_target_page_bits();
>               paddr |= range.byte_offset;
>               range.byte_count -= plen;
>   
> @@ -1804,7 +1804,7 @@ static void handle_gpadl_header(VMBus *vmbus, vmbus_message_gpadl_header *msg,
>        * anything else and simplify things greatly.
>        */
>       if (msg->rangecount != 1 || msg->range[0].byte_offset ||
> -        (msg->range[0].byte_count != (num_gfns << TARGET_PAGE_BITS))) {
> +        (msg->range[0].byte_count != (num_gfns << qemu_target_page_bits()))) {
>           return;
>       }
>   
> @@ -2240,10 +2240,10 @@ static void vmbus_signal_event(EventNotifier *e)
>           return;
>       }
>   
> -    addr = vmbus->int_page_gpa + TARGET_PAGE_SIZE / 2;
> -    len = TARGET_PAGE_SIZE / 2;
> +    addr = vmbus->int_page_gpa + qemu_target_page_size() / 2;
> +    len = qemu_target_page_size() / 2;
>       int_map = cpu_physical_memory_map(addr, &len, 1);
> -    if (len != TARGET_PAGE_SIZE / 2) {
> +    if (len != qemu_target_page_size() / 2) {
>           goto unmap;
>       }
>   
> diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
> index f4aa0a5ada9..c855fdcf04c 100644
> --- a/hw/hyperv/meson.build
> +++ b/hw/hyperv/meson.build
> @@ -1,6 +1,6 @@
>   specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
>   specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
> -specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
> +system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
>   specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
>   specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
>   system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))


