Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826031206B5
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 14:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfLPNLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 08:11:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24434 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727782AbfLPNLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 08:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576501910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=75YfmPUd8IxShkS7a0b2Ig4I+aTSu5nF6jxguOhk6cM=;
        b=KSrThmf9izmv/Yhj/9gbfDcwelG5Fee6HXY45eaDMS5xI7oSbNswDN1Esj98Cbsek5guzp
        aGiZ7Hl/6KcoPg1tfPHgMQbVL7tvYNKKwRUJM8NOG+LkxW90a80sVLFybLPqc6sHG005IV
        QN9xIfm9T7WAGxF00wLgdHWT3+VXhlA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-1slzXXL4Pzu-vQiAahAQSQ-1; Mon, 16 Dec 2019 08:11:48 -0500
X-MC-Unique: 1slzXXL4Pzu-vQiAahAQSQ-1
Received: by mail-wm1-f72.google.com with SMTP id t17so1004849wmi.7
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 05:11:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=75YfmPUd8IxShkS7a0b2Ig4I+aTSu5nF6jxguOhk6cM=;
        b=awPRt9GPsrQMh2ylhdIsZUFBKoKXdYzbEEZD4f3yXB58rwfLztOEpVSfNd989DbYrI
         ZKBErm/d2WOLs22hKMUXJEYddG96b75IgtyXkcfJZdZbtLTbOKLF+MTGlMFU7R62MHMt
         KoNSzCubBigS+05Gg0PB5kFPAlUaMHeGFQQqpVe1JI9sx9U3EqktAJjtDzpi45pzovG0
         6E/U3adtmvbJqfPepSvRKyySbruUZqGhMJbVcAnbOCFYRd8+wHTVb7Hq7o0pfsngoCwe
         zDRAmpn7ZuKoCc98SlNLBsHTi+F4Nq0KcdGO8U7Y7S+rq+TBv+HjQQg4BqRljeR1g1jt
         Efuw==
X-Gm-Message-State: APjAAAW1J+S2dri2n0Pm6ehAbqaoAHQ7om6rFvhJqnPryVKinXkEGoIf
        Y1U6i7KNjIjPbLmX2Q+JF/YIQ/FSG0wzRTm0nOzd0OBU87RW8kZLmlNsMyScCasaDDmmya2EjC2
        4CKf3A2RnM1I9
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr29258093wrw.327.1576501907532;
        Mon, 16 Dec 2019 05:11:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqwuIcoQzrLz1xC87UatN3jXBE3T8LoVif4M67IAzWtqOxR+SyLrgYTkIoP4IoF7SSSnGn/e5g==
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr29258050wrw.327.1576501907281;
        Mon, 16 Dec 2019 05:11:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id t190sm12609330wmt.44.2019.12.16.05.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 05:11:46 -0800 (PST)
Subject: Re: [PATCH 08/12] hw/ide/piix: Use ARRAY_SIZE() instead of magic
 numbers
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org, Sergio Lopez <slp@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-9-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3e4ef8f0-4ccf-65c8-35ec-95bc6cf4e3d0@redhat.com>
Date:   Mon, 16 Dec 2019 14:11:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-9-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 17:17, Philippe Mathieu-Daudé wrote:
> Using magic numbers is dangerous because the structures PCIIDEState
> might be modified and this source file consuming the "ide/pci.h"
> header would be out of sync, eventually accessing out of bound
> array members.
> Use the ARRAY_SIZE() to keep the source file sync.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/ide/piix.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/hw/ide/piix.c b/hw/ide/piix.c
> index ffeff4e095..ab23613a44 100644
> --- a/hw/ide/piix.c
> +++ b/hw/ide/piix.c
> @@ -87,10 +87,9 @@ static const MemoryRegionOps piix_bmdma_ops = {
>  
>  static void bmdma_setup_bar(PCIIDEState *d)
>  {
> -    int i;
> -
>      memory_region_init(&d->bmdma_bar, OBJECT(d), "piix-bmdma-container", 16);
> -    for(i = 0;i < 2; i++) {
> +
> +    for (size_t i = 0; i < ARRAY_SIZE(d->bmdma); i++) {
>          BMDMAState *bm = &d->bmdma[i];
>  
>          memory_region_init_io(&bm->extra_io, OBJECT(d), &piix_bmdma_ops, bm,
> @@ -107,9 +106,8 @@ static void piix_ide_reset(DeviceState *dev)
>      PCIIDEState *d = PCI_IDE(dev);
>      PCIDevice *pd = PCI_DEVICE(d);
>      uint8_t *pci_conf = pd->config;
> -    int i;
>  
> -    for (i = 0; i < 2; i++) {
> +    for (size_t i = 0; i < ARRAY_SIZE(d->bus); i++) {
>          ide_bus_reset(&d->bus[i]);
>      }
>  
> @@ -132,10 +130,10 @@ static void pci_piix_init_ports(PCIIDEState *d) {
>          {0x1f0, 0x3f6, 14},
>          {0x170, 0x376, 15},
>      };
> -    int i;
>  
> -    for (i = 0; i < 2; i++) {
> -        ide_bus_new(&d->bus[i], sizeof(d->bus[i]), DEVICE(d), i, 2);
> +    for (size_t i = 0; i < ARRAY_SIZE(d->bus); i++) {
> +        ide_bus_new(&d->bus[i], sizeof(d->bus[i]), DEVICE(d), i,
> +                    ARRAY_SIZE(d->bus[0].ifs));
>          ide_init_ioport(&d->bus[i], NULL, port_info[i].iobase,
>                          port_info[i].iobase2);
>          ide_init2(&d->bus[i], isa_get_irq(NULL, port_info[i].isairq));
> @@ -163,14 +161,13 @@ static void pci_piix_ide_realize(PCIDevice *dev, Error **errp)
>  
>  int pci_piix3_xen_ide_unplug(DeviceState *dev, bool aux)
>  {
> -    PCIIDEState *pci_ide;
> +    PCIIDEState *pci_ide = PCI_IDE(dev);
>      DriveInfo *di;
> -    int i;
>      IDEDevice *idedev;
> +    const size_t idedev_max = ARRAY_SIZE(pci_ide->bus)
> +                            * ARRAY_SIZE(pci_ide->bus[0].ifs);
>  
> -    pci_ide = PCI_IDE(dev);
> -
> -    for (i = aux ? 1 : 0; i < 4; i++) {
> +    for (size_t i = aux ? 1 : 0; i < idedev_max; i++) {
>          di = drive_get_by_index(IF_IDE, i);
>          if (di != NULL && !di->media_cd) {
>              BlockBackend *blk = blk_by_legacy_dinfo(di);
> @@ -210,9 +207,8 @@ PCIDevice *pci_piix3_xen_ide_init(PCIBus *bus, DriveInfo **hd_table, int devfn)
>  static void pci_piix_ide_exitfn(PCIDevice *dev)
>  {
>      PCIIDEState *d = PCI_IDE(dev);
> -    unsigned i;
>  
> -    for (i = 0; i < 2; ++i) {
> +    for (size_t i = 0; i < ARRAY_SIZE(d->bmdma); ++i) {
>          memory_region_del_subregion(&d->bmdma_bar, &d->bmdma[i].extra_io);
>          memory_region_del_subregion(&d->bmdma_bar, &d->bmdma[i].addr_ioport);
>      }
> 

Queued, thanks.

Paolo

