Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1B68F119
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjBHOq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjBHOq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:46:56 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EA87AB3
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:46:54 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m2-20020a17090a414200b00231173c006fso1939844pjg.5
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 06:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K7RdkiYdEwT5ArxsEoVVFpqBmlXV1ft5ToNCy1aUUX8=;
        b=Lm+cD966bOaY0FMZUVQREySn37LI5igtbI624yU1j1hZE5MyfF/qG9jYi85t4Ut01P
         H7DWid2NOoJx5WItVbe8/XFrsRW5EbrqPJWSWXePQSHX6rSJeqBBjcOd2CxMGsj4Qa6N
         k9G1OX9oGFzLQqYwJVJNLJAEOSMaaXGRYAnMAiexodA3YlRX1I5qCpyFxzywPYudQb68
         COmpdq9HeBcYujWcSBhLY5u47SvGSREPpynX4qLVzNmOfUzAieNCbC7atwZbBWgAWLqZ
         EOiU1/GwC6Hu2MJU0pZTfGD4tbIArXSIs14hpssN7vtypkbNdGTcxrv6m+7iVW2AOYLw
         P/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7RdkiYdEwT5ArxsEoVVFpqBmlXV1ft5ToNCy1aUUX8=;
        b=XvHrQuv1jN/bPiL/iNsLPoaCx0EXDcme0FP3Qi25XUxJlM7iTvfqd3EDC8cSH436qc
         3XixDMqfaiHpjY0TFTm1XafO5fjGctdNaHRGJRtjYUZZwc5EXukiEC8H9zhBRbGi5HPY
         Qy/YYh+Vxhu35NEa5vEzXFHdbjDXms5XZ1Al7MLCExfGUkGrVZ0KJdb/gIfKDMs64iqR
         LPjeeP2HOtMydikKrFCqY4HlPAgznWJq6E6I077g1RiEqu90GlQP5Pj4Tp7lWBa0/II7
         OArJFvEJaoNp0jf0dhcs8hb2+ZeorMOSkeDmuPQxjfm8jzo5YYWjJhoWUBWPBpeXS86M
         AYkg==
X-Gm-Message-State: AO0yUKXSYWifpaG9iu2LCkKkhrFmiRfx+X/GW9lirjJHs/RjaKL46PEP
        FtmUfH7v7mZ8sPycIv51l3uV95lOr2tDRFmb4ec=
X-Google-Smtp-Source: AK7set9U9frlmZ67ZD4Mkgioyt9UyB1tayDJ9IR+l/gtRBa/1L+qXWUz8qUezgDgempjxvIv69stlQ==
X-Received: by 2002:a17:902:8a91:b0:198:af50:e4e3 with SMTP id p17-20020a1709028a9100b00198af50e4e3mr231863plo.9.1675867613287;
        Wed, 08 Feb 2023 06:46:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902c3cc00b001949b92f8a8sm2404383plj.279.2023.02.08.06.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 06:46:52 -0800 (PST)
Date:   Wed, 8 Feb 2023 14:46:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, shuah@kernel.org, dwmw@amazon.co.uk
Subject: Re: [PATCH] KVM: selftests: Clean up misnomers in xen_shinfo_test
Message-ID: <Y+O12SuLQYU7Ic05@google.com>
References: <20230206202430.1898057-1-mhal@rbox.co>
 <167582135973.455074.10130862673762989635.b4-ty@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167582135973.455074.10130862673762989635.b4-ty@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08, 2023, Sean Christopherson wrote:
> On Mon, 06 Feb 2023 21:24:30 +0100, Michal Luczaj wrote:
> > As discussed[*], relabel the poorly named structs to align with the
> > current KVM nomenclature.
> > 
> > Old names are a leftover from before commit 52491a38b2c2 ("KVM:
> > Initialize gfn_to_pfn_cache locks in dedicated helper"), which i.a.
> > introduced kvm_gpc_init() and renamed kvm_gfn_to_pfn_cache_init()/
> > _destroy() to kvm_gpc_activate()/_deactivate(). Partly in an effort
> > to avoid implying that the cache really is destroyed/freed.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [1/1] KVM: selftests: Clean up misnomers in xen_shinfo_test
>       https://github.com/kvm-x86/linux/commit/5c483f92ea7c

I force pushed to selftests because of a goof on my end, new SHA-1 is:

  https://github.com/kvm-x86/linux/commit/6c77ae716d54
