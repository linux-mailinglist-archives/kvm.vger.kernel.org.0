Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D3C7290D9
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 09:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbjFIHWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 03:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238472AbjFIHVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 03:21:51 -0400
Received: from out-63.mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F2918D
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 00:21:49 -0700 (PDT)
Date:   Fri, 9 Jun 2023 09:21:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686295307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IaopBfagvwS3R4qAUdnfrfhlAWkc1cyOQNQ3E55q+Y8=;
        b=TURntaX0ZxW2FHUB2YLXB0WyFUx2MYPHe2IyvUAPHeQJnlbtUIhMFWJAQpVw+zcDjF9g+9
        OQQg4KscQVSmOlPW4SxRF4TOlh2xQK4aZkRVaopJ2Vu5ChvT7Ao4h7vN02hO/UYhfre47R
        TSnBELUpbNedElQ035uyzMZtG9npOjc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
Message-ID: <20230609-2ef801d526b6f0256720cf24@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
 <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
 <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 10:24:11AM -0700, Nadav Amit wrote:
> 
> 
> > On Jun 8, 2023, at 10:18 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
> > 
> > 
> > On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > 
> >> 
> >> +static void uart0_init_acpi(void)
> >> +{
> >> + struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
> >> +
> >> + assert_msg(spcr, "Unable to find ACPI SPCR");
> >> + uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
> >> +}
> > 
> > Is it possible as a fallback, is SPCR is not available, to UART_EARLY_BASE as
> > address and bit_width as bit-width?
> > 
> > I would appreciate it, since it would help my setup.
> > 
> 
> Ugh - typo, 8 as bit-width for the fallback (ioremap with these parameters to
> make my request clear).
>

That sounds reasonable to me. Nikos, can you send a fixup! patch? I'll
squash it in.

Thanks,
drew
