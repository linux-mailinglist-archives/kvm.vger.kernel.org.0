Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FA858032D
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 18:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbiGYQ4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 12:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiGYQ4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 12:56:11 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E11A6576
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:56:11 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id r8so2591309plh.8
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QOtGfqE91niNT3ySboLeLvYa6CoCD0V28mqALfdRWlg=;
        b=i9ciq/REKBNm64yQy531o0DGoNJhM58iU1NhxtOlyUDstPo2rliEOEY+KudZN1gaZA
         rIVssDyfhzfHc+jbXUHvT28n28eGDRU7ufNNr8n0Xuc5SZhjyOnKP3qEGWtmR2TwDclk
         6IDs2QsXjPIQNTxaPRseKiKM3T/jx/bBkOHTJl0L8bOo/mFU0Wbr3Q91uLXvZZw1DQUN
         pVSuIj40CHJqxJxuU4roPkGHIulr9xnQG/XiaQKv3zIxehLbVpIlAI/8vBhx1MRh4jkq
         w+8NAgc1gV4fge40ss5SROWHOWflS5cQ03oTcOZBKaWxuHGBHGr/YlxtkF3fNyaMV+aq
         o6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QOtGfqE91niNT3ySboLeLvYa6CoCD0V28mqALfdRWlg=;
        b=CjvtzHaWPKsrgAaUNetMbUqUx0mXOXXJco5ZILs52V7XnpAZYaC00rLDta8lh0gnIf
         YyI7e5AYd1okHGlR4phSsahHu6CY6MsG+4QrftTemUxPRF8jNywl4iiqBU7PWA1sxyCf
         GRaCKQEclTwqKBafMeEAQw6SsVML9vr0wty4jZJ5jhFOe34fNLDAyrtreE1PMTPLvYkR
         JJp3GIcBJ5Ra4pdGAtjZX/VQUxlJ+T1JP9fXwV4pVv0ucixFLcT/8hwAIPecFSohYJ4n
         0EPfM1EsrrLMa5cuJSMtUioBiyYj4Zhw2S+PZ6z+aOBmLygT9yhZjGMGrfKlkN11HoNr
         7tfg==
X-Gm-Message-State: AJIora8mwJvQCeRt5Thf24uKZ1/Dh2pRRFLzFqc58g1AAj7dhOwY3uIV
        hB79XLtp4dHVri24xeFMc364ObMdVz9lyw==
X-Google-Smtp-Source: AGRyM1t2rEsdTL3n+lWmj1QEwEGh2dr/5TeyfOuU3yc6r0ZekRiTcVrRu9J8bgv7df9oza8CA/a4QA==
X-Received: by 2002:a17:90b:3ec1:b0:1f1:edcf:dd2b with SMTP id rm1-20020a17090b3ec100b001f1edcfdd2bmr15493182pjb.156.1658768169461;
        Mon, 25 Jul 2022 09:56:09 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d48400b0016be368fb30sm5085898plg.212.2022.07.25.09.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 09:56:08 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:56:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>,
        Manali Shukla <manali.shukla@amd.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new sub-tests
Message-ID: <Yt7LJZpmF3ddJJnk@google.com>
References: <YtnBbb1pleBpIl2J@google.com>
 <YttLhpaAwft0PnbI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YttLhpaAwft0PnbI@google.com>
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

On Sat, Jul 23, 2022, Sean Christopherson wrote:
> On Thu, Jul 21, 2022, Sean Christopherson wrote:
> > Please pull/merge a pile of x86 cleanups and fixes, most of which have been
> > waiting for review/merge for quite some time.  The only non-trivial changes that
> > haven't been posted are the massaged version of the PMU cleanup patches.
> > 
> > Note, the very last commit will fail spectacularly on kvm/queue due to a KVM
> > bug: https://lore.kernel.org/all/20220607213604.3346000-4-seanjc@google.com.
> > 
> > Other than that, tested on Intel and AMD, both 64-bit and 32-bit.
> 
> Argh, don't pull this.
> 
> Commit b89a09f ("x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI")
> broke the SVM tests on Rome.  I'll look into it next week and spin a new version.

The APIC needs to be "reset" to put it back into xAPIC, otherwise pre_boot_apic_id()
will return garbage when `svm_init_startup_test` is run and x2APIC is supported.
