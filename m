Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA051D7324
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 10:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgERImb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 04:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgERIma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 04:42:30 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15DEC061A0C;
        Mon, 18 May 2020 01:42:30 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u188so9298691wmu.1;
        Mon, 18 May 2020 01:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6rCQDnpCBqEjecCnmIenSye1eK7mw1G0XLc59v/D478=;
        b=u1ZHOQ7pY6BQXkcXjjTiCGQLgwtFQklx4tvb4P7KbjdRROcLtam5Ls9Huc9xXcsSAM
         69++inp6nmAxDqqTVa8U4LMdSOF93DC9l6CBSh6yJgdc8P+ip2BpFxlFWWULKRE5rhnE
         bhyKRAFTups7B+mXG5YdyttVSr/MsfemIUbb6xoqItdQViyhFzn6RfUxLCv6vbmI+9mP
         wN/7zxRI9fKccZyf4puhJWOSWU3V3aUZR1wV+7AKIFFJyXCU3lTbJdDRoPPQP7We2Fkg
         5SiClnlbBzffBq17zolAdasqt3gcnH9cpfhHmpG46biWl66980nvO6S6NYSaa0N64CIS
         ybWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6rCQDnpCBqEjecCnmIenSye1eK7mw1G0XLc59v/D478=;
        b=l0NUyWH7aq/Z+JVo5jX61gc71hjFqswA7XRJ5t7IBkRFHGVubzEh0jRxerPPTvjfuY
         nHTu1rdjyG0akQG3IxvO5TwOqJN/20GY2t5m4xsGCuWLVQ44hHZ4ZcoyqsUUGnOwS4+t
         QeaQrdoTMg2VR6F1hsweByIKVo9cXiR73ztOKMHp4QsUZ/ISBwdfdU4cge/jro3rAl7h
         Nfjro7v3WeHUpY+IKSjO9PAMrzjneDZ4Zcospb5syUIaldESPlpiuKbzH+zjjQArhuoy
         3JsbeEeYclD8pNikhXVSlfzLB6SlV/SYQxUMdg9gUGAa/508K7OR5FA6mXhpHAkxoOyV
         x+vA==
X-Gm-Message-State: AOAM531NK8BoP4V/0te0sY+0zYIiUQXpxvDbJkadPcgDvwHAOdUcs41V
        61V/qH44HMk5cMFNwyXWfTZoeQ9K/8uXSxHhNFc=
X-Google-Smtp-Source: ABdhPJzDWqtnuBtqUKl/Y6GWfI1D6NhnXMkeyttrmUevve7IOOSi/uq/Uy1Bnp7nvHWI2GaLTUc5Ozrxk2ILqA9jbcs=
X-Received: by 2002:a1c:2dc7:: with SMTP id t190mr17405239wmt.129.1589791349320;
 Mon, 18 May 2020 01:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-16-git-send-email-chenhc@lemote.com> <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
 <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com>
 <20200515211353.GB22922@alpha.franken.de> <CAAhV-H58G7+se6VTBMo2R4joDXngF-c_W=fh8=zD8rVnono=gg@mail.gmail.com>
 <1a22adb0-0b7a-24a3-e762-7b9919a70a8e@redhat.com>
In-Reply-To: <1a22adb0-0b7a-24a3-e762-7b9919a70a8e@redhat.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Mon, 18 May 2020 10:42:14 +0200
Message-ID: <CAHiYmc6qnvEhgX8BOhuUkQcfnLzBf_1hqoW=GKGh26KpQU5HLQ@mail.gmail.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D1=81=D1=83=D0=B1, 16. =D0=BC=D0=B0=D1=98 2020. =D1=83 13:55 Paolo Bonzini=
 <pbonzini@redhat.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=
=BE/=D0=BB=D0=B0:
>
> On 16/05/20 11:36, Huacai Chen wrote:
> >> I'm happy to see you taking care of the KVM part. So how is your plan
> >> to handle patches ? Do want to collect them and send pull requests to
> >> me ? Or should I just pick them up with your Acked-by ?
> > I think we can only use the second method, because both Aleksandar and
> > me don't have a kernel tree in kernel.org now.
>
> If you don't mind, I generally prefer to have MIPS changs submitted
> through the KVM tree, because KVM patches rarely have intrusive changes
> in generic arch files.  It's more common to have generic KVM patches
> that require touching all architectures.
>

To me, Paolo's workflow seems reasonable and efficient from practical
point of view. No unnecessary multitude of repeated series or pull sending,
and no single person is burdened with majority of work being done just by
himself for any given case of series like this one. Also, it looks to me it=
 is
quite efficient wrt possible conflict and rebase issues, that will be taken
care by both KVM/MIPS and KVM/general submitters/maintainers.

I suggest we keep Paolo's workflow plan for this series, but, more
importantly, if you guys all agree, in future as well.

Sincerely,
Aleksandar

> For 5.8 I don't have anything planned that could cause conflicts, so
> this time it doesn't matter; but I can pick these up too if Thomas acks
> patches 6, 12 and 14.
>
> Thanks,
>
> Paolo
>
