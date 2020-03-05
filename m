Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49B217A831
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCEOxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:53:55 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37884 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCEOxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 09:53:55 -0500
Received: by mail-ed1-f66.google.com with SMTP id m9so1485379edl.4;
        Thu, 05 Mar 2020 06:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W3PXlBNCG7FpHe1bsD2Om9lQtteQxPY470S45EoSOD4=;
        b=do0F5XGyeCB9FzIA3lw3uklSKMKx1keztgNc9rrYiqbskDFSTO0PtYu1kGX41yqeDX
         pXUXCFvFC2vpdoHyk1IGsPTkfDBM+dCR19uix9mBhSSTk3MadlesE3rAODH+4BKLhbfK
         E8OYsj9k9SyTzOSB2ljfM6SomJyZrBvyIACRXI1nhbjEeub95AU2AhVZrkR5QR1m3d2c
         R3Zm6GvpnBGQf92i/AcZeNcfdMd/v3uOR9/E7XOoaAdXEZbH1/ID0AvVicm5oXNOqwce
         WgrFi1smCbdziqmMte22vHfYLnbxf9sTDsUZnlnGTWPU5h2mhdZnyW598XzBrg4BC165
         IcaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W3PXlBNCG7FpHe1bsD2Om9lQtteQxPY470S45EoSOD4=;
        b=NQJ+9DVOVJshhBiHkQvNHrpTE7Ik0qwQy2IFmbYTgP/DIzrgwPmK9Yul8ZL49WKqil
         /UDjPThVdcQgEATm1RfDdP1BjghxdPQFN1a3tREDcMAumi8+FKtoGQ3HSqLjtdsATBK8
         Bt6bmwxt9KtAzFzlfKW/OvJF3dooqE05sWFZb3rAaFONfHmhUMiG2HHpHdLCEqOaoE6q
         0RID2IE5K8hcqkGRstzJxLeNClutVr5vEWUYFTvD2XJNR55WbZz0fwUVSdSU/05o7txU
         91WZWpgF8nieu20Y62jE3M1+NgVvm4J7Y8Y5nYhbYyAtPG4CmEUXQCDWVL99BF8RNMEm
         HGRA==
X-Gm-Message-State: ANhLgQ1WLLFi1V1q0ykPgXO1VA5qXLpM7sS58a9+eo/dYXD/247Bne+d
        EPtrMV8ZMG8ka0pQsYv3W2X8nxHngW1vJVegl2s=
X-Google-Smtp-Source: ADFU+vsshS+ueiG0ttQN2fbWuz5hWypSE3ZNEEvSVg2/wXgCZ46pLFdOzL6PA6Te0DLh5DJtsWpTpNob1T99MdTYxUI=
X-Received: by 2002:aa7:dd1a:: with SMTP id i26mr8638644edv.321.1583420033239;
 Thu, 05 Mar 2020 06:53:53 -0800 (PST)
MIME-Version: 1.0
References: <20200305140142.413220-1-arilou@gmail.com> <20200305140142.413220-2-arilou@gmail.com>
 <09762184-9913-d334-0a33-b76d153bc371@redhat.com>
In-Reply-To: <09762184-9913-d334-0a33-b76d153bc371@redhat.com>
From:   Jon Doron <arilou@gmail.com>
Date:   Thu, 5 Mar 2020 16:53:42 +0200
Message-ID: <CAP7QCoj9=mZCWdiOa92QP9Fjb=p3DfKTs0xHKZYQ+yRiMabmLA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] x86/kvm/hyper-v: Align the hcall param for kvm_hyperv_exit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly recommended we will align the struct to 64bit...

On Thu, Mar 5, 2020 at 4:24 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/03/20 15:01, Jon Doron wrote:
> > Signed-off-by: Jon Doron <arilou@gmail.com>
> > ---
> >  include/uapi/linux/kvm.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 4b95f9a31a2f..9b4d449f4d20 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -200,6 +200,7 @@ struct kvm_hyperv_exit {
> >                       __u64 input;
> >                       __u64 result;
> >                       __u64 params[2];
> > +                     __u32 pad;
> >               } hcall;
> >       } u;
> >  };
> >
>
> Can you explain the purpose of this patch?
>
> Paolo
>
