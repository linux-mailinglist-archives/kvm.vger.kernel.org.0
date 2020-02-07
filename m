Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EA91553EF
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 09:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgBGIsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 03:48:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726958AbgBGIsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 03:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581065292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cJ1SfKxvE9crgTE3OrX7M8hasjRet+oX1Q810pUeSAA=;
        b=ORmO1oVDpaZ1u6mpMkoAueOYo5lqfbtfZChPYZbz1E2WmeC1Ob68y+LOcK1vki4F9vFYRn
        DV4qIj+oFMRrGj3nmPp5lu8a3rKnUHZ4wfVsbWTTM8jVcX8+2kY4eSc+bN7fhAnN0cjXYy
        bU+nMXWLG7IgVmaZSOwSovl3vBra/TI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-1z69S-cjNPOwon6_YYUBUw-1; Fri, 07 Feb 2020 03:48:09 -0500
X-MC-Unique: 1z69S-cjNPOwon6_YYUBUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24CDE800E21;
        Fri,  7 Feb 2020 08:48:08 +0000 (UTC)
Received: from gondolin (ovpn-117-112.ams2.redhat.com [10.36.117.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 565FB77931;
        Fri,  7 Feb 2020 08:48:06 +0000 (UTC)
Date:   Fri, 7 Feb 2020 09:48:03 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 21/27] docs: kvm: Convert locking.txt to ReST format
Message-ID: <20200207094803.152f0c9b.cohuck@redhat.com>
In-Reply-To: <20200207072409.2cb038da@infradead.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <1464d69fe780940cec6ecec4ac2505b9701a1e01.1581000481.git.mchehab+huawei@kernel.org>
        <20200206171132.4f51f17a.cohuck@redhat.com>
        <a17d6a27-0d3f-2020-7fc2-87ec20a6225f@redhat.com>
        <20200206234736.196ef417@kernel.org>
        <20200207072409.2cb038da@infradead.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Feb 2020 07:24:09 +0100
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> >   
> > > 
> > > Would be nicer but this is acceptable too I think.  Especially, the
> > > monospaced font allows breaking the table and keeping the parts aligned.    
> 
> I couldn't resist trying to use a table ;-)
> 
> The following patch does that. IMO, it looks nice on both text and html
> outputs.

Now that I see this, I think this version is actually more readable
than the existing text.

> 
> Cheers,
> Mauro
> 
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 428cb3412ecc..c02291beac3f 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -59,30 +59,39 @@ The mapping from gfn to pfn may be changed since we can only ensure the pfn
>  is not changed during cmpxchg. This is a ABA problem, for example, below case
>  will happen:
>  
> -At the beginning::
> -
> -	gpte = gfn1
> -	gfn1 is mapped to pfn1 on host
> -	spte is the shadow page table entry corresponding with gpte and
> -	spte = pfn1
> -
> -	   VCPU 0                           VCPU0
> -
> -on fast page fault path::
> -
> -   old_spte = *spte;
> -                                 pfn1 is swapped out:
> -                                    spte = 0;
> -
> -                                 pfn1 is re-alloced for gfn2.
> -
> -                                 gpte is changed to point to
> -                                 gfn2 by the guest:
> -                                    spte = pfn1;
> -
> -   if (cmpxchg(spte, old_spte, old_spte+W)
> -	mark_page_dirty(vcpu->kvm, gfn1)
> -             OOPS!!!
> ++------------------------------------------------------------------------+
> +| At the beginning::                                                     |
> +|                                                                        |
> +|	gpte = gfn1                                                      |
> +|	gfn1 is mapped to pfn1 on host                                   |
> +|	spte is the shadow page table entry corresponding with gpte and  |
> +|	spte = pfn1                                                      |
> ++------------------------------------------------------------------------+
> +| On fast page fault path:                                               |
> ++------------------------------------+-----------------------------------+
> +| CPU 0:                             | CPU 1:                            |
> ++------------------------------------+-----------------------------------+
> +| ::                                 |                                   |

The '::' directives look a bit like leftover christmas decorations,
but it's not really distracting, and on the plus side, we'll get nice
html formatting.

> +|                                    |                                   |
> +|   old_spte = *spte;                |                                   |
> ++------------------------------------+-----------------------------------+
> +|                                    | pfn1 is swapped out::             |
> +|                                    |                                   |
> +|                                    |    spte = 0;                      |
> +|                                    |                                   |
> +|                                    | pfn1 is re-alloced for gfn2.      |
> +|                                    |                                   |
> +|                                    | gpte is changed to point to       |
> +|                                    | gfn2 by the guest::               |
> +|                                    |                                   |
> +|                                    |    spte = pfn1;                   |
> ++------------------------------------+-----------------------------------+
> +| ::                                                                     |
> +|                                                                        |
> +|   if (cmpxchg(spte, old_spte, old_spte+W)                              |
> +|	mark_page_dirty(vcpu->kvm, gfn1)                                 |
> +|            OOPS!!!                                                     |
> ++------------------------------------------------------------------------+
>  
>  We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
>  

So I'd like to cast my vote for this version :)

