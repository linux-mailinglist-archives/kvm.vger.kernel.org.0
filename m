Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DF076F690
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjHDAlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjHDAlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:41:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8750D4219
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 17:41:00 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bc49d9e97aso5683765ad.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 17:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109659; x=1691714459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4gublzeLEVLruE6FnjFWjpgufJL9hFIzfNhqjHnShw=;
        b=Uv4r9k+HDQc9YeQ3QiNH60v1HjfkAv74BdKPLJBAyjHMIzd4Lgpko10grlMOfyjAo1
         tJ+hIOI/kYnpZdbRyZXULqwUb/x9sVu73IeqHhrqvfPmd3I8nZmaGBHsNlURLSp8GPRR
         9iGN9nfVh7Rt9Ca0JFGMErHQM31Z2rOZK//w5vRL8neLQ8DG7K3Gkr/d9w0JwYmXbde4
         pVZKAfXkuPdEhTxdStKWOr9lyj1tpeCQsro8hIHAn32fu4kkIjpoO7Sb+G9X4YC6DyHX
         7ItpaqlwJCFgMN2iCCZ9fnuMh98kxeczN3mARgGBdvSGiZO1aP/HQJbPX6xo/gTurdE7
         hwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109659; x=1691714459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z4gublzeLEVLruE6FnjFWjpgufJL9hFIzfNhqjHnShw=;
        b=jC44xYuaW+a7+omdoTmZWJ1W8d7TyEjlEc8+9u4jfIrasQV45QfHyyo53HkTIPMItN
         Jz1bZl9poyl3eSUvORgI/aJLG92UioW6oD1We0gELCFCi6CZ9J6ZtSRJOYqtR0KjDfX+
         eewGeS9fgPeKVKqltCDrFctw1YgQd2ql1ghEbFZ0MnMZ3jhYRS2JinCuxTPEnCGfwQ71
         iCgzeH8h5TRI5vMpNfjfjy2gxl4UOzRIGfkfdB9A/CJYeLrguLB/3kFJt3aG3rh3yjcD
         c0OSJrpUfClQdl6Qep4uSPsqYWue8MPXmRMcSi0KFQACgk6ExSpbaSXTjxev0hAFX8FV
         JlNg==
X-Gm-Message-State: AOJu0YxoU8pkbSwxhcQjDLFSukhm8XbBoUn+QaZdQ7KSluWhw4D5kS9X
        wTvpJ3kz9NJhWeKxg9sfaUzL4JVL2q8=
X-Google-Smtp-Source: AGHT+IGFlL6n9YGTwH03rLO2nlc+RpxsqqOCGJ9MVAH2kmtmlw8jDHvNH425dSHUElXXEbevC4zwgkIEAgw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b682:b0:1bb:a13a:c21e with SMTP id
 c2-20020a170902b68200b001bba13ac21emr1140pls.10.1691109659628; Thu, 03 Aug
 2023 17:40:59 -0700 (PDT)
Date:   Thu,  3 Aug 2023 17:40:28 -0700
In-Reply-To: <20230802022954.193843-1-tao1.su@linux.intel.com>
Mime-Version: 1.0
References: <20230802022954.193843-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169110477096.1973451.1256801276984611165.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Tao Su <tao1.su@linux.intel.com>
Cc:     pbonzini@redhat.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 02 Aug 2023 10:29:54 +0800, Tao Su wrote:
> Latest Intel platform GraniteRapids-D introduces AMX-COMPLEX, which adds
> two instructions to perform matrix multiplication of two tiles containing
> complex elements and accumulate the results into a packed single precision
> tile.
> 
> AMX-COMPLEX is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 8]
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
      https://github.com/kvm-x86/linux/commit/99b668545356

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
