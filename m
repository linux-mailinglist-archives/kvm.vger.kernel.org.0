Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C285D5D3
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 20:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGBSCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 14:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGBSCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 14:02:18 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B10E687620;
        Tue,  2 Jul 2019 18:02:18 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 644741799F;
        Tue,  2 Jul 2019 18:02:18 +0000 (UTC)
Date:   Tue, 2 Jul 2019 12:02:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <kwankhede@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] sample/mdev/mbochs: remove set but not used
 variable 'mdev_state'
Message-ID: <20190702120217.51ca4dfa@x1.home>
In-Reply-To: <20190525135349.16488-1-yuehaibing@huawei.com>
References: <20190525135349.16488-1-yuehaibing@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 02 Jul 2019 18:02:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 25 May 2019 21:53:49 +0800
YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> samples/vfio-mdev/mbochs.c: In function mbochs_ioctl:
> samples/vfio-mdev/mbochs.c:1188:21: warning: variable mdev_state set but not used [-Wunused-but-set-variable]
> 
> It's not used any more since commit 104c7405a64d ("vfio:
> add edid support to mbochs sample driver")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  samples/vfio-mdev/mbochs.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index b038aa9f5a70..ac5c8c17b1ff 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1185,9 +1185,6 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  {
>  	int ret = 0;
>  	unsigned long minsz, outsz;
> -	struct mdev_state *mdev_state;
> -
> -	mdev_state = mdev_get_drvdata(mdev);
>  
>  	switch (cmd) {
>  	case VFIO_DEVICE_GET_INFO:

Applied to vfio next branch for 5.3.  Thanks!

Alex
