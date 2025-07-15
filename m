Return-Path: <kvm+bounces-52439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E13AB05384
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60B851AA7A15
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86232701D2;
	Tue, 15 Jul 2025 07:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="EM8wQ8HW"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947EA26FD9B
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 07:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752565373; cv=none; b=KNRLLgPUVoXRz3C6lpwfS3OPLHQJEiKFfV7b30QvVcnchqRR+Pzl6kgRFlbkzjlJNKFlfJgfd3q+blpEBn3KDuBDjpek/JIjuNuExiAKe7kFvhG3Q/XaNgVypjxRSVRNcsx+lYvtqgT+2+zA4AEz0dXJ1L6DLBGugLTr30zlu6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752565373; c=relaxed/simple;
	bh=SNRknQLv6NPDTQMb++m9SSF9AEy/CaOpDPIFHvGwoDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aIkieU5WeqkmRsFRM0YlZRPdx3lfZHG4g4EoD93KbabJiT8MM1sPinexudiu0rKWs/VukyDRXr1/S+OEQooambekGF8r4/LWgxwcBUV3rWNMtBeRVh78A3xMYXRT7f+PnckZ4kMqaQGceVZsK3ngeFLeLhWcIYBEsmcV2ZbMJRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=EM8wQ8HW reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [10.105.8.218] ([192.51.222.130])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56F7gmrF023054
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 15 Jul 2025 16:42:48 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=kx29O3j64MckhEwy/8xrLI+WMcwnZ0a/DV+G30DWIt4=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752565368; v=1;
        b=EM8wQ8HW2O8SSEOhYmNg3PskWpwOwfaKYdS/xScxjL8o43n2ua8JiFXFbFGzEN87
         GCRt0wfCypl49ZS4Y1xHX5tC/eh9eh6n9Eutc8CwvvDdguSrEDYa17zt5tA6Dp5v
         de13QRh2oVK9ZWfHNw3lr9iAdEV4wFmPhq0m1sM0JjEORML1876fuQtxc0RhWsgE
         6E34F9YMbUxRx1PJlS9UK3YPbFKSNfv/f6+etly4NbpITgZvM4WlWC7/sNuQkyLC
         /wI7Yc4s14XUz9MyB4ek44cxdOEFxWLcTP/+/Uf2ZfWhTOnZN14coQXqAzG0qAbB
         Tu689Fp4DYpsSFfcL//DDQ==
