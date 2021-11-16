Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A53452DE8
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 10:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhKPJ1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 04:27:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233181AbhKPJ0j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 04:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637054622;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=0vrLtCDJ9gL8MBQ1ewZJSg/di8vT6DQLqgyLkCbBUk4=;
        b=dVHzGTx5QCWIz5DdvrZtK0wqq8bEjUL0bp5GT9SPZXy1ynQYUoZ1nYplwvMMRCKtXcp/XD
        6BcQB4DgS+O7C64kHl5WzuereD3ZQtGFzgg4a68zaofySH7BRUrDVC8vAPbM2H5kokNBkN
        2P55t3IiOnibbl6P4SdeZ6p1AvaTuS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-IglynhnsPq-e_HjdlD3eGQ-1; Tue, 16 Nov 2021 04:23:39 -0500
X-MC-Unique: IglynhnsPq-e_HjdlD3eGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3DDACC623;
        Tue, 16 Nov 2021 09:23:37 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 551AD60843;
        Tue, 16 Nov 2021 09:23:31 +0000 (UTC)
Date:   Tue, 16 Nov 2021 09:23:28 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     qemu-devel@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 00/12] Add AMD Secure Nested Paging (SEV-SNP)
 support
Message-ID: <YZN4kBG4A/Sr1kIq@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 05:26:15PM -0500, Michael Roth wrote:
> These patches implement SEV-SNP along with CPUID enforcement support for QEMU,
> and are also available at:
> 
>   https://github.com/mdroth/qemu/commits/snp-rfc-v2-upstream
> 
> They are based on the initial RFC submitted by Brijesh:
> 
>   https://lore.kernel.org/qemu-devel/20210722000259.ykepl7t6ptua7im5@amd.com/T/

What's the status of these patches ?  Is there going to be any non-RFC
version posted in the near future ?

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

