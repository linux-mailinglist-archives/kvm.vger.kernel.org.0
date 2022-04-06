Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A64F65DA
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbiDFQan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbiDFQ3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:29:53 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116E4432489
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 18:50:34 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t13so932040pgn.8
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 18:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=urDwMH5Kk1KfjrQeaJid9AArbzQ9KreP5Y2aNsYYLvw=;
        b=Gta44WdpTdySv8KVV/aLRw1jW/AgPqKonNyWSanOe+OgmkSi/hCe5qRLhGuQWTYUNX
         AfXBZitdIcGxiq/1mwF0mi3E8PKslzoNYWuUQ3fVp1hmvhx14oiu9Og9ldIbaNJZQ4e9
         p7W5hP0daYbeuB40sAo5e+gm0rJO8RbzqGmdpj+MyHjK+Ka0VirE9XeosOioP9xBMwkg
         Dl5vx6W+lQ+i7NK72a1vQpjHjadTk1kjsZ4N27n/3NpkRdYHZvySijpIGUpB4BTLhbRE
         oYvIswH5qm5Ki76FqPszvuEX2V5I9Y5IuyEk5QgOhQJhUzcisak/wSYu9V9LTx7RvgFT
         4Lew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=urDwMH5Kk1KfjrQeaJid9AArbzQ9KreP5Y2aNsYYLvw=;
        b=WzqCmaigSEQyDUW9YOKy1NG3QxQgtIfKZTjGbO5/SL2weChn9xFxnhX6uYk3Zsmd9P
         vWoDUn3NhrGyA/e+tFeX/7j3fEyD8SY33eDTPl3mR1Rhic4vwV1sUnqakP+TaTg5TR+k
         daYiD9S/0ShJ7UmzyMc7Eq9SOzxuWbMO38X6p8bTCDn41jIP5AEyBNLqJi9N981pSpEe
         ovgSXLObeBQRBiLMJJ8/mw5GWCwW4bA8nrCw+ENWCK92X+8hJOG/FRcNT2HfDVxMNKcr
         BLVd9Jk45RNwktOnI+IM81noJxafaR3IBaLl5hzZyP/z0ZfBYYdsW7SIcupgXpQ7IFYH
         PJrA==
X-Gm-Message-State: AOAM532ilDpYMmf5gRl77xLpfKu71DRqAwGqr9xBRisWf8pE2HV3CW5X
        cUjxMOiJiLAyNW44coH4cf3MLQ==
X-Google-Smtp-Source: ABdhPJwvlaGQuNw+7D+lnn+rDNWamAl+YMLOOcLlLd5ZIfdrpl0akDCq1Qq53Kd+xEE9NjWYQkIwQw==
X-Received: by 2002:a65:63d9:0:b0:374:6b38:c6b3 with SMTP id n25-20020a6563d9000000b003746b38c6b3mr5234225pgv.195.1649209834303;
        Tue, 05 Apr 2022 18:50:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v13-20020aa799cd000000b004fdaae0a91bsm17056837pfi.20.2022.04.05.18.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 18:50:33 -0700 (PDT)
Date:   Wed, 6 Apr 2022 01:50:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: AMD SEV-ES: Handle string
 IO for IOIO #VC
Message-ID: <Ykzx5f9HucC7ss2i@google.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-12-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224105451.5035-12-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022, Varad Gautam wrote:
> Using Linux's IOIO #VC processing logic.

How much string I/O is there in KUT?  I assume it's rare, i.e. avoiding it entirely
is probably less work in the long run.
