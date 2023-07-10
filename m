Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C4B74E190
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 00:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjGJWub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 18:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGJWua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 18:50:30 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611319D
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:50:29 -0700 (PDT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1b888bdacbcso57915195ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689029429; x=1691621429;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xXKdk5epPeeQlII9y+BUup69WnYMrLiC4Uw86kNPKx0=;
        b=Roth8EHlQCXpxazD73yCmSlziA9jELzlPFWxTSGZDLCSEje32/fpYtLDuwpcWgkcoB
         u5dSsEc/kezQv8jQf1CxnTh7ju92fptQUvQkV8bUKIQy6msSH1HWX7RvEalSeqGSvP4N
         g+woas9+nobGmLAvRYyXs+bosnbom49sCcxkGtLOZPGjFOR5ByXc8w9Uz5yCi7D+BZnY
         +7BeifBy0DQmhhf/dLNwovfu3Ou9Ip4T3H3RTc8QsR2HRzb5kH6C1i7DL04Qgy2Hz4nT
         UcI+pvPs5bogfGpnguIBOxkql8pPHl6bxxLk8Y6Uaz0kRZ/rzIIAHvarDKC5rf0iCtQQ
         cz/g==
X-Gm-Message-State: ABy/qLZDnBPVypU/sDrHfo7+xsfACn4Sbx0w5tD5gx+Fn9phNx1CBEKn
        wEl24xfa0KReieIboYUr3aZr3e9F4Wgt1n0YlEXibmbSjqZRQkE=
X-Google-Smtp-Source: APBJJlEqhpYFnCs4kZfw4bGMQRYSzxoY4DfuQuZLR0YfyJRIYUn/+yzubUUgrJVoc/QjEotCutqtCQSX08R7Bbp5dF8LQ03fZF8G
MIME-Version: 1.0
X-Received: by 2002:a17:903:2450:b0:1b8:3c5e:2289 with SMTP id
 l16-20020a170903245000b001b83c5e2289mr12900870pls.2.1689029428872; Mon, 10
 Jul 2023 15:50:28 -0700 (PDT)
Date:   Mon, 10 Jul 2023 15:50:28 -0700
In-Reply-To: <ZKyGn5UsJaAx7Ghy@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f8ae4060029cff1@google.com>
Subject: Re: [syzbot] [kvm?] general protection fault in vmx_vcpu_run (2)
From:   syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
SYZFAIL: wrong response packet

Warning: Permanently added '10.128.0.15' (ECDSA) to the list of known hosts.
2023/07/10 22:43:25 ignoring optional flag "sandboxArg"="0"
2023/07/10 22:43:25 parsed 1 programs
2023/07/10 22:43:25 executed programs: 0
2023/07/10 22:43:28 result: hanged=false err=executor 0: failed to write control pipe: write |1: broken pipe
SYZFAIL: wrong response packet
 (errno 16: Device or resource busy)
loop exited with status 67
2023/07/10 22:43:30 executed programs: 2
2023/07/10 22:43:35 executed programs: 55


Tested on:

commit:         3f01e9fe Merge tag 'linux-watchdog-6.5-rc2' of git://w..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ed6c5aa80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5837d74dc9cc112b
dashboard link: https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
