Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1B391E25
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbhEZRbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhEZRbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 13:31:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9569FC061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:29:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t11so1216032pjm.0
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 10:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zxcwJdMitJagdoUHLIPfOd7FzZjdzJOPb4YTYoW3nPI=;
        b=u+mlRBqhXwN50NmfvFgzDxZcIXXTbUCbiXZlJ6c7lVV8C3cSrP1Pv9bnx1BLDEx1fq
         cSu6u5D7AyDjkdFFLI822oe/1vnSDeyYLeRxwVfFQ2kFIkglBHBGcEhpG5eNQmv/mD4D
         kFMPSa5kH7eNQOiVdcfJ9iGdWiYl6KKvWZpHHRwo8SO5BZwu2X0vBULg2A+zr/RicDAZ
         IYnQ4SY8ymoobptF0GphGKMefjjWEbr63C/hqbo16jannOYLunu5VcUyntmwdS4A4sIj
         +xcgq1sL0xw9G57DAPlrF+mz7nm6YBTpEzohppL4CLZpF96BZHmBSVeQoNy1Yx3c/5rU
         k9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zxcwJdMitJagdoUHLIPfOd7FzZjdzJOPb4YTYoW3nPI=;
        b=smKAGpFsK7ygH0xRI2bNIgbrMG5X6Tl854iWS4t56CHJov0HtCvF3gm3tfv7zp+hQn
         D3vDYGBDzWyCVh2proQi1AQtTf+Wz2xvNYiHV9zQjCIeUgFP2BmxSawuyECrQVDK0dPt
         r1zCpOEmlN3LL9tPSOwWQtiaoxoFN+4PWLdsvOWaSA1b0GlGYCVa70JOlukX40x7okbx
         LSlZxHsDcyll0QdAthi6ve0T4hzCB/GVrm5pV13tDdf23jLdW1sbB5QC2IW3RHquAoAE
         Jmex+j1ncIiZhLjuEPJ1YyF7ozfjwniMK5IbqqS1c6QUMocZ0DG+7V7wI5wszJK6eeT5
         4Ckw==
X-Gm-Message-State: AOAM533m+sGwFLOEltk0Nj+A2eak7vcCqJMsDl5y+Brkn8NbpwKoLV+0
        3EAe9akF9cHb0vDg1tBqj6nxhDEWPPk0Pg==
X-Google-Smtp-Source: ABdhPJwDUUoDCsXbotSL+sh3sDSo0nHTpVUko/FtHZT4BdWgCasfYVpF393baQS8jU4/ovF0p5z/Lg==
X-Received: by 2002:a17:902:6501:b029:ef:8518:a25a with SMTP id b1-20020a1709026501b02900ef8518a25amr37122355plk.64.1622050171045;
        Wed, 26 May 2021 10:29:31 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t19sm16669158pfg.70.2021.05.26.10.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 10:29:30 -0700 (PDT)
Date:   Wed, 26 May 2021 17:29:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix comment mentioning skip_4k
Message-ID: <YK6FdtswnFklJuAO@google.com>
References: <20210526163227.3113557-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526163227.3113557-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Put version information in the subject, otherwise it's not always obvious which
patch you want to be accepted, e.g.

  [PATCH v2] KVM: x86/mmu: Fix comment mentioning skip_4k

On Wed, May 26, 2021, David Matlack wrote:
> This comment was left over from a previous version of the patch that
> introduced wrprot_gfn_range, when skip_4k was passed in instead of
> min_level.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com> 
