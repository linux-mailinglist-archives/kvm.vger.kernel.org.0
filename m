Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C14E26C13E
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgIPJ6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 05:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgIPJ6a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 05:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600250309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BVtI/7NnTkyObREoyozupiV/GFHRXfocWPLEIFpC08=;
        b=eL6WqkJ76K2PgPcKek0fidMsoqi5xPF2YmmjJnUze701uBfzqVcCdzP4nN7e2mFsfO2WX6
        rvgt/+7EejxxOJL74X5o4XZ2PZFQna0idBQ6RGeEH5B5s6RpyzGCv2+bR3HSnk2oEh0P7A
        k8QC4QAhjkPXRe9CY+wJYTI3CAGdQBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-B_gYUNrgP6qGsJNA8ZGU3Q-1; Wed, 16 Sep 2020 05:58:27 -0400
X-MC-Unique: B_gYUNrgP6qGsJNA8ZGU3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 228D28015A4;
        Wed, 16 Sep 2020 09:58:26 +0000 (UTC)
Received: from gondolin (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCC5870105;
        Wed, 16 Sep 2020 09:58:14 +0000 (UTC)
Date:   Wed, 16 Sep 2020 11:58:12 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, rth@twiddle.net, david@redhat.com,
        thuth@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/5] vfio: Create shared routine for scanning info
 capabilities
Message-ID: <20200916115812.6a61f756.cohuck@redhat.com>
In-Reply-To: <1600197283-25274-3-git-send-email-mjrosato@linux.ibm.com>
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
        <1600197283-25274-3-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 15:14:40 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Rather than duplicating the same loop in multiple locations,
> create a static function to do the work.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/vfio/common.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

