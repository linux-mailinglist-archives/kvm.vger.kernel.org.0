Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022139FD6A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfH1IrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 04:47:25 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34119 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfH1IrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 04:47:24 -0400
Received: by mail-oi1-f193.google.com with SMTP id g128so1503793oib.1;
        Wed, 28 Aug 2019 01:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wvXkpVgy6884rDBDub7GSrouN3alYy0RjubNjRU4D8c=;
        b=fF1VTJyoZfOh/nue2zV6YK0gz/XCdIae5JY/qHfApx9B7F2xZT2NBmDMMpguRZNaZD
         KPxZJa9DWjfbKJxoKa5zhA3DXFM8IWlFPzwTQ4omHTIo5ZCDmX1QCuQgvNTbo09iOvEp
         yhAV8mM74MNFpQ8ezqwXpcITtWQAyzmryrBqw0digdqAFDZa0jNCBP9xCDw43BBeKr32
         scty0zVhhc/5xdluSu6mvF6iBiSx+SNFOSlFOCmDhAISSHTA2q7YTEAX76RvzgkV93i+
         VUUtDnDXVX8C2dqSyd6/tZIjHxJAFnDJqCsLkCK1euNorCqdpODqosOL+9CUkmkk7EXB
         +NQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wvXkpVgy6884rDBDub7GSrouN3alYy0RjubNjRU4D8c=;
        b=qiRrWS/VQ3oYacHXTIkzAZ4LWlHDNbh6lE3kcpSSCdgXmQOHlakU3S/31qJF6Dqyvt
         Up9eZFf8Nxxq+lu/Zefhj1VoANwk1gT0SYGIzrMSmX8ypqpheSY6cRd0r6sqz2E/0xr7
         dNm+h2pTvHVt9r26vPAcUowXECsaIiiW6lWWLSyw8XXCIa7hMWT1Zy4xvGFvnrwYmpSb
         0QGeHJ1uxbRJDON1m5gwtu3TAk30zsCuhHynF4+qdi81msPbm7zpZJYwI93mkag4td48
         tEaNTym/ZI3XIm/woua71mYsS/nec+CQYf9NGAtU2z1/W3ar6SFi5/AnlSEgwRFro8/q
         MCHg==
X-Gm-Message-State: APjAAAXgPsFUwWMku4hRauOp8Q6PNBGlbjOZvzkv1cvso2Femtg4w6MV
        ohXhyS43P+YXQNeLMJMSm2iVB7zT3obt+gwRTlg=
X-Google-Smtp-Source: APXvYqypLx3K4rWNLLZYA/GQnRqFih0CeElXVoPUwwnmxm+jKccr7fsFsDB0jQwV9ey6FHJU6J/HlaktN6yEMFzdUmE=
X-Received: by 2002:aca:d410:: with SMTP id l16mr1887721oig.141.1566982043664;
 Wed, 28 Aug 2019 01:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com> <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet> <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet> <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
 <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com> <CAJZ5v0iQc0-WzqeyAh-6m5O-BLraRMj+Z7sqvRgGwh2u2Hp7cg@mail.gmail.com>
In-Reply-To: <CAJZ5v0iQc0-WzqeyAh-6m5O-BLraRMj+Z7sqvRgGwh2u2Hp7cg@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 28 Aug 2019 16:48:00 +0800
Message-ID: <CANRm+CyHwAKDGtEDkKz_u9e5pzrV=h8K5=9CWt7Fv+PzYUheHA@mail.gmail.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Aug 2019 at 16:45, Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Aug 28, 2019 at 10:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Tue, 27 Aug 2019 at 08:43, Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > Cc Michael S. Tsirkin,
> > > On Tue, 27 Aug 2019 at 04:42, Marcelo Tosatti <mtosatti@redhat.com> w=
rote:
> > > >
> > > > On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> > > > > On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com=
> wrote:
> > > > > >
> > > > > > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > > > > > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > > > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > > > > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > >>
> > > > > > > >> The downside of guest side polling is that polling is perf=
ormed even
> > > > > > > >> with other runnable tasks in the host. However, even if po=
ll in kvm
> > > > > > > >> can aware whether or not other runnable tasks in the same =
pCPU, it
> > > > > > > >> can still incur extra overhead in over-subscribe scenario.=
 Now we can
> > > > > > > >> just enable guest polling when dedicated pCPUs are availab=
le.
> > > > > > > >>
> > > > > > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > >> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > > > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > >
> > > > > > > > Paolo, Marcelo, any comments?
> > > > > > >
> > > > > > > Yes, it's a good idea.
> > > > > > >
> > > > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> >
> > Hi Marcelo,
> >
> > If you don't have more concern, I guess Rafael can apply this patch
> > now since the merge window is not too far.
>
> I will likely queue it up later today and it will go to linux-next
> early next week.

Thank you, Rafael.

Regards,
Wanpeng Li
