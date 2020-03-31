Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7647819971F
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 15:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgCaNLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 09:11:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53772 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730916AbgCaNLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585660284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=usxsvV26fFHRpbo4EPS+A1tC2Knjsvias64PeyQykb4=;
        b=Q2LZ1lMuxLomIDTRFym2Ud148KlRBy6iwmv+ybZr8y6OD/zAhpZ1w639/05XkI1/qO6h/v
        TQwkSAgjA8jtnc838LpbOYPXTR1yZ80yb6eNRrPFiQSR5qpGCrG4Mhg/yTVd/r/FaNV0Mq
        QrKUAK12SEETkWpGStH2FHBnKyATLoU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-Frd-rvzGNZ2kqE6RNttg6g-1; Tue, 31 Mar 2020 09:11:23 -0400
X-MC-Unique: Frd-rvzGNZ2kqE6RNttg6g-1
Received: by mail-wm1-f69.google.com with SMTP id p18so1034323wmk.9
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 06:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=usxsvV26fFHRpbo4EPS+A1tC2Knjsvias64PeyQykb4=;
        b=iX9Fr3/sWEE0K/8+j+JHvPy8C/Il3oCOa1CmWjmKb+6nKrXTwWVBgPKUgGjBLokdHg
         /HMqX26l+PgtVdS4OvuMQ+c9pxGkJH992U/ZLKzNjxk2/Y37RjxF79U6G8uO9XDxBjCK
         hO0b8Y3SM2ubv4kJ6Np8jUclELroUBsRjLB9qV4amE7jGDhYHcnVWkIAsv1B8BOR/m41
         aSViO3V79EtM2vtpSUbZKf9PL0SD2DJ0mSNIvYgrRUqYcQns+WFm5dTlOgjSJZvIZxP4
         njW50bm4gFl2UIOSvcKd35kvph6YX/jt8VTgjdTCRShm/UFJ/sxltkrO/gTaB32ceKe7
         qtMA==
X-Gm-Message-State: ANhLgQ2POxZBIcJAPG5Fs/a/5/w0JHFJ+gpjf0nsHkWCA8sd0EmWzlPK
        TZSFmJnfiuR7TiIWLfkeCyca4f0oOZ95Or5lCxjah573ml2s/0uPT2ggc1Pz/4yvnB/Wf4IFPbA
        M4/68/T4DUUSg
X-Received: by 2002:a5d:490f:: with SMTP id x15mr19523933wrq.47.1585660278648;
        Tue, 31 Mar 2020 06:11:18 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vttjf+fvsMP8RlVLnva+uKSJYXT4yC5ZNHvDRMtCn+D/13PEya9eLPWLqUf0IcUzgcQvmLXLA==
X-Received: by 2002:a5d:490f:: with SMTP id x15mr19523917wrq.47.1585660278456;
        Tue, 31 Mar 2020 06:11:18 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id n2sm28031408wro.25.2020.03.31.06.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 06:11:12 -0700 (PDT)
Date:   Tue, 31 Mar 2020 09:11:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM <kvm@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: linux-next: Tree for Mar 30 (vhost)
Message-ID: <20200331085955-mutt-send-email-mst@kernel.org>
References: <20200330204307.669bbb4d@canb.auug.org.au>
 <347c851a-b9f6-0046-f6c8-1db0b42be213@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <347c851a-b9f6-0046-f6c8-1db0b42be213@infradead.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 10:22:22AM -0700, Randy Dunlap wrote:
> On 3/30/20 2:43 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > The merge window has opened, so please do not add any material for the
> > next release into your linux-next included trees/branches until after
> > the merge window closes.
> > 
> > Changes since 20200327:
> > 
> > The vhost tree gained a conflict against the kvm-arm tree.
> > 
> 
> (note: today's linux-next is on 5.6-rc7.)
> 
> on x86_64:
> 
> # CONFIG_EVENTFD is not set

Oh, this is Jason's Kconfig refactoring. Vhost must depend on eventfd
of course. I fixed the relevant commit up and pushed the new tree again.
Would appreciate a report on whether any problems are left.


> ../drivers/vhost/vhost.c: In function 'vhost_vring_ioctl':
> ../drivers/vhost/vhost.c:1577:33: error: implicit declaration of function 'eventfd_fget'; did you mean 'eventfd_signal'? [-Werror=implicit-function-declaration]
>    eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
>                                  ^~~~~~~~~~~~
>                                  eventfd_signal
> ../drivers/vhost/vhost.c:1577:31: warning: pointer/integer type mismatch in conditional expression
>    eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
>                                ^
> 
> -- 
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>

