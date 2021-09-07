Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C851402FF1
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 22:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbhIGUxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 16:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhIGUxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 16:53:33 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50BBC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 13:52:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id l11so2198035plk.6
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 13:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZD4j0dIbXDPxZzB5zy3lU+EMIURf4JISQ9XraoRzmVE=;
        b=gs6NtmfnkLqF9NVivjccT/E1NM1MuGNlQW4c1ayJ8Z6wS1p43MFIKGf+qz+2YzaBi5
         cjFMNmIH+QwmLP0myg/0tYxRZBel2yEaQ8FT8eYHdmebz5CU2rBzEhgn3AWt40v1G7G/
         db3kL5u9qkAgwfHDm1mt9I/HfhgBw8VIB7MyyRJXxZePCpncWHRotTBSDZ8oa+cFR/hC
         Sk+lUc1Q9NJp7oJooz3BQ76611abiiunlfiUC9MeJAIg5fMRF+aPhfWKNNvaGPUCUxCS
         oXxwwSOElaIoXrofOXZBbb3y1UwCNgK9IpSGbB3jAJBXwiD3peBx+hFsFsPimE7B2gRN
         n7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZD4j0dIbXDPxZzB5zy3lU+EMIURf4JISQ9XraoRzmVE=;
        b=uOawCq1Ex5GyTWy+MJsg+MZTbycoyrYnLZ8zwAs9/qeNEv30WjvdDUSydUI5itm6/B
         aWiTRM2lroBxlmi0vblbaVnOGGg8OSJxW9/fC7GgxjZDBlOzTDDwLmSGLgyP8sWzrL0i
         7wK5uiXW6L+lvvjfp0PnacKYkdO5pL/b5ksPrd6vFwv6BnxORkKrXlcU983pC8bXcgkM
         ssmGMH+2XBIiLIAFlnYeD5v6giXjsvKloaeucRl/OqP7hXfuyd9gh8RuuBRvWJj331My
         YFAW+NRoYozV9RK01qgF0U+OMKzEe3NsOpHuVpl2enTC3DRDo+XJl0BnsJC2KkR9B3C7
         63ig==
X-Gm-Message-State: AOAM533yHRiJQRfhFjJxDOOQnRgKEzAym7ZrMppoFEAX2fua8SxJ42zH
        8w2ubVhcm+MZeDZ8+HHW8tPkFg==
X-Google-Smtp-Source: ABdhPJyC9Rx5xBdPvu6Zi/Z25HeneZXtf+yUR+/2WJKZ4jkwTOc1Gz9L+IBv/EcXZiBZ+PDxdv5Haw==
X-Received: by 2002:a17:90b:224f:: with SMTP id hk15mr343120pjb.134.1631047945599;
        Tue, 07 Sep 2021 13:52:25 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h8sm7120pfr.219.2021.09.07.13.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 13:52:25 -0700 (PDT)
Date:   Tue, 7 Sep 2021 13:52:21 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
Message-ID: <YTfRBSs3Y1OjNH5u@google.com>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907181737.jrg35l3d342zgikt@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907181737.jrg35l3d342zgikt@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 08:17:37PM +0200, Andrew Jones wrote:
> On Tue, Sep 07, 2021 at 11:09:55AM -0700, Ricardo Koller wrote:
> > Enable memslot_modification_stress_test and memslot_perf_test in ARM64
> > (second patch). memslot_modification_stress_test builds and runs in
> > aarch64 without any modification. memslot_perf_test needs some nits
> > regarding ucalls (first patch).
> > 
> > Can anybody try these two tests in s390, please?
> > 
> > Changes:
> > v2: Makefile tests in the right order (from Andrew).
> 
> Hi Ricardo,
> 
> You could have collected all the r-b's too.

Thanks Andrew. Will try to do it next time (if changes are small like
in this patch set.

Thanks,
Ricardo

> 
> Thanks,
> drew
> 
> > 
> > Ricardo Koller (2):
> >   KVM: selftests: make memslot_perf_test arch independent
> >   KVM: selftests: build the memslot tests for arm64
> > 
> >  tools/testing/selftests/kvm/Makefile          |  2 +
> >  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
> >  2 files changed, 36 insertions(+), 22 deletions(-)
> > 
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
