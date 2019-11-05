Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5311CEFDA2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 13:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388695AbfKEMuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 07:50:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388468AbfKEMuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 07:50:04 -0500
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C3E45821F5
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 12:50:03 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id 22so17005454qka.23
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 04:50:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EdlBg8P4PzJeKJFbp0I86fI5VuI9JKDso5/u4JeQ6D4=;
        b=RA4UfPRTzLkOm2dT3P/XK5BwLPW3PBFaxBYyzn46Dwkvuqli5spzmKEmgJnsubOfci
         lULID8FyoUkusxWdR4zpan8vgPugZ62XeNYn1gRh4o9eYBRUTM78u5UvzhSd2SqWkxBI
         JMpNpOH1YcxENxZxb6kFum92u1qp9KYID67rtFLxTkq3MaXwawFOht2hjorXRUdzytcF
         cx3Yq/V34s3bPNESw3v/zd8gtjj7ignBQmf4ftXJEwmKB+MzXC4dp64cQYWVHrp7cL73
         su205CCs3FxXpWy4ZKLNmaFiwQT+NmBpOwb9b9OI6o6/w5RPM5FJHrTN8wkUsVFDxkW2
         OnyQ==
X-Gm-Message-State: APjAAAXCtd43N6AVM03/6kyDdGbhJOPYeQ6e1li3ErVMxWBq0ejKH5fN
        +ltami9jDMpgPsmjmPDDn2TBtEhRfM9n1efP1MKRD+z9x3Jos+XTSWf57mkzAmIuY5uNybDyZb/
        V0krR/NRXZjDH
X-Received: by 2002:a37:5645:: with SMTP id k66mr22949992qkb.368.1572958203023;
        Tue, 05 Nov 2019 04:50:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNgDCdQhbyW5Bg3iAlgavvicLqR0KlhK13lkvdyXE46MczwtzIs7/LQPhvcX0Ad3wZNod/ag==
X-Received: by 2002:a37:5645:: with SMTP id k66mr22949975qkb.368.1572958202779;
        Tue, 05 Nov 2019 04:50:02 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id o201sm9375290qka.17.2019.11.05.04.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 04:50:02 -0800 (PST)
Date:   Tue, 5 Nov 2019 07:50:00 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 03/22] intel_iommu: modify x-scalable-mode to be string
 option
Message-ID: <20191105125000.GE12619@xz-x1>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-4-git-send-email-yi.l.liu@intel.com>
 <20191101145753.GC8888@xz-x1.metropole.lan>
 <A2975661238FB949B60364EF0F2C25743A0EE30A@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0EE30A@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 09:14:08AM +0000, Liu, Yi L wrote:
> > Something like:
> > 
> >   - s->scalable_mode_str to keep the string
> >   - s->scalable_mode still as a bool to cache the global enablement
> >   - s->scalable_modern as a bool to keep the mode
> > 
> > ?
> 
> So x-scalable-mode is still a string option, just to have a new field to store it?

Yep.  I'd say maybe we should start to allow to define some union-ish
properties, but for now I think string is ok.

-- 
Peter Xu
