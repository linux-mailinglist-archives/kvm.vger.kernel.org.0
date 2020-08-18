Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBF5248B96
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 18:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHRQ2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 12:28:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40451 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727986AbgHRQ1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 12:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597768047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=if9LpYICK0NhGXF5AA8XXB22L0fg+m6z8gcS1Q79zUU=;
        b=c7TB2s4nJZZtfxADyn2lGRVDOg1erPbexqz5JyHkRdT+GVyKZIv8FYzpmAr1N2W1yhNfBo
        WFTatipZ0ZxQuqde/DYFHWPh92se4d5i4khHQXSet1JybgZOjiQGC79wTJbqnebvWdl6oo
        EAHIc2eh+REJPofVh8YIU9MWgLr50Bk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-EQuc0SfAMyenCj1Oczno8A-1; Tue, 18 Aug 2020 12:27:25 -0400
X-MC-Unique: EQuc0SfAMyenCj1Oczno8A-1
Received: by mail-wm1-f69.google.com with SMTP id k204so6304955wmb.3
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 09:27:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=if9LpYICK0NhGXF5AA8XXB22L0fg+m6z8gcS1Q79zUU=;
        b=nTgTZa1dawcEhKqx/3me2mbI6MG5yZUW2Ez5wcP6/J701/gcLDC63akWqUhY7WnIGx
         M8Aw4pMAYJdHw3HrFEfgrrbKp2W7QoJyfbXJLgvyLMqKR/3ppprlkXEgP0hu80vDnUME
         4d9eARtYLdwLh4Bf9TjtMP4+2I1Amk8xuTj3gB2Bp19AcWln+Iw2+RgTtykiB4ij9q8w
         MkdQRVOC0LxWYuUd1GR4faj+T/6pSN5uwrDV78riy87U9uey+uOmJmA4qPlHPIA0dr5t
         U2ZDzw8iPu+jnNfVIOqM68xZySvp26FvCzI+QuaW21DRFJcBV3pGRd3L5FKT35HwirDc
         Em5w==
X-Gm-Message-State: AOAM532+sxPFauzvrs7geTXqceV6NNRmbXB6kO+ZbUb0B+I0oBB4eyz8
        yb64ZP/HtmbTptuZ/0BljeVmhk4XHVDGydduIN2SIcEMDfcm/sXe4yJ7VmOPuUZMwQYet8w2adQ
        5v6T1jnxFxNHj
X-Received: by 2002:a7b:cf29:: with SMTP id m9mr692505wmg.88.1597768044065;
        Tue, 18 Aug 2020 09:27:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykPaZdW75tblNPwohfUTSZAywU3pLEZHF86kgfsgbeUM6YEol+VFwyiwZdqftvl2orXJtznA==
X-Received: by 2002:a7b:cf29:: with SMTP id m9mr692461wmg.88.1597768043853;
        Tue, 18 Aug 2020 09:27:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:38e0:ccf8:ca85:3d9b? ([2001:b07:6468:f312:38e0:ccf8:ca85:3d9b])
        by smtp.gmail.com with ESMTPSA id e5sm37696385wrc.37.2020.08.18.09.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 09:27:23 -0700 (PDT)
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
 <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818004343.GG1152540@nvidia.com>
 <MWHPR11MB164579D1BBBB0F7164B07A228C5C0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818115003.GM1152540@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0711a4ce-1e64-a0cb-3e6d-f6653284e2e3@redhat.com>
Date:   Tue, 18 Aug 2020 18:27:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200818115003.GM1152540@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/20 13:50, Jason Gunthorpe wrote:
> For instance, what about suspend/resume of containers using idxd?
> Wouldn't you want to have the same basic approach of controlling the
> wq from userspace that virtualization uses?

The difference is that VFIO more or less standardizes the approach you
use for live migration.  With another interface you'd have to come up
with something for every driver, and add support in CRIU for every
driver as well.

Paolo

