Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E53425715
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 17:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241951AbhJGPyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 11:54:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233416AbhJGPyr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 11:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633621973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mki5wTjxXGr+IGNPFHM4xHf+VH4JglD76WJd/mMOISs=;
        b=ZW4NS9yiYE4RatWENqfxdIrdexBE5IuyMYLpDtyjwrKc9vRjnSADKsPFvzAA5DAQGjnXeH
        FtUYzyh0WKIuTO9Bnw8ZDq8ORN8pZc1SRkc5QSVFV538/KEo6dBG2x/FzbujCfFklzDG0r
        RpD512sTJRv9mGDWMOpr1c4lRR/OI0s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-hpjD-BWHPcOFHnMPqUKaEA-1; Thu, 07 Oct 2021 11:52:52 -0400
X-MC-Unique: hpjD-BWHPcOFHnMPqUKaEA-1
Received: by mail-wr1-f71.google.com with SMTP id k16-20020a5d6290000000b00160753b430fso5085075wru.11
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 08:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mki5wTjxXGr+IGNPFHM4xHf+VH4JglD76WJd/mMOISs=;
        b=IDUZq2KFazYVRmaSiIdzFWluwDkexOVMi9P0TQrORgqwS5uVHh7ab4WcPmQDs2gkns
         oHEcV3u2JNVgjYLo3MqgWsYH/bpQ2VqOKh/dagFzTDrtZfF2Bw4sX7q+6+saJm0J740n
         L5whnXtXbAT89M29YPPbEQsbIWjynck9bZgSUF/W/z9+U7y6JfuvMGqQJpU0eFbmeAtV
         h9s3n3H4EwmF9K64zlQO9IH1iOvNNSXEai7/ZkHUSZeHqZ/WZxxnSzuX7yKOUZHRXoTZ
         KNw4a44VL5afzHqvWTrxBV1BQ62ZkDMslpoUlxXOUjq0OZbBbRLxyjtQ+N5uBn8dmXsT
         /2Ww==
X-Gm-Message-State: AOAM531d5IMkOAPm5Onkj91ujEwxBNUtC3oECMTuGI+HGh0IQ9Fyz20V
        Vq2jqJf5fXpE/xZOptgrMj9j7cE5iHsRVa2HZ8TvDhptD1elR/tDNNcaGS5n6KwvgtiOzKUniM7
        Kc4Knmssv/SYL
X-Received: by 2002:adf:9b97:: with SMTP id d23mr6386626wrc.53.1633621970951;
        Thu, 07 Oct 2021 08:52:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxS9zzcdO8gEa8I10rZOiZ3zEoCv1L5U3v+lF61OvcEjd+iZrkvzPdw2F8ibmZvXvAL8shTg==
X-Received: by 2002:adf:9b97:: with SMTP id d23mr6386598wrc.53.1633621970756;
        Thu, 07 Oct 2021 08:52:50 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id i92sm13012wri.28.2021.10.07.08.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:52:50 -0700 (PDT)
Date:   Thu, 7 Oct 2021 17:52:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 00/16]  KVM: arm64: MMIO guard PV services
Message-ID: <20211007155248.ejwclkwnnsaunmc6@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:33PM +0100, Marc Zyngier wrote:
> This is the second version of this series initially posted at [1] that
> aims at letting a guest express what it considers as MMIO, and only
> let this through to userspace. Together with the guest memory made
> (mostly) inaccessible to the host kernel and userspace, this allows an
> implementation of a hardened IO subsystem.
> 
> A lot has been fixed/revamped/improved since the initial posting,
> although I am still not pleased with the ioremap plugging on the guest
> side. I'll take any idea to get rid of it!
>

Pros/cons of the hooks

Pros:
 1) VM only needs to have a kernel that supports the feature (and a
    kernel command line that enables it)
 2) All the ioremapped MMIO ranges are permitted immediately, rather than
    deferring until some other event (which would probably be too late in
    many cases)

Cons:
 1) Having to have hooks, which is never pretty
 2) Adding the hypcalls to each ioremap, which adds some overhead
 3) Having to reference count all the mappings, which adds even more overhead
 4) Not giving the owner of the VM control over what MMIO is permitted
    (Well, maybe the VM owner just needs to blacklist drivers for anything
     that it doesn't want.)

I don't think any of the Con's are too bad and probably Pro-2 more or less
makes the hooks a necessity.

Thanks,
drew

