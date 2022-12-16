Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB4C64EFC0
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiLPQvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiLPQus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:50:48 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC7F2F67C
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:50:00 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n3so2146598pfq.10
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugnAwOwh/FSBH/fpXrZh26QfpVqE92ljRImza3TOQyg=;
        b=epq1B5czOF0NfOrIQbTxTE+wUbHwun/A9EED6mnhA8GpCfv5TmK7jKx/wvvF2iTi3o
         pojWTVDqlgSAcSDSE3hFeV/mh6qwVKVEe28trmqJAzowHNOFmCKMZqddpOhmG1FonBq1
         qhqmTY5CoqGGxWhXmlqsLaNNekfV2/d9LfARUDA31k4/kUJGZkVLutIyQULX6eJHq8so
         aDuKWqz+1BAfTsbSbgvPJR8dkitwIlRKmASebAMrPbr+EFcyjC+Xv1nX6LqTfn1bz5j4
         A7zQW7aZfMI0FAQkg1hCjgDj6SVVHUEeqA29rqz2h9G6s/1pAM2PBGY0/z/uBA+iG0zR
         snCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugnAwOwh/FSBH/fpXrZh26QfpVqE92ljRImza3TOQyg=;
        b=XU6FvT4G2qoVbLxEmsa1IL84IzC9jpENvccqiBhGKPMXPZeIEFzctPHLis1y3iGqNr
         hLRChUr9KdP+hJAgi7jxhJ1zPF+TvdTiL+kZjCwBTLO+ColOH2T/nMk5VXdn3JicOOy+
         iKbEM0gwkEHL+tOl/2jFC+SinOHbbNepsmQhIlPPuZff5WqtgyARVc3xkPIV3+bOS0d1
         CJd9DB5C5XmAZCCrpkZDlFOOtTgwa5Q7/EgY4AVo1hO8Mf6P/35CnZVAWgxM8h7GCGKW
         +K6GRKiLSX0jrN+0xFBZ5EV0qEcZ0IdXuu6tf/wVaBN+s/eWgxcERTwHrD1wiUwX/Ai9
         sl+g==
X-Gm-Message-State: AFqh2krS5m9DMX+X2pyMWX77SaU7FpoagJCKBGpMpjPN2Us6BzzzpCvC
        QhIdUxLvW3Nr1eWcsMFVD85xvg==
X-Google-Smtp-Source: AMrXdXsou5gMAOrfox+dNfuFcfwIIOv3F9NdVCunJjHH3K/A3ct/OjkJXdFgKflbI+SjQGAiojIP2Q==
X-Received: by 2002:a05:6a00:418f:b0:576:22d7:fd9e with SMTP id ca15-20020a056a00418f00b0057622d7fd9emr625648pfb.0.1671209399655;
        Fri, 16 Dec 2022 08:49:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a3-20020aa794a3000000b005750d6b4761sm1703145pfl.168.2022.12.16.08.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:49:58 -0800 (PST)
Date:   Fri, 16 Dec 2022 16:49:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Remove outdated comments in
 nested_vmx_setup_ctls_msrs().
Message-ID: <Y5yhs34E169ol+qE@google.com>
References: <20221215100558.1202615-1-yu.c.zhang@linux.intel.com>
 <Y5tmFKPj8ZX2GgUY@google.com>
 <20221216014538.3yx5mnmwz2vaa5cy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216014538.3yx5mnmwz2vaa5cy@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 16, 2022, Yu Zhang wrote:
> > 
> > Eh, just drop the comment.  Pretty obvious this is for secondary execution controls.
> Thanks Sean. Well, I agree it is obvious.
> 
> This line was kept because there are comments for other groups of
> control fields(e.g., exit/entry/pin-based/cpu-based controls etc.)
> in nested_vmx_setup_ctls_msrs(). If we do not keep the one for secondary
> cpu-based controls, we may just delete other comments as well. But
> is that really necessary? 

Adding a patch to delete the various one-line comments is probably unnecessary
churn.  The comments are kinda sorta helpful, but only because the function is a
giant and thus a bit hard to follow.  A better solution than comments would be to
add helpers for each collection ("secondary_ctls" is a bit of a lie because it
handle VPID, EPT, VMFUNC, etc..., but whatever), e.g.

	nested_vmx_setup_pinbased_ctls(msrs);
	nested_vmx_setup_exit_ctls(msrs);
	nested_vmx_setup_entry_ctls(msrs);
	nested_vmx_setup_cpubased_ctls(msrs);
	nested_vmx_setup_secondary_ctls(msrs);
	nested_vmx_setup_misc_data(msrs);
