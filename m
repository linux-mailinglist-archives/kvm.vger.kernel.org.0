Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E47562FFD
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiGAJ2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236740AbiGAJ1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:27:49 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968FB70E76
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:27:22 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:27:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656667640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yBDM3jk0/YsmKGe6+ySUDtPZ+C3SrxCp2v9vVkoKXYg=;
        b=l54pU2FFkcdmrF3HltysN/t8WF+bcHY+HqzHK0uVSIC90L9BDzeoBQnoksQOaOlUKuhbfX
        U7pxbeoOriwK+BmQd/mhCYw1ZYQOCx76TpcUnSYZ3/jStPjUWubmiejnPsdglL/N0WBrdd
        mDp4sSmAez3XmEL+BXItusLqwgkjUyU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 01/27] lib: Fix style for acpi.{c,h}
Message-ID: <20220701092719.63g4kv6co65dnpnd@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-2-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-2-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

I guess you used Linux's scripts/Lindent or something for this
conversion. Can you please specify what you used/did in the
commit message?

On Thu, Jun 30, 2022 at 11:02:58AM +0100, Nikos Nikoleris wrote:
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h | 148 ++++++++++++++++++++++++++---------------------------
>  lib/acpi.c |  70 ++++++++++++-------------
>  2 files changed, 108 insertions(+), 110 deletions(-)

It looks like the series is missing the file move patch. Latest master
still doesn't have lib/acpi.*

Thanks,
drew
