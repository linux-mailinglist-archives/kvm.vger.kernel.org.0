Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7461ADA2B
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 11:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgDQJit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 05:38:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27792 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730340AbgDQJiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 05:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587116325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVkbDn8gkw5+Noos0y5yOQUyWaS8jqC9S0wOjm7uqw4=;
        b=hYoP3OsLWjN8USEoRJuqHSPouv8JvlRgrqueiDkIcqe4+l56Q/BS7WHvri4ooTtLMTO4Xg
        UNcsqbbORZc5EBZ6jnt1ojqHz0kptYVlR30/6XS3v/UqID7vlimUZQGYOR1FONC3hD92Uw
        R0YpKBm6N4hH9kMaD7UjOLmCP/bsAAY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-DwGDG_nzN-SKIidawAnf-g-1; Fri, 17 Apr 2020 05:38:43 -0400
X-MC-Unique: DwGDG_nzN-SKIidawAnf-g-1
Received: by mail-wm1-f72.google.com with SMTP id f17so589646wmm.5
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 02:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EVkbDn8gkw5+Noos0y5yOQUyWaS8jqC9S0wOjm7uqw4=;
        b=apzoYaKLD482kCqvsKFGD6XL4DyrVFdqun2hPK/nw82mmxtdxi1MA96bvZ0+niBjdf
         MhQ2d96HOYjXGMJY1bW9JbvveJ973q03MttjYbFA3YLlC7ESHg6Xw5ZCbD5pqnq692br
         rqtJ5q8ddxe4Di0vX4FtvBowQAPFMgSNhR76AHsYV3HFz1Ld2Q9Wy855n207o/DCTrN/
         eRvl+xRQyT87y2chq7a0QrN27Cyjqcy5PQ5DCId1cKUI1eZIKMs6SwaDVYqKZdoS95Ca
         ajwN8FWndIvOW1TPQsCpZRjRvFmfF1ZbjFWAl4aHsHNxn2CSsfUmYfMf2/6oclPmbuMv
         xNdw==
X-Gm-Message-State: AGi0PuYm0FcnKYjQiljP3SDZ9Qj1f59cbZRQCWPWakuYWnzkdStGJ/6k
        8AWxWWgIZ5JAMtHCTjWwhTBbXn8/imb2jjekcyA0mHJR/FFm9S7OG4otNUaC3OF9xDt16VCzLFq
        UI1C+XK0GClHF
X-Received: by 2002:adf:e711:: with SMTP id c17mr1264152wrm.334.1587116322163;
        Fri, 17 Apr 2020 02:38:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLI0ZplMhJRXp9IgnvDd4jNrwD2zcF2noQBvqCsovqT0NxBwm05qUG6Nsovmh0zi9ATjf9KqA==
X-Received: by 2002:adf:e711:: with SMTP id c17mr1264134wrm.334.1587116321952;
        Fri, 17 Apr 2020 02:38:41 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id a24sm6912835wmb.24.2020.04.17.02.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 02:38:41 -0700 (PDT)
Date:   Fri, 17 Apr 2020 05:38:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
Message-ID: <20200417053803-mutt-send-email-mst@kernel.org>
References: <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
 <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
 <20200417042912-mutt-send-email-mst@kernel.org>
 <fdb555a6-4b8d-15b6-0849-3fe0e0786038@redhat.com>
 <20200417044230-mutt-send-email-mst@kernel.org>
 <73843240-3040-655d-baa9-683341ed4786@redhat.com>
 <20200417050029-mutt-send-email-mst@kernel.org>
 <ce8a18e5-3c74-73cc-57c5-10c40af838a3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce8a18e5-3c74-73cc-57c5-10c40af838a3@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 05:33:56PM +0800, Jason Wang wrote:
> 
> On 2020/4/17 下午5:01, Michael S. Tsirkin wrote:
> > > There could be some misunderstanding here. I thought it's somehow similar: a
> > > CONFIG_VHOST_MENU=y will be left in the defconfigs even if CONFIG_VHOST is
> > > not set.
> > > 
> > > Thanks
> > > 
> > BTW do entries with no prompt actually appear in defconfig?
> > 
> 
> Yes. I can see CONFIG_VHOST_DPN=y after make ARCH=m68k defconfig

You see it in .config right? So that's harmless right?

-- 
MST

