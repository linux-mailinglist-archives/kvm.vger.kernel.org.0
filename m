Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA62F423B49
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 12:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhJFKPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 06:15:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237980AbhJFKPo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 06:15:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633515232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/J+FI9BmegXNC9OorjI5/QExOSyFnucr7CzcEa9NXjY=;
        b=J60m88vsS3NpwwbmYAMwtdJyuokcHUJU+xGKCa1eF0Aa4u52vypavfBdjPwQf0QvzxBunH
        2nKXhQli74oYV73P01fEmsgGAB2IQk/S/9Ec6R+z4UdgCEXjFvlLIcMA7+6XP9cawGfe2z
        oEysqcVH4l2ltVoQb+mnM142mUwS+cc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-_NZfDfYQNp2z9PiCalFZmQ-1; Wed, 06 Oct 2021 06:13:51 -0400
X-MC-Unique: _NZfDfYQNp2z9PiCalFZmQ-1
Received: by mail-ed1-f71.google.com with SMTP id v2-20020a50f082000000b003db24e28d59so2192704edl.5
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 03:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/J+FI9BmegXNC9OorjI5/QExOSyFnucr7CzcEa9NXjY=;
        b=xi4RX2jE2LOcFKDbq/hJwsDmyCG8wCyesy/SVF64mVP4ahMYHmdPsz+Kvg0q4qEBSL
         99bN1EQXUsZPR0lLdeOC4jYw160nWEU3pE819OajbVY2FZuFmkFbW5FzTctZaNmY6prh
         WF26YxENoKHGp8PLDzv1s+nVeButXybCc+x5FNf/sGXh+ffzIc6VDRW0v92khfGyf3vz
         +yo1A9s+ChSvehi1FPdyjevGegIa8So4QKVz3wCWkLLk17/R5Z20c+/6luP+GvXwwSDQ
         dAlXhPAFWkPRbi8E9WY0QwMTavEirXqzEfEU+0phpAqVosVxJ0DCqSVDm6n7fNg8/nrA
         jNFg==
X-Gm-Message-State: AOAM5330Q8cZzVtJtneDvq3TbjUyZJDERZJN7GvasTiOZSVX20+3NvAY
        W5+O9KIO/nOU902W99gagsgMngHE6Fqwqw0/TSlQUXyMqnqE9WAH5+RqvxhTrRiPBgWJUCVessS
        etOJK1Smc90+w
X-Received: by 2002:a50:9d49:: with SMTP id j9mr32029491edk.39.1633515230244;
        Wed, 06 Oct 2021 03:13:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqHiAUfNXJLrOpbjMnYwSPrvrVfqR+aEtx42GvvD8RJOVmpaWCmZRwYhEQ8Ul4GC5ywSc7ig==
X-Received: by 2002:a50:9d49:: with SMTP id j9mr32029469edk.39.1633515230134;
        Wed, 06 Oct 2021 03:13:50 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id bf23sm3465236edb.88.2021.10.06.03.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 03:13:49 -0700 (PDT)
Date:   Wed, 6 Oct 2021 12:13:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v4 11/11] KVM: arm64: selftests: Add init ITS device test
Message-ID: <20211006101348.7d6z2oivnv2tteof@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-12-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005011921.437353-12-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:19:21PM -0700, Ricardo Koller wrote:
> Add some ITS device init tests: general KVM device tests (address not
> defined already, address aligned) and tests for the ITS region being
> within the addressable IPA range.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

