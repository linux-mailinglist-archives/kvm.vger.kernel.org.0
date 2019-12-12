Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DA411D8B4
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 22:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbfLLVnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 16:43:51 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:62980 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731086AbfLLVnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 16:43:51 -0500
Received: from 79.184.255.82.ipv4.supernova.orange.pl (79.184.255.82) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.320)
 id c3b75eb5d16eb454; Thu, 12 Dec 2019 22:43:48 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH RFC v4 01/13] ACPI: NUMA: export pxm_to_node
Date:   Thu, 12 Dec 2019 22:43:48 +0100
Message-ID: <5687328.t4MNS9KDDX@kreacher>
In-Reply-To: <20191212171137.13872-2-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com> <20191212171137.13872-2-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, December 12, 2019 6:11:25 PM CET David Hildenbrand wrote:
> Will be needed by virtio-mem to identify the node from a pxm.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/acpi/numa/srat.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
> index eadbf90e65d1..d5847fa7ac69 100644
> --- a/drivers/acpi/numa/srat.c
> +++ b/drivers/acpi/numa/srat.c
> @@ -35,6 +35,7 @@ int pxm_to_node(int pxm)
>  		return NUMA_NO_NODE;
>  	return pxm_to_node_map[pxm];
>  }
> +EXPORT_SYMBOL(pxm_to_node);
>  
>  int node_to_pxm(int node)
>  {
> 

This is fine by me FWIW.




