Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF8B66BA3
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 13:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfGLLaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 07:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbfGLLaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 07:30:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF4F030BC594;
        Fri, 12 Jul 2019 11:30:09 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF86C5D756;
        Fri, 12 Jul 2019 11:30:08 +0000 (UTC)
Date:   Fri, 12 Jul 2019 13:30:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] vfio-ccw: Update documentation for csch/hsch
Message-ID: <20190712133006.23efcd0d.cohuck@redhat.com>
In-Reply-To: <7d977612c3f3152ffb950d77ae11b4b25c1e20c4.1562854091.git.alifm@linux.ibm.com>
References: <cover.1562854091.git.alifm@linux.ibm.com>
        <7d977612c3f3152ffb950d77ae11b4b25c1e20c4.1562854091.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 12 Jul 2019 11:30:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 10:28:55 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> We now support CLEAR SUBCHANNEL and HALT SUBCHANNEL
> via ccw_cmd_region.
> 
> Fixes: d5afd5d135c8 ("vfio-ccw: add handling for async channel instructions")
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  Documentation/s390/vfio-ccw.rst | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)

(...)

> +vfio-ccw cmd region
> +-------------------
> +
> +The vfio-ccw cmd region is used to accept asynchronous instructions
> +from userspace.
> +

Add :: and indent the structure so that we get proper formatting?

(Sorry about not noticing this last time; but I can add it while
applying if there are no other comments.)

> +#define VFIO_CCW_ASYNC_CMD_HSCH (1 << 0)
> +#define VFIO_CCW_ASYNC_CMD_CSCH (1 << 1)
> +struct ccw_cmd_region {
> +       __u32 command;
> +       __u32 ret_code;
> +} __packed;
> +
> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
> +
> +Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
> +

Otherwise,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
