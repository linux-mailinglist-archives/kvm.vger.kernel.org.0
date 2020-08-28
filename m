Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF9F255BE6
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 16:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgH1OE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 10:04:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727794AbgH1OET (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 10:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598623457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gi+o9kVZ3pRl9KJVntsAEDs9X1jzPPrVq1ZT4piLZwc=;
        b=DeXIsKKxZWlJgtEoP5gzZGBPx82BOgP5YoXTjB8epaoA4AIReq9YEY+sHzpuJp77iDkg+K
        LUpj5pwb+Ge/iS1Mk114RHQothzfArSGg8mODlCnFxDRKFR1lDdH510OCE1NK9mE8luac5
        9zjXXFBi4EaO0/N3+JfVe7f/gATrmeg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-e7YKDfXaN4q4cE0co1mdXg-1; Fri, 28 Aug 2020 10:04:16 -0400
X-MC-Unique: e7YKDfXaN4q4cE0co1mdXg-1
Received: by mail-wm1-f70.google.com with SMTP id z1so415955wmf.9
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 07:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gi+o9kVZ3pRl9KJVntsAEDs9X1jzPPrVq1ZT4piLZwc=;
        b=IGTLbVNFCO1AGMNxxoCJiqQHTYGwI+fh2jfGvNlUhLb6lWIC26hgbXoQEbNrNHT+5G
         AINH3kiwtYZoxIUm2EPW57xcsw3BY5Dl1e2h5s568oVt2iK3I1L2PDn5z1cQb+smv/Yj
         CHKU2eCZo6XHBQhmm9W78xxjz+nKNwNBFlfaag61jfhsYlI8IRWu9rPAjua1MrYtrCbH
         Nj4u/FC6OTtrRsnWCdMRQmAWn00uIEuL8vUi7+kSd9PxgFJvgMBsLxkXqDcB+uDffjx1
         JT2uGLSLMkB9y723OunJpmhaD9OMyjt7qBan3Ph0qp9YPGxYZasWDokT+Fmjc/XERyxH
         ntWw==
X-Gm-Message-State: AOAM531kQ2iolwEc1fQ0/X7klhC2opmqq9NJcKSBxyDooG52QMWyf4JQ
        dSn66tzNOocyfVk7d0YDbPIMNSfkWxP+6gGerbnbHQjzCZcHscxHsvvp2VuUlTebuWOkvWTtuSp
        cZc/nGty4Y3JP
X-Received: by 2002:adf:ec08:: with SMTP id x8mr1578083wrn.235.1598623454919;
        Fri, 28 Aug 2020 07:04:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjcEcmgw98Ndt+QARtzjoATu98n1weTlJlDzx2jKF8LfrQcWGZlMQP/bfAOjJPZD2xR/7NHA==
X-Received: by 2002:adf:ec08:: with SMTP id x8mr1578044wrn.235.1598623454652;
        Fri, 28 Aug 2020 07:04:14 -0700 (PDT)
Received: from pop-os ([51.37.51.98])
        by smtp.gmail.com with ESMTPSA id m10sm2344213wmi.9.2020.08.28.07.04.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Aug 2020 07:04:13 -0700 (PDT)
Message-ID: <8f5345be73ebf4f8f7f51d6cdc9c2a0d8e0aa45e.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Daniel =?ISO-8859-1?Q?P=2EBerrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn, intel-gvt-dev@lists.freedesktop.org,
        eskultet@redhat.com, Jiri Pirko <jiri@mellanox.com>,
        dinechin@redhat.com, devel@ovirt.org
Date:   Fri, 28 Aug 2020 15:04:12 +0100
In-Reply-To: <20200828154741.30cfc1a3.cohuck@redhat.com>
References: <20200814051601.GD15344@joy-OptiPlex-7040>
         <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
         <20200818085527.GB20215@redhat.com>
         <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
         <20200818091628.GC20215@redhat.com>
         <20200818113652.5d81a392.cohuck@redhat.com>
         <20200820003922.GE21172@joy-OptiPlex-7040>
         <20200819212234.223667b3@x1.home>
         <20200820031621.GA24997@joy-OptiPlex-7040>
         <20200825163925.1c19b0f0.cohuck@redhat.com>
         <20200826064117.GA22243@joy-OptiPlex-7040>
         <20200828154741.30cfc1a3.cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-08-28 at 15:47 +0200, Cornelia Huck wrote:
> On Wed, 26 Aug 2020 14:41:17 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > previously, we want to regard the two mdevs created with dsa-1dwq x 30 and
> > dsa-2dwq x 15 as compatible, because the two mdevs consist equal resources.
> > 
> > But, as it's a burden to upper layer, we agree that if this condition
> > happens, we still treat the two as incompatible.
> > 
> > To fix it, either the driver should expose dsa-1dwq only, or the target
> > dsa-2dwq needs to be destroyed and reallocated via dsa-1dwq x 30.
> 
> AFAIU, these are mdev types, aren't they? So, basically, any management
> software needs to take care to use the matching mdev type on the target
> system for device creation?

or just do the simple thing of use the same mdev type on the source and dest.
matching mdevtypes is not nessiarly trivial. we could do that but we woudl have
to do that in python rather then sql so it would be slower to do at least today.

we dont currently have the ablity to say the resouce provider must have 1 of these
set of traits. just that we must have a specific trait. this is a feature we have
disucssed a couple of times and delayed untill we really really need it but its not out
of the question that we could add it for this usecase. i suspect however we would do exact
match first and explore this later after the inital mdev migration works.

by the way i was looking at some vdpa reslated matiail today and noticed vdpa devices are nolonger
usign mdevs and and now use a vhost chardev so i guess we will need a completely seperate mechanioum
for vdpa vs mdev migration as a result. that is rather unfortunet but i guess that is life.
> 

