Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A921AC115
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635523AbgDPMVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 08:21:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54048 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2635291AbgDPMU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 08:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587039654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N//aUi9ilfSYZbtt9uubNhdLlMHa9VPzC/9aWc7u2N4=;
        b=TV6CBrEOpmWjIdSjNFIyBBxbVxnW1vZwBpM+nEFbziHjfTD1lMafWgBfFgYEMhlzSjVvFP
        43eL+wswiT81sTOO5cNMAWYDWpvy8gHKTWn7Rx39eLEUeTPBr3z7rAaoWYThPYk4OzPtGO
        LrBlUIsyBa20ny3ZniiYZ4eAt6gWVnI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-RMAMSWb_P7ChQCwK3LtPag-1; Thu, 16 Apr 2020 08:20:52 -0400
X-MC-Unique: RMAMSWb_P7ChQCwK3LtPag-1
Received: by mail-wr1-f72.google.com with SMTP id m5so1603765wru.15
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 05:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N//aUi9ilfSYZbtt9uubNhdLlMHa9VPzC/9aWc7u2N4=;
        b=P8tAkdLAfyJwin1ibdg/BjH+p9dbBW9H2194tn8+jhWQkSM1TAIB9zLc+biserbsCx
         zmOBHgYAMebjgX8J3ZZxkPNa216k9MVVkfEUEXlSxc71vd9RlabnwqYoAFtgqu7a7JWD
         p/bdh+ot+VOIjlccZwhNlnH1WOmbYoGRWM1P/ypv6MK1zbkV6dqS7s2Nxyhi9fRELN67
         eMBF5Dm8Zku15sTibAjOhcmnbqPkgD227wCH6eQVMvCtGO2r+fWvlE7NIFRdlJ8Wn5yN
         2i7XKqdXdXEOxUXaaFlr1j2EoQ+M73LkZm4jJghPO871D51X32tlIEcwQgVi+q8Vg+62
         aGdg==
X-Gm-Message-State: AGi0PuY7JxbTdqbby+3QlmY5KvEviLvUGb96AY5x62od6t3tmA6jAQzR
        9oKXMazhw8G98gYFZBiNV4YxprCvFAHBZxxn5+EQeZ1d7cZ8Ga4ozZVEZmMscXfMo6NSxWI9EK5
        VWnDcNcm7JUPu
X-Received: by 2002:a1c:a344:: with SMTP id m65mr4634833wme.20.1587039648640;
        Thu, 16 Apr 2020 05:20:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypL7Zr1AmadDiZcqsAC7y2lchYjfJabub1W1Nve6Z9EGEGzkMDXcyVU803uWBITr/U3dkRDooA==
X-Received: by 2002:a1c:a344:: with SMTP id m65mr4634814wme.20.1587039648429;
        Thu, 16 Apr 2020 05:20:48 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id a67sm3645719wmc.30.2020.04.16.05.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 05:20:47 -0700 (PDT)
Date:   Thu, 16 Apr 2020 08:20:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, ashutosh.dixit@intel.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        eli@mellanox.com, eperezma@redhat.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>, hulkci@huawei.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        matej.genci@nutanix.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        yanaijie@huawei.com, YueHaibing <yuehaibing@huawei.com>
Subject: Re: [GIT PULL] vhost: cleanups and fixes
Message-ID: <20200416081330-mutt-send-email-mst@kernel.org>
References: <20200414123606-mutt-send-email-mst@kernel.org>
 <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 05:46:33PM -0700, Linus Torvalds wrote:
> On Tue, Apr 14, 2020 at 9:36 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > virtio: fixes, cleanups
> 
> Looking at this, about 75% of it looks like it should have come in
> during the merge window, not now.
> 
>               Linus

Well it's all just fallout from

	commit 61b89f23f854f458b8e23719978df58260f051ed
	Author: Michael S. Tsirkin <mst@redhat.com>
	Date:   Mon Apr 6 08:42:55 2020 -0400

	    vhost: force spec specified alignment on types

which I didn't know we need until things landed upstream and
people started testing with weird configs.

That forced changes to a header file and the rest followed.

We could just ignore -mabi=apcs-gnu build being broken for this release -
is that preferable? Pls let me know.

-- 
MST

