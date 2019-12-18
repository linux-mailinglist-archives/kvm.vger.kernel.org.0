Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182C3124AC2
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 16:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfLRPKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 10:10:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20554 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726913AbfLRPKU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 10:10:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576681819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QM58zRG2E33uopTi5C1OLZUP84XlNWgGlqpWQbuCIPw=;
        b=giL2cRqi7uySqBFzskBehkV1wUW21VtzT/szfQoPmHMZHhfhIp1sP6/YB/kt2YUmqaU3+i
        VmiHC6An73+bsyz9InEjx3FJ4+NH8ZgBN7a/qdgW5TUK6bYmbypN0enjkFYVAO/WgBfZnP
        Z3LounYvq1sOhEhXX+mh1L6n5qgA8Ws=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-nAPYtekNPYir2rdc_NOXag-1; Wed, 18 Dec 2019 10:10:16 -0500
X-MC-Unique: nAPYtekNPYir2rdc_NOXag-1
Received: by mail-qk1-f199.google.com with SMTP id m13so1514925qka.9
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 07:10:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QM58zRG2E33uopTi5C1OLZUP84XlNWgGlqpWQbuCIPw=;
        b=odazY3M0pOOUMJV47iMDiOUdtPl827bEvw8l/PgLzyf9zo1iOSbnT/uipOpCBKRA2d
         vX1vU7lcfaoeuFGoX8PQK7pyiLcXQqiZ4tti6yA6+h2HX/KNQGIpqd6Ieg7zarLHT1Vr
         mzi7+/7VKGMQGTH843LItDsJTULdhloi3ppLPoRRgo6MN+GT2YBu/9O3jsZDCwWarZ3I
         4JTlRBiCSqwsooxbRK8mpZGBUAUbx05aCPtWIxLKC1SGyKFMZwvdw/7Og6AwpJJjHapb
         bZIFGLjCqMAXflRu72gjeVEEJxb8Q1CRGFNu7wClafZ6iyMsYB7MhluKvUekg2PivQNP
         8w0Q==
X-Gm-Message-State: APjAAAUR0FCm3sbxEr+Hn2Rnn2PngckelbtAU6lT+oYvzBwa3/24y+PY
        J4YCEjwlA93teA2vDVxkZrilgm7xrpyOrx3QyHkdfGoftvG2H/nMuM6RYDXWgusMAWDcV+0udka
        cNtf//pJJmAzt
X-Received: by 2002:a0c:e1ce:: with SMTP id v14mr2673048qvl.39.1576681816440;
        Wed, 18 Dec 2019 07:10:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhQfsc+4bORIeWfJPGw6vR+W11ECcHruYmI+Dy/4t2QYKRuVwYMstb8WaGcqyUqp1oBsusFQ==
X-Received: by 2002:a0c:e1ce:: with SMTP id v14mr2673022qvl.39.1576681816185;
        Wed, 18 Dec 2019 07:10:16 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id i19sm716606qki.124.2019.12.18.07.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 07:10:15 -0800 (PST)
Date:   Wed, 18 Dec 2019 10:10:11 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
Message-ID: <20191218100926-mutt-send-email-mst@kernel.org>
References: <c022e1d6-0d57-ae07-5e6b-8e40d3b01f4b@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c022e1d6-0d57-ae07-5e6b-8e40d3b01f4b@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 03:43:43PM +0100, Christian Borntraeger wrote:
> Michael,
> 
> with 
> commit db7286b100b503ef80612884453bed53d74c9a16 (refs/bisect/skip-db7286b100b503ef80612884453bed53d74c9a16)
>     vhost: use batched version by default
> plus
> commit 6bd262d5eafcdf8cdfae491e2e748e4e434dcda6 (HEAD, refs/bisect/bad)
>     Revert "vhost/net: add an option to test new code"
> to make things compile (your next tree is not easily bisectable, can you fix that as well?).

I'll try.

> 
> I get random crashes in my s390 KVM guests after reboot.
> Reverting both patches together with commit decd9b8 "vhost: use vhost_desc instead of vhost_log" to
> make it compile again) on top of linux-next-1218 makes the problem go away.
> 
> Looks like the batched version is not yet ready for prime time. Can you drop these patches until
> we have fixed the issues?
> 
> Christian
> 

Will do, thanks for letting me know.

-- 
MST

