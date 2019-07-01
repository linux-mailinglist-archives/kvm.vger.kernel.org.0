Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D825BF04
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 17:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbfGAPHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 11:07:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727568AbfGAPHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 11:07:03 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FD8F3001C3D;
        Mon,  1 Jul 2019 15:07:03 +0000 (UTC)
Received: from gondolin (ovpn-117-220.ams2.redhat.com [10.36.117.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 181226085B;
        Mon,  1 Jul 2019 15:06:59 +0000 (UTC)
Date:   Mon, 1 Jul 2019 17:06:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mdev: Send uevents around parent device registration
Message-ID: <20190701170656.6ac05101.cohuck@redhat.com>
In-Reply-To: <156199271955.1646.13321360197612813634.stgit@gimli.home>
References: <156199271955.1646.13321360197612813634.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 01 Jul 2019 15:07:03 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 01 Jul 2019 08:54:44 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> This allows udev to trigger rules when a parent device is registered
> or unregistered from mdev.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> v2: Don't remove the dev_info(), Kirti requested they stay and
>     removing them is only tangential to the goal of this change.
> 
>  drivers/vfio/mdev/mdev_core.c |    8 ++++++++
>  1 file changed, 8 insertions(+)

Not that fond of the dev_info(), but this still looks sane.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
