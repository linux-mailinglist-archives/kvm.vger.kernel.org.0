Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDE250E39C
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 16:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242573AbiDYOvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 10:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242570AbiDYOvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 10:51:16 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B5125CB
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 07:48:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s14so27355910plk.8
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 07:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l4lKSPRxIIkarNlCX01NJf9i1fT2jNKlniuO57olXJ8=;
        b=ambMkR+jIT07uQUtKrYulIjjbnG17hx96o3jN4VizRte3aTpAz3W4KV8Hm4KF3quSg
         Uwf/I+RGsCo/2pNTp5Wmv0dDT93lqk8B0PcM65l6BZs2jEHIsllRtl1NmfiAFzoHN2Gv
         INw7EYkM36tF3X+CwnBQDtW6AznFKsLyqfdbFk+SrcYNb2XN4iXKoR8XsTR05Y27tHWl
         +mdWlmm6IRsD/eTkLK0iufG+D/4wAT1C/sXVgB3NNkNQdEdCMDuT/kAZvCdiVbA0jYZv
         MIwakKWOHQhSPR2KX8JVX6lKBM7ZqUtsUtKty4MQJpyAh+hu9MchSkKdr/2Yd/OA61rV
         8wYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l4lKSPRxIIkarNlCX01NJf9i1fT2jNKlniuO57olXJ8=;
        b=NsRAypi5+UU8lIWrBliWL0wu30zOaB1ZvGPFYkDichj4K6ClmRyGFDXB65VuHG41iH
         ZqPhc5t6uhk2baPpeSPDQcylciVFGFPX9vtyh8JA3cclfw9j2GAxxUmp32Y0N6nVXAaZ
         Ubj2yKX0re2eT25doQyMxrGZMBu9zPth/B4qw73cQluCJAOkIT9eu4Zizva5+4+RWdVU
         7snfkv7Aja02nEl72/gBzzsAVRsiYl/9Xr1Nf4p9PgpI2NhiKfeQpfw7ksQ0uNCoOzOM
         C3rMUPkBURUZwplpXSe/SJPpsF3jzht4Myl8TXQKx+MJR51Sp0FgzQi38KoVR3rwh7m5
         E4Lw==
X-Gm-Message-State: AOAM5318vIY5PrpmLQXmOptJj/0aLvo9ZsV0xi5+jFai6Sz7I019VmHj
        YiTtQ0e4rQE/SHaNc099OqK31g==
X-Google-Smtp-Source: ABdhPJwJ5DuZSEHJZi+yz+UWqIEMAiQgoiV2MuByWE/UBocnOGIEGV8rWK/QhJq5V+vZknx5tsnRzA==
X-Received: by 2002:a17:90a:a782:b0:1d9:9998:925e with SMTP id f2-20020a17090aa78200b001d99998925emr1601178pjq.217.1650898092141;
        Mon, 25 Apr 2022 07:48:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm12514825pfl.135.2022.04.25.07.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:48:11 -0700 (PDT)
Date:   Mon, 25 Apr 2022 14:48:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests RESEND PATCH v3 0/8] Move npt test cases and NPT
 code improvements
Message-ID: <Yma0qPzbYU+pSZhd@google.com>
References: <20220425114417.151540-1-manali.shukla@amd.com>
 <19e902c3-b3cd-a9cc-be0f-d709b2a52c77@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e902c3-b3cd-a9cc-be0f-d709b2a52c77@redhat.com>
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

On Mon, Apr 25, 2022, Paolo Bonzini wrote:
> On 4/25/22 13:44, Manali Shukla wrote:
> > If __setup_vm() is changed to setup_vm(), KUT will build tests with
> > PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests
> > to their own file so that tests don't need to fiddle with page tables midway.
> 
> Sorry, I have already asked this but I don't understand: why is it
> problematic to have PT_USER_MASK set on all PTEs, since you have a patch (3)
> to "allow nSVM tests to run with PT_USER_MASK enabled"?

svm_npt_rsvd_bits_test() intentionally sets hCR4.SMEP=1 to verify that KVM doesn't
consume the host's value for the guest.  Having USER set on PTEs causes the test
to hit SMEP violations.
