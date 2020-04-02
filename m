Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB36019C70A
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389819AbgDBQ1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 12:27:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54037 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731892AbgDBQ1U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 12:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585844839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YiGejvc/Z1PscIO5Y2Td9wzrTW6YFSsKAEAcda9xkVg=;
        b=WGMhaXVKFwi04/dx6sLUHCE2DekZ2R+rAlwb+ZGdQbmGF0V+hTcXHfcmpp9pHeJpJ0T72p
        Ev0GEJLx1ZXgyztm2Ry8Fm2Z2vM0dNe1irjIey3XqCnrIFYaDJbWWfS2jKIRLtAKhCDnG2
        SBhA6j/DBapLsIvsVSz1HlXWS5BolM8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-kMukF2YINiaNzh8Ikuk4AQ-1; Thu, 02 Apr 2020 12:27:15 -0400
X-MC-Unique: kMukF2YINiaNzh8Ikuk4AQ-1
Received: by mail-qv1-f69.google.com with SMTP id z2so3174697qvw.7
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 09:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YiGejvc/Z1PscIO5Y2Td9wzrTW6YFSsKAEAcda9xkVg=;
        b=KckIjxuk1/5B+sDVuwCbYl28DVGtoDzcrWNQdeDqjtQxTyba0oW1fLNvwL0JB7AGTR
         9Y1DmO6Cp+HMIwevwWnH92+ZlQUXiF0uzybmvuBHcHc7dYvuf4rVIGD6nVlVuX7CESME
         NvwHiKOIIlzS+PwOjePSz2KifJMCedJSdOQpIjt4mrhfw0mPN++/hrKfS6umZ2Uvb3UM
         Yyzb9rKFqArC7YncSb7L5gOis9kPAcWKK0fpSphBTCp1uLHFIvpOBvWGvGEcMckGTvDu
         q7l6tu6nXGnrOb7zaMQ3ZUHTloFG+5OXHkKuLcJuQgAEXWb5ecjB6U0y9dWXsx0jrdCQ
         x1ZA==
X-Gm-Message-State: AGi0PuYn5Te+M7tIufpIQviXGhOFvTjiaRaIBY70s/IlRwd6L6ThXpgk
        +H/+Cs9G/Y2dOlMWeytSJBwsojUP5jCMXwP7dAZTE1vm1euNCIpZ5VBRfgB6xNoQnp32wiFGK0E
        iLbgwBjTfbE0F
X-Received: by 2002:ac8:4641:: with SMTP id f1mr3595342qto.216.1585844834567;
        Thu, 02 Apr 2020 09:27:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypI9uiNgZebAWGTM/6pTKMcpl2+Pbh6hcnrsxur+SijZm8gBzgmehd7nG3POHrAdyCwNw6XVFw==
X-Received: by 2002:ac8:4641:: with SMTP id f1mr3595317qto.216.1585844834186;
        Thu, 02 Apr 2020 09:27:14 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id v17sm3764796qkf.83.2020.04.02.09.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 09:27:13 -0700 (PDT)
Date:   Thu, 2 Apr 2020 12:27:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: drop vring dependency on iotlb
Message-ID: <20200402122544-mutt-send-email-mst@kernel.org>
References: <20200402144519.34194-1-mst@redhat.com>
 <44f9b9d3-3da2-fafe-aa45-edd574dc6484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44f9b9d3-3da2-fafe-aa45-edd574dc6484@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 11:01:13PM +0800, Jason Wang wrote:
> 
> On 2020/4/2 下午10:46, Michael S. Tsirkin wrote:
> > vringh can now be built without IOTLB.
> > Select IOTLB directly where it's used.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Applies on top of my vhost tree.
> > Changes from v1:
> > 	VDPA_SIM needs VHOST_IOTLB
> 
> 
> It looks to me the patch is identical to v1.
> 
> Thanks


you are right. I squashed the description into
    virtio/test: fix up after IOTLB changes
take a look at it in the vhost tree.

> 
> > 
> >   drivers/vdpa/Kconfig  | 1 +
> >   drivers/vhost/Kconfig | 1 -
> >   2 files changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> > index 7db1460104b7..08b615f2da39 100644
> > --- a/drivers/vdpa/Kconfig
> > +++ b/drivers/vdpa/Kconfig
> > @@ -17,6 +17,7 @@ config VDPA_SIM
> >   	depends on RUNTIME_TESTING_MENU
> >   	select VDPA
> >   	select VHOST_RING
> > +	select VHOST_IOTLB
> >   	default n
> >   	help
> >   	  vDPA networking device simulator which loop TX traffic back
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index f0404ce255d1..cb6b17323eb2 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -8,7 +8,6 @@ config VHOST_IOTLB
> >   config VHOST_RING
> >   	tristate
> > -	select VHOST_IOTLB
> >   	help
> >   	  This option is selected by any driver which needs to access
> >   	  the host side of a virtio ring.

