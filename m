Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6BC199729
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 15:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgCaNNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 09:13:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47444 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730882AbgCaNNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 09:13:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585660389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhuhyUwYopA1n84wfzfATkQxt+0y/RkX+3b+ZUlYd24=;
        b=W+drrOejeZaVtpW/+L29iOCR2m9vRERvgTyQT0kAnCW8zU+WsZhO4RUwW2IUfleMqDLGsH
        3c2aZ6DY/hl80HuZXo7c2u3kPdwoGbWWRhIJkx/BniQhz42ZjMsbvWuVvZ0xcKokrCIBiS
        8BW0WM5CYnHSoE6bWFYLdLnYC51YxeY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-5eFReZ7bP9mYG_yqt69frg-1; Tue, 31 Mar 2020 09:13:05 -0400
X-MC-Unique: 5eFReZ7bP9mYG_yqt69frg-1
Received: by mail-wm1-f69.google.com with SMTP id s9so1055666wmh.2
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 06:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vhuhyUwYopA1n84wfzfATkQxt+0y/RkX+3b+ZUlYd24=;
        b=OwU1BCLvaexGNpqkNefTCJYKL1pWsM7eq6H/w3HuOhFbZXiv9A0ZF9QW87cfWcbnsH
         7B1nOSkGk+c5B4VTTv7V0juEk7UVG7hXyfa2F0D0N0oVR/SQiWfHUOCgOlSYYHuTE9+q
         VTNOalgKOtVSCyt+exfgotQ7ZKaMSWb+h74RU+OD9c2N9gwBxPcss+QfUL180awz/quw
         U19Ck8qGyDTPNJKreAilfJHbr4w5CTCl4vKWQGPXyXkKFEdpOo58rA03KHtFo1ZQWDR3
         jgQpFD7G1s20aFinWKqixMZGhsb9sToSZbiqoPXzMBjGf17gpicQkjqs+emkJNeLEhkZ
         saeg==
X-Gm-Message-State: ANhLgQ1wC90rk//6CuOOkmB8goHi0B55K5o1jWz7ldut5yy4YUXMrKSp
        vy+v/cEnyLZHhUeRWDp4QaUHZBF/weiKZICJpZMkXOaJp1WpPKNH1ycVskp611am9g6Y8rCX8MC
        MEUTCY0Y4uutU
X-Received: by 2002:adf:f610:: with SMTP id t16mr20105983wrp.30.1585660384342;
        Tue, 31 Mar 2020 06:13:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuM4mf6PErLBYuIr557Jbfwdq0tffIdJD4BRvVV+5LWR2L1gVxuCah7k8R5X7pszotZ2Uw5HA==
X-Received: by 2002:adf:f610:: with SMTP id t16mr20105970wrp.30.1585660384168;
        Tue, 31 Mar 2020 06:13:04 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id j188sm3928906wmj.36.2020.03.31.06.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 06:13:03 -0700 (PDT)
Date:   Tue, 31 Mar 2020 09:13:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 30 (vhost)
Message-ID: <20200331091138-mutt-send-email-mst@kernel.org>
References: <20200330204307.669bbb4d@canb.auug.org.au>
 <347c851a-b9f6-0046-f6c8-1db0b42be213@infradead.org>
 <649927d4-9851-c369-2ad2-bf25527b057a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <649927d4-9851-c369-2ad2-bf25527b057a@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 10:27:48AM +0800, Jason Wang wrote:
> 
> On 2020/3/31 上午1:22, Randy Dunlap wrote:
> > On 3/30/20 2:43 AM, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > The merge window has opened, so please do not add any material for the
> > > next release into your linux-next included trees/branches until after
> > > the merge window closes.
> > > 
> > > Changes since 20200327:
> > > 
> > > The vhost tree gained a conflict against the kvm-arm tree.
> > > 
> > (note: today's linux-next is on 5.6-rc7.)
> > 
> > on x86_64:
> > 
> > # CONFIG_EVENTFD is not set
> > 
> > ../drivers/vhost/vhost.c: In function 'vhost_vring_ioctl':
> > ../drivers/vhost/vhost.c:1577:33: error: implicit declaration of function 'eventfd_fget'; did you mean 'eventfd_signal'? [-Werror=implicit-function-declaration]
> >     eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
> >                                   ^~~~~~~~~~~~
> >                                   eventfd_signal
> > ../drivers/vhost/vhost.c:1577:31: warning: pointer/integer type mismatch in conditional expression
> >     eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
> 
> 
> Will fix.
> 
> VHOST should depend on EVENTFD now.
> 
> Thanks


I did that and pushed. Pls take a look.

> 
> >                                 ^
> > 

