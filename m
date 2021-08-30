Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D57D3FB93F
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhH3Puh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:50:37 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:8749 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhH3Pue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630338581; x=1661874581;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/c1llN9C4IquXz3bbhXpbJ6//ha+QcyeP4evN5K3J5A=;
  b=Ha9ubgL1oE03cRRUjPH/ijC4lkfKosiMcKvaYwGSx1Lc5dYjoppDPyoK
   ELrAUFqvtrIO9iO7v9EqKOEwWx+sWGUHyFzDBIerigLi3oE8feziMyxxA
   ibyONyhd1xsw7IQb9l58RilS/lMMIcl5UQTabWb8m8GEZ8s8ccI7QJDYv
   c=;
X-IronPort-AV: E=Sophos;i="5.84,363,1620691200"; 
   d="scan'208";a="133232323"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 30 Aug 2021 15:49:40 +0000
Received: from EX13D46EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id D7444C09D6;
        Mon, 30 Aug 2021 15:49:38 +0000 (UTC)
Received: from u90cef543d0ab5a.ant.amazon.com (10.43.160.41) by
 EX13D46EUB004.ant.amazon.com (10.43.166.65) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 15:49:32 +0000
Date:   Mon, 30 Aug 2021 18:49:27 +0300
From:   George-Aurelian Popescu <popegeo@amazon.com>
To:     Andra Paraschiv <andraprs@amazon.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v3 4/7] nitro_enclaves: Update copyright statement to
 include 2021
Message-ID: <20210830154926.GD10224@u90cef543d0ab5a.ant.amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-5-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827154930.40608-5-andraprs@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D28UWB001.ant.amazon.com (10.43.161.98) To
 EX13D46EUB004.ant.amazon.com (10.43.166.65)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:49:27PM +0300, Andra Paraschiv wrote:
> Update the copyright statement to include 2021, as a change has been
> made over this year.
> 
> Check commit d874742f6a73 ("nitro_enclaves: Set Bus Master for the NE
> PCI device") for the codebase update from this file (ne_pci_dev.c).
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> 
> v1 -> v2
> 
> * No codebase changes, it was split from the patch 3 in the v1 of the
> patch series.
> 
> v2 -> v3
> 
> * Move changelog after the "---" line.
> ---
>  drivers/virt/nitro_enclaves/ne_pci_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> index 143207e9b9698..40b49ec8e30b1 100644
> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + * Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>   */
>  
>  /**
> -- 
> 2.20.1 (Apple Git-117)
> 

Reviewed-by: George-Aurelian Popescu <popegeo@amazon.com>

Looks ok,
George



Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

