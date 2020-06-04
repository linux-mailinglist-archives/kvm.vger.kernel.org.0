Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868621EE06A
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 11:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgFDJBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 05:01:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728218AbgFDJBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 05:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591261283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xh5Mj8Dm7pwISvlFLqL8NiYNfeUBsG7hGmY7DgnArSI=;
        b=fPQzV/7KRd9IVuccwoP4QK4Zaxkn+nMy17G+hkhbnAaHKEFkd9COvX8fE5lbTfWJtdrWa6
        Jfr/TOktw4bGwKujNL8VGtb3LEoYvPecb39qU3FbNG+YdBw2Ato6alSNzY69Pqev9oQyP6
        XGyATlld9INlY1OOujf768kgfB5VPGI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-hBjXnc2XOWmzSu0Ak9Lrkw-1; Thu, 04 Jun 2020 05:01:21 -0400
X-MC-Unique: hBjXnc2XOWmzSu0Ak9Lrkw-1
Received: by mail-wm1-f71.google.com with SMTP id b65so1751104wmb.5
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 02:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xh5Mj8Dm7pwISvlFLqL8NiYNfeUBsG7hGmY7DgnArSI=;
        b=dIhoaAlMFjGJmtTpZV12/wQYiTJJnqWiLT4t4i3PPgnT3vdS3j1We+I/fgSFJM9SPv
         L2J4ZKA4vS2rALjHVikdl3/QLbxmzR0f0sE1eALx0clRq/56nnzyjNb3GyhXY+eLhH1/
         4v3Oi4gosctxlRBp3AhfWD7X81SpmybInBQ+AMhVvH16rmYIBNFBkWggHAObwvRhxCbP
         ttacDuDFL1YdSo+WKmndj84Fk/7+NfgrTCxzG5/bNtF4Wbl//4W3nvdqlQlqz8Oap0HZ
         ruU3yk7A+Ate4ad1j0DDAbN/YRoWAClk6bpOJDkdSV1ZtU8rgas4bAxUDVx/bcmToCon
         a3YQ==
X-Gm-Message-State: AOAM533Q1iUxsCTFwIMdAvWYBfM7pN/QrSyEXLLczPjs7cdl30KAfDks
        /1NlIk/yqjmtkPXTBPq8aafTGP4jJh3dBXJ4p3DbTE/w+4ODSjbQsaO1FWU2covn3kyczKcq28I
        D9dsO44ckQJ0i
X-Received: by 2002:adf:ea03:: with SMTP id q3mr3291688wrm.286.1591261279686;
        Thu, 04 Jun 2020 02:01:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/zGaMBjx21Z9cwBMj+pCZMs7uKzsNY9xUq1Big6tLAZfVUSVRfMUci1KnmD6zuRYgAJmYOQ==
X-Received: by 2002:adf:ea03:: with SMTP id q3mr3291669wrm.286.1591261279537;
        Thu, 04 Jun 2020 02:01:19 -0700 (PDT)
Received: from redhat.com ([2a00:a040:185:f65:9a3b:8fff:fed3:ad8d])
        by smtp.gmail.com with ESMTPSA id d18sm6904921wrn.34.2020.06.04.02.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 02:01:18 -0700 (PDT)
Date:   Thu, 4 Jun 2020 05:01:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 04/13] vhost: cleanup fetch_buf return code handling
Message-ID: <20200604050011-mutt-send-email-mst@kernel.org>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-5-mst@redhat.com>
 <7221afa5-bafd-f19b-9cfd-cc51a8d3b321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7221afa5-bafd-f19b-9cfd-cc51a8d3b321@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 03, 2020 at 03:29:02PM +0800, Jason Wang wrote:
> 
> On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
> > Return code of fetch_buf is confusing, so callers resort to
> > tricks to get to sane values. Let's switch to something standard:
> > 0 empty, >0 non-empty, <0 error.
> > 
> > Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> > ---
> >   drivers/vhost/vhost.c | 24 ++++++++++++++++--------
> >   1 file changed, 16 insertions(+), 8 deletions(-)
> 
> 
> Why not squashing this into patch 2 or 3?
> 
> Thanks

It makes the tricky patches smaller. I'll consider it,
for now this split is also because patches 1-3 have
already been tested.

-- 
MST

