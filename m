Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01DE2B0C6F
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgKLSTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:19:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbgKLST1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:19:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605205166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RDR8sflLkI/6evq5tTC2KLbMUsTjJUoZI7jN2aQMMP8=;
        b=M6D8wGvHDtejkW+IvdK//Czpw/e7AK6x0XXnPcDq9an9rZfX6Y6ohCAlUvuPMXOR5/RIXz
        8AkXCGl7lkk5ixIMi0fCtUHxer6zEcMBzUw4urfA9+wYvhJpBcdXmXNKgdQWQp1dThTVUu
        Taj50GJXBw072TrVxnwvXdZbq5s95XU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-VaNuKQRIM06_Yq4t0aRtVA-1; Thu, 12 Nov 2020 13:19:24 -0500
X-MC-Unique: VaNuKQRIM06_Yq4t0aRtVA-1
Received: by mail-qv1-f71.google.com with SMTP id d41so4313162qvc.23
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:19:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RDR8sflLkI/6evq5tTC2KLbMUsTjJUoZI7jN2aQMMP8=;
        b=IcGSDp42Df/X/U8F1OaBlgQkcVY4Nj0ZWWJg6YuWCmFim8ajHltehuJwIU6CSye1HO
         39rda2+PjTVZZD6K7yHLFJHfFErPafHYEjuzofF58MAEwGfOcqXI6wFBCo65yEe6jY/Z
         BBXim28KHWlWYX2sb7vPAz/mipqi2ciB21nAAlcW6tARBF8NsfVV/yhQVSDdlaNwDOUe
         P96Y+p1gxFYyKwyleC882N1LkLqBIQxcr4VpmkDcW5EhKlpe9W+7Lzr1LPSAa/vZFPH1
         +YQEcEXH1XL/pIezPmIGsI1zjCAnM2PM7kqbHjvFPZ75nKFzKhmYMzzbwlFTpNpIZnw0
         2CQg==
X-Gm-Message-State: AOAM530Mk06nqKRqBeKpDxy4uNGvKDjpDwSLidOd50hQd2I9FxDfFpVI
        9Kdeaa0kguPw/1o/2UCpXf+caC0M5gn4haI+iGyD8GA30VBPK7CpMDunh/dnswz2bq5NVivuz4e
        ngXCBY4bB2N+X
X-Received: by 2002:ac8:5046:: with SMTP id h6mr393818qtm.349.1605205163729;
        Thu, 12 Nov 2020 10:19:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXBmQImUO/bNJTFQTDIbg7T0ZIp7GjA+kZukQrgi4pEn0HypLfDeeCUghs7GsKa/kiekwwVw==
X-Received: by 2002:ac8:5046:: with SMTP id h6mr393804qtm.349.1605205163533;
        Thu, 12 Nov 2020 10:19:23 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id y35sm1112497qty.58.2020.11.12.10.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:19:22 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:19:21 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 02/11] KVM: selftests: Remove deadcode
Message-ID: <20201112181921.GS26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-3-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-3-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:27PM +0100, Andrew Jones wrote:
> Nothing sets USE_CLEAR_DIRTY_LOG anymore, so anything it surrounds
> is dead code.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

It's kind of a pity that there seem to a few valid measurements for clear dirty
log from Ben. I'm just thinking whether clear dirty log should be even more
important since imho that should be the right way to use KVM_GET_DIRTY_LOG on a
kernel new enough, since it's a total win (not like dirty ring, which depends).

So far, the statement is definitely true above, since we can always work on
top.  So:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

