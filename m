Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DA137B097
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 23:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhEKVOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 17:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhEKVOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 17:14:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90840C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 14:13:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so2108372pjb.4
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 14:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=udQopo09yiN7BZym6iPBJj0HRqYBWUyaKZOwZTHYUDc=;
        b=QJctDFxBQkbiWCVjnD3yaN3HqYZ3ZwawGEkBFpKdJjyDut5/gOpJoi2lEBoi8qlULw
         HfCostyZDeec6fRZ70/0nUQV8mwOJ7rFXRj12AQI/HOH36woylcL7ASmk5r7yGlQobFa
         r2UFzH50p3N9KVboF96rvz7ZbcyZ/mmTLGJDvu8+qhwsWnWhLpyu5A0BNyQoVMw2LTlc
         +I7HEEBTdt5RkqpS+7ituaTCrh1eae1/RJjweuuTPJcEid24Lb2ovyejIElujIIqT4y0
         H52HZDaacuJP6IickdlwW4F9CYxp1kUnVU5A9vdyf+3F3W6uG7VSWpm1mMKxKuKkeK/j
         rPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=udQopo09yiN7BZym6iPBJj0HRqYBWUyaKZOwZTHYUDc=;
        b=OTQePlMcMkxFGlCUOnEwsTiIK0J5qEaGvRQgHhSJ+V0iMp7glNJKtQQZR7a7uMaudf
         rDIeamesny9HTcGvZmhK0pyK4a82ky+D3DqWNmRRDxoHOQHPSOUUzmxY9x7eSz6f/yMs
         Gx6gWaFdru4gJ273jkhsYaBu0VMAzpdpT61T/SqiXQLVRCXtyVIdoBWV4XQ1xjxr5fo7
         UuTvNmEDIcL5LMIOrac6JQOKLqw5+tjW2l4SKw/gxmY23i5g2G22SO2J6ymIaVWzFE15
         YQtIuFPYItAePWY63XoX3KxXVtmk97bx6dtYhciuesP9Ti64fuJjOHgCRsL48N0nAme3
         eFow==
X-Gm-Message-State: AOAM532R/1SCpwgJ6EuagdEYoZuKe7UhzdOxxCPOri1OVu4ZBF3tFXBj
        ys+mZg0WsRgslSWmF2nIE9VJTw==
X-Google-Smtp-Source: ABdhPJxEXv59fde7v4QVBK4b1vS7G8DygMQIUY4cgxYS1Rcwyw24n5ZflTts6O4EGpKEguXAEwPmwg==
X-Received: by 2002:a17:902:c214:b029:ee:de19:9ae4 with SMTP id 20-20020a170902c214b02900eede199ae4mr30899581pll.57.1620767590370;
        Tue, 11 May 2021 14:13:10 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w74sm14327277pfc.173.2021.05.11.14.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:13:09 -0700 (PDT)
Date:   Tue, 11 May 2021 21:13:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jacob Xu <jacobhxu@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: remove use of compiler's memset
 from emulator.c
Message-ID: <YJrzYVJXs8gNBPmF@google.com>
References: <20210511015016.815461-1-jacobhxu@google.com>
 <20210511015016.815461-2-jacobhxu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511015016.815461-2-jacobhxu@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Jacob Xu wrote:
> Per Sean in discussion of the previous patch, "using the compiler's
> memset() in kvm-unit-tests seems inherently dangerous since the tests
> are often doing intentionally stupid things."
> 
> The string.h memset is already imported through libcflat.h, so let's use
> that instead.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jacob Xu <jacobhxu@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
