Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70A43F90A2
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243729AbhHZWVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:21:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhHZWVj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 18:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630016449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x25KwSHDDRRQqsVl47v2hM4HtFlmU81V8CETU4p2thE=;
        b=EHuhHm9FhspaBmg5M3C4AtuApnXI77voegEu6oXHEv4nimTUDddSc3biQrO/OqnQxtps86
        SjKr4z9k9QFTIrLgDWdXjLc9HEVXI9y9wO83Kg2C66Nmj9yQ1TJ5uVTgwlohXfhM8dhoqV
        03BUyh0DTGX2v/XSH9qZY0pePRX4EaU=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-eNIUkKOmOpK2VUTNAQx7iQ-1; Thu, 26 Aug 2021 18:20:45 -0400
X-MC-Unique: eNIUkKOmOpK2VUTNAQx7iQ-1
Received: by mail-ot1-f72.google.com with SMTP id n4-20020a9d64c40000b02904f40ca6ab63so1827219otl.14
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 15:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x25KwSHDDRRQqsVl47v2hM4HtFlmU81V8CETU4p2thE=;
        b=KIEMa1xnukEZaluh6zjzFzgJPZ1tstF0XGyppGpjQeUnDc08hUE7HEbrXzpArl/uwh
         v+jERN3BVY8s/ZVjYlAikcQffQbH1yDswWPg4l9ccJdm6D/tHJs3s/nRNAk0k1t/NJoB
         OHNUlxbMQFC/B6LgzZStfAA8I2Lui0c+YSsmiPe+Xcf9bBzMyTBPMYkfUUGx2fCZB0PT
         DmTvZa09r1yw0UI5dtEhThqUIF/GhPx1sxYeNUJl5R+bbTEJ1VEXIH7ii/sh78qbw6Df
         X80j1624ppWD4BFlLF2/rlFxluq5XtgKzF8aQO2vnCRN3ZlfJiBRYuXqo9LvAO6jxCkg
         uy0w==
X-Gm-Message-State: AOAM531UNoa8b42HS9rUe9jvCd1O5aWLKgqHgRW8kw/KpN0pQB71b9t1
        iDEzEIIAMZwSFWcbiUzQZz/Wt0EOg9zvUXaNxhZxpG7LF3E0oEe6zBcJQpZvpsxCwAEhrXGorlL
        AN8hwDrG7LDt3
X-Received: by 2002:a05:6808:690:: with SMTP id k16mr4230638oig.152.1630016443732;
        Thu, 26 Aug 2021 15:20:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/CPQBQzGnGZAoVpvwmMUzj3NaTUTuMHtLgclxQkuDqcr22UYsvkTUXA4wlQ852jrUyT+LFA==
X-Received: by 2002:a05:6808:690:: with SMTP id k16mr4230624oig.152.1630016443525;
        Thu, 26 Aug 2021 15:20:43 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id z18sm938199oib.27.2021.08.26.15.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 15:20:43 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:20:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     <mjrosato@linux.ibm.com>, <farman@linux.ibm.com>,
        <cohuck@redhat.com>, <linux-s390@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] vfio-pci/zdev: Remove repeated verbose license text
Message-ID: <20210826162042.095f085e.alex.williamson@redhat.com>
In-Reply-To: <20210824003749.1039-1-caihuoqing@baidu.com>
References: <20210824003749.1039-1-caihuoqing@baidu.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Aug 2021 08:37:49 +0800
Cai Huoqing <caihuoqing@baidu.com> wrote:

> remove it because SPDX-License-Identifier is already used
> and change "GPL-2.0+" to "GPL-2.0-only"
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
> v1->v2: change "GPL-2.0+" to "GPL-2.0-only"
> 
>  drivers/vfio/pci/vfio_pci_zdev.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Applied to vfio next branch for v5.15 with Matthew's review and agreed
commit log wording.  Thanks,

Alex

