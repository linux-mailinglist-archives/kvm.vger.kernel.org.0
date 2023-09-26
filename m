Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FC47AF1C7
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 19:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjIZRcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 13:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbjIZRcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 13:32:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854A0DC
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 10:31:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7ec535fe42so14519715276.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 10:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695749513; x=1696354313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XkOwjfTSaHY+m/Zl9b5fE1gcn9HuUtefVhZTX1+CRKM=;
        b=SmGBrNauuLEYP0AaOKRObj3Gcuwo3oeyPPyVYuvynGxEsRrIgk03qWG5oRBWYalrsS
         yBYVOrE+SR09JPwHikw4R/tPPh65SXs2qQd8+85sJMsMJMJucIU8dV9KnM40/i4aDB7q
         4W+REDDFRLUsfOG4spcKjMvqfNaEEqd7Y6e5kYT7bi0f84Mexg+aHQraehsN6kT0SqiB
         +UpW1wL6QuKaOURdeZPc7ZxEiHw1eCVmQO0Qj4nSsmLSuiu6l7MGWh4z4qZSQnUnzfTX
         CR/UUH4hyYEIUG+m2PI6hST8d3TWnD/Nr0WEcbmz2OJLFhAzaC8Jn+h4TyOebijBEJ2i
         4l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695749513; x=1696354313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XkOwjfTSaHY+m/Zl9b5fE1gcn9HuUtefVhZTX1+CRKM=;
        b=Q+AqLrn1b+20411pXBEb5a26xgjMliVzIiJSbgwQse00W+poYpLzaxS46TlZf4HzPn
         WNpQt1AVf8oRkkNIaPjAUIj6PBhFogG2LxEkMnoOJICJo+VhLTLHKehsgcFqKSHF9Tqx
         T+Ke/YT8uZlBQC5vyMBrcOq66o0v9CfkzvOHY4QvJJI0z63R/Ng60OPBtXcIST81fdCk
         jKAOTJk/X7zgtBUJLg5sTdEQE1kozDkBtCnLPXSZpxfnx77gga3D1O89EEGyp7v16rV7
         zS8M4QoUT9PrO3VfdXkMJSFYg86VCWkYB/QiFs6f/1BdSimmWoePmaGauxA8e6UGNjZX
         CFLA==
X-Gm-Message-State: AOJu0YzPwzFVQ3NQDkiuqvnSlQGBEOFQy5A9+N5mEP68ggxAkOQIM4GT
        zhmUUP3TzrIyZgiQCNS6eikj/e3LafI=
X-Google-Smtp-Source: AGHT+IExq3tjwerjS6HeYq1RGLysSQci3pAH4clVrhj0LxExcmC9lW1kAbBZp0UEI75+zMH0OFY5ZyUXqVo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ec0c:0:b0:d7e:b82a:ef68 with SMTP id
 j12-20020a25ec0c000000b00d7eb82aef68mr112052ybh.3.1695749513702; Tue, 26 Sep
 2023 10:31:53 -0700 (PDT)
Date:   Tue, 26 Sep 2023 10:31:51 -0700
In-Reply-To: <ZRMHY83W/VPjYyhy@google.com>
Mime-Version: 1.0
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com> <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com> <ZQOsQjsa4bEfB28H@luigi.stachecki.net>
 <ZQQKoIEgFki0KzxB@redhat.com> <ZQRNmsWcOM1xbNsZ@luigi.stachecki.net>
 <ZRH7F3SlHZEBf1I2@google.com> <ZRJJtWC4ch0RhY/Y@luigi.stachecki.net> <ZRMHY83W/VPjYyhy@google.com>
Message-ID: <ZRMVh0CMmfMo3kmc@google.com>
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
From:   Sean Christopherson <seanjc@google.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dgilbert@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023, Sean Christopherson wrote:
> Masking fpstate->user_xfeatures is buggy for another reason: it's destructive if
> userspace calls KVM_SET_CPUID multiple times.  No real world userspace actually
> calls KVM_SET_CPUID to "expand" features, but it's technically possible and KVM
> is supposed to allow it.

This particular bit is wrong, KVM overwrites user_xfeatures, it doesn't AND it.
I misremembered the code.
