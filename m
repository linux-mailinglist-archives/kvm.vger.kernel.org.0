Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED537CBEA
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhELQiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242047AbhELQbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 12:31:43 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B668C061364
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 09:06:42 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q15so14282065pgg.12
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 09:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dgHbOLOeSj5WKbYYrBAPLjp+f/dwtBzWBZ4797F6XUY=;
        b=e0Y+6aQ4yaGK7mLERwh7bRnbUGpEsba/vWgxviu4hiqJ2TDknS0YbLE/PCHvBHKLdp
         r7rXRSv4M5zcTlW3mVyZHXRvuF8v9zhy76xYEGfbeNlCjMXQ7kMxFz7OsOahEo+azl/u
         DXDUdie3Vre2iSrbE8UIxNHonczaH1OfjmNvZ6u9h4z9/I7PUgQ6cg/5Y0PuCHO9Qq24
         6h+dkMBG9aJ+JlrmMDRWglC1RCfXZmpUuzcxOT9IqunqkiEJcaD7gr5ExafEkb4c6taK
         YGKSlxUPquyGLHjlSDd+yGfPUEEgITzLRCtLOwET6Wjdb4lc+mq2rfcHhh6XpbbJre3U
         7I+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dgHbOLOeSj5WKbYYrBAPLjp+f/dwtBzWBZ4797F6XUY=;
        b=CQpaYJjii/WI1VoDXg9xXVEeImfbCyfIzEXfTTYypB6PgkLQWo5D6eK40I4G/hiFpp
         aGv+dU62T6veqwS6NsFt9NkgGgpT+o0d5As7drqRKQ8/gB9Qoe2AgnJwDjHEjhr+c4JZ
         80yj0BhkiBSVwlw4qnvIQOzEcBNVAih71208SivPM6BLLrDxVevvwq8nSboAjtb1GAX5
         QUcPHCsJ/AsHpPrY1wK58X3zdipGeVXQGtgCudVcT+ASFvfAsRxx0tpu26mImT7AgsGv
         eeCR4rKwfQahhtPYubiVEafr6rhLCdAoB6sCPnJo7CGMAc7N+HBzekYmFVVo0JthSZfL
         uaAw==
X-Gm-Message-State: AOAM533doIY3OJERyYbMgLYOypilOJtBxO4EtTkqRBKVhG+3EctQ4qqY
        TVwa5TdZrahVJxEBSIr16l013NswbUsL5Q==
X-Google-Smtp-Source: ABdhPJwCnyutMSxtRMlZCImn/MhoJ/z1aUOeS5rTLjqqupr6g4dPYtzV1nLinn5hNQDtN8Brl2rMBA==
X-Received: by 2002:a62:3003:0:b029:28e:74d9:1e16 with SMTP id w3-20020a6230030000b029028e74d91e16mr37368927pfw.21.1620835601750;
        Wed, 12 May 2021 09:06:41 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id b13sm240823pfl.140.2021.05.12.09.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 09:06:41 -0700 (PDT)
Date:   Wed, 12 May 2021 09:06:37 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        drjones@redhat.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJv9DYIvqRW24P5C@google.com>
References: <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <YJRADhU4CcTE7bdm@google.com>
 <8a99d57b-0513-557c-79e0-98084799812f@redhat.com>
 <YJuDYZbqe8V47YCJ@google.com>
 <4e83daa3-3166-eeed-840c-39be71b1124d@redhat.com>
 <348b978aad60db6af7ba9c9ce51bbd87@kernel.org>
 <628dca08-4108-8be1-9bea-8c388f28401e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <628dca08-4108-8be1-9bea-8c388f28401e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 10:52:09AM +0200, Auger Eric wrote:
> Hi,
> 
> On 5/12/21 10:33 AM, Marc Zyngier wrote:
> > On 2021-05-12 09:19, Auger Eric wrote:
> >> Hi Ricardo,
> >>
> >> On 5/12/21 9:27 AM, Ricardo Koller wrote:
> >>> On Fri, May 07, 2021 at 04:08:07PM +0200, Auger Eric wrote:
> >>>> Hi Ricardo,
> >>>>
> >>>> On 5/6/21 9:14 PM, Ricardo Koller wrote:
> >>>>> On Thu, May 06, 2021 at 02:30:17PM +0200, Auger Eric wrote:
> >>>>>> Hi Ricardo,
> >>>>>>
> >>>>>
> >>>>> Hi Eric,
> >>>>>
> >>>>> Thank you very much for the test.
> >>>>>
> >>>>>> On 5/3/21 9:12 PM, Ricardo Koller wrote:
> >>>>>>> On Mon, May 03, 2021 at 11:32:39AM +0100, Marc Zyngier wrote:
> >>>>>>>> On Sat, 01 May 2021 00:24:06 +0100,
> >>>>>>>> Ricardo Koller <ricarkol@google.com> wrote:
> >>>>>>>>>
> >>>>>>>>> Add the infrastructure needed to enable exception handling in
> >>>>>>>>> aarch64
> >>>>>>>>> selftests. The exception handling defaults to an
> >>>>>>>>> unhandled-exception
> >>>>>>>>> handler which aborts the test, just like x86. These handlers
> >>>>>>>>> can be
> >>>>>>>>> overridden by calling vm_install_vector_handler(vector) or
> >>>>>>>>> vm_install_exception_handler(vector, ec). The unhandled exception
> >>>>>>>>> reporting from the guest is done using the ucall type
> >>>>>>>>> introduced in a
> >>>>>>>>> previous commit, UCALL_UNHANDLED.
> >>>>>>>>>
> >>>>>>>>> The exception handling code is heavily inspired on kvm-unit-tests.
> >>>>>>
> >>>>>> running the test on 5.12 I get
> >>>>>>
> >>>
> >>> Hi Eric,
> >>>
> >>> I'm able to reproduce the failure you are seeing on 5.6, specifically
> >>> with kernels older than this commit:
> >>>
> >>>   4942dc6638b0 KVM: arm64: Write arch.mdcr_el2 changes since last
> >>> vcpu_load on VHE
> >>>
> >>> but not yet on v5.12. Could you share the commit of the kernel you are
> >>> testing, please?
> >>
> >> my host is a 5.12 kernel (8404c9fbc84b)
> > 
> > Time to compare notes then. What HW are you using? Running VHE or not?
> VHE yes. Cavium Sabre system.
> 

On my side. VHE (v5.12) on both QEMU (5.2.0 cpu=max) and Ampere Altra.

> Thanks
> 
> Eric
> > 
> > Thanks,
> > 
> >         M.
> 
