Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 003DF1757D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 11:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfEHJxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 05:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfEHJxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 05:53:46 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2882305B886;
        Wed,  8 May 2019 09:53:46 +0000 (UTC)
Received: from gondolin (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 129525D9C8;
        Wed,  8 May 2019 09:53:44 +0000 (UTC)
Date:   Wed, 8 May 2019 11:53:41 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        alifm@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] New state handling for VFIO CCW
Message-ID: <20190508115341.2be6b108.cohuck@redhat.com>
In-Reply-To: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 08 May 2019 09:53:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  6 May 2019 15:11:08 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Hi,
> 
> I did not integrate all my patches for state handling like I had
> before but just two patches which seems interresting to me:
> 
> - The first one allows the device ti be used only when a guest
>   is currently using it.
>   Otherwise the device is in NOT_OPER state
>  
> - The second rework the sch_event callback: AFAIU we can not
>   consider that the event moves the device in IDLE state.
>   I think we better let it as it is currently.

I agree with the direction of this patch series.

> 
> Regards,
> Pierre
> 
> Pierre Morel (2):
>   vfio-ccw: Set subchannel state STANDBY on open
>   vfio-ccw: rework sch_event
> 
>  drivers/s390/cio/vfio_ccw_drv.c     | 21 ++-------------------
>  drivers/s390/cio/vfio_ccw_fsm.c     |  7 +------
>  drivers/s390/cio/vfio_ccw_ops.c     | 36 ++++++++++++++++++------------------
>  drivers/s390/cio/vfio_ccw_private.h |  1 -
>  4 files changed, 21 insertions(+), 44 deletions(-)
> 

