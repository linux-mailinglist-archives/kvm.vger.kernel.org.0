Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96A076CF6A
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbjHBOCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 10:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbjHBOCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 10:02:33 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6237D2115
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 07:02:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bb98659f3cso48316005ad.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 07:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690984949; x=1691589749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=egTWiZCw3gKznxrOWTRNAPk9VweCUmI4yRD+DM/laTA=;
        b=QT2uNTltSNNXJQPXfu0tr//mcYDiMR5d7MEasWb2qXAVZIq0DYYV+ThfsJe6l2Mp9U
         mRBzNq62vb9glu5quToK3y2aSaXJhdmAH4TR/BZISwOjk3t5FwpSvgFHSHjX2Jnkp6p9
         Vw5w/MPlgyBtn1NjVAgP0j5Aaud0Omr3y8EpkOnDbpJEa/xS7wij21s0qz08WHUrNlKz
         anByM5RkrGUd/DgJS6wageONftXYIyiwaobNbWt3iVKmv78AhLdifyNOVl0EZ2CipIsx
         OS+dISPk9Ooo90agzAXi3HhsGgLyJt2OalqKKQaZpD32C9naIzAKC/FymOL6gGobbdNr
         PTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690984949; x=1691589749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=egTWiZCw3gKznxrOWTRNAPk9VweCUmI4yRD+DM/laTA=;
        b=Lgt+nH1h+OaNoysI9XTspil1V/6NRnlWyv6ZBkprvDc5BPM7O5eZJpCFpS88u3/8In
         u996r7A85a9zJmpPLuoyof0qCiMT+YPgtnhHFdKA4LcsnPTgfSF9sGgRIVczYP0SOlf1
         l7Kfz1LlXnkmusVYAFBqPtdplTfjp8jhEoq6C37ShTRyNGJP2FiJ+2tQj0g0uvjMqxJB
         erk+jUG0/mvBz7egWWuOfGDTMgiSErYVZpQzQoIMnOLO5vZPkoFDO7p7V+7qm56nVMK6
         uTDFG93OC7pBVDz71QZyVahopf9k9yaIGWdZ4WqpeEGMkNdeRkyiydVQvhAb3WyQ2avc
         KAQA==
X-Gm-Message-State: ABy/qLbE4J1wfrXZjvtjXGT2wB/9zxpTFUkkKwZiyImApTC4jh8+gHak
        Db//zR+wJI2gNnnHywLb5ZiwrrcQPKA=
X-Google-Smtp-Source: APBJJlErCD7UL9vb1rdyD/q9BD7RRwvkS1psEVV8Vfnp/izQGhqyhak7274AEsRsW6fp1eGCWfSbMrwsQMA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e847:b0:1bb:b74c:88fa with SMTP id
 t7-20020a170902e84700b001bbb74c88famr85887plg.6.1690984948835; Wed, 02 Aug
 2023 07:02:28 -0700 (PDT)
Date:   Wed, 2 Aug 2023 07:02:27 -0700
In-Reply-To: <20230802091107.1160320-1-nikunj@amd.com>
Mime-Version: 1.0
References: <20230802091107.1160320-1-nikunj@amd.com>
Message-ID: <ZMph82WH/k19fMvE@google.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for kvm-amd.o
From:   Sean Christopherson <seanjc@google.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     kvm@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Nikunj A Dadhania wrote:
> objtool gives the following warnings in the newer kernel builds:

Define "newer".  As in, exactly what commit is causing problems?
