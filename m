Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E14B5B7A30
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 20:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiIMSyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 14:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiIMSxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 14:53:45 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF0561D9C
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 11:40:08 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z12so3897241wrp.9
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 11:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8P/rtt532wy+m+cdRj+p9xndqvxx7K2+mXQXqrigolc=;
        b=LxfZv2fGKRwenvDKyKsvwf0P4h6JQ1P1MW1tPZCDc2Uv2QkSIrASDwCCK4qE7xhOSG
         cY23eGQWwIb10wNbLjFpqY2zBFNwQYqv3rAIialZIih5sYUPb8/epqEICVLUJzw+ht2E
         dOf6s58bHYpVSt/RR9tDGm5X5kYSAMLU4+d01CqomM6ZrAHFN5IB/DRdu/MshtPt4agd
         lnSrwgZfHi9AUdf9+Tf4kypiv7cNdHaxZWukweRUhzp44f9n/WgQwufW46yTptop8Lcf
         /5SOmm7CEagMT4cI4g9vq0NoOdlYMx7W0cWGnYXF7AliFSsB8i03A5vJPBd7Y4sVm5vX
         JXEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8P/rtt532wy+m+cdRj+p9xndqvxx7K2+mXQXqrigolc=;
        b=a+DOrmuJoDtqrJ7dUxNNt8X7//TAoTvPyD0vvLJkB4jKpGdTJK2d0/UNQgAGdpJWbp
         GGdwcDlyXEvlepxnYpWoGEUUEwMhAKDNzKmCeYIygPz82jmtvTn5rp/RC12Zr5+2qaFQ
         8rsxJb3JSPSog33cyB4zsY1EJ69gNhtWZBhIYP/mV95X6dRIjREYOCRgrEzQfWBedKeD
         AMUrWaGaJWFk6zc3GY1uqu6+JnLYZHrfQUJq7u6KzW4iWVOWJ18DQfUihCPA1GgpJY3X
         JzD9h01SBpv28IcONUbQmiu1uvDEIlTatVlv7COBBy2xC38DZ4G01NfXJDmHAYMKGBiZ
         Bgxw==
X-Gm-Message-State: ACgBeo17KfSeyiNF/oGJArVt8eGRXILL29e17P8zAok/a39UKBQ3P/Sk
        +ZUm25H4aMaEvLSfDZQc2saOfmb4Z/7cYA==
X-Google-Smtp-Source: AA6agR4CTdYKDDOVni5B3BUbsoYC3ieMwBnsjGXKJ1lyd5IWN+pfHBHYqiFqHkKc2K6cfEARoT3nYQ==
X-Received: by 2002:a5d:59c3:0:b0:22a:4463:5a3a with SMTP id v3-20020a5d59c3000000b0022a44635a3amr11333268wry.123.1663094407161;
        Tue, 13 Sep 2022 11:40:07 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id m7-20020a056000008700b00228ccd00cedsm11574006wrx.107.2022.09.13.11.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 11:40:06 -0700 (PDT)
Date:   Tue, 13 Sep 2022 19:40:02 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, andre.przywara@arm.com, kvm@vger.kernel.org,
        Pierre Gondois <pierre.gondois@arm.com>
Subject: Re: [PATCH kvmtool] pci: Disable writes to Status register
Message-ID: <YyDOgu1gPcN1wLq1@myrica>
References: <20220908144208.231272-1-jean-philippe@linaro.org>
 <YyCLLLVi6AzAzW0p@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyCLLLVi6AzAzW0p@monolith.localdoman>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 13, 2022 at 02:52:44PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Sep 08, 2022 at 03:42:09PM +0100, Jean-Philippe Brucker wrote:
