Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC0F12044B
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 12:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfLPLpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 06:45:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41622 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727467AbfLPLpF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 06:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576496704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=iETY8N66g2LLsU/PeoO2pAL2WQc0jjnlz8UfQyJ5KCE=;
        b=afNH42cxNKISjDeIByqapFr141teq3+/sYZB+R5Jz7Qg/kA0S7vldI5rWEjikF5OFnv6X5
        TOXOmFc1mbb2FS8l9ixSmAz+habM47rO8ZWk/BjUHY978AvaC+tgIUkuWymz3UusdiQZHi
        wBj80oqGfj0/0zUM2tbM70SUr5Fzmt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-3Xj03FiANHav4g6yCAlIGA-1; Mon, 16 Dec 2019 06:45:02 -0500
X-MC-Unique: 3Xj03FiANHav4g6yCAlIGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A25E107ACC5;
        Mon, 16 Dec 2019 11:45:00 +0000 (UTC)
Received: from [10.40.205.109] (ovpn-205-109.brq.redhat.com [10.40.205.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C5ED5C1D6;
        Mon, 16 Dec 2019 11:44:41 +0000 (UTC)
Subject: Re: [PATCH v15 4/7] mm: Introduce Reported pages
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
 <20191205162238.19548.68238.stgit@localhost.localdomain>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <34abf700-bdb0-e01b-c7c2-3eab8d058c22@redhat.com>
Date:   Mon, 16 Dec 2019 06:44:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191205162238.19548.68238.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/5/19 11:22 AM, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> In order to pave the way for free page reporting in virtualized
> environments we will need a way to get pages out of the free lists and
> identify those pages after they have been returned. To accomplish this,=

> this patch adds the concept of a Reported Buddy, which is essentially
> meant to just be the Uptodate flag used in conjunction with the Buddy
> page type.
>
> To prevent the reported pages from leaking outside of the buddy lists I=

> added a check to clear the PageReported bit in the del_page_from_free_l=
ist
> function. As a result any reported page that is split, merged, or
> allocated will have the flag cleared prior to the PageBuddy value being=

> cleared.
>
> The process for reporting pages is fairly simple. Once we free a page t=
hat
> meets the minimum order for page reporting we will schedule a worker th=
read
> to start 2s or more in the future. That worker thread will begin workin=
g
> from the lowest supported page reporting order up to MAX_ORDER - 1 pull=
ing
> unreported pages from the free list and storing them in the scatterlist=
=2E
>
> When processing each individual free list it is necessary for the worke=
r
> thread to release the zone lock when it needs to stop and report the fu=
ll
> scatterlist of pages. To reduce the work of the next iteration the work=
er
> thread will rotate the free list so that the first unreported page in t=
he
> free list becomes the first entry in the list.

[...]

> k);
> +
> +	return err;
> +}
> +
> +static int
> +page_reporting_process_zone(struct page_reporting_dev_info *prdev,
> +			    struct scatterlist *sgl, struct zone *zone)
> +{
> +	unsigned int order, mt, leftover, offset =3D PAGE_REPORTING_CAPACITY;=

> +	unsigned long watermark;
> +	int err =3D 0;
> +
> +	/* Generate minimum watermark to be able to guarantee progress */
> +	watermark =3D low_wmark_pages(zone) +
> +		    (PAGE_REPORTING_CAPACITY << PAGE_REPORTING_MIN_ORDER);
> +
> +	/*
> +	 * Cancel request if insufficient free memory or if we failed
> +	 * to allocate page reporting statistics for the zone.
> +	 */
> +	if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
> +		return err;
> +


Will it not make more sense to check the low watermark condition before e=
very
reporting request generated for a bunch of 32 isolated pages?
or will that be too costly?

> +	/* Process each free list starting from lowest order/mt */
> +	for (order =3D PAGE_REPORTING_MIN_ORDER; order < MAX_ORDER; order++) =
{
> +		for (mt =3D 0; mt < MIGRATE_TYPES; mt++) {
> +			/* We do not pull pages from the isolate free list */
> +			if (is_migrate_isolate(mt))
> +				continue;
> +
> +			err =3D page_reporting_cycle(prdev, zone, order, mt,
> +						   sgl, &offset);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	/* report the leftover pages before going idle */
> +	leftover =3D PAGE_REPORTING_CAPACITY - offset;
> +	if (leftover) {
> +		sgl =3D &sgl[offset];
> +		err =3D prdev->report(prdev, sgl, leftover);
> +
> +		/* flush any remaining pages out from the last report */
> +		spin_lock_irq(&zone->lock);
> +		page_reporting_drain(prdev, sgl, leftover, !err);
> +		spin_unlock_irq(&zone->lock);
> +	}
> +
> +	return err;
> +}
--=20
Nitesh

