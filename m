Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23C617F4F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfEHRq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbfEHRq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:46:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0447B30821F4;
        Wed,  8 May 2019 17:46:56 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC05119729;
        Wed,  8 May 2019 17:46:55 +0000 (UTC)
Date:   Wed, 8 May 2019 11:46:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: add myself as reviewer
Message-ID: <20190508114655.79f40935@x1.home>
In-Reply-To: <20190508160632.20441-1-cohuck@redhat.com>
References: <20190508160632.20441-1-cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 08 May 2019 17:46:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  8 May 2019 18:06:32 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> I'm trying to look at vfio patches, and it's easier if
> I'm cc:ed.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 920a0a1545b7..9c0cd7a49309 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16454,6 +16454,7 @@ F:	fs/fat/
>  
>  VFIO DRIVER
>  M:	Alex Williamson <alex.williamson@redhat.com>
> +R:	Cornelia Huck <cohuck@redhat.com>
>  L:	kvm@vger.kernel.org
>  T:	git git://github.com/awilliam/linux-vfio.git
>  S:	Maintained

Thanks for volunteering Connie!  Applied to vfio next branch for v5.2.

Alex