> > Although the PCI Status register only contains read-only and
> > write-1-to-clear bits, we currently keep anything written there, which
> > can confuse a guest.
> > 
> > The problem was highlighted by recent Linux commit 6cd514e58f12 ("PCI:
> > Clear PCI_STATUS when setting up device"), which unconditionally writes
> > 0xffff to the Status register in order to clear pending errors. Then the
> > EDAC driver sees the parity status bits set and attempts to clear them
> > by writing 0xc100, which in turn clears the Capabilities List bit.
> > Later on, when the virtio-pci driver starts probing, it assumes due to
> > missing capabilities that the device is using the legacy transport, and
> > fails to setup the device because of mismatched protocol.
> > 
> > Filter writes to the config space, keeping only those to writable
> > fields. Tighten the access size check while we're at it, to prevent
> > overflow. This is only a small step in the right direction, not a
> > foolproof solution, because a guest could still write both Command and
> > Status registers using a single 32-bit write. More work is needed for:
> > * Supporting arbitrary sized writes.
> > * Sanitizing accesses to capabilities, which are device-specific.
> > * Fine-grained filtering of the Command register, where only some bits
> >   are writable.
> 
> I'm confused here. Why not do value &= mask to keep only those bits that
> writable?

Sure, I can add it

> 
> > 
> > Also remove the old hack that filtered accesses. It was wrong and not
> > properly explained in the git history, but whatever it was guarding
> > against should be prevented by these new checks.
> 
> If I remember correctly, that was guarding against the guest kernel poking
> the ROM base address register for drivers that assumed that the ROM was
> always there, I vaguely remember that was the case with GPUs. Pairs with
> the similar check in the vfio callback, vfio_pci_cfg_write().

Right, makes sense. I think that's what I assumed when rewriting
pci__config_wr() hence the current comment but the original commits didn't
say anything about it.

> 
> > 
> > Reported-by: Pierre Gondois <pierre.gondois@arm.com>
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > ---
> > Note that the issue described here only shows up during ACPI boot for
> > me, because edac_init() happens after PCI enumeration. With DT boot,
> > edac_pci_clear_parity_errors() runs earlier and doesn't find any device.
> > ---
> >  pci.c | 41 ++++++++++++++++++++++++++++++++---------
> >  1 file changed, 32 insertions(+), 9 deletions(-)
> > 
> > diff --git a/pci.c b/pci.c
> > index a769ae27..84dc7d1d 100644
> > --- a/pci.c
> > +++ b/pci.c
> > @@ -350,6 +350,24 @@ static void pci_config_bar_wr(struct kvm *kvm,
> >  	pci_activate_bar_regions(kvm, old_addr, bar_size);
> >  }
> >  
> > +/*
> > + * Bits that are writable in the config space header.
> > + * Write-1-to-clear Status bits are missing since we never set them.
> > + */
> > +static const u8 pci_config_writable[PCI_STD_HEADER_SIZEOF] = {
> > +	[PCI_COMMAND] =
> > +		PCI_COMMAND_IO |
> > +		PCI_COMMAND_MEMORY |
> > +		PCI_COMMAND_MASTER |
> > +		PCI_COMMAND_PARITY,
> > +	[PCI_COMMAND + 1] =
> > +		(PCI_COMMAND_SERR |
> > +		 PCI_COMMAND_INTX_DISABLE) >> 8,
> > +	[PCI_INTERRUPT_LINE] = 0xff,
> > +	[PCI_BASE_ADDRESS_0 ... PCI_BASE_ADDRESS_5 + 3] = 0xff,
> > +	[PCI_CACHE_LINE_SIZE] = 0xff,
> > +};
> > +
> >  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
> >  {
> >  	void *base;
> > @@ -357,7 +375,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
> >  	u16 offset;
> >  	struct pci_device_header *pci_hdr;
> >  	u8 dev_num = addr.device_number;
> > -	u32 value = 0;
> > +	u32 value = 0, mask = 0;
> >  
> >  	if (!pci_device_exists(addr.bus_number, dev_num, 0))
> >  		return;
> > @@ -368,12 +386,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
> >  	if (pci_hdr->cfg_ops.write)
> >  		pci_hdr->cfg_ops.write(kvm, pci_hdr, offset, data, size);
> >  
> > -	/*
> > -	 * legacy hack: ignore writes to uninitialized regions (e.g. ROM BAR).
> > -	 * Not very nice but has been working so far.
> > -	 */
> > -	if (*(u32 *)(base + offset) == 0)
> > -		return;
> > +	/* We don't sanity-check capabilities for the moment */
> > +	if (offset < PCI_STD_HEADER_SIZEOF) {
> > +		memcpy(&mask, pci_config_writable + offset, size);
> > +		if (!mask)
> > +			return;
> 
> Shouldn't this be performed before the VFIO callbacks?

Yes I think I can move it up

> Also, the vfio callbacks still do the writes to the VFIO in-kernel PCI
> header, but now kvmtool would skip those writes entirely. Shouldn't
> kvmtool's view of the configuration space be identical to that of VFIO?

VFIO also skips writes to read-only fields, so they should now be more in
sync than before :) But their views are already desynchronized, because
kvmtool doesn't read back the config space virtualized by VFIO after
writing to it. We should probably improve it, but that's also for a future
patch.

> 
> > +	}
> >  
> >  	if (offset == PCI_COMMAND) {
> >  		memcpy(&value, data, size);
> > @@ -419,8 +437,13 @@ static void pci_config_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> >  	cfg_addr.w		= (u32)addr;
> >  	cfg_addr.enable_bit	= 1;
> >  
> > -	if (len > 4)
> > -		len = 4;
> > +	/*
> > +	 * "Root Complex implementations are not required to support the
> > +	 * generation of Configuration Requests from accesses that cross DW
> > +	 * [4 bytes] boundaries."
> > +	 */
> > +	if ((addr & 3) + len > 4)
> > +		return;
> 
> Isn't that a change in behaviour?

Yes, but it should be safe to change since it is implementation defined.
According to the spec 64-bit config space writes through ECAM are not
expected to work and I find the old behaviour, truncating the write, worse
than rejecting the whole thing. It looks like at least linux, freebsd,
u-boot and edk2 don't issue 64-bit writes.

Thanks,
Jean

> How about:
> 
>     len = 4 - (addr & 3);
> 
> Which should conform to the spec, but still allow writes like before.
> 
> Thanks,
> Alex
> 
> >  
> >  	if (is_write)
> >  		pci__config_wr(kvm, cfg_addr, data, len);
> > -- 
> > 2.37.3
> > 
