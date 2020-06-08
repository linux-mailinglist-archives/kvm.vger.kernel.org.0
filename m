Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030BE1F1991
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 15:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgFHNBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 09:01:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728245AbgFHNBf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 09:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591621294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N4tYRK/0WF4gJ3sPDYLn/EAB8Y9lZ28vccHh6mfdyZY=;
        b=FHU9qE2Puzlp93xauPxSTcir0dV3lMZwwsyK505r+8E8S4p0LRaKVuDwEnwTTSg23XexjC
        n4zsS5JvPJ0DNU0VsAT4gozOIPeW8nwiX4PjR57bLOOByTz2qpdxmH26HbHWWyYW3znZJj
        KZrDIy0/v0tnhYldHke9ZlxcmTrtzXc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-14a6riF7Mo6X7YLJohSHdg-1; Mon, 08 Jun 2020 09:01:29 -0400
X-MC-Unique: 14a6riF7Mo6X7YLJohSHdg-1
Received: by mail-wr1-f72.google.com with SMTP id d6so7120882wrn.1
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 06:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N4tYRK/0WF4gJ3sPDYLn/EAB8Y9lZ28vccHh6mfdyZY=;
        b=sYc3R1AvjxoQM0818MArTQZq/Ooaz4X44w6zXMv44lgo9fQTFnrCoIgn1P1bKmlRSw
         punz3HqrFj4MSE0q0V2RkTMfO57iw29ZMh2K4ZLWLiSgJslYO1uRriwU7fv4pqVeJK+E
         5ThJ3XYQP77NsO3PGO9f/5d+W1JjwYkDPOPM+jdA6KVKer82Yu2AjfmgAwwWpR+L1XR/
         kNk4HSHwmqN+P3ynnBTGDy7keFIAzqSF52etJEEtOZcEy1Un9z75rUyUJSV9ybPWM+Cg
         tNZjnKl++KYVoeWkGBMXgG3JzbqgULCpZVzc9dZBvfeaaP7zSShKKCZLMMOgRQyYJV03
         6GiQ==
X-Gm-Message-State: AOAM53294xaYELPRKWBABkfUTsDr92COltzZChXzvhlfSxRJ/65YUuGF
        sSwJX+gwCU01Fm8J0dpKnBoBe9wa1FIOKp29NP9o3ou4S4jAb2kDLImrQXTZnw6T0VLA21ID+5O
        4ucN7V0pMaBXM
X-Received: by 2002:adf:d851:: with SMTP id k17mr23165018wrl.30.1591621288297;
        Mon, 08 Jun 2020 06:01:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+ZpeCIIHsXHsXp7F2is1vc7M7N6GxGrFprOEl+lRsTOD0+vtXz9a5XQCm3jC3ps0vzgeTJg==
X-Received: by 2002:adf:d851:: with SMTP id k17mr23164991wrl.30.1591621288062;
        Mon, 08 Jun 2020 06:01:28 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id z25sm22048079wmf.10.2020.06.08.06.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 06:01:27 -0700 (PDT)
Date:   Mon, 8 Jun 2020 09:01:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 0/5] Add a vhost RPMsg API
Message-ID: <20200608090010-mutt-send-email-mst@kernel.org>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200604151917-mutt-send-email-mst@kernel.org>
 <20200605063435.GA32302@ubuntu>
 <20200608073715.GA10562@ubuntu>
 <20200608091100.GC10562@ubuntu>
 <20200608051358-mutt-send-email-mst@kernel.org>
 <20200608101526.GD10562@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608101526.GD10562@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 12:15:27PM +0200, Guennadi Liakhovetski wrote:
> On Mon, Jun 08, 2020 at 05:19:06AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2020 at 11:11:00AM +0200, Guennadi Liakhovetski wrote:
> > > Update: I looked through VirtIO 1.0 and 1.1 specs, data format their, 
> > > including byte order, is defined on a per-device type basis. RPMsg is 
> > > indeed included in the spec as device type 7, but that's the only 
> > > mention of it in both versions. It seems RPMsg over VirtIO isn't 
> > > standardised yet.
> > 
> > Yes. And it would be very good to have some standartization before we
> > keep adding things. For example without any spec if host code breaks
> > with some guests, how do we know which side should be fixed?
> > 
> > > Also it looks like newer interface definitions 
> > > specify using "guest native endianness" for Virtual Queue data.
> > 
> > They really don't or shouldn't. That's limited to legacy chapters.
> > Some definitions could have slipped through but it's not
> > the norm. I just quickly looked through the 1.1 spec and could
> > not find any instances that specify "guest native endianness"
> > but feel free to point them out to me.
> 
> Oh, there you go. No, sorry, my fault, it's the other way round: "guest 
> native" is for legacy and LE is for current / v1.0 and up.
> 
> > > So 
> > > I think the same should be done for RPMsg instead of enforcing LE?
> > 
> > That makes hardware implementations as well as any cross-endian
> > hypervisors tricky.
> 
> Yes, LE it is then. And we need to add some text to the spec.
> 
> In theory there could be a backward compatibility issue - in case someone 
> was already using virtio_rpmsg_bus.c in BE mode, but I very much doubt 
> that...
> 
> Thanks
> Guennadi

It's probably easiest to use virtio wrappers and then we don't need to
worry about it.

-- 
MST

