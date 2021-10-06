Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00727423B45
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbhJFKOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 06:14:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229874AbhJFKOc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 06:14:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633515160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LVKa10Ka2NztPVFkO4ojxiDXv4AaKaB2OGd/MiltWxs=;
        b=iIt7xfFNL85JkdpX2+jI11LvWjjk2w4CqdRiBxm5iQoLMAG+7hoYRex0DXuuuMecVjiyRk
        91hLcoawYtPHWwAGVvbkpNtQk62aabJOB8GKlIGeRjlbTciiQxVdUQZlwdKJrxVGTZWesf
        TvCgMCcHaI8bZbWEXC8W+oDYmmweWjQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-chdFz7vLMYiDf5W_etXr2w-1; Wed, 06 Oct 2021 06:12:39 -0400
X-MC-Unique: chdFz7vLMYiDf5W_etXr2w-1
Received: by mail-ed1-f71.google.com with SMTP id w6-20020a50d786000000b003dabc563406so2129947edi.17
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 03:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LVKa10Ka2NztPVFkO4ojxiDXv4AaKaB2OGd/MiltWxs=;
        b=zwfoqli2y2kzBjrsM+4BKDJV/wvJu1GO3kElhen+d2y7tUzlvKzLw+wJEF+aQSbYIK
         uIIKoMSG/XOS6aelnkUw/LRlFq3UV5dKyGumkd/ocOccM4DTeNeKCwd6RajPvN2jLhqX
         1tQr8MAybWAwu5bO+lQZ2xDFgo/U2eZ6vyincwhrNkLRkIAgtsM6ZNIr/+oQNSBUxskW
         9Cp58ZbJTxf1ouXP57wDKgP4KjP5qlhA5M6BuK16pNA6ce/DRlxoluRAami5KPKoGe5K
         36dEMBNzT4j5tCTC9Po/YLfwakmpsS3kTdUgDHrgEG4ZcNtfWbIveaMr0Y39M/leLlJ0
         HBzA==
X-Gm-Message-State: AOAM533ln4tOd0j9jxU4P7BVDsxvKzso1/y4zBmIoDPgVXKV0WUZJz2V
        byNRAIQkrtOQo+UNBgqNWD7uWpRNqk/tT3q/Xu1DKZoNiFe2WKOojYIUygkjyBN1P9HpVPDKwPx
        O+xZOAuzv7WtD
X-Received: by 2002:a17:907:785a:: with SMTP id lb26mr30740271ejc.77.1633515158421;
        Wed, 06 Oct 2021 03:12:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqZuM9LLB357DG8BTmc0wddDVHkGSLTZqlWFSDFmapsNWHXkLzwSDxzDoCFY/er6q5YbEReQ==
X-Received: by 2002:a17:907:785a:: with SMTP id lb26mr30740256ejc.77.1633515158261;
        Wed, 06 Oct 2021 03:12:38 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id lb12sm8932498ejc.28.2021.10.06.03.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 03:12:37 -0700 (PDT)
Date:   Wed, 6 Oct 2021 12:12:36 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v4 10/11] KVM: arm64: selftests: Add test for legacy
 GICv3 REDIST base partially above IPA range
Message-ID: <20211006101236.5hqyaqbf2km2vqfh@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-11-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005011921.437353-11-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:19:20PM -0700, Ricardo Koller wrote:
> Add a new test into vgic_init which checks that the first vcpu fails to
> run if there is not sufficient REDIST space below the addressable IPA
> range.  This only applies to the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API
> as the required REDIST space is not know when setting the DIST region.
> 
> Note that using the REDIST_REGION API results in a different check at
> first vcpu run: that the number of redist regions is enough for all
> vcpus. And there is already a test for that case in, the first step of
> test_v3_new_redist_regions.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

