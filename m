Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E612769FE80
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 23:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjBVW1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 17:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjBVW1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 17:27:43 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279054615F
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 14:27:22 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id n21-20020a634d55000000b004f340df037cso3389441pgl.22
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 14:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QyBao/zCxHE4Dryl4Lyupf40pVyBcoaZKJWwnulHvsU=;
        b=jiqI+ls/CP5PRlYuQs1bMDz6jHMbKE3Sd4Oe4xEI1wI9DJQtiM4SEo4nvgBN9y1XpD
         oMJfyBpQrQi2b9TWq9mXUYsCwPslpRNXrHRHxJuRtYXXVMSyBziLYgzRVPt5wcDgK5eE
         1f1zvMp5rSj9Dy7HC8rY8h/4iEwxSH/Yaf/jtF2q+GaDjqQoYOquNa5Ejgh5HHlPGKfW
         zY+hNqumlEnd1q7hDhOrggawkuRERbonPcWUoxtZ7DHyRatVk00PdpYHQVWf2JSPKzwS
         WSlHN5NlaSUJ0UuXeizYqbfZlaWe+UxvA15Px5C/8opb+HFoWzfiwZvD1T/2EfWwJZIU
         Ih/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QyBao/zCxHE4Dryl4Lyupf40pVyBcoaZKJWwnulHvsU=;
        b=k0VnQpxLZL3Ggc/3jCsVtjaj9eafqXzru53UJCkklCYtP6oqurXXSs8Z16rmGegeBc
         BOqMHX3kR1xm/fc61ABe6tl5t5nnKvdDN/ioDARnKWvXVcelRW/wLuqiN0AW01/6pdZw
         5r7iESaVvUUR61seBzVdVr1rLJr778J2dRrBqz1MDkAJepUMTNk3o3kKAMKNz9/7OKYT
         KTjgKOYZAGWI9KLXiOeAazEAa+brv5TnClKg2DT+KCap6A7IfYQgBitM2ZrXJG6ZqSr7
         sqGIWljGPk/W/86Qo62Yw07NqZIf1GdyR+4F3deu24withe3+sYYoBppvyXFlwLs7xik
         7x4A==
X-Gm-Message-State: AO0yUKXtvtPKooq1mNcqNw/iWpmhGWRqqv9IwMSwgizM0Cjyqobz6+yt
        5LDuQScN4PF6WRcJymcsVRIMYpE3zUU=
X-Google-Smtp-Source: AK7set/WEIYhiEiFsk9kJ8Zxu/xCARbHwDQOuPD5DoNKc1tkuXQgeBYfXOIGmO6EadMIC1o65vQwXG8vZko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3e41:0:b0:4df:6f34:48f8 with SMTP id
 l62-20020a633e41000000b004df6f3448f8mr1343624pga.8.1677104841424; Wed, 22 Feb
 2023 14:27:21 -0800 (PST)
Date:   Wed, 22 Feb 2023 14:27:19 -0800
In-Reply-To: <06d04f32-8403-4d7f-76a1-11a7fac3078e@redhat.com>
Mime-Version: 1.0
References: <20220926165112.603078-1-pbonzini@redhat.com> <YzMt24/14n1BVdnI@google.com>
 <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
 <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com> <YzRycXDnWgMDgbD7@google.com>
 <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
 <YzSKhUEg3L1eMKOR@google.com> <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
 <b8fa9561295bb6af2b7fcaa8125c6a3b89b305c7.camel@redhat.com> <06d04f32-8403-4d7f-76a1-11a7fac3078e@redhat.com>
Message-ID: <Y/aWx4EiDzKW6RHe@google.com>
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023, Thomas Huth wrote:
> On 29/09/2022 15.52, Maxim Levitsky wrote:
> > On Thu, 2022-09-29 at 15:26 +0200, Paolo Bonzini wrote:
> > > On 9/28/22 19:55, Sean Christopherson wrote:
> > > > > As far as my opinion goes I do volunteer to test this code more often,
> > > > > and I do not want to see the 32 bit KVM support be removed*yet*.
> > > > 
> > > > Yeah, I 100% agree that it shouldn't be removed until we have equivalent test
> > > > coverage.  But I do think it should an "off-by-default" sort of thing.  Maybe
> > > > BROKEN is the wrong dependency though?  E.g. would EXPERT be a better option?
> > > 
> > > Yeah, maybe EXPERT is better but I'm not sure of the equivalent test
> > > coverage.  32-bit VMX/SVM kvm-unit-tests are surely a good idea, but
> > > what's wrong with booting an older guest?
> > 
> > > From my point of view, using the same kernel source for host and the guest
> > is easier because you know that both kernels behave the same.
> > 
> > About EXPERT, IMHO these days most distros already dropped 32 bit suport thus anyway
> > one needs to compile a recent 32 bit kernel manually - thus IMHO whoever
> > these days compiles a 32 bit kernel, knows what they are doing.
> > 
> > I personally would wait few more releases when there is a pressing reason to remove
> > this support.
> 
> FWIW, from the QEMU perspective, it would be very helpful to remove 32-bit
> KVM support from the kernel. The QEMU project currently struggles badly with
> keeping everything tested in the CI in a reasonable amount of time. The
> 32-bit KVM kernel support is the only reason to keep the qemu-system-i386
> binary around - everything else can be covered with the qemu-system-x86_64
> binary that is a superset of the -i386 variant (except for the KVM part as
> far as I know).
> Sure, we could also drop qemu-system-i386 from the CI without dropping the
> 32-bit KVM code in the kernel, but I guess things will rather bitrot there
> even faster in that case, so I'd appreciate if the kernel could drop the
> 32-bit in the near future, too.

Ya, I would happily drop support for 32-bit kernels today, the only sticking point
is the lack of 32-bit shadow paging test coverage, which unfortunately is a rather
large point.  :-(
