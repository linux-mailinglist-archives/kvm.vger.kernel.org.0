Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CB0598B6F
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 20:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243478AbiHRSnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 14:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiHRSnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 14:43:19 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFD822BD6
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 11:43:18 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f21so2540009pjt.2
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 11:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=EZNPdtAkUjL/8BisHyi/e90Lqm2n7xYyH/MX4BS/mJI=;
        b=FEjTdfql9SwI6lhmhc97t1ZtELcAgbAxG0SePXOV8TOmtzp2mSJ4SeoMQDtR3T7YDh
         OoZPp6dEOADgOes90rFdoaHD3Ez4Y7IZ0EKo5kGfNUQnp7MPhI6Y0zN+/Z+iI20B7Q7U
         7sChdSUkown612Tq19eah2lx1yTd3L/20vitaaP22dKGReVuS+/mgE+/rt4BQX5KKwvH
         nXQyBr4uIw5d0svzwcC6epe5Uft9TnydsPgYw4E9+ifY1NWCFqVfavcW0eQLjwEMul6h
         KoOAbQwdmzP6kjLFyb/Pq2Q5T4A8KONRJD1HDfw/1WPbJAHQPX1MUe26/2ZzVa6FRC56
         7fSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=EZNPdtAkUjL/8BisHyi/e90Lqm2n7xYyH/MX4BS/mJI=;
        b=hkn4fJIWfDYHD0CexuNZU0RSWuUZgj0u2Ge6ieKhnjVELc7TRdV0QWE/Ug2IyE116u
         ELMKSec0XfshXo4dPB1oLtDNZ7/uYlyRwDxQp9kfkJ3Eyc7OwkiEcGWwXanAyfdSfSTn
         PrG6NfhO5CRyEZXOA1Nu/7KH4I2hMG9h1QYJCm5ZjoFwJZZ9HxB9A6lQTXgXspFsPMpW
         +QVp1H4yEYnVU3GyCV4XGULq0k3At7G0PTS3J6m4snDkaKVHSxcYPMfefjUIlgEVu1Rc
         toBBg/65EBAGl8oxrOfP6PxJBJrI0DU0gZ3owAjUTHo70SM+/U+qEy5tnGAiG19sXgbG
         QvLg==
X-Gm-Message-State: ACgBeo1OeZfAjO/cSFGccz4c7qU3Pvxw9ZlUKq6WqpSHeRPf/4NsEoL7
        37XDWTH4QgWLPVlf0Tkhh+ptc+TZAMGE/Q==
X-Google-Smtp-Source: AA6agR6j5hVPUABlfWXPoMjpcOuCJpF40QAcXSOrLn3IVNtcrFJ5fmKXQBvzoBmKH3sBVPirdX9HFw==
X-Received: by 2002:a17:90a:c283:b0:1f8:a3e3:f937 with SMTP id f3-20020a17090ac28300b001f8a3e3f937mr9868336pjt.141.1660848197820;
        Thu, 18 Aug 2022 11:43:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s138-20020a632c90000000b0042195f31243sm1600965pgs.74.2022.08.18.11.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 11:43:17 -0700 (PDT)
Date:   Thu, 18 Aug 2022 18:43:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com
Subject: Re: [V3 11/11] KVM: selftests: Add simple sev vm testing
Message-ID: <Yv6IQW5wa1doLbQX@google.com>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-12-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810152033.946942-12-pgonda@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022, Peter Gonda wrote:
> A very simple of booting SEV guests that checks related CPUID bits. This
> is a stripped down version of "[PATCH v2 08/13] KVM: selftests: add SEV
> boot tests" from Michael but much simpler.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

If you're including Mike's SOB, then he should either be credited as the author
or with Co-developed-by.  If the code has been significantly rewritten, i.e.
carrying Mike's SOB would be disingenuous, then do a less "official"

  Originally-by: Michael Roth <michael.roth@amd.com>

or 

  Suggested-by: Michael Roth <michael.roth@amd.com>
