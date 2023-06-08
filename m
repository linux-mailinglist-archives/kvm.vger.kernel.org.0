Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA17728295
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 16:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbjFHOYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 10:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbjFHOYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 10:24:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBDC2D5F
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 07:23:31 -0700 (PDT)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-2Z-2RWyMN0Kk8UEVDTG5UA-1; Thu, 08 Jun 2023 10:23:27 -0400
X-MC-Unique: 2Z-2RWyMN0Kk8UEVDTG5UA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30c5d31b567so308389f8f.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 07:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686234206; x=1688826206;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ylaz4EsLWG8gT+tyBhiFM3PeWqHKsVLZz02Gzuw52i8=;
        b=ApQlSpyp56SD2z79H34ky74KFd6NxDNK1TRjoqAIN6xl3yktDGnxxY5oXE5L7aixnL
         M/q6gIBTGEcyBo7XKSRJ1Bv3zOEUv3YaWv99X+z1DQJnZ5MfPAimno3UN4FJWMzrwsPJ
         sYgqd1IpmXIXXC2pcIt2/Sl7vq75VLF1jFkhq5ULDDEOyxs3x4F3YIGgcJ/1WAhNzWl9
         pHi1x9ZHm1d9y9jm65w3toTnJG2xIG7VZONJG+a56kxyakGD+yxHG7a7bgyQRB4gwefp
         KO4cZd9g9PWv/wxlaISWqO/jlgZzeeH+6p5Pr8vmnIF4iBqrr6bbZJ9YdsoDNMHl+RXZ
         xEaA==
X-Gm-Message-State: AC+VfDwPSD26r/ttOz4EsXfoijzecp5Wrfg6r/RT0XkR+Us5bBwjTlq2
        KrfRk4RIh6B87ZpSEpR+T7iGInB4bCevM8CdydIc/77FknrxNtaY30D8gAznPQEBlPagzG5nfqs
        DUMl/eHb8v2/1
X-Received: by 2002:adf:dfc1:0:b0:30e:4886:3533 with SMTP id q1-20020adfdfc1000000b0030e48863533mr7800347wrn.34.1686234206023;
        Thu, 08 Jun 2023 07:23:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6c9mr4sGROJv3wpcDBq+xuHW3beEKuX1wsKDRXlb1F7uOxTNYgZiIdVFsqG1xx2NOA7F1/fA==
X-Received: by 2002:adf:dfc1:0:b0:30e:4886:3533 with SMTP id q1-20020adfdfc1000000b0030e48863533mr7800329wrn.34.1686234205650;
        Thu, 08 Jun 2023 07:23:25 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id 26-20020a05600c021a00b003f7f475c3c7sm2175514wmi.8.2023.06.08.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 07:23:25 -0700 (PDT)
Date:   Thu, 8 Jun 2023 10:23:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230608102259-mutt-send-email-mst@kernel.org>
References: <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
 <5giudxjp6siucr4l3i4tggrh2dpqiqhhihmdd34w3mq2pm5dlo@mrqpbwckpxai>
 <CACGkMEtqn1dbrQZn3i-W_7sVikY4sQjwLRC5xAhMnyqkc3jwOw@mail.gmail.com>
 <lw3nmkdszqo6jjtneyp4kjlmutooozz7xj2fqyxgh4v2ralptc@vkimgnbfafvi>
 <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt1yRV9qOLBqtQQmJA_UoRLCpznT=Gvd5D51Uaz2jakHA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 05:29:58PM +0800, Jason Wang wrote:
