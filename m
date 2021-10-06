Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED53423ACE
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 11:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbhJFJtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 05:49:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJFJts (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 05:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633513676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LIgH8gu1r21yeBq6abOkIDI2JxH09Ml9MBToyvOxu20=;
        b=Hl17sacUfCDrrZ3K/ulnFRJdsMnz6ssx52N0wIBipsdJhSpN9x87lRknJm9NB69NbRKaD3
        ZCn0ktrp3ytn4JxsGa5QEX1XoFXjHbzbTGGvWtfBvAhmhXCSm1cR+DL3Pdn7DXqb2C2KoU
        CjGknGAO8s6SM7vHCLlkUhAoF4edbQ0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-GyQFc_dAPmeDwOMwSfDrWw-1; Wed, 06 Oct 2021 05:47:54 -0400
X-MC-Unique: GyQFc_dAPmeDwOMwSfDrWw-1
Received: by mail-ed1-f71.google.com with SMTP id x5-20020a50f185000000b003db0f796903so2075588edl.18
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 02:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LIgH8gu1r21yeBq6abOkIDI2JxH09Ml9MBToyvOxu20=;
        b=OcqsHi8shnnRsbWOqt7zk26X7EW+J53jWJVgOm41BVVSSQ+4BvjlXaWHRxqpzpFJLa
         C3ijD8I0p1o836twZIB7peN3jfAqcKsRW0cgbnMtrvrZHsWKerphkvQ+jLU7L23isoMM
         rl92DjGrfOtLZcuhKMvlUusmFkYyFzF9EDRO8ICt8eUxg56uKzvhNIJKR5ZzvDoq3px+
         mHmkeXI8afE6pvuuagnXExDUIMMIq3j/qus7xgqbYqoI3JrH4XuzqF109s3mKiV7mKBR
         420uQpOnvPCZ89xInwJBwqPrOQiCzKnUqL5gVSN/BPCkQYVym5GSkXdHHNbDJhNNlYNS
         GxBA==
X-Gm-Message-State: AOAM532JK6reNCNv/Z7SHggJ9DLc2n0zef6HNCVeeVMC9SWRitscqpnV
        rdO9S/8b5nMlEZiSWBrwf76wNZ+02MAEnRN+AAxN9YFnwrnDOAeurBmBhGTeqUV8n0QYOcvCa5R
        lVBTHy4cg7U4T
X-Received: by 2002:a17:906:2706:: with SMTP id z6mr31136652ejc.551.1633513673561;
        Wed, 06 Oct 2021 02:47:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLsv7QfJ9edq3MbAwDzJGPzcyo85uxhptP4qfeMda0Ru51+ZwihXwCVe1lDsAKEIfAjcnZJQ==
X-Received: by 2002:a17:906:2706:: with SMTP id z6mr31136628ejc.551.1633513673369;
        Wed, 06 Oct 2021 02:47:53 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id v10sm1921159edw.96.2021.10.06.02.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:47:53 -0700 (PDT)
Date:   Wed, 6 Oct 2021 11:47:51 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v4 07/11] KVM: arm64: selftests: Make
 vgic_init/vm_gic_create version agnostic
Message-ID: <20211006094751.asalvm7ufhjovttg@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005011921.437353-8-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:19:17PM -0700, Ricardo Koller wrote:
> Make vm_gic_create GIC version agnostic in the vgic_init test. Also
> add a nr_vcpus arg into it instead of defaulting to NR_VCPUS.
> 
> No functional change.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

