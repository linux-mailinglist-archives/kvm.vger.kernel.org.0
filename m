Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEAA412EE5
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 08:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhIUG7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 02:59:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhIUG7r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 02:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632207499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M4pKUgQCJ/YOECkfGDCU8OhrHstuKMeIFUsvJmrJgME=;
        b=SKpoZJw0UhWaAs6cbJtBa7/rIzXB0ZviY4NpVxjdQPJeJvha5ZnpOBKkH6oiwBL+JQDBGE
        Rr8/QMIhMpqRFGuVGMJ08GF9CiCOYsEwaIelbV+qclq5zYmEtw9BdR8Ws0HIsieuik924K
        a9LQnKhxxnnKOQ9gxg8zNcXDVkT9wMA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-4puuW_06N4KLGV_-ArGhZA-1; Tue, 21 Sep 2021 02:58:18 -0400
X-MC-Unique: 4puuW_06N4KLGV_-ArGhZA-1
Received: by mail-ed1-f71.google.com with SMTP id h15-20020aa7de0f000000b003d02f9592d6so18026541edv.17
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 23:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M4pKUgQCJ/YOECkfGDCU8OhrHstuKMeIFUsvJmrJgME=;
        b=KHkvYUM61lDUrr6ivCp0+MtPDqCjSJ0/bS3NJzn0PV1AMxSA3YwfstIoeDt4wHqo4i
         8AysCIiFVQaocrRZYvn2o/fghVFTx5rLF2dIutxN6bCCfZAe5b50AHjlQ9LQehZ3cySH
         OshJnpx+vkXfzvm9zXdbifOPxRRBCxilNRCI0x3ep5UO+TS0noD+ihObt1V2+aHNLdvA
         4XF+LmQMr4TD9JWFk6355jWxNFj8lqj+5unGt7fOMsEidxxq8pqkW/aQdW4+mFymW25w
         u/ejFdRGX9Cr0o1BscwMP33pzEKuLQNou+7cRIFz/x9E2d2vQ7GXsVf1IntbDdC8/FPe
         uuvw==
X-Gm-Message-State: AOAM533Wj9d9zLeaywwto6j7QhAredLI/cAb0PPsE1ymSabUkdznoueD
        9uqizLhxt4aaHoPDZlQ8UGT8fVjn+vsuv/9mS1lXsuLYKPdkq9bzsrfgdAJLQss8s7qYrAkEoUM
        xjeFBTPnBJdih
X-Received: by 2002:aa7:d51a:: with SMTP id y26mr33980244edq.163.1632207497283;
        Mon, 20 Sep 2021 23:58:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlpe+CeNM6RWAqL1GO/yqQVY455/NiiUiOhPfQJ7Ro0yAQ5KBEhscaqhE0VUtRBsb73hI/MA==
X-Received: by 2002:aa7:d51a:: with SMTP id y26mr33980231edq.163.1632207497161;
        Mon, 20 Sep 2021 23:58:17 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id w2sm883856edj.44.2021.09.20.23.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 23:58:16 -0700 (PDT)
Date:   Tue, 21 Sep 2021 08:58:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
Message-ID: <20210921065815.eo5ir55pzkfoqsgj@gator.home>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
 <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
 <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
 <20210827102204.3y6gdpchn77cz7yo@gator.home>
 <327ff7e0-82d8-a12d-7565-e476b1dbcca8@redhat.com>
 <20210920141039.jfb2iektdzdjldy5@gator>
 <7b2d795b-a65c-1983-868c-b4ae38d939f8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b2d795b-a65c-1983-868c-b4ae38d939f8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 08:04:02PM +0200, Paolo Bonzini wrote:
> On 20/09/21 16:10, Andrew Jones wrote:
> > Hi Paolo,
> > 
> > You'll get a conflict when you go to merge because I already did it :-)
> > 
> > commit 3d4eb24cb5b4de6c26f79b849fe2818d5315a691 (origin/misc/queue, misc/queue)
> > Author: Andrew Jones <drjones@redhat.com>
> > Date:   Fri Aug 27 12:25:27 2021 +0200
> > 
> >      Makefile: Don't trust PWD
> >      PWD comes from the environment and it's possible that it's already
> >      set to something which isn't the full path of the current working
> >      directory. Use the make variable $(CURDIR) instead.
> >      Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> >      Reviewed-by: Thomas Huth <thuth@redhat.com>
> >      Suggested-by: Thomas Huth <thuth@redhat.com>
> >      Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > 
> > 
> > misc/queue is something I recently invented for stuff like this in order
> > to help lighten your load a bit.
> 
> Ok, are you going to create a merge request?
>

I did. And I merged it.

https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/16

Thanks,
drew 

