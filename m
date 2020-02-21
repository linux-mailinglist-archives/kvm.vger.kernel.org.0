Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5DC167EF0
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 14:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBUNpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 08:45:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43618 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727352AbgBUNpx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 08:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582292752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AFJZYeg1FH5EHgG8Ezli1QLqr8ew4/tiU+CB93jzcb4=;
        b=YBgNRGkNSyvlKwKDf8tXNhcinVp87ODIjj9Iu/bPZzpzE6huYpc5yso9c3ib1HlXevebj8
        tHr7V0Povhu00KFLDuiLEAeNu5qCiC7ojjp+8bkoORS1jl+a4LTe9I0dZKyNgqmvuLjuKb
        ca0hOte6w8RABED6ZpUl+jB9aDyOgMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-fdxAid2vMdy07mPZPcMPGg-1; Fri, 21 Feb 2020 08:45:48 -0500
X-MC-Unique: fdxAid2vMdy07mPZPcMPGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 659B2107ACC7;
        Fri, 21 Feb 2020 13:45:46 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E9761001281;
        Fri, 21 Feb 2020 13:45:40 +0000 (UTC)
Date:   Fri, 21 Feb 2020 14:45:38 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KVM <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3 00/37] KVM: s390: Add support for protected VMs
Message-ID: <20200221144538.032f4b0e.cohuck@redhat.com>
In-Reply-To: <1c54d830-79de-e3ee-4c11-d87f95f90c57@redhat.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
        <5556ee4a-09c6-117a-be99-4a5e136b78ea@redhat.com>
        <0665a90a-19f2-39a8-8a48-d180a622e9f2@de.ibm.com>
        <1c54d830-79de-e3ee-4c11-d87f95f90c57@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Feb 2020 12:28:51 +0100
David Hildenbrand <david@redhat.com> wrote:

> >> Can we get a new version once the other reviewers are done, so at least
> >> I can have a final look?  
> > 
> > Just the updated patches as reply (e.g. a 3.2 for patch 9) or the full monty?  
> 
> Whatever you others prefer. I can see that Conny has some feedback.
> maybe wait for that and then (selectively) resend.

I was still looking over this version. And to be honest, I find those
3.x patches utterly confusing, especially as this is all coming in so
quickly as to make it hard to keep up.

That said, I'll probably not be able to do much (or any) reviewing
today or on Monday, so feel free to send a new version next week.

