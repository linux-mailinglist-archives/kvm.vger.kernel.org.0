Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ADD6C3836
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 18:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjCURcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 13:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjCURcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 13:32:15 -0400
Received: from out-55.mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AE118A98
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:32:13 -0700 (PDT)
Date:   Tue, 21 Mar 2023 18:32:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679419931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7w4ZEi3YbIfHRVCRyPDA4Njekej7K6ZPISjlI0RqQ4Y=;
        b=w3eErXp5VgR9/2P5TjtGC6tRAoy/ghNE4BmXnU+jlcTl1dzwwvYsZpy30kjDvStULutR+l
        cGa5DZcUlGWblNsmg3PymEM0+HdRSouW9VdLHZf0aSE64ycD3l1ypbjXDCp05jhhbX4F2H
        lNUC2pbwGin2jk9DKR22bFTYYaspb4g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [PATCH v4 04/30] lib: Apply Lindent to acpi.{c,h}
Message-ID: <20230321173210.kojqm6owufly7upk@orel>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-5-nikos.nikoleris@arm.com>
 <5a8887b2-a276-b087-964e-fa3f98826185@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8887b2-a276-b087-964e-fa3f98826185@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 09, 2023 at 03:11:56PM +0800, Shaoqin Huang wrote:
...
> > +#define ACPI_TABLE_HEADER_DEF		/* ACPI common table header */			\
> > +	u32 signature;			/* ACPI signature (4 ASCII characters) */	\
> > +	u32 length;			/* Length of table, in bytes, including header */ \
> > +	u8  revision;			/* ACPI Specification minor version # */	\
> > +	u8  checksum;			/* To make sum of entire table == 0 */		\
> > +	u8  oem_id [6];			/* OEM identification */			\
>                   ^
> > +	u8  oem_table_id [8];		/* OEM table identification */			\
>                         ^
> > +	u32 oem_revision;		/* OEM revision number */			\
> > +	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
>                            ^
> nit: These space should also be deleted.
>

Yes, but the fixup belongs in the next patch that does manual style
changes.

Thanks,
drew
