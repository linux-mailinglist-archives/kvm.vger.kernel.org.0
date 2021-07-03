Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A6D3BA7A2
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 09:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhGCHPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jul 2021 03:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhGCHPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jul 2021 03:15:24 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61364C061762;
        Sat,  3 Jul 2021 00:12:50 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id r16so16654954ljk.9;
        Sat, 03 Jul 2021 00:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GAW9lnwtVnFyUtaQ5AmfL6215rSilhWJrqizpVhadjs=;
        b=Bl4yNlVjfNtoEaRxV9M017/FxDtGa8R7KQS1fmdm17WAoe3QYCDN5cLexWrffcbE5u
         9O17DV0iFoeIpapzmEQrE0Zf6lPRwcny1lp3TzVMhaJCpCVPKEOUQizqRRlROMMMp+4F
         dS0yRv+sPAWA6qhx/RSIMd6TbSo5Nc0YIGCPeSN/aQ4pUg2Z07rT3I4mdfmYEErTFz6o
         l5DIPWPk5RBBgstmWkHxe7KfXlN440yF62gnxdC2WmheQcQgsatYXlFPC9sL3aJ6WcDN
         q+5muDuzvTFrnslV2CtI1WH4twKU4O5KFeh9lyVzhdaw/FzVwvupb9rY9fLO1SmlmnH4
         lN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GAW9lnwtVnFyUtaQ5AmfL6215rSilhWJrqizpVhadjs=;
        b=W9VSdHfte1aYVmnQ0YjjuOQ0y+1rjaPii73OF4HJPO1jM1J33+xKrlZrqNK76Ly//J
         CBfM1UGnCP02ac4MCBhsUq7rtvrZ/QX7DKTnkPrxGMMmuld5HKdWzijhw12BV5fgc0G7
         eFSzaR+DSE3s9wJQgrS0fSKt6aAXFDr04w5OFnoeSWI7wn96EqxYZApeyvSND/WMRTRD
         qZMe2EO1AQZLGMO7RbGmrJAE+v3PHdTnWRB86sqbonfGyaudkxoLwqh3K6LccN3GnOkp
         MfbUTs/pCzGUV966FkqZpoSZlm9Fy9PumReqP2ylWf4f5DaWOhecc81e/cCQSGh6q/qK
         /AyA==
X-Gm-Message-State: AOAM530zj4fIEu0zouMlnxsoZzguXodopjHyPEmJJX2OxD3KxNt2XB6+
        xvGwtY7gkHy6wSkr75beUVA=
X-Google-Smtp-Source: ABdhPJyG85iqr6p6mzaTPkHbbVMhCQlLB1QcTSaLtwc5XN/Cycv7XyXEPhSS5wG3J64B2X3ZClUI7A==
X-Received: by 2002:a2e:9cc2:: with SMTP id g2mr2626717ljj.295.1625296368553;
        Sat, 03 Jul 2021 00:12:48 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.116])
        by smtp.gmail.com with ESMTPSA id x20sm596530lji.38.2021.07.03.00.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 00:12:48 -0700 (PDT)
Date:   Sat, 3 Jul 2021 10:12:43 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in kvm_dev_ioctl
Message-ID: <20210703101243.45cbf143@gmail.com>
In-Reply-To: <000000000000bfb6cf05c631db0b@google.com>
References: <000000000000bfb6cf05c631db0b@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 02 Jul 2021 23:05:26 -0700
syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e058a84b Merge tag 'drm-next-2021-07-01' of
> git://anongit... git tree:       upstream
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=171fbbdc300000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=8c46abb9076f44dc
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=c87d2efb740931ec76c7 syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=119d1efc300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c58c28300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit: Reported-by:
> syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com
> 

Corresponding fix was sent about 2 days ago
https://patchwork.kernel.org/project/kvm/patch/20210701195500.27097-1-paskripkin@gmail.com/



With regards,
Pavel Skripkin



