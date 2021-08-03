Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8DC3DF4EA
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 20:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbhHCSp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 14:45:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237949AbhHCSpZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 14:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628016313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23GDkNLhLe5EW0NBURzRb+WIAuJSlfKe4etutEbvPx8=;
        b=CLr6bTFQdaKdZeierT3ogqX7zjJ7PL5d8H27r54tZmXTYVpr3B12MdevjG46B1CA2MEZOt
        yUq1gR0v4aJddP7r44O6EMEgxSYqY/+tti+HW8aT/LmPGupcwWbpwVmHMDdwV+JJAjO5ny
        I5rYWPMyvz5/vhct5gKxLVpHbAo6xeQ=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-rklPls8kP5akSVSxifQe9w-1; Tue, 03 Aug 2021 14:45:12 -0400
X-MC-Unique: rklPls8kP5akSVSxifQe9w-1
Received: by mail-ot1-f70.google.com with SMTP id z13-20020a9d71cd0000b02904d2c9963aa2so10197051otj.19
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 11:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=23GDkNLhLe5EW0NBURzRb+WIAuJSlfKe4etutEbvPx8=;
        b=ohH/V6YBHZVcoOxPMEjNDH5g964UyYP/9DYiRVzj0WkL+SF/fdZUwutJ7j229QbBol
         My7/f13BN4JqE1GUt2hRWaXXfsVen9yLMsLOqonDtOar4RLAyAdxKFL5/eeuNiHIGqUu
         tqUIxe4fKBZuzZBm5asEsBcmnAqetwJLxPdBo7d/XI4OqJoal5Axd6R+Hs/XXqUH47oT
         FLtGP0hW4051OzJIQYnrql1Eh5kKoXIXX5E9+qWGsjVws19s6sRk4cFj9Ek7Id/klt3b
         HXFyK+vM7o9wj2aGPbNpp2/VcxCHZsLlCeXX9KTPt5rIdj7F53+2ERh1rP73n3FWHecN
         oNgA==
X-Gm-Message-State: AOAM531GTcYMth2eWGsnxE7DfS+F5KQuCTvNBaXfPAzZBDcfAF4ss61c
        jpdOTdfRUhDGkKjpUBxnPaJ7Tjs0i5Vn7rnAsKkRfo9MndyWhA9o14EAL7+nsf98PMp0IfTrlPo
        kRBPirlrn31JY
X-Received: by 2002:a05:6808:140e:: with SMTP id w14mr15296597oiv.32.1628016312013;
        Tue, 03 Aug 2021 11:45:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjwfPbRtv9ckeJhTA4ncmD0idGMo982VS6iLv1VNS5vntu3eB8DqEimcc2uqnGAXEP7yXfwg==
X-Received: by 2002:a05:6808:140e:: with SMTP id w14mr15296590oiv.32.1628016311893;
        Tue, 03 Aug 2021 11:45:11 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p4sm2378831ooa.35.2021.08.03.11.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 11:45:11 -0700 (PDT)
Date:   Tue, 3 Aug 2021 12:45:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: two small mdev fixups
Message-ID: <20210803124510.618baf20.alex.williamson@redhat.com>
In-Reply-To: <20210726143524.155779-1-hch@lst.de>
References: <20210726143524.155779-1-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Jul 2021 16:35:22 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> two small mdev fixes - one to fix mdev for built-in drivers, and the other
> one to remove a pointless warning.

Applied to vfio next branch for v5.15 with Connie and Jason's R-b.
Thanks,

Alex

