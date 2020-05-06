Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AFD1C6F4A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEFL0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:26:44 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56669 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727884AbgEFL0n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588764402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qweg3VFGzlx0RBZSC6t5XnxZUVTlXq/67adswM0vTp4=;
        b=O7TTdpzPbCOHCgMlsNA2Do9SI5dNKIjZNtrCNu/+DlMlr3Hmg5f6u+bm8So40YKUMFCNn0
        UGrwVNtZWplliU++chYAOgig1P7T9z9W980IkChgs9M3KGfvqFD91N//SOlaIsIO70IW2s
        o0KL7dg7oqmoLGhlfLqGVRtl7aGB8Ag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-cjJWEjQ3NAejmvflRK9sWw-1; Wed, 06 May 2020 07:26:40 -0400
X-MC-Unique: cjJWEjQ3NAejmvflRK9sWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC8D51899521;
        Wed,  6 May 2020 11:26:39 +0000 (UTC)
Received: from gondolin (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A346C60BEC;
        Wed,  6 May 2020 11:26:35 +0000 (UTC)
Date:   Wed, 6 May 2020 13:26:33 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, cjia@nvidia.com
Subject: Re: [PATCH v2] vfio-pci: Mask cap zero
Message-ID: <20200506132633.033cbc2c.cohuck@redhat.com>
In-Reply-To: <158871758778.17183.9778359960687348692.stgit@gimli.home>
References: <158871758778.17183.9778359960687348692.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 05 May 2020 16:27:01 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> The PCI Code and ID Assignment Specification changed capability ID 0
> from reserved to a NULL capability in the v1.1 revision.  The NULL
> capability is defined to include only the 16-bit capability header,
> ie. only the ID and next pointer.  Unfortunately vfio-pci creates a
> map of config space, where ID 0 is used to reserve the standard type
> 0 header.  Finding an actual capability with this ID therefore results
> in a bogus range marked in that map and conflicts with subsequent
> capabilities.  As this seems to be a dummy capability anyway and we
> already support dropping capabilities, let's hide this one rather than
> delving into the potentially subtle dependencies within our map.
> 
> Seen on an NVIDIA Tesla T4.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

