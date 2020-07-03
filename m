Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67481213A19
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 14:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGCMam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 08:30:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38717 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726022AbgGCMal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 08:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593779440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XbkyyV6G3+KFc4yA1s/WA0Us/LTQm895N3L0RzMOZco=;
        b=EhF0lvgv88nyn/Sn8qcfc+ha9xIGJWEJCVYQiDpMKMuBQN9xC57CcP1L91Qtb3iSSjve2z
        Q+wG8kHgwTV/olVV8RFE7LhIJSSUQbpkXTQk81i8jkKV2LFwyKXtNLp3uPAAzPTIKMelLT
        VrEKci0jr1HjVepy5Ms2LuOQCo25jtU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-Oea6z_7dMTSC67AXMu_MXg-1; Fri, 03 Jul 2020 08:30:38 -0400
X-MC-Unique: Oea6z_7dMTSC67AXMu_MXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0D301005510;
        Fri,  3 Jul 2020 12:30:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50A205FC2E;
        Fri,  3 Jul 2020 12:30:31 +0000 (UTC)
Date:   Fri, 3 Jul 2020 14:30:28 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 0/4] More lib/alloc cleanup and a minor
 improvement
Message-ID: <20200703123028.xmk3wff5dlysakv7@kamzik.brq.redhat.com>
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703115109.39139-1-imbrenda@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 03, 2020 at 01:51:05PM +0200, Claudio Imbrenda wrote:
> Some more cleanup of lib/alloc in light of upcoming changes
> 
> The first real feature: allow aligned virtual allocations with
> alignment greater than one page.
> 
> Also export a function for allocating aligned non-backed virtual pages.
> 
> Claudio Imbrenda (4):
>   lib/vmalloc: fix pages count local variable to be size_t
>   lib/alloc_page: change some parameter types
>   lib/alloc_page: move get_order and is_power_of_2 to a bitops.h
>   lib/vmalloc: allow vm_memalign with alignment > PAGE_SIZE
> 
>  lib/alloc_page.h |  7 +++----
>  lib/bitops.h     | 10 ++++++++++
>  lib/libcflat.h   |  5 -----
>  lib/vmalloc.h    |  3 +++
>  lib/alloc.c      |  1 +
>  lib/alloc_page.c | 13 ++++---------
>  lib/vmalloc.c    | 42 +++++++++++++++++++++++++++++++++---------
>  7 files changed, 54 insertions(+), 27 deletions(-)
> 
> -- 
> 2.26.2
>

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

