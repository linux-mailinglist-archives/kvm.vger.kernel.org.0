Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0907182D96
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbfHFIQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:16:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbfHFIQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:16:04 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 09F9C2D6A3D;
        Tue,  6 Aug 2019 08:16:04 +0000 (UTC)
Received: from gondolin (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 583BC10016E8;
        Tue,  6 Aug 2019 08:15:58 +0000 (UTC)
Date:   Tue, 6 Aug 2019 10:15:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, wankhede@nvidia.com,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        cjia@nvidia.com
Subject: Re: [PATCH 1/2] vfio-mdev/mtty: Simplify interrupt generation
Message-ID: <20190806101556.3ca75900.cohuck@redhat.com>
In-Reply-To: <20190802065905.45239-2-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190802065905.45239-2-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 06 Aug 2019 08:16:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Aug 2019 01:59:04 -0500
Parav Pandit <parav@mellanox.com> wrote:

> While generating interrupt, mdev_state is already available for which
> interrupt is generated.
> Instead of doing indirect way from state->device->uuid-> to searching
> state linearly in linked list on every interrupt generation,
> directly use the available state.
> 
> Hence, simplify the code to use mdev_state and remove unused helper
> function with that.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  samples/vfio-mdev/mtty.c | 39 ++++++++-------------------------------
>  1 file changed, 8 insertions(+), 31 deletions(-)

This is sample code, so no high impact; but it makes sense to set a
good example.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
