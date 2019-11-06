Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF22F0D7E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 05:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbfKFEAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 23:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbfKFEAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 23:00:24 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF06F2087E;
        Wed,  6 Nov 2019 04:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573012824;
        bh=EHB0u3MVxEhZWTCAi5ESkXM4zpATJfaJBa2YTknoRTg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ED+AyhOAGBVb9eR7kmanZ6wkAt4L+7d3LzYOhxHrTEdk65Q6f+V6vk5gZxfwJuoLL
         qbbGHBThIPKa5oqbpA8lBNoUPrjZ/vauXJeSdCFvF1FM6/NL8a7CqBQxXfMecOsBMp
         ciWGs8vlr8ZM46fm58Xbgd5Q2FC3L1aBBgaZEHWM=
Date:   Tue, 5 Nov 2019 20:00:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Subject: Re: [PATCH v13 3/6] mm: Introduce Reported pages
Message-Id: <20191105200022.ed3b5f803bef55377bcc5d30@linux-foundation.org>
In-Reply-To: <20191105220219.15144.69031.stgit@localhost.localdomain>
References: <20191105215940.15144.65968.stgit@localhost.localdomain>
        <20191105220219.15144.69031.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 05 Nov 2019 14:02:19 -0800 Alexander Duyck <alexander.duyck@gmail.com> wrote:

> In order to pave the way for free page reporting in virtualized
> environments we will need a way to get pages out of the free lists and
> identify those pages after they have been returned. To accomplish this,
> this patch adds the concept of a Reported Buddy, which is essentially
> meant to just be the Uptodate flag used in conjunction with the Buddy
> page type.

build fix

--- a/mm/page_reporting.h~mm-introduce-reported-pages-fix
+++ a/mm/page_reporting.h
@@ -158,7 +158,7 @@ free_area_reporting(struct zone *zone, u
 	return false;
 }
 static inline struct list_head *
-get_unreported_tail(struct zone *zone, unsigned int order, int migratetype)
+get_unreported_tail(unsigned int order, int migratetype)
 {
 	return NULL;
 }
_

