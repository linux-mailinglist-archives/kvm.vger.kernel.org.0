Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B8332DE0A
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 00:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhCDXvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 18:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhCDXvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 18:51:50 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4637C061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 15:51:49 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id ba1so366691plb.1
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 15:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OXSfr2dabCSvdFRUAzNzC8wQejac0UjQtMYaN+FXYKk=;
        b=stE3m++/iGDyiGc9o3fu84MVOWZUsRRvCJGX4SHMhA0uTiAYXG2r+2IjLFpDbM7Ic5
         wdSB54z0J+GYobdHMBWLaiF83w9GCZKcRVAFJogRlq0Lkd5WbV1Ps1GSCuWZKWhYIH/b
         HGD9Itn8q7SciMCBbnfm6HQ4zzFq7lDY4tsF1gNaSmEHaxrVMp3kU9PYVMtzlg8tg4gn
         WzZbNOCe/4RpmkVLfQkCT6wdya/ca+XMiZrYoEmL6omTyg1nZ3sDxpjwnie/YeBuqt4V
         p0GktkGr+Mm4hR0FpiK8ctZsDqO5pstn2Cooo15/nJCBKQqogdCm1N7rB83MdaLpbrVn
         nKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OXSfr2dabCSvdFRUAzNzC8wQejac0UjQtMYaN+FXYKk=;
        b=FAKtCHgAOrvwG5EwmpIuQeZHlKDWAz5yyDa5HgkC62sXQ7qsf4duxz346BSUAObtR5
         4qVds+iGb0jgIMvuzhLzK4y45MuzFq3Na94ILGLoXSz8rga4+Gl/4nlmjGsMcJfAY429
         XkEf2ghtpX4qOWgxExmJKy6WRSRPnJmFLypXOnAkAwvMFAJu6N7tAxalRZdt+HZJdxB6
         RiZz9HaOaO7ApE7+bYNQhT8sY0VfL2uAXuCfN49DLReDTBxfJO9PPYSLnpLfjyRpyWUB
         JEUO4JqXmcQeXe+khf3Qo3tp/hfVQdM51OERsWPQi4ltcIBjTpfCM73K30e09Z8BdHkv
         ftxw==
X-Gm-Message-State: AOAM530tenGKQjtJWBaYpUuo5e0atwmVfUKNUkcC87xXEtjTjJ145Y6E
        lUF0GTsj4/RpRIVrIcu7thtjJtrQowoPXg==
X-Google-Smtp-Source: ABdhPJztBXto5m76DGiuLZ+N4lYSCUxyX25pHdM3nm5pZ4z/p6uNUFKDRA822D5mSyPjIqaXGmEXag==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr7194261pjq.124.1614901909348;
        Thu, 04 Mar 2021 15:51:49 -0800 (PST)
Received: from google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
        by smtp.gmail.com with ESMTPSA id y202sm424952pfb.153.2021.03.04.15.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 15:51:48 -0800 (PST)
Date:   Thu, 4 Mar 2021 15:51:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: Problem With XFS + KVM
Message-ID: <YEFyjtsftfU2WRPg@google.com>
References: <BYAPR04MB4965AAAB580D73E3B03E7E7886979@BYAPR04MB4965.namprd04.prod.outlook.com>
 <20210304231359.GT4662@dread.disaster.area>
 <BYAPR04MB49657CB2E5F0C2F2FC4F24E686979@BYAPR04MB4965.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB49657CB2E5F0C2F2FC4F24E686979@BYAPR04MB4965.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021, Chaitanya Kulkarni wrote:
> On 3/4/21 15:14, Dave Chinner wrote:
> >> 00000000003506e0
> >> [  587.766864] Call Trace:
> >> [  587.766867]  kvm_wait+0x8c/0x90
> >> [  587.766876]  __pv_queued_spin_lock_slowpath+0x265/0x2a0
> >> [  587.766893]  do_raw_spin_lock+0xb1/0xc0
> >> [  587.766898]  _raw_spin_lock+0x61/0x70
> >> [  587.766904]  xfs_extent_busy_trim+0x2f/0x200 [xfs]
> > That looks like a KVM or local_irq_save()/local_irq_restore problem.
> > kvm_wait() does:
> >
> > static void kvm_wait(u8 *ptr, u8 val)
> > {
> >         unsigned long flags;
> >
> >         if (in_nmi())
> >                 return;
> >
> >         local_irq_save(flags);
> >
> >         if (READ_ONCE(*ptr) != val)
> >                 goto out;
> >
> >         /*
> >          * halt until it's our turn and kicked. Note that we do safe halt
> >          * for irq enabled case to avoid hang when lock info is overwritten
> >          * in irq spinlock slowpath and no spurious interrupt occur to save us.
> >          */
> >         if (arch_irqs_disabled_flags(flags))
> >                 halt();
> >         else
> >                 safe_halt();
> >
> > out:
> >         local_irq_restore(flags);
> > }
> >
> > And the warning is coming from the local_irq_restore() call
> > indicating that interrupts are not disabled when they should be.
> > The interrupt state is being modified entirely within the kvm_wait()
> > code here, so none of the high level XFS code has any influence on
> > behaviour here.
> >
> > Cheers,
> >
> > Dave.
> > -- Dave Chinner david@fromorbit.com
> 
> Thanks a lot for the response Dave, that is what I thought, just wasn't
> sure.

Yep, Wanpeng posted a patch for this.

https://lkml.kernel.org/r/1614057902-23774-1-git-send-email-wanpengli@tencent.com
