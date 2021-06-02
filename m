Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240823984C7
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 10:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhFBJAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 05:00:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232981AbhFBJAG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 05:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622624303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HgwV7ft+Ln03MaD+qvV/AkL0B+iArPbUA9ahbhF+wVg=;
        b=QTSJnx4QZANKC2MFrXYT9euhRrVNbgeSmtWvBezvt4xanvqdTbszjudM7O+/7kwlZwQKhu
        ZfF8PrfdX554kqW/3QLQEGWVq+PdH4BWVXPGoqJuKJGvIJsqnmT4qzyfvpsZLuX2peDUEZ
        4Zr2KHhthRE/SX9KmS85ZL9S/H5qtHo=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-0n6JL-j_MvS6CwGpO5ziyg-1; Wed, 02 Jun 2021 04:58:22 -0400
X-MC-Unique: 0n6JL-j_MvS6CwGpO5ziyg-1
Received: by mail-pg1-f197.google.com with SMTP id 15-20020a630c4f0000b029021a6da9af28so1251604pgm.22
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 01:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HgwV7ft+Ln03MaD+qvV/AkL0B+iArPbUA9ahbhF+wVg=;
        b=S95M7+PvTT1CzA0bLhNZyz0j94abvw7/x5zYTRw3XbYnergBIG/lJ0mmW67cJy2+cp
         c1RAQL59WY1dBYK9za9HDjwNrLaHDXGv6x0mrw49UWH9SI71+l1rXI2xwnhT6feDl6+6
         rtLfuM81dzZ0FQNcg9nXVASaeY/EJZHKkv8KKiPhfkPMmbKF3GC6gc+2kGJNzvr11pV6
         fFJWCpOqfRyyCk7xlMxAPOzAusIASCc4jmbgo6VISarpdhXEukoX6IUISY6Nwz1Wq562
         QNcnAZDxfkdamt0f9AwV4l+69d8XXz2WZwAL9CIG0c2XzJ5Q2yciCpPFeMo5En+Nk+aM
         elfA==
X-Gm-Message-State: AOAM5306YxBd18+2jvNO5aN9+H3qv8p7Dg7F3owblszld+ZYXYZcuFCL
        97ETdU0k4L9PhkN0EAZ07TQif9PYSKaIoWAyALNMX6qqR7ty3u7ibqEO13ZcrygWbWK8uxI+07E
        UdDAZHCtF2KnL
X-Received: by 2002:a63:e642:: with SMTP id p2mr31912918pgj.316.1622624301197;
        Wed, 02 Jun 2021 01:58:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/hC2DUGaHASQJ2eBIgS4POmbF/OU0iTy4EElTI9I8lf554Diw4PoXXYk+RPG+3MuIoH1a7g==
X-Received: by 2002:a63:e642:: with SMTP id p2mr31912901pgj.316.1622624301050;
        Wed, 02 Jun 2021 01:58:21 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m134sm4163818pfd.148.2021.06.02.01.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 01:58:20 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
 <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
 <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <20210601172956.GL1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d8bb795f-8d73-e9a5-a4b1-8d9c563dffbd@redhat.com>
Date:   Wed, 2 Jun 2021 16:58:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601172956.GL1002214@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/2 ÉÏÎç1:29, Jason Gunthorpe Ð´µÀ:
> On Tue, Jun 01, 2021 at 02:07:05PM +0800, Jason Wang wrote:
>
>> For the case of 1M, I would like to know what's the use case for a single
>> process to handle 1M+ address spaces?
> For some scenarios every guest PASID will require a IOASID ID # so
> there is a large enough demand that FDs alone are not a good fit.
>
> Further there are global container wide properties that are hard to
> carry over to a multi-FD model, like the attachment of devices to the
> container at the startup.


So if we implement per fd model. The global "container" properties could 
be done via the parent fd. E.g attaching the parent to the device at the 
startup.


>
>>> So this RFC treats fd as a container of address spaces which is each
>>> tagged by an IOASID.
>> If the container and address space is 1:1 then the container seems useless.
> The examples at the bottom of the document show multiple IOASIDs in
> the container for a parent/child type relationship


This can also be done per fd? A fd parent can have multiple fd childs.

Thanks


>
> Jason
>

