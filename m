Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2212B8A4B
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 04:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKSDFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 22:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKSDFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 22:05:31 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B253CC0613D4
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 19:05:30 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id f20so5781501ejz.4
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 19:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=S9lnBxEhYxd0mqc9JD+SeLLhJdjY2GMuoY1EAx2zB88=;
        b=rfyIOCw5ft+n9zVlp2PA9j1Wf00Ooc85dLLVIFhqsahamoE9+SQOPlQrCZWMGx4Cit
         lgILcq+Jpq1wwbK1D5ABgJhj/XWgoOepJ2O1fYdSjt+8ztCcvmtEFbYrqi93C55mTs1A
         UPnmvgFF0u4DN/pnptQjm/YqRzRos51VvRDhVESVCq2c1lG+0Bp5CVD+Jw2vv8EcF3mT
         s1xRIj2kLUBa0Wg66imP2ek6Izo+KigM4xaQtw5oH6Gj3QUujppRoggcRkxbmBSV7i7g
         KeWKoHeQ6ajzSkjA2aNjSptLvhoWwDi5l68qlPtTSc7zsLaAfsCum+ZDMotJkqadULJe
         5hQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=S9lnBxEhYxd0mqc9JD+SeLLhJdjY2GMuoY1EAx2zB88=;
        b=l84KWIZCYcA3RYvLOJc8Tw+/K3eX+o5N1dDofTs7ZqobGWbb6GneEViBKQPl7MA0Ab
         BQXjBBdI850eqDTijucyIKwxFUPW8qoWsibYAHaMnk8TLGhr7CSGFOW103WUfPwUUgju
         nIXO1MSZsrOgg33nMzeZNB2zjTIrp8eLnqtC3OQSawQ675S2rBiciW1pi/ZtzlpCS8LB
         V7J+EIjj2dLWFkb5nm6Cj/Q/vnRU8J0WqWkDYXjdoUwOtvxHsSMTHcLPwby9QqMB4j+M
         H6Qh1RJ9YxFesBSX21al9IW8YeZ2vkSkTWyLzNoycacTlhLGNzfiVK0FgA7rxoi+eulD
         tgeg==
X-Gm-Message-State: AOAM532GNFQ3EgPnpgooYUqZvOxrK3aCRCS9o3366Z//JKabIkZ1YF0w
        od3dSqkZgVHxJtquOz3d/xE39f87zsE=
X-Google-Smtp-Source: ABdhPJyxUZdJMpj38d7r3IIAlK1DPpQRD3r2jZ4lTGNmdFbtKfyRz2wJ7oatjfS2b0+7Voum98UEBQ==
X-Received: by 2002:a17:906:4e56:: with SMTP id g22mr27162017ejw.49.1605755129180;
        Wed, 18 Nov 2020 19:05:29 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id ay5sm6697377edb.40.2020.11.18.19.05.28
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 19:05:28 -0800 (PST)
Date:   Thu, 19 Nov 2020 04:05:26 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Bad performance since 5.9-rc1
Message-ID: <20201119040526.5263f557.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

in my initial report (https://marc.info/?l=kvm&m=160502183220080&w=2 -
now fixed by c887c9b9ca62c051d339b1c7b796edf2724029ed) I saw degraded
performance going back somewhere between v5.8 - v5.9-rc1.

OpenBSD 6.8 (GENERIC.MP) guest performance (time ./test-build.sh)
good: 0m13.54s real     0m10.51s user     0m10.96s system
bad : 6m20.07s real    11m42.93s user     0m13.57s system

bisected to first bad commit: 6b82ef2c9cf18a48726e4bb359aa9014632f6466

git bisect log:
# bad: [e47c4aee5bde03e7018f4fde45ba21028a8f8438] KVM: x86/mmu: Rename
page_header() to to_shadow_page() # good:
[01c3b2b5cdae39af8dfcf6e40fdf484ae0e812c5] KVM: SVM: Rename
svm_nested_virtualize_tpr() to nested_svm_virtualize_tpr() git bisect
start 'e47c4aee5bde' '01c3b2b5cdae' # bad:
[ebdb292dac7993425c8e31e2c21c9978e914a676] KVM: x86/mmu: Batch zap MMU
pages when shrinking the slab git bisect bad
ebdb292dac7993425c8e31e2c21c9978e914a676 # good:
[fb58a9c345f645f1774dcf6a36fda169253008ae] KVM: x86/mmu: Optimize MMU
page cache lookup for fully direct MMUs git bisect good
fb58a9c345f645f1774dcf6a36fda169253008ae # bad:
[6b82ef2c9cf18a48726e4bb359aa9014632f6466] KVM: x86/mmu: Batch zap MMU
pages when recycling oldest pages git bisect bad
6b82ef2c9cf18a48726e4bb359aa9014632f6466 # good:
[f95eec9bed76d42194c23153cb1cc8f186bf91cb] KVM: x86/mmu: Don't put
invalid SPs back on the list of active pages git bisect good
f95eec9bed76d42194c23153cb1cc8f186bf91cb # first bad commit:
[6b82ef2c9cf18a48726e4bb359aa9014632f6466] KVM: x86/mmu: Batch zap MMU
pages when recycling oldest pages

Host machine is old Intel Core2 without EPT (TDP).

TIA, Z.
