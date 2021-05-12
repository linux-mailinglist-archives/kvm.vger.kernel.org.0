Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CD737B644
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 08:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhELGmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 02:42:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELGmG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 02:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620801658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRJOEEFYEPL3RHgC5MYWKfnh+NkXyrxypv6GAj/cNM4=;
        b=ia6y+L5O0RHN4Ge9J7rztkWJ1TiOusyU3lnNBrizhiM8nRfslRy21OsuZzWrZ+qH8BGPkQ
        Cmf/cTDQkuYUsiVD9ZZDqtSYUeMreiFVQ7VZJlXxusd9c44N9nVV3Z05qXl/qNRGqKPTLN
        l7Wy1ehrtuIeW53paM965FzFXRJbu2g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-8hgpxwdhPn6zWWhzEx7NRg-1; Wed, 12 May 2021 02:40:56 -0400
X-MC-Unique: 8hgpxwdhPn6zWWhzEx7NRg-1
Received: by mail-ej1-f70.google.com with SMTP id h4-20020a1709067184b02903cbbd4c3d8fso1940791ejk.6
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 23:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cRJOEEFYEPL3RHgC5MYWKfnh+NkXyrxypv6GAj/cNM4=;
        b=WCkjXnvH07xD4ZtElT5+lOM/BtxGnZCuu8/ldsWh6jGifpsf7MiYBp9foDAVIyi9lO
         sDPTjdRGGbfWlulTx3LRAeCeiTxI4CQWu2LKYGFLCAfQTDB73yIqay4ELm0O41G+c/hz
         OckdpIIFBiIzeFWynGsGcCwNY61AzCenApuCSZWkKkF2MR29rdOLBHjRBgrgpHhcpv9N
         LeEXDJc41H0J8rAtCvQFrtYmfaNSX7SoACTpKXidnF4QyOAOP05cPPT22uBqo/vZlXbg
         0AspMuAvutfGDWmWrKB1wYEtQg8Mn/l5qeV/BEWgygtYUi1fY9iOSXw9zjxq9eqbPPT3
         EiIQ==
X-Gm-Message-State: AOAM531TaWa/Ov2M+pUdteGvZUKgGkH8PmB0BbtqrUz7vPwG6513V2MK
        Wk1qBzpuUUCmvZHkqV22u83KNHYeA0sH0i7cdstiLm3LJ0BlHyQqcqmG/ZzROh31ezCeX6Q1ihX
        mbCOtGihkDYXA
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr36432292ejc.292.1620801655224;
        Tue, 11 May 2021 23:40:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXreSnsGMiEM69035VeGFYjHR0PDgfDZ9QqQOtx2EdhzZ8LZ6vSZ0VnuVm6WISifc0EJ+2tQ==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr36432275ejc.292.1620801655077;
        Tue, 11 May 2021 23:40:55 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id jt11sm3796325ejb.83.2021.05.11.23.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:40:54 -0700 (PDT)
Date:   Wed, 12 May 2021 08:40:52 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4] KVM: selftests: Print a message if /dev/kvm is missing
Message-ID: <20210512064052.jgmyknopi3xcmwrl@gator>
References: <20210511202120.1371800-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511202120.1371800-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 08:21:20PM +0000, David Matlack wrote:
> If a KVM selftest is run on a machine without /dev/kvm, it will exit
> silently. Make it easy to tell what's happening by printing an error
> message.
> 
> Opportunistically consolidate all codepaths that open /dev/kvm into a
> single function so they all print the same message.
> 
> This slightly changes the semantics of vm_is_unrestricted_guest() by
> changing a TEST_ASSERT() to exit(KSFT_SKIP). However
> vm_is_unrestricted_guest() is only called in one place
> (x86_64/mmio_warning_test.c) and that is to determine if the test should
> be skipped or not.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 45 +++++++++++++------
>  .../selftests/kvm/lib/x86_64/processor.c      | 16 ++-----
>  .../kvm/x86_64/get_msr_index_features.c       |  8 +---
>  4 files changed, 38 insertions(+), 32 deletions(-)
>

Hi David,

You could have grabbed my r-b from v3, but anyway here it is again

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

