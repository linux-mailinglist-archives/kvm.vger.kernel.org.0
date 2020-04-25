Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272271B8921
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgDYTrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 15:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgDYTrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 15:47:36 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0044FC09B04D
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 12:47:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k18so5135768pll.6
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 12:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=su/TZCdqsGvDX9O/dILShocQiIYHImvs41WopVEj3dw=;
        b=HSXwK1S0RYPgtPSMNgcEjmafSf61If+0xsLS+GSFa2PueznsCEQ0seads/QyC49eam
         ChF2VREKs79Xr2/x1ZXz/hxctXZzXzSm+dKeuSZ95p5d0d9wlWufoRlNviyr31NcTuPi
         ds/VTJnblzlXan6xNWu5FVl05hOJTzbCmH7FnIrRgzN9MwKqO7iu7VFWv8xkBoY6GpDl
         Jznip7aJE891SixfzCyH9GiFuwWvLoOukW3NU363SZ3X+hewceNu0/cauA9MStDr+tgz
         ndotP6Bq4jE6rI35SQCmWMndOsi1yWHYH0/LiDg6y8dKccC3HNc4Yb/re7xLVArFp9Cf
         9afg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=su/TZCdqsGvDX9O/dILShocQiIYHImvs41WopVEj3dw=;
        b=HgmgXTCXuYYtEsXJT9M+xnHfYfRxapYt97Dk5+xJk+895Ce2MzDimCL0+zMd4Q/PP5
         AC2AdH0apUc91Ig0x1gJp/A6Lb2GAJQWC+/88yXOPKHgTDn5Nrte2kTFcUeT3VoRLhHK
         HOqmLpSUYUq3qjgt4o7RiekgKoPzMBBgBWP6K+AZWqfrJmLqevd+XOHpVE/WPaNU8fIw
         8EzZwSdXJMVvJuW5sZArCHqfsoamLKsCGOVwxdMsAsMmsDEzwr+udfb+Q8LYQteyksam
         4aBPC8e+h1LGu77ICbGnH3HPAAQGhG8uuCu5VeU6OJIW9q3fud+IPktRXprzf1GrSP2J
         bq9Q==
X-Gm-Message-State: AGi0Pubytu0hRk0nHfDpZbfqLlxnEq0sxMuegfVA8NGdxkQpf8xXu7ta
        BlQvxT4ZJhid8qZXjpxlnSt5mA==
X-Google-Smtp-Source: APiQypKEMhdWCQosOVFNGGvelzt3tcfdxzwTQ4wUUFKoxDVH8RdkAuEGYoNGN00zKueIqusTJ5+Cmg==
X-Received: by 2002:a17:90a:d984:: with SMTP id d4mr14044440pjv.59.1587844054298;
        Sat, 25 Apr 2020 12:47:34 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:d16f:990f:8780:729d? ([2601:646:c200:1ef2:d16f:990f:8780:729d])
        by smtp.gmail.com with ESMTPSA id b2sm7567961pgg.77.2020.04.25.12.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 12:47:33 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] Allow RDTSC and RDTSCP from userspace
Date:   Sat, 25 Apr 2020 12:47:31 -0700
Message-Id: <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
References: <20200425191032.GK21900@8bytes.org>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
In-Reply-To: <20200425191032.GK21900@8bytes.org>
To:     Joerg Roedel <joro@8bytes.org>
X-Mailer: iPhone Mail (17E262)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 25, 2020, at 12:10 PM, Joerg Roedel <joro@8bytes.org> wrote:
>=20
> =EF=BB=BFOn Sat, Apr 25, 2020 at 11:15:35AM -0700, Andy Lutomirski wrote:
>> shift_ist is gross.  What's it for?  If it's not needed, I'd rather
>> not use it, and I eventually want to get rid of it for #DB as well.
>=20
> The #VC handler needs to be able to nest, there is no way around that
> for various reasons, the two most important ones are:
>=20
>    1. The #VC -> NMI -> #VC case. #VCs can happen in the NMI
>       handler, for example (but not exclusivly) for RDPMC.
>=20
>    2. In case of an error the #VC handler needs to print out error
>       information by calling one of the printk wrappers. Those will
>       end up doing IO to some console/serial port/whatever which
>       will also cause #VC exceptions to emulate the access to the
>       output devices.
>=20
> Using shift_ist is perfect for that, the only problem is the race
> condition with the NMI handler, as shift_ist does not work well with
> exceptions that can also trigger within the NMI handler. But I have
> taken care of that for #VC.
>=20

I assume the race you mean is:

#VC
Immediate NMI before IST gets shifted
#VC

Kaboom.

How are you dealing with this?  Ultimately, I think that NMI will need to tu=
rn off IST before engaging in any funny business. Let me ponder this a bit.

>=20
> Regards,
>=20
>    Joerg
>=20
