Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8EF7914
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKKQrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:47:23 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45813 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfKKQrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:47:23 -0500
Received: by mail-pg1-f195.google.com with SMTP id w11so9763700pga.12
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 08:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1uln3PQWpJHVN0cvSdX7VnkuLpysZdK64D1CGthDMQQ=;
        b=ZGldm3S4bKZDsolIkr062FeCWNvgqBDCbXBCZQSlgjXHxjrJOCNka+55vftk5tfbjO
         xM+8nieUBc2AaHtdsnK3zOkygz7oCeH3iSjCF9E/DpsUwm0ogx6DuoGw4RGJIIjds2xf
         9QVw5/y5wXbeGEku9KqrasNNLbW1Qyp1qCPhJFXZov/EYKd0Mdxb2X5C3QjYJ208kiTX
         Wkw6tBRfnSUeC1R+4MgsXVLIXOE9875v0yvZ1QQsQbBYTzmu+DXPa8l2DiT2+UHlkYlu
         QJJcdoqKQO0+K+L/5aRb7X+ffsioxLikRuP7FuWx6HD1CpQs+uDJ9EaAgwKeCl2k9QSN
         FsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1uln3PQWpJHVN0cvSdX7VnkuLpysZdK64D1CGthDMQQ=;
        b=qjMjEwYQt1uGT0SIlhcOLoTJytotfb3GtMGlCSMemh0L+QXrqUaKt1ngVzhhWbOrEU
         gKI969pJKJWdymp+cVd7Dusu059VZKdcszL8rAnCFs00hzXppxGEZahNe0b4fOWsMB/g
         pJqrjtlJiCeW5S/6v1ZDshOfphEbkiN61YBJjGUb9nuZ/oiRymXHVSkPPnQm43f+Cbdu
         YMWYDztH1dxjMM2cmg12rQOoJWIIfuvSOoQSdn/mHccpf8D+hImSLAObjXyIKU5cSHhO
         xwLb6fgAccHH9AdGvm5ErG4Cs+QAV0uRnLcB8zTByv6lCQQRMzsWz3iv0TYHAAlr+cln
         mFvA==
X-Gm-Message-State: APjAAAXWhatQmCRh6SC4a4GlpJ4b0hl3ZqtDpVbHwgQIWpQfPNgYh8xn
        MtLJesyHjkgqdGy6gpfmYDROyg==
X-Google-Smtp-Source: APXvYqxIqglx9JQpZhfV6sn5yZId682STyaqTWhX69LzBX/PclD2m0DM/D8mPbJZgsMlMwbmAnwP5g==
X-Received: by 2002:a62:1bd0:: with SMTP id b199mr31175476pfb.44.1573490842323;
        Mon, 11 Nov 2019 08:47:22 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 186sm4038077pfe.141.2019.11.11.08.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 08:47:21 -0800 (PST)
Date:   Mon, 11 Nov 2019 08:47:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     <lantianyu1986@gmail.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, "KY Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>, <sashal@kernel.org>,
        <mchehab+samsung@kernel.org>, <davem@davemloft.net>,
        <robh@kernel.org>, <Jonathan.Cameron@huawei.com>,
        <paulmck@linux.ibm.com>, "Michael Kelley" <mikelley@microsoft.com>,
        "Tianyu Lan" <Tianyu.Lan@microsoft.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, "vkuznets" <vkuznets@redhat.com>
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191111084712.37ba7d5a@hermes.lan>
In-Reply-To: <20191111094920.GA135867@kroah.com>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
        <20191111094920.GA135867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Nov 2019 01:49:20 -0800
"Greg KH" <gregkh@linuxfoundation.org> wrote:

> > +	ret = sysfs_create_bin_file(&channel->kobj,  
> &ring_buffer_bin_attr);
> > +	if (ret)
> > +		dev_notice(&dev->device,
> > +			   "sysfs create ring bin file failed; %d\n",  
> ret);
> > +  
> 
> Again, don't create sysfs files on your own, the bus code should be
> doing this for you automatically and in a way that is race-free.
> 
> thanks,
> 
> greg k-h

The sysfs file is only created if the VFIO/UIO driveris used.
