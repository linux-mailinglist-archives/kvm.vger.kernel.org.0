Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060AC32B5BC
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449289AbhCCHTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:44 -0500
Received: from tr21g11a.aset.psu.edu ([128.118.146.164]:54176 "EHLO
        tr21g11a.aset.psu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573777AbhCBUAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 15:00:11 -0500
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (authenticated bits=0)
        by tr21g11a.aset.psu.edu (8.15.2/8.15.2) with ESMTPSA id 122JxIUq018989
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 14:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=psu.edu;
        s=authsmtp_2020; t=1614715159;
        bh=LMmfGmKCfzgLgKGl/Sw65K2lkdEfK5EcXiuTVyy/Joo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mV5vixxtzBUJ4q0HFEUlBUdVNceHgW8gtDPxmGPQQ9uV3XJOtcNz3GTlpbIszLVgD
         OwAPdi9+ekyhJDleMAl5iRXml2wSsjy/c8iFOQsbaFHBFCwBBp/c6LdvltFldzXWpx
         dwKgK4VmEXRvvYbRWnXwRMbHwKkja/wBzaBfRZLZtgd+u2syw/T/Yk4ueeCGq8pGc+
         qdLAWZzkppHyCG8LuRYbzVx8/v4hTASswoIOhTuADpC3gtI5ph9q3pzXuuXA1yPqC0
         H8EYvjn41az97Btj/lITpOFvrK0bhAaShdVvw1kfE29h0Dp5znZfuBsqGvq3GENNVN
         6jxap7yVkC5Og==
Received: by mail-oi1-f179.google.com with SMTP id j1so23309268oiw.3
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 11:59:19 -0800 (PST)
X-Gm-Message-State: AOAM531O3ESbRV3YNkUFQkjkUVzXag/PPImVg5aIYIPEOGstDjc9appL
        iGwyH0SBmYMD4UfwAEfGvfFlt/S9JxnxdT4MdkRcdA==
X-Google-Smtp-Source: ABdhPJw3mDRZ/LOBiDEVLcavdoH+tu5sxt//Z5L0JuUnUF/yRf90rakDS/qeqHTWuz8sbCg+D8uNjXMIdTTF7jzVxUQ=
X-Received: by 2002:aca:b389:: with SMTP id c131mr4563490oif.99.1614715158780;
 Tue, 02 Mar 2021 11:59:18 -0800 (PST)
MIME-Version: 1.0
References: <CAPn5F5zvmfpo3tdbfVDYC+rTBmVzQ8aGYG+7FrcbeRsnZKPs-w@mail.gmail.com>
 <0f76acb4-48ee-1e20-f3f1-de4efa276620@intel.com>
In-Reply-To: <0f76acb4-48ee-1e20-f3f1-de4efa276620@intel.com>
From:   Aditya Basu <aditya.basu@psu.edu>
Date:   Tue, 2 Mar 2021 14:59:04 -0500
X-Gmail-Original-Message-ID: <CAPn5F5xms0LnffB78ep-nsHH7LiJYaWv_1c0=Awfz9zcciaogQ@mail.gmail.com>
Message-ID: <CAPn5F5xms0LnffB78ep-nsHH7LiJYaWv_1c0=Awfz9zcciaogQ@mail.gmail.com>
Subject: Re: Processor to run Intel PT in a Guest VM
To:     "Xu, Like" <like.xu@intel.com>
Cc:     "Jaeger, Trent Ray" <trj1@psu.edu>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Milter: Strip-Plus
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks a lot for the information. From what I see, the Atom P series
are server-grade processors.

Would you happen to know if any Desktop/Workstation processors (ex.
10th gen i9) also support this feature?
Specifically, I'm referring to Comet Lake, here --

https://ark.intel.com/content/www/us/en/ark/products/codename/90354/comet-l=
ake.html

Aditya


Aditya

On Mon, Mar 1, 2021 at 8:16 PM Xu, Like <like.xu@intel.com> wrote:
>
> On 2021/3/2 2:48, Aditya Basu wrote:
> > Hi all,
> > I am a PhD student at the Pennsylvania State University. For my
> > current project, I am trying to run Intel Processor Trace (PT) inside
> > a Guest VM. Specifically, I want to run KVM in the "Host-Guest mode"
> > as stated in the following bug:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D201565
> >
> > However, I *cannot* find an Intel processor that supports this mode. I
> > have tried using Intel's i7-7700 and i7-9700k processors. Based on my
> > findings, the problem seems to be that bit 24 (PT_USE_GPA) of
> > MSR_IA32_VMX_PROCBASED_CTLS2 (high) is reported as 0 by the processor.
> > Hence, KVM seems to force pt_mode to 0 (or PT_MODE_HOST).
>
> You may try the Intel Atom=C2=AE Processor P* Series.
>
> https://ark.intel.com/content/www/us/en/ark/products/series/29035/intel-a=
tom-processor.html?wapkw=3DAtom#@Server
>
> >
> > I would appreciate any pointers that someone might have regarding the
> > above. Specifically, I want to find an Intel processor that supports
> > running Intel PT in "Host-Guest mode".
> >
> > Regards,
> >
> > Aditya Basu
> > PhD Student in CSE
> > Pennsylvania State University
> > https://www.adityabasu.me/
>
