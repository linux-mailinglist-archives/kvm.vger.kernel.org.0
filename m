Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5872C5FCEF6
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 01:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJLXeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 19:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJLXen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 19:34:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67362655
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 16:34:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so436750pjb.2
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 16:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cERvbXaBoiwZpLKTMnoym2lrd8wojnSLxS5/Et/ZtxM=;
        b=Gkxb8MUaDmEzLcR56fUT7U9XlDq92WTgfJvzf394J9kipOUYLIxUTIOJy0wHD/ynj7
         hgAf5bUmHtQA1Wrn5/cpLo9xJzzdT8v6dtOSZiTTCsRm3Nm7CtZ+kIwgdWutPKU7xP31
         LgqrIStVocg96iTePzjBNRSbbX6vRJU6LKhqsORbDlJPf90Sss9EBObqq4KFo7WMmNfD
         THRNC1hyTlvmZKuTTVIHxLxqtSR2hDjCFgnDonRSpJxIw3pBNGTGpuXiAZ4nidVUObQm
         msltusfCmr0j3tDaaeH2Kwulq14Tb0p8bz38pFEXlkrCCW0MGBY0wbcyhvDg9kR4hkYA
         kNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cERvbXaBoiwZpLKTMnoym2lrd8wojnSLxS5/Et/ZtxM=;
        b=BHh6hAU3kO5EqMnonIuLil4/gGmOAWXS0Cl8IW7pK0PlGz4JxtzQkfkb+VV0x2zh9K
         9OtgUnbfjvWVMyVZQeYY4NXDmNCQUGOCQZ3wAQQtpaifhRH2hlaF0phod+4YAKUo/7/C
         tIK2lJZGUCmA7DbK26+qM2qNqE93KBJxkQdik8cEEsEPsD+QkaH+8UMSr022Ka8sQ1/M
         2+44xeXwUYTOXBO76/w3uj9kWi6BYo4mRqdIdmOcB6Ydfs70Bo+iCR24s9ZpReRQ2OGs
         jbUs0Xq8aZBMESOaiP6dO5qSveprTuTWKgH+1zcYnoSPgd9qCdU66V0HbMnxxodkD5wx
         mElw==
X-Gm-Message-State: ACrzQf1WjKqb0rx2EjTnUxpBWIOiUIFv2A2ef6khmXxpZk62uFKAMZgU
        8kDn4bMj8Gi0aAbWGH/b3npg3Rtnipm66w==
X-Google-Smtp-Source: AMsMyM46sM7BCLJjLxJHK32ndolQlA3APMWrMKLNoV5eSatnFPGtNz60YL4T59Rzsf11vIKItLJHsg==
X-Received: by 2002:a17:902:d588:b0:180:cf18:e76c with SMTP id k8-20020a170902d58800b00180cf18e76cmr25806611plh.138.1665617681224;
        Wed, 12 Oct 2022 16:34:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b3-20020a62cf03000000b005625ef68eecsm444952pfg.31.2022.10.12.16.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 16:34:40 -0700 (PDT)
Date:   Wed, 12 Oct 2022 23:34:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y0dPDGtj4SJTeqAO@google.com>
References: <Y0YAdQC7eP1TN90b@google.com>
 <gsnt1qrc3fy9.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsnt1qrc3fy9.fsf@coltonlewis-kvm.c.googlers.com>
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

On Wed, Oct 12, 2022, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > The code is trivial to write and I can't think of any meaningful downside.
> > Worst case scenario, we end up with an implementation that is slightly more
> > formal than then we really need.
> 
> As a matter of personal taste, I don't like the additional formality
> making things look more complicated than they are. The stakes are small
> here but that kind of extra boilerplate can add up to make things
> confusing.

I agree about unnecessary boilerplate being a burden, especially when it comes to
KVM selftests, which are ridiculously "formal" and make simple operations
frustratingly difficult.

In this case though, I think the benefits of encapsulating the seed outweigh the
cost of the formality by a good margin, and I don't see that formality snowballing
any further.  A struct gets us:

  - Type checking on the input param, e.g. prevents passing in garbage for the seed.
  - The ability to switch out the algorithm.
  - Some protection against overwriting the seed, e.g. corrupting the struct pointer
    will explode and a memcpy() to overwrite the struct will be more visibily wrong.

> Thanks for your patience. I never wanted to cause trouble.

Heh, no worries.
