Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132F7423AC6
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 11:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbhJFJsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 05:48:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230071AbhJFJsG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 05:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633513574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Isv83yUMYdjJZv7dbRJw65ylR0cbrGVXZMMS10Fa4Xc=;
        b=fh0webZFHXTCkIjzsZ0Un0Jo4LILIi+X09BP8Tbl//bUpkxqI7YGprdkLe0BFVmuDfGFyr
        vvFb7Nf5XC9WcqDEwUpj0B5xkLOfE7o7THJVw5R2ogq/OF1leCv+xD65P3X/8w4+cXoZER
        tq10bSAxC5bZyQaQDQWUqHCK3OS0lHg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-EFbHoQGzNG-O7Bf61H1NEg-1; Wed, 06 Oct 2021 05:46:13 -0400
X-MC-Unique: EFbHoQGzNG-O7Bf61H1NEg-1
Received: by mail-ed1-f70.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso2060951edj.20
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 02:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Isv83yUMYdjJZv7dbRJw65ylR0cbrGVXZMMS10Fa4Xc=;
        b=wjgGNUOFDmxnDDRyy9Pne4Gc9b9AXP2YXbxF80OHpXdZQel3/ciqHoHNE+Dpu1CiAm
         B5Axe7Icuk4AcoccJ4Cmga9W77O1VmVGWWFtoB7ZoXmf4JgeLbzNhl3vqvf6/yfZKCTu
         NAhpW1JNYVMXCPSlRwGwDQgHVJXX6LQfu1zz6BCv9UlodV4gamrNcp5WB253/OLtK/0O
         hkaJoa6lhpOoM/JtWegRKBWKv9fOL0RMi8hnFY556wmc93mogyF6HTVfWogmz91fWAuD
         rO5G4Xc9ev0KA1LqLXkIicGvcvgLRFRBTfM6i8X5DDToTR9PyFNegdHvb5s94EX/pcPY
         0iyQ==
X-Gm-Message-State: AOAM532rvAWgm8teM5okkqw8ri1krhFpmfCYYg5AnBrL0phBVV5mV6+m
        ZzOoyrwkUda5oQOjLz7KsR5mNcKMgOJ1iG99MFJVYRBaEBeS2lIj0Hx4so4ad34zTymvA4HtQXr
        kgqwu9JaSkn4V
X-Received: by 2002:a17:906:a59:: with SMTP id x25mr30837162ejf.33.1633513571895;
        Wed, 06 Oct 2021 02:46:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypI1RG6bNERNdraDCnperFmmiC0GJAWwP2rbWeg6esoxpIgv/gXYPEvOrtVhDivn1SOhbdEg==
X-Received: by 2002:a17:906:a59:: with SMTP id x25mr30837124ejf.33.1633513571564;
        Wed, 06 Oct 2021 02:46:11 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id x13sm8607889ejv.64.2021.10.06.02.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:46:11 -0700 (PDT)
Date:   Wed, 6 Oct 2021 11:46:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v4 06/11] KVM: arm64: selftests: Make vgic_init gic
 version agnostic
Message-ID: <20211006094609.tbocj6phk2hmdydj@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-7-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005011921.437353-7-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:19:16PM -0700, Ricardo Koller wrote:
> As a preparation for the next commits which will add some tests for
> GICv2, make aarch64/vgic_init GIC version agnostic. Add a new generic
> run_tests function(gic_dev_type) that starts all applicable tests using
> GICv3 or GICv2. GICv2 tests are attempted if GICv3 is not available in
> the system. There are currently no GICv2 tests, but the test passes now
> in GICv2 systems.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 156 +++++++++++-------
>  1 file changed, 95 insertions(+), 61 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

