Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092182C8824
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 16:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgK3PgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 10:36:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727521AbgK3PgQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 10:36:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606750490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ekTEnzj+QPMF2L41+Oi7EL2a0qpEfLvgxnNu0apYUMY=;
        b=Or0pez3hu0k9jqLcCZKDocdWJZgZNEmtywZXT4LBuzTOLdbeqeijyWF+5KF0b/r2dmBmct
        oZQhH7QbP8HRi9J1hwjmziIerGJWxCeIgSzLRo7L7KJLrX4VobnuqxvUS/L9qJ5F2aRfyD
        rzlhVUDOR8Tn5RouPnqMs1Ypyn7pGXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-6_bFztZQNfe2O2gkQtqjNQ-1; Mon, 30 Nov 2020 10:34:48 -0500
X-MC-Unique: 6_bFztZQNfe2O2gkQtqjNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C08081084D7E;
        Mon, 30 Nov 2020 15:34:34 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B8DA5D9C0;
        Mon, 30 Nov 2020 15:34:34 +0000 (UTC)
Date:   Mon, 30 Nov 2020 08:34:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201130083433.3b80ef13@w520.home>
In-Reply-To: <f7de6a25-8ace-3d51-d954-149752f9cf26@amd.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
        <20201105233949.GA138364@xz-x1>
        <20201116155341.GL917484@nvidia.com>
        <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
        <20201116232033.GR917484@nvidia.com>
        <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
        <20201117155757.GA13873@xz-x1>
        <57f51f08-1dec-e3d6-b636-71c8a00142fb@amd.com>
        <20201117181754.GC13873@xz-x1>
        <20201126201339.GA552508@nvidia.com>
        <f7de6a25-8ace-3d51-d954-149752f9cf26@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Nov 2020 08:34:51 -0600
Tom Lendacky <thomas.lendacky@amd.com> wrote:

> On 11/26/20 2:13 PM, Jason Gunthorpe wrote:
> > On Tue, Nov 17, 2020 at 01:17:54PM -0500, Peter Xu wrote:
> >    
> >> Logically this patch should fix that, just like the dpdk scenario where mmio
> >> regions were accessed from userspace (qemu).  From that pov, I think this patch
> >> should help.
> >>
> >> Acked-by: Peter Xu <peterx@redhat.com>  
> > 
> > Thanks Peter
> > 
> > Is there more to do here?  
> 
> I just did a quick, limited passthrough test of a NIC device (non SRIOV)
> for a legacy and an SEV guest and it all appears to work.
> 
> I don't have anything more (i.e. SRIOV, GPUs, etc.) with which to test
> device passthrough.

Thanks, I'll include this for v5.11.

Alex

