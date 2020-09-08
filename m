Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F639260CB7
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgIHH6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:58:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729921AbgIHH5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599551860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hjajqtvEuISTBRgRpPMUCH8ji6lbeHsCmX5hSQj+D2Q=;
        b=HVFVXNTCn0P8hxdzDQkceEZE95e+2L8CyHiJGAdMFWyTELNh0rCS64n0hyDoSvB+uoXlC2
        as/CK00hPloi+JHHZowUZJFtc47cjpZlZoTF/Q3Touz780mZnTcffk1thObxcy6ig6S2fb
        O4I/8if0CXHx/UFEovyQOwhgHLa9o+Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-5xSxcFoqPhWnPTPJoNt_3g-1; Tue, 08 Sep 2020 03:57:38 -0400
X-MC-Unique: 5xSxcFoqPhWnPTPJoNt_3g-1
Received: by mail-ej1-f71.google.com with SMTP id j2so370358ejm.18
        for <kvm@vger.kernel.org>; Tue, 08 Sep 2020 00:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hjajqtvEuISTBRgRpPMUCH8ji6lbeHsCmX5hSQj+D2Q=;
        b=L1aSfukYRMEDgzQy2FmZIB3F/mq2N0z8TnHQVh5eEizpmrIc6IjASUH6fNRIsplujW
         R6lcmKNDhLOi6qmxJQxE06jLyj6V+WSgvfiRzCAKMkqvbnKrwKPTv1mdOl1sXPqtPlgK
         WJrYdreziVgyT/tKFMHTKUBTOqaxrN8JmAnnFn+QrhFGEMM7aOHu0f8Jk02oW49hp70F
         kBeZQdoPnEZEa0hZ0/FxLkEeEFQ38lN3W3DMnebcD2r7A9Neoxi95LI5YD692OH+RIQT
         scuCSZ9aTAFMzrMFAox4c3LuREgG68yXQVAzTHcWZQI7jw4sjEh9Ugnj6+1A1sKkWydf
         D+5g==
X-Gm-Message-State: AOAM530o8GD6K8AaFIjhsxlSoEPaHgL/ZV6LH7q2yoHmYcRKfhJ2whSB
        rLf4+BZ1QthywDQFFodFp2LaEQRVPxaffgKvPsVes7Z944dMQbS869IEHi1IxHNVtHaLwHVosW9
        7GIefjMD+6sGy
X-Received: by 2002:a17:906:4cc6:: with SMTP id q6mr17306534ejt.201.1599551857520;
        Tue, 08 Sep 2020 00:57:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpDLRo1CVGFPV8s2mB7FGn6jr+cgUVgJN/ozC0WS4OAeawUnu+/98JbXILSr3J/Bhzu7egLw==
X-Received: by 2002:a17:906:4cc6:: with SMTP id q6mr17306516ejt.201.1599551857341;
        Tue, 08 Sep 2020 00:57:37 -0700 (PDT)
Received: from redhat.com ([147.161.9.118])
        by smtp.gmail.com with ESMTPSA id e4sm16024501edk.38.2020.09.08.00.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 00:57:36 -0700 (PDT)
Date:   Tue, 8 Sep 2020 03:57:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 0/2] s390: virtio: let arch validate VIRTIO features
Message-ID: <20200908035506-mutt-send-email-mst@kernel.org>
References: <1599471547-28631-1-git-send-email-pmorel@linux.ibm.com>
 <20200908003951.233e47f3.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908003951.233e47f3.pasic@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 12:39:51AM +0200, Halil Pasic wrote:
> On Mon,  7 Sep 2020 11:39:05 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > Hi all,
> > 
> > The goal of the series is to give a chance to the architecture
> > to validate VIRTIO device features.
> 
> Michael, is this going in via your tree?

I guess so. Still not really happy about second-guessing
the hypervisor, but this got acks from others
so maybe I'm wrong in this instance. Won't be the first time.

-- 
MST

