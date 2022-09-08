Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17DB5B29C4
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 00:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiIHW6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 18:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiIHW6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 18:58:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ED53A156
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 15:57:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so3696905pja.4
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 15:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/UkehsXQHuR4Idp4x5z8yZPfpovB5B00gX0cZoxw3sE=;
        b=JFvI+LBe3owau6mC8Hz2QOh23QeexiSC39e4tw2Z1hpnN/sR+ZM2Kv4IbYWTkOADmZ
         PUdGVuiSHsU8ngaqvH1VvONQidNiXcSKaI60RTqrzsTEDcSIMfZjjsOchRtQi65RkkTc
         RbiwviSZSb7qeCkWe+Hd9x7Keh1oSYFYeLRRDYDyWSLJ89hC6c7ulvfaI48q3ZIqyKiT
         5SIysznhIUMJme4VSYyJitjDc+prT2A5qdlNkkujeb/PR04WOhN6ueR5j0awqRYhPqmL
         pRJYcHSTtA8Kf4Zse7r34GsjUNJeq/8n3GnSnolTvUqZfE9TVVzFL7MCKD4dzR+N/1pj
         AyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/UkehsXQHuR4Idp4x5z8yZPfpovB5B00gX0cZoxw3sE=;
        b=EhkmsLtbIE3vh5rHJdMTbkSY+ya7+4xSyMcm3G38i8mydkzP4PtPwshS8zGLbZ5rNG
         z8HBUc9qFWM0ta0Fn5Md5Ys+4m/eDix5Yjb32HSirRGsO7YPMKQlGWKr6zpkv3Nc2x47
         VaspEPJnsEBMQNvC35LfSH0IPC1Ptp992f0SnDZs7y3f+cozUZOqRsxklII7uSYu3tb4
         vDV1zaGo65fkYRIUgLT9X1AYALe1ZE3Kbc4aI1cbyf6rE2cNr72zaj2ghA7ZonZof7EK
         TF/7YFGPibWGF2ON87y44qZT1lQY08iKI1di4couYZCd3ulMhkxFJS7W1FjkhpM4AAHT
         iB9w==
X-Gm-Message-State: ACgBeo01Src1GyTuCfQL4Dna7Gxiro1uO2JKP9igVHX5hxcIwonwpY3H
        B8e2YkwgiYvrn8FxdInDDSvjzw==
X-Google-Smtp-Source: AA6agR7KtwQ1kgqa9eVdvNOQiZbjLUejfBGPF5svnseUZ/OpS3g1QYPHiKXHFrc2rnPT+VfdLDmx4g==
X-Received: by 2002:a17:902:d4c9:b0:176:e833:4efe with SMTP id o9-20020a170902d4c900b00176e8334efemr10497775plg.108.1662677852858;
        Thu, 08 Sep 2022 15:57:32 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902a41200b001750361f430sm45085plq.155.2022.09.08.15.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 15:57:31 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:57:27 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, seanjc@google.com,
        oupton@google.com, peterx@redhat.com, vkuznets@redhat.com,
        drjones@redhat.com
Subject: Re: [V1 PATCH 3/5] selftests: kvm: x86: Execute vmcall/vmmcall
 according to CPU type
Message-ID: <YxpzV1Ir15n41gGK@google.com>
References: <20220903012849.938069-1-vannapurve@google.com>
 <20220903012849.938069-4-vannapurve@google.com>
 <YxpysbHZb2G56K+f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxpysbHZb2G56K+f@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 03:54:41PM -0700, David Matlack wrote:
> Please use "KVM: selftest: ..." for the shortlog.

Doh. "KVM: selftests: ..."
