Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8301F19AE
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 15:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgFHNIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 09:08:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728245AbgFHNIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 09:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591621720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dqBwBX1iWxa0YmZVaEODhc8PGLo2VfdKn86FOfgmR1g=;
        b=RnImqbY2zCdhTc8uG5KaCKBtyA2QUWBP3+0tN1Kf6awKg2MTJG8kx0pUYd+SW0hgDlU7ty
        SELEzOIynYlaY6JAzYUj1VUxfcNrpxjFAbRGZ5hEHizMR3iKc+ugxCND1+y9M2WTeDqylZ
        +iT+6gD1kONPlIqWIkfqRgqYY7Svrbo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-xL732I-9P6OUI6DyYvj_tg-1; Mon, 08 Jun 2020 09:08:38 -0400
X-MC-Unique: xL732I-9P6OUI6DyYvj_tg-1
Received: by mail-wr1-f71.google.com with SMTP id c14so7093545wrw.11
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 06:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dqBwBX1iWxa0YmZVaEODhc8PGLo2VfdKn86FOfgmR1g=;
        b=O42d8G3iOgg4+FTvlkstLBfeRZVrE33ZKGFz3zZxQ9eq/g7KjiS5Ug6qZerU87cCcw
         rl3uxK6IPjnJ6Ui/jnLhSEfhJVdYsMerB5zTZvXj11bj5dte2WjkKoflNmO7g7GqSIN2
         DrjI/RpJ/2vcsbdMtKsm2hbyz6VCMmoGBOJZmSWXqbRJmJiDFCSawhyDCAVDtg6vBGjY
         kJ4D28zyBG40OPcwQCs9dEfa8ToLhML9z4sjaR1+1aSur8e7zqbDrHiDxCkdXj4BGQ2R
         GP7DLC0a1IQoIlBp8S5+eCdeGwCF1SAlSX3d6azcu9SU3ucOomMYGQYkHktnLhf+t0tn
         JK/g==
X-Gm-Message-State: AOAM532iad9ESopWaOFUiU4k/riZHo3gBtA0/kNI70UezXMXk/A1yFPB
        UGHhe/dCIiC50SIeAjQDxul0n4x6ifiQkyh83iADTnFVo+CodEw9MnQcxbWZRMGjzz7wRo3D/IC
        qmPBq55t7z98R
X-Received: by 2002:a5d:6789:: with SMTP id v9mr25040819wru.124.1591621716993;
        Mon, 08 Jun 2020 06:08:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMOU/wtRvJJc/E+tmpBswF5Ul40bkOzM0HliSRv4EENKFeQzLuZVeBr361vAI3C5zdXVwJig==
X-Received: by 2002:a5d:6789:: with SMTP id v9mr25040787wru.124.1591621716746;
        Mon, 08 Jun 2020 06:08:36 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id b8sm24159773wrs.36.2020.06.08.06.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 06:08:36 -0700 (PDT)
Date:   Mon, 8 Jun 2020 09:08:33 -0400
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
Message-ID: <20200608090145-mutt-send-email-mst@kernel.org>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200604151917-mutt-send-email-mst@kernel.org>
 <20200605063435.GA32302@ubuntu>
 <20200608073715.GA10562@ubuntu>
 <20200608091100.GC10562@ubuntu>
 <20200608051358-mutt-send-email-mst@kernel.org>
 <20200608101526.GD10562@ubuntu>
 <20200608111637.GE10562@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608111637.GE10562@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 01:16:38PM +0200, Guennadi Liakhovetski wrote:
> On Mon, Jun 08, 2020 at 12:15:26PM +0200, Guennadi Liakhovetski wrote:
> > On Mon, Jun 08, 2020 at 05:19:06AM -0400, Michael S. Tsirkin wrote:
> > > On Mon, Jun 08, 2020 at 11:11:00AM +0200, Guennadi Liakhovetski wrote:
> > > > Update: I looked through VirtIO 1.0 and 1.1 specs, data format their, 
> > > > including byte order, is defined on a per-device type basis. RPMsg is 
> > > > indeed included in the spec as device type 7, but that's the only 
> > > > mention of it in both versions. It seems RPMsg over VirtIO isn't 
> > > > standardised yet.
> > > 
> > > Yes. And it would be very good to have some standartization before we
> > > keep adding things. For example without any spec if host code breaks
> > > with some guests, how do we know which side should be fixed?
> > > 
> > > > Also it looks like newer interface definitions 
> > > > specify using "guest native endianness" for Virtual Queue data.
> > > 
> > > They really don't or shouldn't. That's limited to legacy chapters.
> > > Some definitions could have slipped through but it's not
> > > the norm. I just quickly looked through the 1.1 spec and could
> > > not find any instances that specify "guest native endianness"
> > > but feel free to point them out to me.
> > 
> > Oh, there you go. No, sorry, my fault, it's the other way round: "guest 
> > native" is for legacy and LE is for current / v1.0 and up.
> > 
> > > > So 
> > > > I think the same should be done for RPMsg instead of enforcing LE?
> > > 
> > > That makes hardware implementations as well as any cross-endian
> > > hypervisors tricky.
> > 
> > Yes, LE it is then. And we need to add some text to the spec.
> 
> I found the protocol and the message format definition: 
> https://github.com/OpenAMP/open-amp/wiki/RPMsg-Messaging-Protocol#transport-layer---rpmsg 
> Don't know what the best way for referencing it in the VirtIO standard 
> would be: just a link to the source or a quote.
> 
> Thanks
> Guennadi

I wasn't aware of that one, thanks!
OK so that's good.

Ideally we'd have RPMsg Header Definition, RPMsg Channel and RPMsg
Endppint in the spec proper.

This link is informal so can't be copied into spec as is but can be used as a basis.

We'd also need approval from authors for inclusion in the spec,
sent to the TC mailing list.

-- 
MST

