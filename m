Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74083D733A
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 12:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhG0K3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 06:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhG0K3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 06:29:53 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78477C061757
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 03:29:53 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id g15so14611535wrd.3
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 03:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sEVmfuf6SAseKM7IhWi4Jb0Zlgwxa7yzUBD2vot0gXo=;
        b=jbMwd6Vf/veIiSMmFyck6MkZinWyb8unn2adULZu5hHXgBtUJvqcr7kHGRoDFsLTVF
         Ht499ehIBB/nonP+vrMAjoWud6FMfahyup+Xc0MfU/qds5iHMcnX9oDDtGxhXfsmw2jQ
         bOA+6T18uhuWrPr7HOF9DqvemNutUfebyAiFbMmlsk90+4cfzU35BkGVuzCOjlJzHABS
         Cpt4iwJFPDMjI6lmrKwLeQlrPdYPUWBMpzRnzxhv7u586fgB5yOFDr74Z++FKEHYj7hv
         vjMZy3Xh3I1JPjwJNfnFXsagRYMzf2VQSW6ySqNJ1lvGEY6NX0bBn2Dlb5HaqspF7peF
         dfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sEVmfuf6SAseKM7IhWi4Jb0Zlgwxa7yzUBD2vot0gXo=;
        b=ENzMiiTSe5X0qefg18agfVTh/5Q0kzryOLsst2QGKl+DqA9ak53LzYaQg8LTtPD/Vl
         erFclH6VHTt5GXb78DvxgAu5JrGEgA0WVgiIhFnbrrGnzfrTMCGhwFxrKpAHTSlJHy0l
         rQdmMa6n+0pW5gB2qW5TUVJSbh1yMRAnCFoklxQo9iRNyz7b2fiClh10Hh8J57yLOQRS
         Cwa0S3Oav1QVDEKnm7xTgifswuVoQzMqRo7sw1nfC2EawwF3ZdcZklKf5MMVVsKoczQj
         WwI8K7I3lna6aFB8FNtEOcEHP+4paMYGwG80cFgDtNvUBoG6IYQg2M/aN77NuLIP0+74
         RHLg==
X-Gm-Message-State: AOAM531NRLeN8P/lehR9/94hrgJdvZssTvbUfwS2bmWO1710kZ5uPQ6L
        /0WMUPWaMWcJtboUhvFzs8YR0A==
X-Google-Smtp-Source: ABdhPJyl4ddC3yvRFr3OUCBwgPccE+P0sn15kKofTfKQowfSw6BB1YRonRXV/ZY3mD3e5qu7Ph1vew==
X-Received: by 2002:adf:f64b:: with SMTP id x11mr14340461wrp.155.1627381791958;
        Tue, 27 Jul 2021 03:29:51 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:c468:e033:fa2b:3a6])
        by smtp.gmail.com with ESMTPSA id w18sm2928774wrg.68.2021.07.27.03.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 03:29:51 -0700 (PDT)
Date:   Tue, 27 Jul 2021 11:29:48 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 1/6] KVM: arm64: Introduce helper to retrieve a PTE
 and its level
Message-ID: <YP/gHGfhXgBBe7iD@google.com>
References: <20210726153552.1535838-1-maz@kernel.org>
 <20210726153552.1535838-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726153552.1535838-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday 26 Jul 2021 at 16:35:47 (+0100), Marc Zyngier wrote:
> It is becoming a common need to fetch the PTE for a given address
> together with its level. Add such a helper.

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
