Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1951C37C52B
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhELPig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:38:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231375AbhELPbf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 11:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620833423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/L2QT7irRTlqrEYB7d0G9UXujzvCdz9UJvuRZkrixYY=;
        b=aiEYVpBINALOHcotG9lu2C4J3B3fYTanuEpCr5inTQLxrtPdWNG5BwNhlRIGGPG6C27YYK
        OfnOKLR4cV+UQtnvdleN5jRyG+2F+5UVhuX7FKfRSo2q3Pu22dS9kYdZOI8d7yYuP2bnOX
        oWj7b/ByMzi8IjA1iUBY763LT2mwYuo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-7a1HgWeAPdGURbGfS2BdoA-1; Wed, 12 May 2021 11:30:21 -0400
X-MC-Unique: 7a1HgWeAPdGURbGfS2BdoA-1
Received: by mail-qv1-f72.google.com with SMTP id r11-20020a0cb28b0000b02901c87a178503so19170983qve.22
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/L2QT7irRTlqrEYB7d0G9UXujzvCdz9UJvuRZkrixYY=;
        b=O3KfafP4bUc9rnlcjrW7/N98KNGRp4LKgFwtx5RfMjR56MZWGlc155MrAZyFT0BwmS
         AmX/vUvirOQ3ayILZ6e7RCyTWzc8Ieg0hbrKQHjmTPZjg5vLfVeDaIfMbwpN93A3ZFm5
         IDPJTYDulcFeYEMzSSMlOeKwNxk01M7tML0r7Sq/jlA7UTId45P7c66CNZGdR2UbPVKw
         JAeBHobv4f6mRcis9shTGwkkJP5b1vnYihAwnuarm/H94mY3n9+lYnl+F5dUfsJAivNe
         lv66hldw9cI8PAiCkq3To92qZGneaKhlD8NSjnJZQqaPWGoa4rXUf114iu8mpIZiaOve
         N2nQ==
X-Gm-Message-State: AOAM533LBOfLzG4PmYX6/KwkTTgvqw27Q6vuAOqQrcXTYy58eonN4QvZ
        SsJP7a9zleA5iSgAIlzgm8V+12br3xA+nJFsf4jIJgj8uLfFuY1DSt//S/3JrwAR9u3cGckUa0+
        lm7mOcECu/C6w
X-Received: by 2002:aed:2010:: with SMTP id 16mr33671175qta.256.1620833420555;
        Wed, 12 May 2021 08:30:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCWsDlUxFJtwZszwbsl+FcZ7ldMK1Wyyx2h6xUQvtC7pItczqgweE4vbsGUjP8w+eLVcry7A==
X-Received: by 2002:aed:2010:: with SMTP id 16mr33671144qta.256.1620833420220;
        Wed, 12 May 2021 08:30:20 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id i129sm254398qke.103.2021.05.12.08.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 08:30:18 -0700 (PDT)
Date:   Wed, 12 May 2021 11:30:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 1/4] KVM: x86: add start_assignment hook to kvm_x86_ops
Message-ID: <YJv0iXG2aJyWsFjV@t490s>
References: <20210511235738.333950860@redhat.com>
 <20210512000101.895392564@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210512000101.895392564@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 08:57:39PM -0300, Marcelo Tosatti wrote:
> Add a start_assignment hook to kvm_x86_ops, which is called when 
> kvm_arch_start_assignment is done.
> 
> The hook is required to update the wakeup vector of a sleeping vCPU
> when a device is assigned to the guest.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

