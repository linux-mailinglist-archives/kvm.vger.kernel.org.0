Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CABA1F150A
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 11:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgFHJJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 05:09:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21962 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725927AbgFHJJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 05:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591607356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1qzz8q0RXIAT8maH8NVpFy7idcd6AVSk1M7/8bU7JLI=;
        b=D4LT/baqbcWPedk3QGlS7jWP4d0okcBiYzu/WQ11icJo83gE4jg+V4nw536GJZLlEHpJYE
        hI4RQ0EiW2LhRJUFpfrNC/K2iEXBezWZuUiD3mlZBJSJXQ/vWMKx5YuYM4TDTVtbDC/Zxw
        1QP9slsclbp44ixBS/tNUUfl/VozpYk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-3Mv-_nK9NT22B5iT3OWXeA-1; Mon, 08 Jun 2020 05:09:15 -0400
X-MC-Unique: 3Mv-_nK9NT22B5iT3OWXeA-1
Received: by mail-wr1-f69.google.com with SMTP id c14so6852570wrw.11
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 02:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1qzz8q0RXIAT8maH8NVpFy7idcd6AVSk1M7/8bU7JLI=;
        b=TnEeagn51VZY/VmdBxuyPKuySFEuzSBIuTl9RF3YYb4AfkUvMFRM7+6Hk/Yslweian
         l0/aQ55aw7czK40CGrTjefw6x4IO+jaAoFOBdbXi/wvdEq40hDW2nar/Cki00tZdlm41
         JibcM6cBW4kvYo2JBzypPHpodtitMWQmheCnz9qp7HMH4HxuCt6rG7kxF+zyZbbdzwyP
         tBIJDUUdGbHMzFXTRRhRoHUFNxlfVo8tyMgrZqsdK28+r4XTCwS3jfP34FVMqELHd0WG
         R5EmDJR9vtvBwY8CE4lpzsW3La47TmPnlIab5ohgWxW77wGPxerqcJK3NKP7mtnMv63W
         bDGQ==
X-Gm-Message-State: AOAM530uF8NCxVbQEZO1K0BlbLHNGwfw1sF8hxP6Xtb6SnkzK+WILihP
        0jtoZAEsVjycfct8H3vTFpGhglmIoxShGioN34We4h/f6nCdUF9Co/74CJua+2tyv8wkDAJyQIb
        vYh8Xhs3m1Qcg
X-Received: by 2002:adf:a41a:: with SMTP id d26mr23153875wra.324.1591607354004;
        Mon, 08 Jun 2020 02:09:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk4C2kFKYGkG3pOjWAb4BdA7+bim0qD4WM5BHVhr/1qFiireNP/Iu0BJQYaiwNrt1nr7CEGA==
X-Received: by 2002:adf:a41a:: with SMTP id d26mr23153862wra.324.1591607353853;
        Mon, 08 Jun 2020 02:09:13 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id u12sm23301667wrq.90.2020.06.08.02.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:09:13 -0700 (PDT)
Date:   Mon, 8 Jun 2020 05:09:10 -0400
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
Message-ID: <20200608050757-mutt-send-email-mst@kernel.org>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200604151917-mutt-send-email-mst@kernel.org>
 <20200605063435.GA32302@ubuntu>
 <20200608073715.GA10562@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608073715.GA10562@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 09:37:15AM +0200, Guennadi Liakhovetski wrote:
> Hi Michael,
> 
> On Fri, Jun 05, 2020 at 08:34:35AM +0200, Guennadi Liakhovetski wrote:
> > 
> > On Thu, Jun 04, 2020 at 03:23:37PM -0400, Michael S. Tsirkin wrote:
> 
> [snip]
> 
> > > Another it's out of line with 1.0 spec passing guest
> > > endian data around. Won't work if host and guest
> > > endian-ness do not match. Should pass eveything in LE and
> > > convert.
> > 
> > Yes, I have to fix this, thanks.
> 
> Just to make sure my understanding is correct: this would involve also 
> modifying the current virtio_rpmsg_bus.c implementation to add 
> endianness conversions. That's what you meant, right?
> 
> Thanks
> Guennadi

right and if there are legacy compat considerations, using _virtio16 and
friends types, as well as virtio16_to_cpu and friends functions.

-- 
MST

