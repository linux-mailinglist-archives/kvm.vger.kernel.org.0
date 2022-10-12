Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B995FCB70
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 21:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJLTYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 15:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJLTYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 15:24:33 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75376DD8B9
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:24:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h10so17163252plb.2
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bB+6x/XxTV5mFIA+w4cPdZWHEhYSNRFca7pswO7BxVI=;
        b=L5ebeR7LByHQUkEbERaD4gFM7NfsE9A+8UVEVau1+UDGsTReFT1qhXQe/kDi/bY8hQ
         wSsbTkhEgKlc/NKyH5xxST/P5SInWl5DXHeGUPVRhUj+opInPGU6ksuZA2LirxknNx4o
         RvCMSsxccDU/d5OCA1LDQscN/nCy3iS3Rsaemobp11FOl3tuSUciSjLSW0pc4QLJNgHZ
         1EmkKDtRa69AjqG23FPNS4vweDR5Xef2yxcoXMKPjnVW9gONna41+z4QHMJUPC91JpfY
         mESx3Ai5n7IlTgahxrqNPE++EKw7HRUc8dlNLywVSfHxVEWY8LuQlk+JNcWZ/SxjK14E
         e5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bB+6x/XxTV5mFIA+w4cPdZWHEhYSNRFca7pswO7BxVI=;
        b=3dxDq+bwkJ+mu9AZAdV7TeeIxLyYXwJwFpKPIfdazuFc1k/eYa+YXQ/JmYuKKs+Zdg
         jlCirNt39rEZxORL1tflXHk7jyGPp//C8f+q8064MrSKybDsKr5SEVWiZg4JTS44+hJj
         UB73YxhQZH0iKcKtrzUG6aTcUsJbrJvRCelQd5YubfFb5uk7FpIa0+Yk6aXaVcXVRyQk
         uvQonkzkXfHBpQHzLbRJxVXch26X8jWgTMmnq6n7n80z+1Z0oiWArVuf17EHNIjhotfv
         aaVCcjBO4cPPZ4ufgVQNUckiHEvVyK9GKbTntf1NQ7ezCD4OQHPjhRCAJBzbsl5qGC4T
         0F7Q==
X-Gm-Message-State: ACrzQf1MFQLjlrbBCfDLtV67pVzi2ghobX2IHqe1iim8xmZnbahU9RqR
        QpUU07z762s2m2abpjjBM/rJkw==
X-Google-Smtp-Source: AMsMyM73zWZ032bW4S+bDrfMRlBXUOeySZS9V3XY5m8boUnWBHDSw7JyKylj9iYVvDpGFIvDvoh/yA==
X-Received: by 2002:a17:903:228f:b0:181:3bec:9b9e with SMTP id b15-20020a170903228f00b001813bec9b9emr23156234plh.120.1665602671929;
        Wed, 12 Oct 2022 12:24:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x27-20020aa7941b000000b00561ed54aa53sm244577pfo.97.2022.10.12.12.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 12:24:31 -0700 (PDT)
Date:   Wed, 12 Oct 2022 19:24:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 2/3] KVM: selftests: Rename pta (short for
 perf_test_args) to args
Message-ID: <Y0cUbIZqWhU+t34f@google.com>
References: <20221012165729.3505266-1-dmatlack@google.com>
 <20221012165729.3505266-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012165729.3505266-3-dmatlack@google.com>
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

On Wed, Oct 12, 2022, David Matlack wrote:
> Rename the local variables "pta" (which is short for perf_test_args) for

s/for/to

> args. "pta" is not an obvious acronym and using "args" mirrors

Quotes around "args" for consistency?

> "vcpu_args".
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

A (very small) part of me is sad that I can no longer mentally unpack "pta" to
"Pain in The Ass" :-)

Reviewed-by: Sean Christopherson <seanjc@google.com>
