Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58381F1546
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 11:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgFHJTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 05:19:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53807 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729138AbgFHJTQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 05:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591607954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kn8BcOVPI4dKLlZEoUFeNJgnO3vX7kKpRZZKwDzWCM4=;
        b=ARtwM00uwaxTp7AosyElDq9WwECrRDQgeeAxDNF9QItNe4cTF/V0CINzr+dggTO2sixFkL
        S1oUkQxsG/eSjNP82DydWdFxnDGFcwL/Gr4PTMC8SrOJUpPqTU9vYETrykwXAeiU0dJXCW
        VR7UumX7oL9UtSEVOusLYxFAbWquWG8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-xh0vangWPbyiZ3XzezuDvw-1; Mon, 08 Jun 2020 05:19:11 -0400
X-MC-Unique: xh0vangWPbyiZ3XzezuDvw-1
Received: by mail-wm1-f72.google.com with SMTP id b63so5159498wme.1
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 02:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kn8BcOVPI4dKLlZEoUFeNJgnO3vX7kKpRZZKwDzWCM4=;
        b=eyTYT5EtHttvqxoTAYJnQmzFxfkgClyaUZMpkgfNXOY1vqJKuJAAhdybI7jelyfUZj
         HxoFhuRuovV/AYLXj7mJuH/9Vf8EbaubprfMzmGvjSHqJZmE+gySDYBkdXr3OXqhOMwD
         n0MYWUJzGZtmK0F+w8PUpgrP9MN0W/gL1AFPFqtDesQTwstOGnmfHiGX0WN9eJEUUsb/
         bboAIZ2JOCKuyq5HgsSnjXZiT0iymSWEfIMlP50f9J81luYwkWXbDpTdv7ErT/LyohWj
         X9PcSGIrtxt46thhWV5y4L37LNN/hOGLfFDsty2nlUkCynvXBj4iYpVpPxGDIdQWJM4G
         T5xg==
X-Gm-Message-State: AOAM533DnTLScpWJpliaiECvCdq2pLlQJ4xKAGPPSj8RcfDRSEfbkzP3
        R8Cf5AkRVXBKy86ZqMs2Z/T0mGXY968pJraIYvF8/AZBOmSCMoabDCdC4EHU17sK/EbfZXPwPR+
        Do/scKzZsxZWY
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr15166574wme.14.1591607950355;
        Mon, 08 Jun 2020 02:19:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysGO90rYrCc3hVq6L5tbawFDDHDFTwffBp9oo0zw0IemSE9gTXzCwg+wtmvYkRO//psgripw==
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr15166561wme.14.1591607950184;
        Mon, 08 Jun 2020 02:19:10 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o15sm23050690wrv.48.2020.06.08.02.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:19:09 -0700 (PDT)
Date:   Mon, 8 Jun 2020 05:19:06 -0400
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
Message-ID: <20200608051358-mutt-send-email-mst@kernel.org>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200604151917-mutt-send-email-mst@kernel.org>
 <20200605063435.GA32302@ubuntu>
 <20200608073715.GA10562@ubuntu>
 <20200608091100.GC10562@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608091100.GC10562@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 11:11:00AM +0200, Guennadi Liakhovetski wrote:
> Update: I looked through VirtIO 1.0 and 1.1 specs, data format their, 
> including byte order, is defined on a per-device type basis. RPMsg is 
> indeed included in the spec as device type 7, but that's the only 
> mention of it in both versions. It seems RPMsg over VirtIO isn't 
> standardised yet.

Yes. And it would be very good to have some standartization before we
keep adding things. For example without any spec if host code breaks
with some guests, how do we know which side should be fixed?

> Also it looks like newer interface definitions 
> specify using "guest native endianness" for Virtual Queue data.

They really don't or shouldn't. That's limited to legacy chapters.
Some definitions could have slipped through but it's not
the norm. I just quickly looked through the 1.1 spec and could
not find any instances that specify "guest native endianness"
but feel free to point them out to me.

> So 
> I think the same should be done for RPMsg instead of enforcing LE?
> 
> Thanks
> Guennadi

That makes hardware implementations as well as any cross-endian
hypervisors tricky.

-- 
MST

