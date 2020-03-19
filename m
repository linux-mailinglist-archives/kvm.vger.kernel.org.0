Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F6A18BEA7
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgCSRrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:47:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:44667 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727253AbgCSRrH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 13:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584640026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aA76ES7e43xggaYU1fSodrMujaNKIwSE//1w1Lnn+qQ=;
        b=aXvs6D1S6Nn91J8ZS2dTipJ/2sQXY0u/wosYRX/KdbWtfp1q9GWZJDnrqt8gRUjvKtE2EQ
        7Z1BdDbh9QjNvewwDIyf1rlw3RdD8Z6IIWtenO796lVWAyMYRPkwR6+GUmlzGVdgHnRNpj
        xiHTJBdLVSMIhIxiSWC+mzsGBuucoFQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-YbKSdRvnMb-H-gKH__LWFQ-1; Thu, 19 Mar 2020 13:47:02 -0400
X-MC-Unique: YbKSdRvnMb-H-gKH__LWFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D88AF85EE74;
        Thu, 19 Mar 2020 17:47:00 +0000 (UTC)
Received: from gondolin (ovpn-113-188.ams2.redhat.com [10.36.113.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71F6B1001B28;
        Thu, 19 Mar 2020 17:46:55 +0000 (UTC)
Date:   Thu, 19 Mar 2020 18:46:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, kevin.tian@intel.com
Subject: Re: [PATCH v3 7/7] vfio/pci: Cleanup .probe() exit paths
Message-ID: <20200319184653.6c10638b.cohuck@redhat.com>
In-Reply-To: <158396396706.5601.17691989521568973524.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
        <158396396706.5601.17691989521568973524.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Mar 2020 15:59:27 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> The cleanup is getting a tad long.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c |   54 ++++++++++++++++++++-----------------------
>  1 file changed, 25 insertions(+), 29 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

