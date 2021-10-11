Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA1C429961
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 00:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhJKWVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 18:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235457AbhJKWVY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 18:21:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633990763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aeXcIsOyNcWtQCi9/bt2+iuYkngLdU5FSyhdmH84bAc=;
        b=ZwewXx7O2Z9uvl4BA/C7r9KNDIFCSpgMsY0UPJPa9t/+dyXdnmwXyMMRlJekfQYakkFSO3
        pj/chPxBq1BlUGz3f/yoCJiJ7IuHFNBvCkiX4Jxb5vHeu7lhZJ8N/8I5d8mPCKkoSOvPoU
        aZPMAkT7TlJoMt+E/1nGeEqP2EuZ5zc=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-10xxH490N-6Ir7RNFX3MdA-1; Mon, 11 Oct 2021 18:19:22 -0400
X-MC-Unique: 10xxH490N-6Ir7RNFX3MdA-1
Received: by mail-ot1-f71.google.com with SMTP id l17-20020a9d7351000000b0054e7cd8a64dso2732549otk.4
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 15:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeXcIsOyNcWtQCi9/bt2+iuYkngLdU5FSyhdmH84bAc=;
        b=X0QTPgN4o+viKqJNr/hVSjEykhlvJBwVZqJ70UJjh9dbOtx/7Z9xa+zPWihuqs3sxH
         qxN4hUZ1pvJyMvj8TEuFeXeJKFaf7tp/amFJR6Trca2x1fnh2ITN74OTTxqh7RrtdnCC
         BXm3Dkg4zLea+OO2locLXYB5GV11RlnSH5uqNIp4wO0U/d9/v+CjCNAFwDyVG9vJcelI
         VvqK8X4OFipbLjmqkYeQvhfTaqhP1Wpx4WapXgTEJVBxJpCXSwHEZyGGsj1voysfPnXy
         1EhjJJTJUi810spfJJ6qnFnZMKW3RCAWO/lCutyBmV9dK85a9AyrpK9ar9yoBLBh1wiV
         avfQ==
X-Gm-Message-State: AOAM5325USRNZVSh6MebDQlOsB+kbhmBtFdLd8GoSyhVg4hW+j1y5CNa
        d0xkynFZglv01OupQwmawluVkXVFj/+BZdQzYDouSd/9SYyz/OtsbOVIX2P/2j895dXvuhC9row
        eJhnBvq9yu8yR
X-Received: by 2002:aca:b10b:: with SMTP id a11mr1156556oif.177.1633990760636;
        Mon, 11 Oct 2021 15:19:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBgW1M4fQn8z4GIqtMKYD0bAdAahgMyBSniuW90BuiIK088EO9nAEjLcW3ZN8rRzTgzgejrg==
X-Received: by 2002:aca:b10b:: with SMTP id a11mr1156481oif.177.1633990758983;
        Mon, 11 Oct 2021 15:19:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i15sm1981679otu.67.2021.10.11.15.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 15:19:18 -0700 (PDT)
Date:   Mon, 11 Oct 2021 16:19:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kvm@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] vfio/fsl-mc: Add per device reset support
Message-ID: <20211011161916.6a3aace0.alex.williamson@redhat.com>
In-Reply-To: <e356b582-7911-6c8e-3201-dbfdbd3e3b1d@nxp.com>
References: <20210922110530.24736-1-diana.craciun@oss.nxp.com>
        <20210922110530.24736-2-diana.craciun@oss.nxp.com>
        <e356b582-7911-6c8e-3201-dbfdbd3e3b1d@nxp.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Sep 2021 16:55:06 +0300
Laurentiu Tudor <laurentiu.tudor@nxp.com> wrote:

> On 9/22/2021 2:05 PM, Diana Craciun wrote:
> > Currently when a fsl-mc device is reset, the entire DPRC container
> > is reset which is very inefficient because the devices within a
> > container will be reset multiple times.
> > Add support for individually resetting a device.
> > 
> > Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> > ---  
> 
> Reviewed-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Applied both to vfio next branch for v5.16, with Laurentiu's R-b added
here.  Thanks,

Alex

