Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B634F6C82E9
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 18:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjCXRJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 13:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjCXRJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 13:09:04 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF4120696
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:09:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-540e3b152a3so24953467b3.2
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679677742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G2GLLrk0eutYOPX5sTRYTvo2Y+x3Tvp07KFj4spklwk=;
        b=JJ8Pg3hkjve4IazlZIeqwGj9EtpZSaYftwdJPK92EMdH3yOMC3MEOCWZQxJVqiEAhw
         z5X2O7Ip468i1Yf/l9QX3dzHdWE1CRO5nroYps7gecyUX9H0l1Y/dKB0LO669Cu34cSH
         TsXw8mLONzFVZv8wdXGr9EPqDRdg/05FCVYmIHVkZCtulSfgl/S9PPQuZb/Rgg5BiBuz
         Yk5rM6KiWEIHbTKp4G7wqPsiyOOb2y3I8hsKuewEtj8OHdS9OmmNbWBEPOUCUSKrMmsm
         xqgW5eRsg7AJkgKv27fNm+yHtEu5TLDBwzO3jxxM4MFjqq6Gb1vfdXzLbRSPq5pxWdqW
         2ZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G2GLLrk0eutYOPX5sTRYTvo2Y+x3Tvp07KFj4spklwk=;
        b=1bCr20ESCxNzLMUX+ZhJ3rIvfGi/4j+TEEEBNe7YnacsFDV/qVRdfrWYhcDzcrS3Ht
         339fAqwdrtcSXPl7diFnJchPq2nQZ+et6Djmoe4yfFzSCDYXdht6YbmLr7LMQE9F0l0S
         vnLwaXXRbVkgrwn58ysMRbrqUq2heJXiqewub9w5SoUmVp/6ckV9C96vAPZ3Zr886ID/
         dYeg9nLKsPtyzuxV9IRFbqr7lumit1OhtD0TAySVHYRAcKPl2yFFA+a4YIIXsOtrAbZS
         0hkAIyd6dU5CncGZ1uug3v7sz8Xh/9vY4r0gGDOkIfmCjDjeZ7Saz/xY4v5yE3lS3CEp
         3Lkw==
X-Gm-Message-State: AAQBX9czxqLCeaVFRnTJlQaXHSMaiMXbDlH2AIj55UglSnSA33UUuiwz
        7TL12gfYaWdKzvz9lS1Avz6G/GHX/bc=
X-Google-Smtp-Source: AKy350ZQ0OSWdgontMVSEWYCTNjXgWYYUP2nzy1s2WGmxt+AwTFMd0BdSY7Rjr+RpV0xGOMR5bDM6WnZrgE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e054:0:b0:b6b:d3f3:45af with SMTP id
 x81-20020a25e054000000b00b6bd3f345afmr3611653ybg.1.1679677741957; Fri, 24 Mar
 2023 10:09:01 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:09:00 -0700
In-Reply-To: <20230110175057.715453-2-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com> <20230110175057.715453-2-pgonda@google.com>
Message-ID: <ZB3ZLFCgqYxekE6U@google.com>
Subject: Re: [PATCH V6 1/7] KVM: selftests: sparsebit: add const where appropriate
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I suggest this for the shortlog

  KVM: selftests: Make sparsebit structs const where appropriate

Three deep scopes are a net negative IMO.  Too much of the shortlog is consumed
by the scope, and very few patches are actually capable of such precision, i.e.
touch more than a single area.

On Tue, Jan 10, 2023, Peter Gonda wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> Subsequent patches will introduce an encryption bitmap in kvm_util that

protected memory, not encryption

> would be useful to allow tests to access in read-only fashion. This
> will be done via a const sparsebit*. To avoid warnings or the need to
> add casts everywhere, add const to the various sparsebit functions that
> are applicable for read-only usage of sparsebit.