> On Thu, Jun 8, 2023 at 5:21 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Thu, Jun 08, 2023 at 05:00:00PM +0800, Jason Wang wrote:
> > >On Thu, Jun 8, 2023 at 4:00 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > >>
> > >> On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> > >>
> > >> [...]
> > >>
> > >> >> > > > > I have a question though, what if down the road there
> > >> >> > > > > is a new feature that needs more changes? It will be
> > >> >> > > > > broken too just like PACKED no?
> > >> >> > > > > Shouldn't vdpa have an allowlist of features it knows how
> > >> >> > > > > to support?
> > >> >> > > >
> > >> >> > > > It looks like we had it, but we took it out (by the way, we were
> > >> >> > > > enabling packed even though we didn't support it):
> > >> >> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
> > >> >> > > >
> > >> >> > > > The only problem I see is that for each new feature we have to modify
> > >> >> > > > the kernel.
> > >> >> > > > Could we have new features that don't require handling by vhost-vdpa?
> > >> >> > > >
> > >> >> > > > Thanks,
> > >> >> > > > Stefano
> > >> >> > >
> > >> >> > > Jason what do you say to reverting this?
> > >> >> >
> > >> >> > I may miss something but I don't see any problem with vDPA core.
> > >> >> >
> > >> >> > It's the duty of the parents to advertise the features it has. For example,
> > >> >> >
> > >> >> > 1) If some kernel version that is packed is not supported via
> > >> >> > set_vq_state, parents should not advertise PACKED features in this
> > >> >> > case.
> > >> >> > 2) If the kernel has support packed set_vq_state(), but it's emulated
> > >> >> > cvq doesn't support, parents should not advertise PACKED as well
> > >> >> >
> > >> >> > If a parent violates the above 2, it looks like a bug of the parents.
> > >> >> >
> > >> >> > Thanks
> > >> >>
> > >> >> Yes but what about vhost_vdpa? Talking about that not the core.
> > >> >
> > >> >Not sure it's a good idea to workaround parent bugs via vhost-vDPA.
> > >>
> > >> Sorry, I'm getting lost...
> > >> We were talking about the fact that vhost-vdpa doesn't handle
> > >> SET_VRING_BASE/GET_VRING_BASE ioctls well for packed virtqueue before
> > >> that series [1], no?
> > >>
> > >> The parents seem okay, but maybe I missed a few things.
> > >>
> > >> [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > >
> > >Yes, more below.
> > >
> > >>
> > >> >
> > >> >> Should that not have a whitelist of features
> > >> >> since it interprets ioctls differently depending on this?
> > >> >
> > >> >If there's a bug, it might only matter the following setup:
> > >> >
> > >> >SET_VRING_BASE/GET_VRING_BASE + VDUSE.
> > >> >
> > >> >This seems to be broken since VDUSE was introduced. If we really want
> > >> >to backport something, it could be a fix to filter out PACKED in
> > >> >VDUSE?
> > >>
> > >> mmm it doesn't seem to be a problem in VDUSE, but in vhost-vdpa.
> > >> I think VDUSE works fine with packed virtqueue using virtio-vdpa
> > >> (I haven't tried), so why should we filter PACKED in VDUSE?
> > >
> > >I don't think we need any filtering since:
> > >
> > >PACKED features has been advertised to userspace via uAPI since
> > >6234f80574d7569444d8718355fa2838e92b158b. Once we relax in uAPI, it
> > >would be very hard to restrict it again. For the userspace that tries
> > >to negotiate PACKED:
> > >
> > >1) if it doesn't use SET_VRING_BASE/GET_VRING_BASE, everything works well
> > >2) if it uses SET_VRING_BASE/GET_VRING_BASE. it might fail or break silently
> > >
> > >If we backport the fixes to -stable, we may break the application at
> > >least in the case 1).
> >
> > Okay, I see now, thanks for the details!
> >
> > Maybe instead of "break silently", we can return an explicit error for
> > SET_VRING_BASE/GET_VRING_BASE in stable branches.
> > But if there are not many cases, we can leave it like that.
> 
> A second thought, if we need to do something for stable. is it better
> if we just backport Shannon's series to stable?
> 
> >
> > I was just concerned about how does the user space understand that it
> > can use SET_VRING_BASE/GET_VRING_BASE for PACKED virtqueues in a given
> > kernel or not.
> 
> My understanding is that if packed is advertised, the application
> should assume SET/GET_VRING_BASE work.
> 
> Thanks


Let me ask you this. This is a bugfix yes? What is the appropriate Fixes
tag?

> >
> > Thanks,
> > Stefano
> >

