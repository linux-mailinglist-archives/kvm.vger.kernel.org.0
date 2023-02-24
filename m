Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EAC6A2471
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBXWsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBXWsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:48:02 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7FD298D9
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:48:01 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id h13-20020a056a00218d00b005a8da78efedso249449pfi.2
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z9P0Y4g8n6fMmAjFzRTId2kiNvMd7dTYme5yR7tmEhI=;
        b=Wv/iNvk9SQt1W/iATMCLEWtg8Qgg9CysAxQqH3Mu3M1EnqNF9jB94EZh4hJVu2b6Jy
         MuFbPENs1Kn1lWgdY/pTEfWrlXkVChMX5GCfkTM+iNEQH/A46a77PHAqWl4VzfIjh248
         +KsIX9wuwZTcIJK8op4sd0FUkylhIiN4B4r9mZkrm+CqblKLOOlHuvfZiQJI+8zf5Hnd
         lxoajiWtkc+BIT2krOyo14sLcgU7JSeJN8pu+2luaua65TkkrnyVBw1cvRWfaZYFbA4u
         RB8ZrJRRlKhI7hMzA/vviPMJ1O7WJlHoOcyc6Abcft8rTbLmMdIAq6SHwVVyYkkhYGhQ
         NBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z9P0Y4g8n6fMmAjFzRTId2kiNvMd7dTYme5yR7tmEhI=;
        b=aL4BhaCRY+cULuKNTMP4XajFs6kRsd58mSYMc5VleL2SOpZeIfAarOKTMD81a1kM9D
         gMgd7/nwDtBvmClCudA9N/mAJQiybmNFIdZ5ES7B9VlbaExyOVItt0VPchsmmiiHsKSy
         EhXeK+7fgMLoGmWlu/6/9CeXlGQk+KQnnENlwfRNc4tqaN5c7KY6/GwdvMWoyKxzFLdz
         8QyBkR2xqIKHHOlv7O6WWygDHyyAOsnVH0VdIVAAVEPprqty8uQpSwQ93FAlloX5OOmQ
         c/e2NTXX/t9PGz9gD0lrJZMzFTb8k5xfOrE+ra31Zd3GRxsflmk9WGyC1/3QMqodxvoE
         ndYw==
X-Gm-Message-State: AO0yUKWyfu7A2ygh2srM8gMICYTBvo2PbcYLqmxJvFotG6LoRNESV8ht
        m7+KlsDFmLPYESva/dUxhj77n6pSld6V9voP9c8QILyaMQyz7uuKMXm9T/XOLtSBkZbdjeV3Xlv
        Z6vP1Fydjrvya3xl9kNRm+h7FfjA/tFy+FS/MpJK+munrg/q18Bl/TwA2wQ==
X-Google-Smtp-Source: AK7set8cydcfojLpqB+kDso4HhKtgLcCcqfb7aa6EHFhc027H7B+9L9dHqtuzZ5rVDdsVSeW4p5194/06jc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6b84:0:b0:4f1:cd3a:3e83 with SMTP id
 d4-20020a656b84000000b004f1cd3a3e83mr472247pgw.3.1677278880573; Fri, 24 Feb
 2023 14:48:00 -0800 (PST)
Date:   Fri, 24 Feb 2023 14:47:59 -0800
Mime-Version: 1.0
Message-ID: <Y/k+n6HqfLNmmmtM@google.com>
Subject: [FYI] KVM x86 6.4 status/plan
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_20,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FYI, I'll be offline all of next week, and will be back online March 6th.  I have
a few series of my own I want to refresh when I get back, but after that I plan
on switching into review mode for 6.4.  If fortune favors me, stuff should start
getting queued for 6.4 shortly after 6.3-rc2.
