Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDD551724B
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385684AbiEBPQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238710AbiEBPQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:16:44 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098E726C2
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 08:13:16 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 15so11910859pgf.4
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 08:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gZqXMAjpC2GrxRmrdCb2L/PEy6IHm+hw+aWNQJWW42o=;
        b=sQvdsdJMDsnRynWzWu/Onoxn/KnxXVpjbdO+M77tcdR7dHAEfCSD7yLnnefPpRMOhw
         R4GoSyV7drXk4c7wg7fohQFFjgPF8MwT8pjFAK0RWF1lzGsFQ47JVoOA295qHydyqqDV
         2NXAlSxa8pvBkAkRIRZXKQnbuXQH7aBEnswuugZ7TjzylcTbNeRQUvasLLSLN7/eIVCI
         /ECus2Ij5KoiQ3x3QCi3VEfCgEGAfLBo5h3w80CTjqQIZySE6XWWU6ApOVKn8QHz5LR9
         Ci1aJGEzDaWtAeGx3B97gbgmf5Csi01g7FV2znTCC5XRlTZwgQKbOOh5OryeU1GKlyL7
         4egA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gZqXMAjpC2GrxRmrdCb2L/PEy6IHm+hw+aWNQJWW42o=;
        b=iphaPmz2Ouc6FJC6VDJmdQXH76cZ3Mcl24d2IACFj7GzEh9GIe/NO+jPupnTaS3ndG
         GoQaMll5Q1ubPvuifddUw0qumCUPpgZYazEqOjKMx1lu+6mR/yERc4sCl7AsiZv4mWBD
         xZ6u6fihzOSY2LYDe1yi7Xk7mZno51z8A5fl3EKso11mOThaNVIEg6ydknb1DMrqSyh5
         mHOrzhTyHAgOHaz83P3h0h8/Fey4Mr77Y/BrBwLiop4bSBR6/6NZgKc6gG1k8C18wTCy
         slRTyvpTwo3BdQN0JE7zNXyKjetuL4zGJMktQoNNO1u1i9y3DnwHDHa5V/OISsU+FJmS
         /rDw==
X-Gm-Message-State: AOAM530H6zXaC8K92/RK89F2IdVqc3jafTkAV6bGFRTnBxmOFmcDz60p
        3lnsPcQWktGp23L9qmv29fhgNw==
X-Google-Smtp-Source: ABdhPJycEDsz+WaokYrUN535SirUeBZ/d8h5v46MnWk1jsBhquwB1CdqjBnO+nl6UZMvY4nILbjSvA==
X-Received: by 2002:a63:78ca:0:b0:398:ae5:6515 with SMTP id t193-20020a6378ca000000b003980ae56515mr10253631pgc.345.1651504395198;
        Mon, 02 May 2022 08:13:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 1-20020a17090a1a0100b001dbe11be891sm10881858pjk.44.2022.05.02.08.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 08:13:14 -0700 (PDT)
Date:   Mon, 2 May 2022 15:13:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: [syzbot] WARNING in vmx_queue_exception (2)
Message-ID: <Ym/1B2cy73fjAx34@google.com>
References: <000000000000ed68ec05de05f7c4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000ed68ec05de05f7c4@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    57ae8a492116 Merge tag 'driver-core-5.18-rc5' of git://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16d27d72f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d21a72f6016e37e8
> dashboard link: https://syzkaller.appspot.com/bug?extid=cfafed3bb76d3e37581b
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1202b25af00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1386a07af00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 3674 at arch/x86/kvm/vmx/vmx.c:1628 vmx_queue_exception+0x3e6/0x450 arch/x86/kvm/vmx/vmx.c:1628
> Modules linked in:
> CPU: 2 PID: 3674 Comm: syz-executor352 Not tainted 5.18.0-rc4-syzkaller-00396-g57ae8a492116 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> RIP: 0010:vmx_queue_exception+0x3e6/0x450 arch/x86/kvm/vmx/vmx.c:1628

Well this is comically straightforward.  Get to invalid guest state and force an
injected exception from userspace.  KVM only bails on a pending exception, because
it's impossible (barring other bugs) to get to an injected exception, but that
obviously fails to account for userspace intervention.  I'll get a patch posted.
