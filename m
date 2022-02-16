Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBFC4B8677
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 12:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiBPLJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 06:09:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiBPLJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 06:09:04 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA003B151D
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:08:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v4so2099372pjh.2
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6216T9Jr8ILh5Xi4PlVIYZIESRGugtEk1/c+8pVfa8c=;
        b=iMGSldaMXYLRFZKPA1Vj3JfBHQXfHd7ST/n2ePKKw74noEFwy34gL0E0aHwMk0AN0P
         M2puD8kaBir+WiZ0E5TrhRLsznliaFVuJ0at54IScZjnSDRo9jePl/DmDU4sBwA0TvD5
         wQ6O5JzW41YovxIGVNeH0rbTTiH93VTtMN5BviX+mOFFkTWmMIovKG9p9LN3GF0o4wEC
         /7wllOvtuJDT89x6ZjVGVko6qn5W3VDH+uFwGdxjhqC6eALeZ5JpmUpXEvG4ajjfvJsd
         OHQTSokbH0VsiTTRf3dd7ukk1t/jdu4EaSYLmlO7J0Y0+NAGCmiKI7ybexDQ4Ho/1xxV
         MwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6216T9Jr8ILh5Xi4PlVIYZIESRGugtEk1/c+8pVfa8c=;
        b=ri3PriFnEPf6bQEbJsscivZGLKtKW4pIhqxeMxhCUuG1kltdwlIla9evoActlDzg/7
         Jo/COL9AZnThFswjODz7VyDCqqjA+ncVrg1HoKvfsNp+CDVVel31ZNRySDRyuef8aPj7
         e7LvsKrHT3LDJsHT54HVQEoKqwf+IbybbE2lXB8SG7DCLD2M8wzLcy/Jwvr2aUoQxIcM
         Oy5Gr74b/KHeI4bbML8PggvtahYlVPcbyIwPysK24XF+qQCTVjEY8/OC9hgJK90FXX61
         C3wAsf8BUa76fJu/TWwhk+XmjHMo897B+A4bpuLo7JBkALcfthVI2oagjIYukTgmJ+Hq
         ofZg==
X-Gm-Message-State: AOAM530aLuLEQYWNI2nBQzlqs8XPRotJm/tbKHtTv5iczNgufFOcGatm
        kX4vE0TC41T2T4kayQAdJxm70FmGJtUTUo4AV8j/uQ==
X-Google-Smtp-Source: ABdhPJzRiLUbMN+FaQn1wfDfi7EHbme/0VZtzUJJYjXrAodgYOfCtofQfyAEZS4HW1G/fFA6MXmaBS2HcaMckye0/Is=
X-Received: by 2002:a17:902:a404:b0:14b:1100:aebc with SMTP id
 p4-20020a170902a40400b0014b1100aebcmr2211777plq.133.1645009732407; Wed, 16
 Feb 2022 03:08:52 -0800 (PST)
MIME-Version: 1.0
References: <20220216043834.39938-1-songmuchun@bytedance.com>
 <20220216043834.39938-2-songmuchun@bytedance.com> <YgzWg2rY859qq4wh@monolith.localdoman>
In-Reply-To: <YgzWg2rY859qq4wh@monolith.localdoman>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Wed, 16 Feb 2022 19:08:14 +0800
Message-ID: <CAMZfGtXS-+k2zR3BKOLY-Ugi4uJ21E3mrDxRSFunfSaHKHwyig@mail.gmail.com>
Subject: Re: [PATCH kvmtool 2/2] kvm tools: avoid printing [Firmware Bug]:
 CPUx: APIC id mismatch. Firmware: x APIC: x
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 16, 2022 at 6:48 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> Would you mind rewording the commit subject to:
>
> x86: Set the correct APIC ID
>
> On Wed, Feb 16, 2022 at 12:38:34PM +0800, Muchun Song wrote:
> > When I boot kernel, the dmesg will print the following message:
>   ^^^^^^^^^^^^^^^^^^
>
> Would you mind replacing that with "When kvmtool boots a kernel, [..]"?

Will do.

>
> >
> >   [Firmware Bug]: CPU1: APIC id mismatch. Firmware: 1 APIC: 30
> >
> > Fix this by setting up correct initial_apicid to cpu_id.
>
> Thank you for fixing this. I've always wanted to fix that error, but I didn't
> know enough about the x86 architecture.
>
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  x86/cpuid.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/x86/cpuid.c b/x86/cpuid.c
> > index c3b67d9..aa213d5 100644
> > --- a/x86/cpuid.c
> > +++ b/x86/cpuid.c
> > @@ -8,7 +8,7 @@
> >
> >  #define      MAX_KVM_CPUID_ENTRIES           100
> >
> > -static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
> > +static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
> >  {
> >       unsigned int signature[3];
> >       unsigned int i;
> > @@ -28,6 +28,8 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
> >                       entry->edx = signature[2];
> >                       break;
> >               case 1:
> > +                     entry->ebx &= ~(0xff << 24);
> > +                     entry->ebx |= cpu_id << 24;
> >                       /* Set X86_FEATURE_HYPERVISOR */
> >                       if (entry->index == 0)
> >                               entry->ecx |= (1 << 31);
> > @@ -80,7 +82,7 @@ void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu)
> >       if (ioctl(vcpu->kvm->sys_fd, KVM_GET_SUPPORTED_CPUID, kvm_cpuid) < 0)
> >               die_perror("KVM_GET_SUPPORTED_CPUID failed");
> >
> > -     filter_cpuid(kvm_cpuid);
> > +     filter_cpuid(kvm_cpuid, vcpu->cpu_id);
>
> Tested it and it works:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
Thanks.
