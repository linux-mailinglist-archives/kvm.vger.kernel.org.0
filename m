Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148BF3759F9
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhEFSK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhEFSK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:10:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BBAC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:09:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so3938542pjb.4
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l5Dlc7w4uK4iSr1bdMuCNZxN2DjDbFLny4tbxIzPuBY=;
        b=E+W/dEwY5qRJzzQ4l3Mzn99iYZ7namyy9BScjSIpURrAtVGs86EaRBnyXGU1764fdg
         mivqI78GlkIQRKFiFWMfSacOABd5GF6uGqHX6nH5Z4JPZUzn1EFPXrZg+dPTatciTTTZ
         5AsiT0xbalr4SIrH6zzxEpwwv8voZKFxQ+1EycQ4VHvlbFTrP0W4jYnwjGI+G66mS+dO
         R9punUTI4mSjQy9kD19+Ufz/tzm/zxNdCWaW9vi91fPijzgN9vglIhj3hMErKF5y1/kH
         gNY6aRDqsZWtP4NrMWuARWVaG9Z+nA+2xf3eBy7ODZmosswhNFQqlEDZVlJkyfxD2GMz
         P5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l5Dlc7w4uK4iSr1bdMuCNZxN2DjDbFLny4tbxIzPuBY=;
        b=bLXy1tWEhJkFJkT3r7slW1B6Sepnmu0hHliNvsYxuEmMm9xkK17FfcM8noaiHXgOID
         q3+xFR8PWfphsU5mw3Yw6g0Ytaa1UbyMDFfYksWxOd06yI/9a/YfGqZ1yPGhiomcpuL5
         gzI9pZg9KRhB5DE6SR4CGOa+1cMb4c1NwOO2rTfq0nekcMr7Q4y7nDz0i0VJYnIku5+Z
         EYJpwB9Pc+R6menGhRtzu+K6J71WcwHK0OE2KjwgZ1u2+85opjtdqcQF1nIzOdesOTeB
         3IsHOY8fwTWS+RDIKwax0WlqVhfcu8CFpmSpzC9EeecOkhMVhcfHsZ8wpqTjgThhKTQ2
         TQsQ==
X-Gm-Message-State: AOAM532q4MC6Ss+RLnoczJtxHcorcKd2PqjvIDGLNzBt1WRHBnh3ZAMK
        KGyNYPkilp7RQ8fLwwzNOFwdtw==
X-Google-Smtp-Source: ABdhPJwPBwkpBMkBxL3iJJA3EPNFDRDiv0AKX8+SqHOc4r48pf+Yw/TqpQF97siXvVV37A2ZSn2/dA==
X-Received: by 2002:a17:90a:de17:: with SMTP id m23mr6126632pjv.16.1620324598850;
        Thu, 06 May 2021 11:09:58 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y190sm2570658pgd.24.2021.05.06.11.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 11:09:58 -0700 (PDT)
Date:   Thu, 6 May 2021 18:09:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     brijesh.singh@amd.com, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Message-ID: <YJQw8jlJcPO9ImNO@google.com>
References: <YIpeKpSB7Wqkqn9f@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIpeKpSB7Wqkqn9f@mwanda>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Dan Carpenter wrote:
> Hello Brijesh Singh,
> 
> The patch d3d1af85e2c7: "KVM: SVM: Add KVM_SEND_UPDATE_DATA command"
> from Apr 15, 2021, leads to the following static checker warning:
> 
> arch/x86/kvm/svm/sev.c:1268 sev_send_update_data() warn: 'guest_page' is an error pointer or valid
> arch/x86/kvm/svm/sev.c:1316 sev_send_update_data() warn: maybe return -EFAULT instead of the bytes remaining?
> arch/x86/kvm/svm/sev.c:1462 sev_receive_update_data() warn: 'guest_page' is an error pointer or valid

Thanks for the report.  Is the static checker you're using publicly available?
Catching these bugs via a checker is super cool!
