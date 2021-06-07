Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2078F39D568
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 08:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhFGGxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 02:53:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhFGGxj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 02:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623048708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4o9AFYShIiOudrYVWqeWOS4+by7917Hd7h/BZiXVljU=;
        b=bqPQzQke0YtLAckNhArCxsPnLZINTBSbrcsmflTw/ZL3eS15ytcMKgxwuJQN6sDf0PX3aM
        ySv1448OX3VIrKtEaBNKiBwAU0EvblwURxrdUFPdU2dV5jqK+vdVcW32DCQUvzh+nYM72m
        VZ2Ec3Nnj3BuC2G2ZWP+2o+peF05bew=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-1Wqs9K6rMa2Kv5xUBmdlQQ-1; Mon, 07 Jun 2021 02:51:47 -0400
X-MC-Unique: 1Wqs9K6rMa2Kv5xUBmdlQQ-1
Received: by mail-wm1-f72.google.com with SMTP id z62-20020a1c65410000b0290179bd585ef9so2083007wmb.7
        for <kvm@vger.kernel.org>; Sun, 06 Jun 2021 23:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4o9AFYShIiOudrYVWqeWOS4+by7917Hd7h/BZiXVljU=;
        b=PHfWGupkG06iqM3Zv/WbJir4C/k6wUIO2y38tohtNVYAoxtpMxp1TznL6VoKSAekC9
         QrOCwF8dJr1nXsiT9I71cR9pGvvvARrjR4jIlewKpSVTCfC9K96xb2IrLh6juYM/haGb
         cq2/S4Oo97pxruC5wp7qoBGm+G2QNVyXo/diJhnGDPUe2U7RM1SeAw45yEhYPVD0YHA1
         ApDo4r3POz1Ry6fU+mThLrhOUcRxyNUz2elwUjX9GvGUsljR8ssLnBB8tEVI/jTeFR6b
         faSZp+lQxIXjbqaqRbY8XwiZ510e+q0iYRHnGDqfFexEtZIDgA0z/FJXA78VWdjZW0Zm
         9kbA==
X-Gm-Message-State: AOAM532jFgdvgHrciOrSjbsVVgm7t8F5RhFV1TjxJUJcgDtTIjUs8NKw
        4N+y/9Ewm2kqhDTqi8HsIlCbUlfiTuIyvFHYMMqBsAZcSFKtxU4UFDCrqxx+L8BoHUmBpxz0R0D
        tTPoc+h95Us7N
X-Received: by 2002:adf:f5c9:: with SMTP id k9mr14884338wrp.180.1623048706568;
        Sun, 06 Jun 2021 23:51:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjl6kAxqdninZuAYWFjtkVqJV6rZp5he0mQ6HQTxXN95BQKqkqQuB5NoWIDG/dxC45jrIuBw==
X-Received: by 2002:adf:f5c9:: with SMTP id k9mr14884320wrp.180.1623048706334;
        Sun, 06 Jun 2021 23:51:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o6sm16499918wre.73.2021.06.06.23.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 23:51:45 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
References: <20210603201018.GF1002214@nvidia.com>
 <20210603154407.6fe33880.alex.williamson@redhat.com>
 <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <MWHPR11MB1886E95C6646F7663DBA10DD8C389@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9dc6c573-94df-a7c1-b4df-7f60fc3cf336@redhat.com>
Date:   Mon, 7 Jun 2021 08:51:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1886E95C6646F7663DBA10DD8C389@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/21 05:25, Tian, Kevin wrote:
> Per Intel SDM wbinvd is a privileged instruction. A process on the
> host has no privilege to execute it.

(Half of) the point of the kernel is to do privileged tasks on the 
processes' behalf.  There are good reasons why a process that uses VFIO 
(without KVM) could want to use wbinvd, so VFIO lets them do it with a 
ioctl and adequate checks around the operation.

Paolo