Message-ID: <8af39b78-a95d-4093-b68c-20b556860a09@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 15 Jul 2025 16:42:48 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 06/13] virtio-pci: implement support for extended
 features
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <eb1aa9c8442d9b482b5c84fdca54b92c8a824495.1752229731.git.pabeni@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <eb1aa9c8442d9b482b5c84fdca54b92c8a824495.1752229731.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/07/11 22:02, Paolo Abeni wrote:
> Extend the features configuration space to 128 bits, and allow the
> common read/write operation to access all of it.
> 
> On migration, save the 128 bit version of the features only if the
> upper bits are non zero; after load zero the upper bits if the extended
> features were not loaded.
> 
> Note that we must clear the proxy-ed features on device reset, otherwise
> a guest kernel not supporting extended features booted after an extended
> features enabled one could end-up wrongly inheriting extended features.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v1 -> v2:
>    - use separate VMStateDescription and pre/post load to avoid breaking
>      migration
>    - clear proxy features on device reset
> ---
>   hw/virtio/virtio-pci.c         | 101 +++++++++++++++++++++++++++++----
>   include/hw/virtio/virtio-pci.h |   6 +-
>   2 files changed, 96 insertions(+), 11 deletions(-)
> 
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index fba2372c93..dc5e7eaf81 100644
> --- a/hw/virtio/virtio-pci.c
> +++ b/hw/virtio/virtio-pci.c
> @@ -108,6 +108,39 @@ static const VMStateDescription vmstate_virtio_pci_modern_queue_state = {
>       }
>   };
>   
> +static bool virtio_pci_modern_state_features128_needed(void *opaque)
> +{
> +    VirtIOPCIProxy *proxy = opaque;
> +    uint32_t features = 0;
> +    int i;
> +
> +    for (i = 2; i < ARRAY_SIZE(proxy->guest_features128); ++i) {
> +        features |= proxy->guest_features128[i];
> +    }
> +    return !!features;

"!!" is unnecessary; the implicit cast will clamp the value into true/false.

> +}
> +
> +static int virtio_pci_modern_state_features128_post_load(void *opaque,
> +                                                         int version_id)
> +{
> +    VirtIOPCIProxy *proxy = opaque;
> +
> +    proxy->extended_features_loaded = true;
> +    return 0;
> +}
> +
> +static const VMStateDescription vmstate_virtio_pci_modern_state_features128 = {
> +    .name = "virtio_pci/modern_state/features128",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .post_load = &virtio_pci_modern_state_features128_post_load,
> +    .needed = &virtio_pci_modern_state_features128_needed,
> +    .fields = (const VMStateField[]) {
> +        VMSTATE_UINT32_ARRAY(guest_features128, VirtIOPCIProxy, 4),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>   static bool virtio_pci_modern_state_needed(void *opaque)
>   {
>       VirtIOPCIProxy *proxy = opaque;
> @@ -115,10 +148,40 @@ static bool virtio_pci_modern_state_needed(void *opaque)
>       return virtio_pci_modern(proxy);
>   }
>   
> +static int virtio_pci_modern_state_pre_load(void *opaque)
> +{
> +    VirtIOPCIProxy *proxy = opaque;
> +
> +    proxy->extended_features_loaded = false;
> +    return 0;
> +}
> +
> +static int virtio_pci_modern_state_post_load(void *opaque, int version_id)
> +{
> +    VirtIOPCIProxy *proxy = opaque;
> +    int i;
> +
> +    if (proxy->extended_features_loaded) {
> +        return 0;
> +    }
> +
> +    QEMU_BUILD_BUG_ON(offsetof(VirtIOPCIProxy, guest_features[0]) !=
> +                      offsetof(VirtIOPCIProxy, guest_features128[0]));
> +    QEMU_BUILD_BUG_ON(offsetof(VirtIOPCIProxy, guest_features[1]) !=
> +                      offsetof(VirtIOPCIProxy, guest_features128[1]));
> +
> +    for (i = 2; i < ARRAY_SIZE(proxy->guest_features128); ++i) {
> +        proxy->guest_features128[i] = 0;
> +    }
> +    return 0;
> +}
> +

You can expect the device is in the reset state when migrating so expect 
guest_features128 is initialized as zero; there are already plenty of 
code expecting the reset state.

>   static const VMStateDescription vmstate_virtio_pci_modern_state_sub = {
>       .name = "virtio_pci/modern_state",
>       .version_id = 1,
>       .minimum_version_id = 1,
> +    .pre_load = &virtio_pci_modern_state_pre_load,
> +    .post_load = &virtio_pci_modern_state_post_load,
>       .needed = &virtio_pci_modern_state_needed,
>       .fields = (const VMStateField[]) {
>           VMSTATE_UINT32(dfselect, VirtIOPCIProxy),
> @@ -128,6 +191,10 @@ static const VMStateDescription vmstate_virtio_pci_modern_state_sub = {
>                                vmstate_virtio_pci_modern_queue_state,
>                                VirtIOPCIQueue),
>           VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription * const []) {
> +        &vmstate_virtio_pci_modern_state_features128,
> +        NULL
>       }
>   };
>   
> @@ -1493,19 +1560,22 @@ static uint64_t virtio_pci_common_read(void *opaque, hwaddr addr,
>           val = proxy->dfselect;
>           break;
>       case VIRTIO_PCI_COMMON_DF:
> -        if (proxy->dfselect <= 1) {
> +        if (proxy->dfselect < VIRTIO_FEATURES_WORDS) {
>               VirtioDeviceClass *vdc = VIRTIO_DEVICE_GET_CLASS(vdev);
>   
> -            val = (vdev->host_features & ~vdc->legacy_features) >>
> -                (32 * proxy->dfselect);
> +            val = vdev->host_features_array[proxy->dfselect >> 1] >>
> +                  (32 * (proxy->dfselect & 1));
> +            if (proxy->dfselect <= 1) {
> +                val &= (~vdc->legacy_features) >> (32 * proxy->dfselect);
> +            }
>           }
>           break;
>       case VIRTIO_PCI_COMMON_GFSELECT:
>           val = proxy->gfselect;
>           break;
>       case VIRTIO_PCI_COMMON_GF:
> -        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features)) {
> -            val = proxy->guest_features[proxy->gfselect];
> +        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features128)) {
> +            val = proxy->guest_features128[proxy->gfselect];
>           }
>           break;
>       case VIRTIO_PCI_COMMON_MSIX:
> @@ -1587,11 +1657,18 @@ static void virtio_pci_common_write(void *opaque, hwaddr addr,
>           proxy->gfselect = val;
>           break;
>       case VIRTIO_PCI_COMMON_GF:
> -        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features)) {
> -            proxy->guest_features[proxy->gfselect] = val;
> -            virtio_set_features(vdev,
> -                                (((uint64_t)proxy->guest_features[1]) << 32) |
> -                                proxy->guest_features[0]);
> +        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features128)) {
> +            uint64_t features[VIRTIO_FEATURES_DWORDS];
> +            int i;
> +
> +            proxy->guest_features128[proxy->gfselect] = val;
> +            virtio_features_clear(features);
> +            for (i = 0; i < ARRAY_SIZE(proxy->guest_features128); ++i) {
> +                uint64_t cur = proxy->guest_features128[i];
> +
> +                features[i >> 1] |= cur << ((i & 1) * 32);
> +            }
> +            virtio_set_features_ex(vdev, features);
>           }
>           break;
>       case VIRTIO_PCI_COMMON_MSIX:
> @@ -2310,6 +2387,10 @@ static void virtio_pci_reset(DeviceState *qdev)
>       virtio_bus_reset(bus);
>       msix_unuse_all_vectors(&proxy->pci_dev);
>   
> +    /* be sure to not carry over any feature across reset */

