Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032B6331AF4
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 00:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCHX3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 18:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhCHX3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 18:29:20 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5805CC06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 15:29:20 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o38so7467826pgm.9
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 15:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CmfxbJbsR32j2stPZTCAVs668uTJmv8SU8V0tORla8k=;
        b=loMSgpyCPFx0qqhEygDCduyPFZcBermyVhL9olczMSLnaHjD/dewtfsl3m0CMLrPKW
         HXffVL050IlTqPDH4XUokC47IidmWHhOUHXb7DL2WP7BTYVoXWLpJlrhtF5DTg83tahq
         Z++bWV0GgCBfSIqO1csGQ3rGm1M8ID4CYAaO4VzebEqfnBSL2hsEuqZ7ekbj5Cb5FCKA
         mKM0S4UCyPIWPUNlTPZrj3//ayV+tgpuO3/LxPKjm9ImwrhQUZfa6gfUgwVwDjzlGhDd
         nucwhzOM8f2Dr8woxq8Awiml9V8mwXXMyVWntouwPKeia7Fu7QnUaYe/4BrxpjLWsu9T
         XKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CmfxbJbsR32j2stPZTCAVs668uTJmv8SU8V0tORla8k=;
        b=k88Xii20+EkEFsX6BVmAN2gOOZzhgMtR0Lv0b6q7i/4JkfoCiDAY84uPZejqBuyKT8
         kVzVnZdqOtn7grwUoHQ6sOqk1NjfGPHK6rB+v3zHDyojJt/r7WnXixjTymlJrGOqfN5K
         Cgk7laN5XEKB5/E2FiCslQR13N4jO/Cmy6Ztr/HzCRyqg28Q40T6EwZPMaAXWFb7WOy7
         Ad4CRThVKDssdQdmnggqkSHs4Ni3eU1RLbh21iMF6SbYEE7xu6TB0bdu77liHTg2hxFh
         WzemBPS18IL30hryaZsrvqB/iZZoeJ1uBFVR6A87lTsuULqNnvJUTcPCtV4ej3u5KRga
         alvw==
X-Gm-Message-State: AOAM530GBJ8jtZtVwUW222EjpKd509qItPlQjlXCh9hJ8mkm4ig4uVtm
        ABgGQuFgy4FBUJ88ljsEiZkmnQ==
X-Google-Smtp-Source: ABdhPJxpn6GHNZAPqETOhgrPoqObmFdwbzRNeB6gxDD3X7bTKOUHCY3nYHX3mMJ+o0dP5thKkYD4ew==
X-Received: by 2002:a63:e22:: with SMTP id d34mr22551523pgl.264.1615246159344;
        Mon, 08 Mar 2021 15:29:19 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id y6sm11950866pfm.99.2021.03.08.15.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 15:29:18 -0800 (PST)
Date:   Mon, 8 Mar 2021 15:29:12 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+3c2bc6358072ede0f11b@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in kvm_wait
Message-ID: <YEazSAsa2l6KQZwL@google.com>
References: <0000000000003912cf05bd0cdd75@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003912cf05bd0cdd75@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a38fd874 Linux 5.12-rc2
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14158fdad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=db9c6adb4986f2f2
> dashboard link: https://syzkaller.appspot.com/bug?extid=3c2bc6358072ede0f11b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1096d35cd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16bf1e52d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3c2bc6358072ede0f11b@syzkaller.appspotmail.com

Wanpeng has a patch posted to fix this[*], is there a way to retroactively point
syzbot at that fix?

[*] https://lkml.kernel.org/r/1614057902-23774-1-git-send-email-wanpengli@tencent.com
