Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3756F165EA0
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBTNVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:21:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56685 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727943AbgBTNVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:21:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8fOoSsSz7tsTUHvX+UaUO6G7U94kDGpWqoCWwnJ/CO0=;
        b=f8R9f/fs+z+SZtBe8/u25Grzgw4n0Hb72dSzMC6RirrFVnhcF+NBJDriVjKMOnO8CDtB5T
        8lzJC3I43qJZpV10cYaZido4ab4QrvU8lR+R7bqWf2SDvafn9aEJ5MspGZUlrrTtLlqfuz
        XcTrRc957n8ZZ80DscX9NT39ZzPWJYk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-N77XKRyXMyut3LxDUyhXag-1; Thu, 20 Feb 2020 08:21:41 -0500
X-MC-Unique: N77XKRyXMyut3LxDUyhXag-1
Received: by mail-wm1-f71.google.com with SMTP id b8so990409wmj.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:21:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8fOoSsSz7tsTUHvX+UaUO6G7U94kDGpWqoCWwnJ/CO0=;
        b=d7Hk1Ve0h0u/j3TZSjs5IYh9PQs8qzN9+BpnoMDD2xJPBGiV2pKOAYO/H1IoxbOHMB
         TtBuLZG85Hb8nBR79dmQtmyXcSX6wxJH6wywOh+4dDoi/Kwtt78Y7pE2ERLGR3fcQ9mj
         8ix40s/Nf7/42dTlZnVIA73ofnWjvsdoqawEWHeCljZwF4UnbgbTmSd3TJr0Qx8T7Lvk
         oeFeN8A3Y6CBJsoin9psxBf3CR4zYReYnH7H5RLA0XmAqgcz54gomFIJpBM5qVXwJ0us
         VBLpsaErThjwnpVrM+nGUOiK6tlWJKprJaeCECayeo9sGDLYcVfSfCoz92naNbzrGrEG
         VejQ==
X-Gm-Message-State: APjAAAX2BvYatemU0YucdxOIZarFCBrcgeooXOGURJLsP4JrcfqstkfN
        hGOpTmGdtc/JoRvTWVbbT5NO48v5dz77KPqcNANMqvuUM7BYX4MnT/PX554xPgqVC/bnRLPHm63
        OH9DWMDMx6fkF
X-Received: by 2002:a7b:ca49:: with SMTP id m9mr4782592wml.50.1582204900626;
        Thu, 20 Feb 2020 05:21:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqzKxcQLqflxe9qCIU9rTsjyGiEk6CQgzPBe/H4AxjLFCiLPx9wCf3WQ03jwpKNmMAnM1bKEcw==
X-Received: by 2002:a7b:ca49:: with SMTP id m9mr4782560wml.50.1582204900358;
        Thu, 20 Feb 2020 05:21:40 -0800 (PST)
Received: from [10.201.49.12] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id i2sm4415838wmb.28.2020.02.20.05.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 05:21:39 -0800 (PST)
Subject: Re: [PATCH v3 03/20] exec: Let qemu_ram_*() functions take a const
 pointer argument
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
 <20200220130548.29974-4-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fce0956e-e542-e8a5-bd02-a7941a9db627@redhat.com>
Date:   Thu, 20 Feb 2020 14:21:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200220130548.29974-4-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/20 14:05, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/exec/cpu-common.h     | 6 +++---
>  include/sysemu/xen-mapcache.h | 4 ++--
>  exec.c                        | 8 ++++----
>  hw/i386/xen/xen-mapcache.c    | 2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
> index 81753bbb34..05ac1a5d69 100644
> --- a/include/exec/cpu-common.h
> +++ b/include/exec/cpu-common.h
> @@ -48,11 +48,11 @@ typedef uint32_t CPUReadMemoryFunc(void *opaque, hwaddr addr);
>  
>  void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
>  /* This should not be used by devices.  */
> -ram_addr_t qemu_ram_addr_from_host(void *ptr);
> +ram_addr_t qemu_ram_addr_from_host(const void *ptr);

