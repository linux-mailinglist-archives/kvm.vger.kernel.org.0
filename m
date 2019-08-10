Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792EA88CDA
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2019 21:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfHJTMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Aug 2019 15:12:19 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45536 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfHJTMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Aug 2019 15:12:19 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so401606qki.12
        for <kvm@vger.kernel.org>; Sat, 10 Aug 2019 12:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tOm/MfXC722ZZDGZkYyy/bxra5b24Gt/HS1+G7EfviI=;
        b=aVlvcv1S46sB5tN21dd0pSvJ3ajY/oaG1IEMAN7xxScqsfdxguoyQntKN7UmyBQUFa
         VmRRnxYoffIIkMajJOYMqxUTu/2I6KB6FpgaFgfRGiDi2y2hIcmzf/maFEvTA0NEubk6
         FUxF3/fh0aH91rauBe0l1xAWx9RPDYxoYLWe0g89R05Ew6ZikkUlFNdVAWQRqaB5R7ed
         w9bSBkiTkr0VEwayaugAVe/2S0jqyQUYkL/EHCiJXKFY3p8WYE0xiPlEBe0uYKGlJvb+
         HYVRMmKAcqjukPypQTvsWAq/mSoDa9wDhVGkWjHbMD+s7xA6g/3RE/7ZlE2MTkV8HzMK
         pfEg==
X-Gm-Message-State: APjAAAUYpyf/WtHfRtp/XuVN6Mg77ed0vavmvZbsqriJObx4yF/htNoL
        NMxXVBCRx/oWwSrJ2piXcIosBg==
X-Google-Smtp-Source: APXvYqy9zmxhh9QafC0RnwL+m0pBIJpGi6lXzl9adS3Ij5sGenWXNRYs/XzZWBUSfehxs1JFSId7lA==
X-Received: by 2002:a37:516:: with SMTP id 22mr23794866qkf.308.1565464338086;
        Sat, 10 Aug 2019 12:12:18 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id q17sm40074395qtl.13.2019.08.10.12.12.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 10 Aug 2019 12:12:16 -0700 (PDT)
Date:   Sat, 10 Aug 2019 15:12:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190810150611-mutt-send-email-mst@kernel.org>
References: <20190807070617.23716-1-jasowang@redhat.com>
 <20190807070617.23716-8-jasowang@redhat.com>
 <20190807120738.GB1557@ziepe.ca>
 <ba5f375f-435a-91fd-7fca-bfab0915594b@redhat.com>
 <1000f8a3-19a9-0383-61e5-ba08ddc9fcba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1000f8a3-19a9-0383-61e5-ba08ddc9fcba@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 08, 2019 at 08:54:54PM +0800, Jason Wang wrote:
> I don't have any objection to convert  to spinlock() but just want to
> know if any case that the above smp_mb() + counter looks good to you?

So how about we try this:
- revert the original patch for this release
- new safe patch with a spinlock for the next release
- whatever improvements we can come up with on top

Thoughts?

Because I think this needs much more scrutiny than we can
give an incremental patch.

-- 
MST
