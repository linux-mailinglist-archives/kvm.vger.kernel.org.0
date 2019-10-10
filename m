Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4F5D2494
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 11:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbfJJIrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 04:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389524AbfJJIrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:49 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08C4681F11
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 08:47:49 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id y18so2398600wrw.8
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 01:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yMEA1vwAxxDR9KMsFNEltEDGLvMYr7N57Wh6Y66WRc0=;
        b=d+n+ENdHpTjo70+OqLxJVC0Z6cPUaXhXqz7ZLBDTEcrkIL2hx3MOUIa2i6VJLWN9z3
         WKHJFmMoNXZSmH3HdbFxNgICzRrsbznE3Xa+MHzJW4QJ+ypnlxPtJoMVqSoBiTkZIRWj
         3b7oEed5H7bzmoW5sdW3xTuLccXdqqorWBUh/kf4+AOVE60yuLsdtq0ZWlp570tT3CUJ
         +8lwP1xP66lDmLcCfjwFOa+WbzQ+Mw/NXPXTKDq7ync8FK3xpYOfEPyow1N0pOrVaDLF
         wYQoc9YG/lyejnc/d8fm8xJardNw+fAN1D3aSpP3d1gC52JCqfwUOwfUmBBkX0Thrbqw
         Gq5Q==
X-Gm-Message-State: APjAAAUjLhJmQm5tAgTfXcbtup/8MJc0kEMJSaQCQL6Y5wD0j/Pe6zla
        VCuIy498stDg3ruq/zFu0ixZTxJdY5BlmOz/gq9Ow6TXmu5q2ouEEQqOt9QD6z/WDiWayztDbUd
        K6vJRXV9Y+eBY
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr6460275wmk.135.1570697267774;
        Thu, 10 Oct 2019 01:47:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwGlOe+0u6KXBMrN0A6Ztn9RSeVar+fTIwwT5kQa51LZTkc+efRSchIZ3bkrYo/CFxMwyo8bg==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr6460257wmk.135.1570697267541;
        Thu, 10 Oct 2019 01:47:47 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id z9sm5103737wrp.26.2019.10.10.01.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:47:46 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:47:44 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/11] VSOCK: add AF_VSOCK test cases
Message-ID: <20191010084744.n46t3ryv7rilkpk2@steredhat>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-8-sgarzare@redhat.com>
 <CAGxU2F4N5ACePf6YLQCBFMHPu8wDLScF+AGQ2==JAuBUj0GB-A@mail.gmail.com>
 <20191009151503.GA13568@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009151503.GA13568@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 04:15:03PM +0100, Stefan Hajnoczi wrote:
> On Wed, Oct 09, 2019 at 12:03:53PM +0200, Stefano Garzarella wrote:
> > Hi Stefan,
> > I'm thinking about dividing this test into single applications, one
> > for each test, do you think it makes sense?
> > Or is it just a useless complication?
> 
> I don't mind either way but personally I would leave it as a single
> program.
> 

Okay, since I had the doubt it was a useless complication and you prefer
a single application, I continue on this way :-)

Thanks,
Stefano
