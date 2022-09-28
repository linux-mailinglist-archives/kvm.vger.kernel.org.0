Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729875EE9D9
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiI1XFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1XFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:05:34 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365BA11C26
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:05:33 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c24so12969855plo.3
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PAmyKBlgjtbvtqhVxXHx2ejMGzjNRJ+Srms5+P+ez64=;
        b=DKwecanPirQPKezM3JUZXVruK+2m/GK9uMx0vqcCuSKCTTJmFBrkaAZ9T0tlg+T4ZF
         oQXWRzqs0ArkQ/CirhQV9zXks0YSjINnPFWsYKq4k5nHhxf4qCVj+JwcSUOUQCojKPxL
         AuQtpFX8q3L91jdd6FeHYvLKiiSokP2f87P1T7OMC5+wNmV3mBdxDMrEjLPds+5dcP4h
         FPFl9p5AS68AbIFWNHS4rQVoQiVp/IAX76cgVhj+fySATYBdGdnHrB7iWzeLe+g0fMzt
         DN8eO45YSiiSO7SrIvjjplWrFdi+PuzpyeEtcCRpAcDL8sYDDZrLW6ZQttuju8dTmtea
         6upA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PAmyKBlgjtbvtqhVxXHx2ejMGzjNRJ+Srms5+P+ez64=;
        b=ItrVEIZ35H7kGwH1b3jQ6Ikda3REjP1pil4XfHobUQa/91w0k/+9LUpeNaBuzH8QOQ
         CLfwUw+2nDKPjQtqa0nyJsXfJdzDQClVCHsNAr82jdM71Dii+cgyB4ERImoadDYlIgl6
         jlil+ves8PcilCVljEuc19pqGcx2G4Zcf5D971QJvtdT2a2mCDqWbaFJ4OIOJQCPcUR0
         lGpNfHm/VJ4iqr4Fk6jgP1b7qzY1LYcYnFuSaMWp7jonj+ElT2z1x1DhmJLzGGhDfqQE
         Hpu2KYVtKrsKiIZGVycMBZLyJ76jvO2/H9fUSsoNiubyvaL1n3cWkfyps+H1bz3QhfeS
         X2Ng==
X-Gm-Message-State: ACrzQf3NEmOj/uvWX0YcWCAImz5sHrZSe+gMqKjWvkCx9xFCq9mWUZP4
        z/wZPezzwGb9/Tmzr90njPjPc/yUVZHfaQ==
X-Google-Smtp-Source: AMsMyM7mVBjUViDKxT1spfFBekYzPo0peBmP6JK8BMtco2twxx71XTEXbyqSX07T43HGN2Z4b2DR2Q==
X-Received: by 2002:a17:90a:7088:b0:200:4e9f:a206 with SMTP id g8-20020a17090a708800b002004e9fa206mr12559534pjk.173.1664406332642;
        Wed, 28 Sep 2022 16:05:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902d48d00b001782751833bsm4329897plg.223.2022.09.28.16.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 16:05:32 -0700 (PDT)
Date:   Wed, 28 Sep 2022 23:05:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Rename perf_test_util symbols to
 memstress
Message-ID: <YzTTOEOkrkSqGcMQ@google.com>
References: <20220919232300.1562683-1-dmatlack@google.com>
 <20220919232300.1562683-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919232300.1562683-3-dmatlack@google.com>
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

On Mon, Sep 19, 2022, David Matlack wrote:
> @@ -42,10 +42,10 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>   * Continuously write to the first 8 bytes of each page in the
>   * specified region.
>   */
> -void perf_test_guest_code(uint32_t vcpu_idx)
> +void memstress_guest_code(uint32_t vcpu_idx)
>  {
> -	struct perf_test_args *pta = &perf_test_args;
> -	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
> +	struct memstress_args *ma = &memstress_args;

As a prep patch, what about renaming pta=>args?  I always struggle to remember
what "pta" means, and "ma" isn't any better.  And that would give some amount
of alignment between "args" and "vcpu_args".  At a glance, I don't think using a
generic name like that will be problematic.