This is a bit ugly, because the pointer _can_ be modified via
qemu_map_ram_ptr.  Is this needed for the rest of the series to apply?

Paolo

>  RAMBlock *qemu_ram_block_by_name(const char *name);
> -RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
> +RAMBlock *qemu_ram_block_from_host(const void *ptr, bool round_offset,
>                                     ram_addr_t *offset);
> -ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host);
> +ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, const void *host);
>  void qemu_ram_set_idstr(RAMBlock *block, const char *name, DeviceState *dev);
>  void qemu_ram_unset_idstr(RAMBlock *block);
>  const char *qemu_ram_get_idstr(RAMBlock *rb);
> diff --git a/include/sysemu/xen-mapcache.h b/include/sysemu/xen-mapcache.h
> index c8e7c2f6cf..81e9aa2fa6 100644
> --- a/include/sysemu/xen-mapcache.h
> +++ b/include/sysemu/xen-mapcache.h
> @@ -19,7 +19,7 @@ void xen_map_cache_init(phys_offset_to_gaddr_t f,
>                          void *opaque);
>  uint8_t *xen_map_cache(hwaddr phys_addr, hwaddr size,
>                         uint8_t lock, bool dma);
> -ram_addr_t xen_ram_addr_from_mapcache(void *ptr);
> +ram_addr_t xen_ram_addr_from_mapcache(const void *ptr);
>  void xen_invalidate_map_cache_entry(uint8_t *buffer);
>  void xen_invalidate_map_cache(void);
>  uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
> @@ -40,7 +40,7 @@ static inline uint8_t *xen_map_cache(hwaddr phys_addr,
>      abort();
>  }
>  
> -static inline ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
> +static inline ram_addr_t xen_ram_addr_from_mapcache(const void *ptr)
>  {
>      abort();
>  }
> diff --git a/exec.c b/exec.c
> index 8e9cc3b47c..02b4e6ea41 100644
> --- a/exec.c
> +++ b/exec.c
> @@ -2614,7 +2614,7 @@ static void *qemu_ram_ptr_length(RAMBlock *ram_block, ram_addr_t addr,
>  }
>  
>  /* Return the offset of a hostpointer within a ramblock */
> -ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
> +ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, const void *host)
>  {
>      ram_addr_t res = (uint8_t *)host - (uint8_t *)rb->host;
>      assert((uintptr_t)host >= (uintptr_t)rb->host);
> @@ -2640,11 +2640,11 @@ ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
>   * pointer, such as a reference to the region that includes the incoming
>   * ram_addr_t.
>   */
> -RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
> +RAMBlock *qemu_ram_block_from_host(const void *ptr, bool round_offset,
>                                     ram_addr_t *offset)
>  {
>      RAMBlock *block;
> -    uint8_t *host = ptr;
> +    const uint8_t *host = ptr;
>  
>      if (xen_enabled()) {
>          ram_addr_t ram_addr;
> @@ -2705,7 +2705,7 @@ RAMBlock *qemu_ram_block_by_name(const char *name)
>  
>  /* Some of the softmmu routines need to translate from a host pointer
>     (typically a TLB entry) back to a ram offset.  */
> -ram_addr_t qemu_ram_addr_from_host(void *ptr)
> +ram_addr_t qemu_ram_addr_from_host(const void *ptr)
>  {
>      RAMBlock *block;
>      ram_addr_t offset;
> diff --git a/hw/i386/xen/xen-mapcache.c b/hw/i386/xen/xen-mapcache.c
> index 5b120ed44b..432ad3354d 100644
> --- a/hw/i386/xen/xen-mapcache.c
> +++ b/hw/i386/xen/xen-mapcache.c
> @@ -363,7 +363,7 @@ uint8_t *xen_map_cache(hwaddr phys_addr, hwaddr size,
>      return p;
>  }
>  
> -ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
> +ram_addr_t xen_ram_addr_from_mapcache(const void *ptr)
>  {
>      MapCacheEntry *entry = NULL;
>      MapCacheRev *reventry;
> 

