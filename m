Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292C71D4C06
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 13:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgEOLC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 07:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgEOLC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 07:02:58 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C45DC061A0C
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 04:02:58 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id v12so2980581wrp.12
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 04:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QSEyQaq4LQecf0jyORsCF74hs8fmG+5qsCygtQRV5Dg=;
        b=Iuwv0st6tBfu2N1oXCtOhkcayvgqQMZupIvuQ2VGVv1/w1cebSJ+5Tf9lEm8kv4Of5
         VKUNqoghQw0xMwQ+iW365XX0XBTte7eaFcbQo5WX6k5T6R72gIUdlcCpSO6Cykl622ym
         upplDZVGF5MEy0WOV6XukDee6uz/yvuFu++aEfenRKuQQUB47C+uzX5AfNtVc4z8kz6e
         U2JJBHvOQpPCV5kDVPnZH1Saop0L8AeGY2XSLhBfrUTHh8rHYkwBbK/AnlpgnLVIz9xe
         HqGGHea8OOioDCvS7+IpU9SrBjQHhfuKNpwa6CKeyX4zSKbG/L5Q7eUMYp53DinKjgqK
         dB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QSEyQaq4LQecf0jyORsCF74hs8fmG+5qsCygtQRV5Dg=;
        b=iurdjMW6sZYS+v1Eclv7YNc9Ffi9XrQIgFk00Vd3fa80ExU/SWbSaXUpOjKKyrRRkv
         8JZqfgdEDFp/L/bWhrAyCiyrUAOuUoROhHXsXdQc/KJ0UtqlOhv5MKsLiGsPKOXl6x4I
         SO0blGCGsT2o56PnZxxQWuz8OOJCgolT64yYuQDHMm/RYfUIAbaRGqbFgQgjg7k292c1
         hzZ0fYBBU6oBI/GDIjk8dGM3RqIFckL5nOLo1hUzX9IznIIREqT+biLizt49X6++DA11
         kDht4FuF9wtmdSQ2k9/Xs4JSAcHLyEFcOlGWnbB3+IaY2ZilcGEBFhbAuDtVNQQchk6u
         kAPg==
X-Gm-Message-State: AOAM5309DZaLXrdHFL4mCR9aqwdieLISdNP9tPIXZn3AFED6c4NtavxB
        aIok6CFYkCFWf1y5azJ9IACxg+nmCbw=
X-Google-Smtp-Source: ABdhPJxdZw/B+gueDnbAmXpzPy0/wjSgamnTKKreYvMlu/5kVJi8yd7clMYiq36nVcXiMdvgBkF7tA==
X-Received: by 2002:a5d:4950:: with SMTP id r16mr3785390wrs.350.1589540576609;
        Fri, 15 May 2020 04:02:56 -0700 (PDT)
Received: from dbrazdil-macbookpro.roam.corp.google.com ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
        by smtp.gmail.com with ESMTPSA id z3sm3368475wrm.81.2020.05.15.04.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 04:02:55 -0700 (PDT)
From:   David Brazdil <dbrazdil@google.com>
X-Google-Original-From: David Brazdil <dbrazdil@dbrazdil-macbookpro.roam.corp.google.com>
Date:   Fri, 15 May 2020 12:02:54 +0100
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        dbrazdil@google.com
Subject: Re: [PATCH] KVM: arm64: Use cpus_have_final_cap for has_vhe()
Message-ID: <20200515110254.cxmng6u2qnnvwpya@dbrazdil-macbookpro.roam.corp.google.com>
References: <20200513103828.74580-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513103828.74580-1-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>

Thanks, this is really helpful for the 'Split off nVHE code' series. Tested
them together and things seem to work just fine.

David
