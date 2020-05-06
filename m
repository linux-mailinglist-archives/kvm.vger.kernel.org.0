Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221A1C6CD1
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgEFJZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:25:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45539 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728712AbgEFJZz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588757154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bim1c8eCjYcLbuTSswn0dpCBvXNi8zOQ0N1tlPafZn4=;
        b=a/WX2MvpVfdLwgMlWsGaXFmhPJcEm7GcakNQf4XqzojKV3Faq0mIzyu3iSox1aInkgs6G2
        3kXdS1nfFOMklUg4HOCBZHDgQMasoFz6YVizWYfuT7YcnmF96jDMbwGqbTZaYEkyJMCYHv
        uyows5NyV74pEW5pv34t7DNBcGNFeTI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-HslA_mUFPZyHeepQ4Iwnzw-1; Wed, 06 May 2020 05:25:51 -0400
X-MC-Unique: HslA_mUFPZyHeepQ4Iwnzw-1
Received: by mail-wr1-f72.google.com with SMTP id s11so1006303wru.6
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 02:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bim1c8eCjYcLbuTSswn0dpCBvXNi8zOQ0N1tlPafZn4=;
        b=dIlhd7kyRzb373ZTdzO6F5W9wUR8EHyV51n0slug3ECg03xv7GpEsZR2wCuviYuzpu
         C+AUW4JvQscUx0Zakt+W/V3pUA9/vPbboRxBVLFvHFyUCXgAtyds5Tw+TDIKVF3uAk6G
         O7OnamwbU0KCPbUgSjd4qDdRKLW013PDZ6QTd3Z6DvtFXvXa494x6qQYZZtcLqtFD4zM
         X7pDOzv8HGfY9rW+BrD9+1dVdpIvm/M5vcoz7nctpy2P2jF4W1KDbfuMZpWkkCBTss45
         jPGv/MBYei/3IG7pEM08KjeyEZ46IyhKyqEKZBhN5rBpPhF9pu2ZqjCMthJesRqaekjm
         mt5A==
X-Gm-Message-State: AGi0PuYLOEJGDxNU2DYkKuRjt5nXJTuBhf5hCf6/oZYIMjmTNOo3V/nz
        oE84iF+VdxuxcXuTfcWXTKnx49mqVrBgQp3NPayTcp3RHxFFVbb7IKiQClGnp3ZaAx6l4sw+tRV
        AuFqBaPTWPAgk
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7131683wrn.22.1588757149675;
        Wed, 06 May 2020 02:25:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypKDcQLCEb81yrXyKaZpg3LwlEaXE+I6k94/3G8d4AwC2GS8U1KX5Fn5b7fyFPoR8Cv9PqLECw==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7131657wrn.22.1588757149453;
        Wed, 06 May 2020 02:25:49 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id c25sm2030281wmb.44.2020.05.06.02.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:25:48 -0700 (PDT)
Date:   Wed, 6 May 2020 11:25:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Justin He <Justin.He@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldigby@redhat.com" <ldigby@redhat.com>,
        "n.b@live.com" <n.b@live.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] vhost: fixes
Message-ID: <20200506092546.o6prnn4d66tavmjl@steredhat>
References: <20200504081540-mutt-send-email-mst@kernel.org>
 <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
 <20200506031918-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506031918-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 03:19:55AM -0400, Michael S. Tsirkin wrote:
> On Wed, May 06, 2020 at 03:28:47AM +0000, Justin He wrote:
> > Hi Michael
> > 
> > > -----Original Message-----
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Monday, May 4, 2020 8:16 PM
> > > To: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> > > <Justin.He@arm.com>; ldigby@redhat.com; mst@redhat.com; n.b@live.com;
> > > stefanha@redhat.com
> > > Subject: [GIT PULL] vhost: fixes
> > >
> > > The following changes since commit
> > > 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> > >
> > >   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > >
> > > for you to fetch changes up to
> > > 0b841030625cde5f784dd62aec72d6a766faae70:
> > >
> > >   vhost: vsock: kick send_pkt worker once device is started (2020-05-02
> > > 10:28:21 -0400)
> > >
> > > ----------------------------------------------------------------
> > > virtio: fixes
> > >
> > > A couple of bug fixes.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > ----------------------------------------------------------------
> > > Jia He (1):
> > >       vhost: vsock: kick send_pkt worker once device is started
> > 
> > Should this fix also be CC-ed to stable? Sorry I forgot to cc it to stable.
> > 
> > --
> > Cheers,
> > Justin (Jia He)
> 
> 
> Go ahead, though recently just including Fixes seems to be enough.
> 

The following patch Justin refers to does not contain the "Fixes:" tag:

0b841030625c vhost: vsock: kick send_pkt worker once device is started


I think we should merge it on stable branches, so if needed, I can backport
and send it.

Stefano

