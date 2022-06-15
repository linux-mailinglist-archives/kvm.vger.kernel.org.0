Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EFF54D576
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348787AbiFOXnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348243AbiFOXns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:43:48 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7641377CE
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:43:47 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id d129so12782971pgc.9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0f3A94R0rdYKcJDXSUvpTbiUn7Q0s38oXPNCfdDcVo8=;
        b=IIcUusGDFxd0ddh8gTZkZwNZ4Ot+D7DyFsnjxTN5SvTOtL5YrDOUs6QIeN/fcKP4ZD
         GHAnjZXx14cs97/7c7da7JV8T+elcZ76EnQGY8X0QQgvbwYZWi0GjMDmaPyylUXFg8xQ
         v8TgjhqyrOa0ka5JYKyXtL/6Se8S00WPSPzDP24TC+hGVbi63UpKKlQdDqy2tq8QbbAf
         71igsWDakxmDc9aJ9DU1pK+WJ7oKxjhOtii/i3DAB1j5nr2VlBySLV9zEnZK4fGRI9hG
         ZXbUwek+KeXixHH06+jHrFDaU2WveQtw1GcDUveuwINw4dGBXXKYWXf8jIe8u05jqmOY
         kl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0f3A94R0rdYKcJDXSUvpTbiUn7Q0s38oXPNCfdDcVo8=;
        b=kNvJDehIPa39bKM7OQUanWXPUh++JQJUTBPO3JLSsd4taOVatj1u0UvALdnSx29mjk
         2QktfRJ7PNRzkOzQvC1YZD7kgnPIwNnFnxmuvul7c6MUrENhRB6nNP0ouk0QJ5HBiwzB
         TA+Hl1cdR2J7z4MS837ZjT/bPQQPguA3X0HykPPA+RlCjTkFrvc86Q/51icfKWyHwlOU
         hLJ+1ziLIeiCtAWHqAzLqmWpYOacNWu/SPDqlW+MzrjizuWwp8cTzjX3y1XF1kshry8S
         pC7ZA/0CTG2mGmx8oBqt7n4BpLhYbS94h8DfVIrCzte9GbovDtK/55cqgC/gXNMa8MmA
         7ymA==
X-Gm-Message-State: AJIora8ZJ49LcVwslCQOErSLdQ+PYJLysNELLIseNDaNQxMuvXe+x7Hi
        kwh/VfaOK0OzIhROjytcD1ZMzGZm2SEgmg==
X-Google-Smtp-Source: AGRyM1vdtySLoTjpWlTeVuY9F6qV84045bdlmCtTFJN/clO+BEUcTHlgPyGTTvVYHxFu1mJIyWhhnQ==
X-Received: by 2002:a65:6786:0:b0:3fc:e1c0:7bbc with SMTP id e6-20020a656786000000b003fce1c07bbcmr1964157pgr.65.1655336627194;
        Wed, 15 Jun 2022 16:43:47 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e7-20020a170902784700b0016797c33b6csm192237pln.116.2022.06.15.16.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 16:43:46 -0700 (PDT)
Date:   Wed, 15 Jun 2022 23:43:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 2/8] x86: nSVM: Move all nNPT test
 cases from svm_tests.c to a separate file.
Message-ID: <Yqpur6a7oYqUEfGd@google.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-3-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428070851.21985-3-manali.shukla@amd.com>
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

On Thu, Apr 28, 2022, Manali Shukla wrote:
> nNPT test cases are moved to a separate file svm_npt.c
> so that they can be run independently with PTE_USER_MASK disabled.

Nit, phrase changelogs as command.  Referring to the patch in the past tense is
confusing because it's not always obvious if the author is referring to this
patch or something else that happened from long ago.

And kind of a nit, but not really because I suggested this and still forgot why
moving to a new file helps.  Moving to a new file isn't what's important, it's
having a separate setup that we really care about.  So something like:

  Move the nNPT testcases to their own test and file, svm_npt.c, so that the
  nNPT tests can run without the USER bit set in the host PTEs (in order to
  toggle CR4.SMEP) without preventing other nSVM testacases from running code
  in usersmode.

> Rest of the test cases can be run with PTE_USER_MASK enabled.
> 
> No functional change intended.

Heh, this isn't technically true, as running the "svm" testcase will no do
different things.
