Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10A7260B51
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgIHGzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 02:55:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38768 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728479AbgIHGzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 02:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599548137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZJLwkK7lK8i/QhLFQOeO0BZqdoTLdZuycajPAvv67h8=;
        b=W6ntvBrX6manAD/ddopIS6GkzdiEU+uTgCNZNLpeLHkorai7pV3Lcg9HyuyEeJRq8z1owV
        NsjU0WY4HQisCkc+owfStKebgToIKW9Grvg7WvfK3YXuRCxckaA/qL4dDYGYjLp300VquJ
        /+9j7mIuUe8MD/E151DGVG6Vzd6dkx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-TwQ8Aw_uOUmrRmno2GWVaA-1; Tue, 08 Sep 2020 02:55:35 -0400
X-MC-Unique: TwQ8Aw_uOUmrRmno2GWVaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A4F7801AC2;
        Tue,  8 Sep 2020 06:55:32 +0000 (UTC)
Received: from gondolin (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93DDC838A6;
        Tue,  8 Sep 2020 06:55:25 +0000 (UTC)
Date:   Tue, 8 Sep 2020 08:55:21 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 0/2] s390: virtio: let arch validate VIRTIO features
Message-ID: <20200908085521.4db22680.cohuck@redhat.com>
In-Reply-To: <20200908003951.233e47f3.pasic@linux.ibm.com>
References: <1599471547-28631-1-git-send-email-pmorel@linux.ibm.com>
        <20200908003951.233e47f3.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Sep 2020 00:39:51 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon,  7 Sep 2020 11:39:05 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > Hi all,
> > 
> > The goal of the series is to give a chance to the architecture
> > to validate VIRTIO device features.  
> 
> Michael, is this going in via your tree?
> 

I believe Michael's tree is the right place for this, but I can also
queue it if I get an ack on patch 1.

