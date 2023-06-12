Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC372B94B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 09:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbjFLH41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 03:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbjFLHz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 03:55:56 -0400
Received: from out-57.mta1.migadu.com (out-57.mta1.migadu.com [IPv6:2001:41d0:203:375::39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C348134
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 00:55:05 -0700 (PDT)
Date:   Mon, 12 Jun 2023 09:54:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686556477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r4sIb7jmKOH0XhlhVEmgL4hOmArSKh30gUR9H6gYdnQ=;
        b=S41/vQO+VGiRrDhKjoBKNNViVb3Quhxe4HkEcJGVHie2ak/QJEywV9DoyGIdI7snNP3hcF
        za/tCKmphaL5MsmLSFqDoqPQ+xQMLUOGu0tN//H97XwEHpT5SymtdeQYGkStsOSpaTFCJu
        K5RlQ35ddAAmXekJeRAlCZGyyA10edE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 23/32] arm64: Add a setup sequence for
 systems that boot through EFI
Message-ID: <20230612-b9eae74905d7460f9da57b75@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-24-nikos.nikoleris@arm.com>
 <A5775A3C-B8BF-44C0-931A-CA2C9A4A0A4D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A5775A3C-B8BF-44C0-931A-CA2C9A4A0A4D@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 06:17:25PM -0700, Nadav Amit wrote:
> > 
> > 
> > On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > 
> > +static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> > +{
> > +   int i;
> > +   unsigned long free_mem_pages = 0;
> > +   unsigned long free_mem_start = 0;
> > +   struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
> > +   efi_memory_desc_t *buffer = *map->map;
> > +   efi_memory_desc_t *d = NULL;
> > +   phys_addr_t base, top;
> > +   struct mem_region r;
> > +   uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
> > +   uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
> 
> I am not a fan of the initialization of multiple variables in one line.
> 
> But that’s not the issue I am complaining about...
> 
> Shouldn't it be ALIGN() instead of __ALIGN() ?
>

Yup.

Thanks,
drew
