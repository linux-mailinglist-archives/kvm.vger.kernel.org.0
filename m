Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CFD37F397
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 09:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhEMHgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 03:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230443AbhEMHgu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 03:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620891340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zTEQQXsAJQxZUo5zOYVOBC+x54vGh0Ue0rC0kRz9wp8=;
        b=GvSFwA75ZZAscu9I2FhpmKHWO7Pfd89FeMGYOBB44QeNYuynOIOfa678ylPJ1iwgJaz7N7
        PBz+5apFDXmo2fqdpHQw5GMghCUCBkKsSYs55uJoKh1hVWqE7Gn1jCmxv/G0Hh1qKnwvcE
        tke0lcaujWEFhQcUgn4juyJKl6pmi6E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-73URZ9gNNdGK1nu74GoObA-1; Thu, 13 May 2021 03:35:38 -0400
X-MC-Unique: 73URZ9gNNdGK1nu74GoObA-1
Received: by mail-ed1-f70.google.com with SMTP id d8-20020a0564020008b0290387d38e3ce0so14200834edu.1
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 00:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zTEQQXsAJQxZUo5zOYVOBC+x54vGh0Ue0rC0kRz9wp8=;
        b=OrNtT5IXQYYTYbdCU8l6K+ptf99r99mzW9wrKDJkrEWgfqgLeogYjuOeYbeo4FXN9M
         aUU3rWzXYyku5VWlZrZUuL7wvTdwEEH4+9oY2uiY1j1pPLkS2EjsnwAVKVvjLinsxVsg
         TglFUXRpsXVz/9Pl/JhQ+ZAsKkfl1kPOZzJfsUP9oFcHFP8KmDW/S7xcOhpg6ldrcLsb
         9XHkcdmHWeuFVnTxQQPQtHp7kvI41J9X2w0SQj/HNnBSlpBnzr9K7r4XD4gpEOo08Rad
         Ol91JkJuCLcaaaUQvPoGXl0lnDwikpAhEpGhc6gdLPIO7+H7q2b63IlIR5IRxAMpmU3J
         bOKg==
X-Gm-Message-State: AOAM530jPS/i9PcggYHsKN03BlLy/v+/VRlbVmviXYSMHv7mV3GBz100
        apSKt0NodGFUFRDfrO//DbEQi7reIT/uxeG6bn7Rpiw6wyKEGDJBfF3VJVJZiBCp0+XdsKg94pW
        kKKZT0TNxsIXH
X-Received: by 2002:a05:6402:1547:: with SMTP id p7mr48873025edx.319.1620891337765;
        Thu, 13 May 2021 00:35:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4fQrV1jLbyyYnaAc4rghuBIVhv9b9kqKDT7Ao5odjIT9s+5ushZxRP+CITFR79rGJjFXT+w==
X-Received: by 2002:a05:6402:1547:: with SMTP id p7mr48873016edx.319.1620891337666;
        Thu, 13 May 2021 00:35:37 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id da25sm1869559edb.38.2021.05.13.00.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 00:35:37 -0700 (PDT)
Date:   Thu, 13 May 2021 09:35:30 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v3 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils
 header
Message-ID: <20210513073530.ajehgqt55o4faxul@gator>
References: <20210513002802.3671838-1-ricarkol@google.com>
 <20210513002802.3671838-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513002802.3671838-4-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 05:28:00PM -0700, Ricardo Koller wrote:
> Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
> architectures and tests to use. Also modify __GUEST_ASSERT so it can be
> reused to implement GUEST_ASSERT_EQ.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 22 ++++++++++---------
>  .../selftests/kvm/x86_64/tsc_msrs_test.c      |  9 --------
>  2 files changed, 12 insertions(+), 19 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

