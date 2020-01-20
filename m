Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA6B142A1B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 13:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgATMJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 07:09:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726650AbgATMJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 07:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579522159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ils+V+DNAQCUc++KUaM/zwaIHOd66hKtcZoyoJKDxck=;
        b=GCe3QNDJRURITeOgI1NabtNtvMz8orHIofX34AArN+lgV3sWaxgxt4DTnAGyrPh1aADYjn
        aawpz8iNZ07iMoXGnsXdxVu35gmunh540+gt1ivhRoo22UplJHXZeu7IW0I8TeBFMZlHjo
        WgSfsE2wUSPtq5/aaveLvPZg/oHbkfQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-PFJD11nJPhect7L26oyk6Q-1; Mon, 20 Jan 2020 07:09:18 -0500
X-MC-Unique: PFJD11nJPhect7L26oyk6Q-1
Received: by mail-qk1-f198.google.com with SMTP id i135so20264011qke.14
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 04:09:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ils+V+DNAQCUc++KUaM/zwaIHOd66hKtcZoyoJKDxck=;
        b=FsZTMaxmGljX/2bFfhc6zDldPC3lUJ60YxUSVOOwJsRPZuzH4DPx1QUVX69rfvXcv4
         gq3Cvq/Xp2tEztxlwFQjcRUkOnJA0nCcQtISPfi2GDA6x3mSshK1+BPzfPB3FYHCrxXs
         1W/Nv4IRjdS9jNa69ajmAbQcYI6XnPyLqPweRc/ld/qfe8MtVMjzC/gL/qbEgFWVxEJE
         SVUDROesWHmn1CfuogJG1oFzw1pb6lde2fE1VKpuAN611B+b89iKmT7/9TMDqC1u0l2P
         KJvPVy/p9jTeyFQmo7uIHnsi4oS4OGK8rn3gcX0GWSI9prMe1MHn+z03ALJsuALzVEHy
         kW2Q==
X-Gm-Message-State: APjAAAWI3rAUzytX5zxbt2t3yq/C7abZYJhGanNWSPKNEyukD0G0DVfT
        dfL7f7nGAGNmD/geGoRp/QY4zCgthnsmXnQkMBDFmYTdsKgbKvRk3w+JzH0ijGSLeYH2R2Zck++
        Zow/lDQstwxLQ
X-Received: by 2002:ac8:747:: with SMTP id k7mr20536097qth.120.1579522157153;
        Mon, 20 Jan 2020 04:09:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPRlGSUNQNiKSICSXdcPuLibX0Cl/JMb+oCpOV4CRtRfGtUmRXGfQQVE1MHMBhude5c31BGg==
X-Received: by 2002:ac8:747:: with SMTP id k7mr20536064qth.120.1579522156954;
        Mon, 20 Jan 2020 04:09:16 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id t2sm15467285qkc.31.2020.01.20.04.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 04:09:15 -0800 (PST)
Date:   Mon, 20 Jan 2020 07:09:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200120070710-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200119045849-mutt-send-email-mst@kernel.org>
 <d4e7fc56-c9d8-f01f-1504-dd49d5658037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4e7fc56-c9d8-f01f-1504-dd49d5658037@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 04:44:34PM +0800, Jason Wang wrote:
> 
> On 2020/1/19 下午5:59, Michael S. Tsirkin wrote:
> > On Sun, Jan 19, 2020 at 09:07:09AM +0000, Shahaf Shuler wrote:
> > > > Technically, we can keep the incremental API
> > > > here and let the vendor vDPA drivers to record the full mapping
> > > > internally which may slightly increase the complexity of vendor driver.
> > > What will be the trigger for the driver to know it received the last mapping on this series and it can now push it to the on-chip IOMMU?
> > Some kind of invalidate API?
> > 
> 
> The problem is how to deal with the case of vIOMMU. When vIOMMU is enabling
> there's no concept of last mapping.
> 
> Thanks

Most IOMMUs have a translation cache so have an invalidate API too.

-- 
MST

