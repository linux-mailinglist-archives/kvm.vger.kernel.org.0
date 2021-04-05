Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1CC354331
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241446AbhDEPKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 11:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbhDEPKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 11:10:47 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07D8C061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 08:10:41 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k8so8315237pgf.4
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 08:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zw+Uj3Uri4YqRrY4p/xa4exi1a5AHTCIvDkMfyoedoE=;
        b=JXSfnRk7RHc1Mn/x4OLPq4m2TyQglRLUBlAmt14gzBzkbv0xUtdlOMlctyUNF9atR3
         ONtiM+1/IIf97Qinc6CTM+L6cU/N9wDOGxDNVKNXFrMybItOzbHInjKtCKQ581DIpbTO
         GCJHFviQ6LdXoCO11pY8zXqHKTGXQG2+QNo89aMVBlnqFy9oXSi5LqYCQV3mKcTWhCfn
         XXHOFL6eYYHZpgz5H9qKoD9fk3szB0HYLrsgiDb9aainAr7WoWLiRIfGKUVsS5S2IdKQ
         tRvKNqmMApeGUI6XlZNSAEKoYriDeXXF50aEgzBvvU1qvoAk6/R6eOIAalEAuFe1U+7x
         oGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zw+Uj3Uri4YqRrY4p/xa4exi1a5AHTCIvDkMfyoedoE=;
        b=beDm3raDkNGFBjWhXYo5FR8jVmWcx0GABGrr3RLMnDizVMt2EbApDl1qRIkDyxCRzc
         x/6UtKnJRwXa+q/g0/cj0BAuNj88d/v6GyAA7nGmzhIeAG2fndKrkhMlm796UetsczRC
         JPRLCldgCFABZ6EN4uWLrRNkU9mIRpoE67iqPqaxkr3GTkHasA8fta/LWf9mbCqjVE98
         8Md/SI7qIbhdisJpSOnwv2FX0UjmIvnTb0JdPWgtW2JIGGOESfogzvkjcd79QXBNPZxY
         DQx597Z0pWdBWESLYezWiFXR4DJDAmyBM3rEr36cuNofA+4efLvqrM9YvFS2SIMZUv+/
         qCRA==
X-Gm-Message-State: AOAM532VBtzHxtbi8/QMBH2q+ChVqfOYayl1yvt2Ngm78iFHOlna0RGI
        o8FtMU4ZE0NKz7RznBPyLWRcMQ==
X-Google-Smtp-Source: ABdhPJyRmMaVKAj1NiaH70WHz7p+uFXlOZVDKcPTRfVXr5cFeGS+t+WQZ5tfhmzLmGaL9wx3GlBp1w==
X-Received: by 2002:a62:1a53:0:b029:22a:e4f0:c104 with SMTP id a80-20020a621a530000b029022ae4f0c104mr24392403pfa.10.1617635441093;
        Mon, 05 Apr 2021 08:10:41 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id q11sm15768144pfh.132.2021.04.05.08.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 08:10:40 -0700 (PDT)
Date:   Mon, 5 Apr 2021 15:10:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Nathan Tempelman <natet@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Robert Hu <robert.hu@intel.com>, kvm@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [kvm:queue 120/120] arch/x86/kvm/svm/sev.c:1380:2-8: preceding
 lock on line 1375 (fwd)
Message-ID: <YGsobMdyqwzi9vr7@google.com>
References: <alpine.DEB.2.22.394.2104041728020.2958@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2104041728020.2958@hadrien>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 04, 2021, Julia Lawall wrote:
> Is an unlock needed on line 1380?

Yep, I reported it as well, but only after it was queued.  I'm guessing Paolo
will tweak the patch or drop it for now.

Thanks!

> f96be2deac9bca Nathan Tempelman 2021-03-16  1377  	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
> f96be2deac9bca Nathan Tempelman 2021-03-16  1378  	if (is_mirroring_enc_context(kvm)) {
> f96be2deac9bca Nathan Tempelman 2021-03-16  1379  		kvm_put_kvm(sev->enc_context_owner);
> f96be2deac9bca Nathan Tempelman 2021-03-16 @1380  		return;
> f96be2deac9bca Nathan Tempelman 2021-03-16  1381  	}
> f96be2deac9bca Nathan Tempelman 2021-03-16  1382
