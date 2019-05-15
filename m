Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F16E1E6BD
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 03:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfEOBnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 21:43:53 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36128 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfEOBnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 21:43:53 -0400
Received: by mail-ot1-f68.google.com with SMTP id c3so773436otr.3;
        Tue, 14 May 2019 18:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7kz9SFYwImR0l3f8y0zVuhQmYvPHKhpr+G4nFc9x4/o=;
        b=qCmhAfMIwRQJWCL2Y9rgyG5pIY6aA9FZ7wUF+E8AG8Eb5FEmu/yx67/jsNLgM6tz0+
         zCBoTRjIZgq7v5jQz6HNRrXxBgQsCJ53L+QCzohQNAKD7PMnSxHblMaU/ULREr/X3Cut
         sptfV8BJFFfOpUv+Tit0YnRYg9jfIMlHiV5hDh2fhegcIcpcrBjyH9cEvFi7fRvgvzy+
         BGTdj38Mf4JUHIW2CdNyXgtKX2C1ASR1ms6nEMp3/96tFo61uTd40ZgItbJldxg29Ukz
         pXP52Mvd8hAKtm2Qcrf+dNdrgoQ/kmuvkh9o2j79m9S5IujCfb2BXVDIcdDtux6gMtL7
         WXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7kz9SFYwImR0l3f8y0zVuhQmYvPHKhpr+G4nFc9x4/o=;
        b=Pxia9GFTlwRIqrhMPSJQaRbewloGZSk5a6vHMjVmp1Kpcmtnh6LbtzvvQ4UdrjG19L
         vB237z1Ya4h9hxKqStdNt4o7uuwkI+6y5Mj7mcmrQ1hRoqarUas3a9Vc58qp1Aw8kohc
         UbUFGOuA6txmXVfAoBuPSkohSiH8TIodHw0Z7IkHczXUM52zGocuSyfoyWkSB6yAqIgE
         VBW4+hbPE8ETPFb6EQIULIdMF3UsWHsbgDzOlmZjaPy2bmwBRRlfr1YcqyB3VSR+/JvB
         CpsSHrsW4IOwOao4+U4y6Gfr8IM4GF/veR477C7vIw18L855OXHe7YIg4JZxRlQA/ohe
         bOKw==
X-Gm-Message-State: APjAAAWzL0XAuy+g2fGbV+roPQGAieWkXK3xSvhFd5APqHadVqsRIoCA
        /ZY3l6MDw+QZnvHT8vfshDDk4oET0iqRUy0C2bE=
X-Google-Smtp-Source: APXvYqxS+vZ4kdLhnEH7p3rkKt4YFEf+YVKidFkRbQYYd3/3WHudxAcqWOflb02Z2j75+JqG9SWfTgLg4G2ma9YF9jQ=
X-Received: by 2002:a9d:7f8b:: with SMTP id t11mr22613983otp.110.1557884632649;
 Tue, 14 May 2019 18:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190507185647.GA29409@amt.cnet> <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <D655C66D-8C52-4CE3-A00B-697735CFA51D@oracle.com> <1557748312.17635.17.camel@amazon.de>
In-Reply-To: <1557748312.17635.17.camel@amazon.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 15 May 2019 09:45:14 +0800
Message-ID: <CANRm+CwFyqCeHKOv-M134k4mvpjqnaO-pUO_p0W0QTPL36+ibA@mail.gmail.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     "Raslan, KarimAllah" <karahmed@amazon.de>
Cc:     "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bsd@redhat.com" <bsd@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 May 2019 at 19:52, Raslan, KarimAllah <karahmed@amazon.de> wrote:
>
> On Mon, 2019-05-13 at 07:31 -0400, Konrad Rzeszutek Wilk wrote:
> > On May 13, 2019 5:20:37 AM EDT, Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com>
> > > wrote:
> > > >
> > > >
> > > >
> > > > Certain workloads perform poorly on KVM compared to baremetal
> > > > due to baremetal's ability to perform mwait on NEED_RESCHED
> > > > bit of task flags (therefore skipping the IPI).
> > >
> > > KVM supports expose mwait to the guest, if it can solve this?
> > >
> >
> >
> > There is a bit of problem with that. The host will see 100% CPU utilization even if the guest is idle and taking long naps..
> >
> > Which depending on your dashboard can look like the machine is on fire.
>
> This can also be fixed. I have a patch that kind of expose proper information
> about the *real* utilization here if that would be help.

You can have a post.

Regards,
Wanpeng Li