It's obvious so I don't think the comment makes difference.

> +    memset(proxy->guest_features128, 0, sizeof(uint32_t) *
> +           ARRAY_SIZE(proxy->guest_features128));

Simpler:
memset(proxy->guest_features128, 0, sizeof(proxy->guest_features128);

> +
>       for (i = 0; i < VIRTIO_QUEUE_MAX; i++) {
>           proxy->vqs[i].enabled = 0;
>           proxy->vqs[i].reset = 0;
> diff --git a/include/hw/virtio/virtio-pci.h b/include/hw/virtio/virtio-pci.h
> index eab5394898..1868e3b106 100644
> --- a/include/hw/virtio/virtio-pci.h
> +++ b/include/hw/virtio/virtio-pci.h
> @@ -151,6 +151,7 @@ struct VirtIOPCIProxy {
>       uint32_t flags;
>       bool disable_modern;
>       bool ignore_backend_features;
> +    bool extended_features_loaded;
>       OnOffAuto disable_legacy;
>       /* Transitional device id */
>       uint16_t trans_devid;
> @@ -158,7 +159,10 @@ struct VirtIOPCIProxy {
>       uint32_t nvectors;
>       uint32_t dfselect;
>       uint32_t gfselect;
> -    uint32_t guest_features[2];
> +    union {
> +        uint32_t guest_features[2];
> +        uint32_t guest_features128[4];
> +    };

I don't see anything preventing you from directly extending guest_features.

>       VirtIOPCIQueue vqs[VIRTIO_QUEUE_MAX];
>   
>       VirtIOIRQFD *vector_irqfd;


