Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D871F7EE1A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390503AbfHBHzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:55:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41998 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfHBHzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:55:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id x1so26248453wrr.9
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 00:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iQeecZfwLuP7CODOolIpmoLPGZENj4z5U1obZlPPBsE=;
        b=MF85XEn8emLFXgtrS4YIDBK3QuwsihRiQYb+LtNQSitOiWnMpuS20TNmTQu7jc9Fex
         y9C+SZCD/camEmhcuXuWKCxGNGyIIQmhWyJ2FXbTp4RSk4Hp5BWO4nm2ozad5VQxjLVn
         fmZNdGD2CLXIyTQOM+32kqAegRzh+XeeC2ZvwkqpcxeL7vQiE+JHuzEhZ5IpeumbTLZC
         iLgCdw/bhSMZviCE63AUFeIsGnNwjoo74kAsXOdt3OnKIq1ijcPMX5tOaa4fUFAnvcLn
         4yQna3QGvNJnEnoQdMmnS6LL2XqiceYJQ+VLIQDCpGocDUNqBiR+tVGk+clykf4pVTdG
         3/4Q==
X-Gm-Message-State: APjAAAVGv+bdu4M8qlz6PlF/ufPQ4+ljqTWfmZLJ5ARfZnG4E7wjxRI7
        P3WSN30QNzqECF7qtIxHeqP0ow==
X-Google-Smtp-Source: APXvYqxJYMba81q1+ZjYpm8CUmRIMpGHEf3SB8tgLMove58CtJewiAKhbgEp6Gf/LDnWAQBR7N5n+w==
X-Received: by 2002:a05:6000:42:: with SMTP id k2mr23783548wrx.80.1564732511147;
        Fri, 02 Aug 2019 00:55:11 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id j9sm83739926wrn.81.2019.08.02.00.55.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 00:55:10 -0700 (PDT)
Date:   Fri, 2 Aug 2019 09:55:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/11] VSOCK: add vsock_test test suite
Message-ID: <20190802075508.tumpam2vfmynuhd5@steredhat>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <PU1P153MB0169B265ECA51CB0AE1212DEBFDE0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169B265ECA51CB0AE1212DEBFDE0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 04:16:37PM +0000, Dexuan Cui wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > Sent: Thursday, August 1, 2019 8:26 AM
> > 
> > The vsock_diag.ko module already has a test suite but the core AF_VSOCK
> > functionality has no tests.  This patch series adds several test cases that
> > exercise AF_VSOCK SOCK_STREAM socket semantics (send/recv,
> > connect/accept,
> > half-closed connections, simultaneous connections).
> > 
> > Dexuan: Do you think can be useful to test HyperV?
> 
> Hi Stefano,
> Thanks! This should be useful, though I have to write the Windows host side
> code to use the test program(s). :-)
> 

Oh, yeah, I thought so :-)

Let me know when you'll try to find out if there's a problem.

Thanks,
Stefano
