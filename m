Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2335B669
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 10:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfGAILM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 04:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbfGAILM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 04:11:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5FD63082A28;
        Mon,  1 Jul 2019 08:11:11 +0000 (UTC)
Received: from gondolin (ovpn-117-220.ams2.redhat.com [10.36.117.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95F5F1001B29;
        Mon,  1 Jul 2019 08:11:05 +0000 (UTC)
Date:   Mon, 1 Jul 2019 10:11:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mdev: Send uevents around parent device registration
Message-ID: <20190701101101.3bd6ff6e.cohuck@redhat.com>
In-Reply-To: <156155924767.11505.11457229921502145577.stgit@gimli.home>
References: <156155924767.11505.11457229921502145577.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 01 Jul 2019 08:11:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019 08:27:58 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> This allows udev to trigger rules when a parent device is registered
> or unregistered from mdev.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/mdev/mdev_core.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
