Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78355FD7E1
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 09:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbfKOI0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 03:26:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26265 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727004AbfKOI0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 03:26:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573806381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xt7ctRiywIG1tpU0cT26zCBUdn9q3E2Aseumqp8v+zU=;
        b=e9lHlgRWsugelA1gTvRfjNDi97koBCuKCS7h6udcuchMc2hT3n4TRgmeXI6p2JKgWUp1Y1
        k2lPeQzuOUfYTE9eFF+d0iflnZOljJKjQ6ninjUugw8o4Bi7lyGUnOb6Rzj4Ecme8uRCBI
        Gp4KmKKkqQ1sBV7wCuy4nNye4hvAxaQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-DL5e_iosOAGvFig7ijke7Q-1; Fri, 15 Nov 2019 03:26:20 -0500
Received: by mail-wr1-f72.google.com with SMTP id m17so7164185wrn.23
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 00:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RoXy81G7M/BfnHRZ4y2U2/JU3z4ekC5J7eZ1fYMw4CI=;
        b=f9DwotJJvGsUfBad1eULFhWkUXJ9MluPJHsEEEJYo055sS+eHdgWpAXnd+LUUsE+Qg
         3E7VZbfz0/bT/EqoG74tsr+N0kA8EuvJw+SE9nWn4Gg6IPDrF3th11o0SwhXIGyX1wFQ
         nEvwZX9Fv1OSzsFeoAX2MxaTn7WiUWOryBT+VqqKCDnUTmO9Eh/qnZqmS40qQUhhzAVU
         GWpv4cu6uD5yGWer84go3osmKM2To83yWJr5BWcDZXH5lKjMpmYvcQGyK2Hn+aFuXb92
         E4g1dnaizok9zK5su2d6pK734MhSYtm9NT1qHAM3i8UpKb6hTr6IZ2dXtNBGDdZ3tFn2
         HoUA==
X-Gm-Message-State: APjAAAVKPd++9rsCjlG67LKCR19aBlwoOKnK6NwI0qRB9xR1GVcYOX4J
        eqhv9zefBHxJL872D5pa7gFvDmDDKuxeF231X/HIlQv7Lri8DpuuxBISJqFEAGsb08wNg1GHZ1s
        KFP3hHVsiL93p
X-Received: by 2002:adf:f78c:: with SMTP id q12mr13056404wrp.71.1573806379269;
        Fri, 15 Nov 2019 00:26:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvFtcZcCmdybEhREmfVJhjMJWYu5vgKjT2yNfXmAdZcdboUyo4lpokec2THBO5n/9IFhwgFw==
X-Received: by 2002:adf:f78c:: with SMTP id q12mr13056369wrp.71.1573806378928;
        Fri, 15 Nov 2019 00:26:18 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id 19sm12549850wrc.47.2019.11.15.00.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 00:26:18 -0800 (PST)
Date:   Fri, 15 Nov 2019 09:26:15 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, arnd@arndb.de,
        jhansen@vmware.com, jasowang@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, haiyangz@microsoft.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        sashal@kernel.org, kys@microsoft.com, decui@microsoft.com,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/15] vsock: add multi-transports support
Message-ID: <20191115082615.uouzvisaz27xny4e@steredhat>
References: <20191114095750.59106-1-sgarzare@redhat.com>
 <20191114.181251.451070581625618487.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20191114.181251.451070581625618487.davem@davemloft.net>
X-MC-Unique: DL5e_iosOAGvFig7ijke7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 14, 2019 at 06:12:51PM -0800, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Thu, 14 Nov 2019 10:57:35 +0100
>=20
> > Most of the patches are reviewed by Dexuan, Stefan, and Jorgen.
> > The following patches need reviews:
> > - [11/15] vsock: add multi-transports support
> > - [12/15] vsock/vmci: register vmci_transport only when VMCI guest/host
> >           are active
> > - [15/15] vhost/vsock: refuse CID assigned to the guest->host transport
> >=20
> > RFC: https://patchwork.ozlabs.org/cover/1168442/
> > v1: https://patchwork.ozlabs.org/cover/1181986/
>=20
> I'm applying this as-is, if there is feedback changes required on 11,
> 12, and 15 please deal with this using follow-up patches.

Thank you very much,
Stefano

