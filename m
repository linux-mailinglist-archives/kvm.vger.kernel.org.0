Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1847B3868
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 19:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbjI2RLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 13:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjI2RLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 13:11:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8912A1AE
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 10:11:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-57cf261194aso15954986a12.3
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 10:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696007497; x=1696612297; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=20euwIYJH+DGbEnMSrsD3cdcsFe24zikSuEhIDKFhWA=;
        b=TLJG9UWuiEASlWs4/pEcBQvXTjKH/kHHwaQC+EIXlQrhJOZWa1Vq4lTY6xy7p1nmY6
         LxzDxpQgZ9v2UK8G1vtUPcDky0aDJkXqCSWjhKqixh4y1eHWmSLwLk9mrii+LMslYSGP
         2S6koCvJhTnWe6TorhmiyE3/PQVwdE/C1W6v5rloBnIf010edFuwS7tLk5NpxEcl5e04
         xW0ca6BSdyFQmzFbU1KtHZRIEV0emQjlIJyT4sW/uxTT/gAlazxVTqr3CjFB0CaWnarx
         1UQMX6bQ41RKPe+xOpDRG1SKI/G7ahWfpO7CCtTIIxQHYPv+UlRaiODW1urGddZIX3RI
         Hdjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696007497; x=1696612297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20euwIYJH+DGbEnMSrsD3cdcsFe24zikSuEhIDKFhWA=;
        b=XOZCStVrv3hqdUBrT/iI+9mgXGi30cOyIvd1u7IwHIb3MxNGb/X+ycXjJqfW3nIGYR
         jtJ2PK0u4+kW3m1FXwBnc7qXAMmD/fqJgUlozMMsE/2MRxQE0adIosstngRA4sox+2L+
         aEVJ8A4QpMkU2JlQ1fFXhFITAixHenOuc4CVIlCg6ih8BGSQ9oMGwlp1y9mQVIsskUuy
         JaKjNoqSFz4LTGwofVFfmxb5aaNWcu+i4PlatXz2VRxV4NJSqkEpMqKr9+wvol7coHma
         navfSzCf1iQYBDFGT/88iysuJWUJCFVxL16YMrDT+XsDDugRZmBgXtSSq3b3/TGqyCAj
         CMMA==
X-Gm-Message-State: AOJu0Yx93SLtIbMF+ojxJyDYk43yJAnqt9ljfB7y7t8eJ+MN1LMKngza
        qZt3cJTYyYhRi2pPcavffXzB1dP3xuE=
X-Google-Smtp-Source: AGHT+IESWcvy7PGhStGPZMamrCN58SeRLjezVmLR//RjaC0b1cG7LEUuZb1rsJeooLxEYJjBDTx34dVdhVA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e84d:b0:1c3:77cd:6520 with SMTP id
 t13-20020a170902e84d00b001c377cd6520mr64509plg.11.1696007496959; Fri, 29 Sep
 2023 10:11:36 -0700 (PDT)
Date:   Fri, 29 Sep 2023 10:11:35 -0700
In-Reply-To: <CAGD3tSxPDVb9sN1g+gTV5SykY57Szpx1SjEcmHJvK62u1fiXmA@mail.gmail.com>
Mime-Version: 1.0
References: <20230913000215.478387-1-hshan@google.com> <169592156740.1035449.1039175365762233349.b4-ty@google.com>
 <CAGD3tSxPDVb9sN1g+gTV5SykY57Szpx1SjEcmHJvK62u1fiXmA@mail.gmail.com>
Message-ID: <ZRcFR6Tf-9QzfbnD@google.com>
Subject: Re: [PATCH v3] KVM: x86: Fix lapic timer interrupt lost after loading
 a snapshot.
From:   Sean Christopherson <seanjc@google.com>
To:     Haitao Shan <hshan@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023, Haitao Shan wrote:
> Thank you very much.
> 
> I do have one more question. Is this fix going to be backported to
> v6.3, v6.4, etc? Or perhaps that will be a decision made by other
> maintainers? The reason for such a question is to decide whether we
> have to keep the workaround for certain kernel versions.

It's tagged for stable, so it'll get automatically selected/backported for stable
kernels so long as the patch applies cleanly.  That won't include 6.3 or 6.4
because those are already end-of-life, i.e. not LTS kernels, and not the most
recent release.

If the patch doesn't apply cleanly, e.g. I highly doubt it'll apply as-is for 5.15,
then someone has to do a manual backport, where "someone" can be anyone.  Sometimes
that's a maintainer, but just as often it's someone that really cares about fixing
something in a particular kernel.
