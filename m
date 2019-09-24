Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A330BC8E0
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632734AbfIXNYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:24:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504930AbfIXNYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:24:34 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2ED8C004E8D
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:24:33 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id 11so1920029qkh.15
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gyt+QtSY5LxRkStjts+Gw8hS4n9Wq+3XVX5S1gdnFC4=;
        b=lS7yyqkzXrhcFQ6zWGIcV3YcoDkhOPOwDf19Wp79VtfZSKm3dhw7D4kdV/E4RHWPHQ
         g8NmC3RUw+m/oUTftKmw5n7352UR2oUTm7/YVfN/IWImu/c5xD7Stlr1TOhWjCqXRJwY
         jRhnRVLTpEIYDA8fgjSPr0pSXpD/aNwB1PeU+ghlh4L2/me+JBJBa+E9mSUsWFrS+tAU
         bqe7wSpYKmI3GnFRxCPkeEhv+SbGJ4anUriIVysD6++DIt85HkTswEu9uuPnUGlCBrq1
         GKVYb7qtNzB5qqIRcqS9bxM6bNXusA7SE6ArqzTPN3YYiPEv6XprA6vq+FbHZAQFfTPk
         HQ5g==
X-Gm-Message-State: APjAAAXvDPWAXGtezy+zd9wPle6rAEV+rrNLnCZXpq7wX/+6aiAiWAOb
        O/CqiaXWh55MJy4uNa+SKoCGOxiqrAdpDEDFOJsbiYzTNxlRljJitMLDMFJS8/b/dQ//FG6A90Q
        8qbGmJJvxbfjJ
X-Received: by 2002:a37:660c:: with SMTP id a12mr2363528qkc.70.1569331473092;
        Tue, 24 Sep 2019 06:24:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxjgG8mfpqiiLRQUIWFSVWiG7TgSKvyHkDPLEqT5ZrVuaG6L/jb1qOCc2tNCJVI59lHt67jZA==
X-Received: by 2002:a37:660c:: with SMTP id a12mr2363507qkc.70.1569331472881;
        Tue, 24 Sep 2019 06:24:32 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id v5sm1157556qtk.66.2019.09.24.06.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 06:24:32 -0700 (PDT)
Date:   Tue, 24 Sep 2019 09:24:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org,
        imammedo@redhat.com, marcel.apfelbaum@gmail.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
Message-ID: <20190924092222-mutt-send-email-mst@kernel.org>
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-9-slp@redhat.com>
 <2cbd2570-d158-c9ce-2a38-08c28cd291ea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cbd2570-d158-c9ce-2a38-08c28cd291ea@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 03:12:15PM +0200, Paolo Bonzini wrote:
> On 24/09/19 14:44, Sergio Lopez wrote:
> > microvm.option-roms=bool (Set off to disable loading option ROMs)
> 
> Please make this x-option-roms

Why? We don't plan to support this going forward?

> > microvm.isa-serial=bool (Set off to disable the instantiation an ISA serial port)
> > microvm.rtc=bool (Set off to disable the instantiation of an MC146818 RTC)
> > microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)
> 
> Perhaps auto-kernel-cmdline?
> 
> Paolo
