Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B75B1FD4F
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 03:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfEPBqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 21:46:31 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35635 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfEPAWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 20:22:03 -0400
Received: by mail-oi1-f194.google.com with SMTP id a132so1222196oib.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 17:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bobcIcGI2hoSe5dAxap34CNUn9LKnTkS03oUmV7h0q4=;
        b=j9nGNhyMsOaTVud6KO3dskijFfmT2ZQWGqLP7vYr40RYrbZpP2ISfBY4/jbvgTXbHD
         PBNLGCVvSGEIW+pkvZWIknWRx7irtf13DgdR99Ie6/6xDxy1VgUpVBlwuK3ybEJWLqgW
         utTN/SrtWzEr/dIFr8r1RtV1Jsh3YspspkZIMQzCSJBi0BrKaoBFZs55FZ0kUQ+CSg3y
         cLNlzpERm8qRNJFebCDsd3GPaloqk3nhEzbkU4ir0yewDOVvjZvhY9NZ9QQfKgfHgQw3
         Jf1vLci6RuObHmAw9PyVKzRBRDvCgYO0flvWfgK5uIBS1CIRxOGoy2HsIk/r+YmH4QgG
         GIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bobcIcGI2hoSe5dAxap34CNUn9LKnTkS03oUmV7h0q4=;
        b=jow1bqZBtOj6pBZb2K4Hta0iROQYOeEEW47z99yXzT0jr+NTA/T9Ce+OwR6XHLVM0h
         UVsEvoz4gDo/TOOPwqdSNmA/NRq9xwBwxGgHzg/ZH6fADs7Yiw+8uaHZBbRS8ritWZs5
         cFrmwM6qKdKx8Q8CI8xeV6Cu/qgj40TRNvM4pX+Y7vSxhNHZHTRlio9HqkIWY5mK+9RY
         P/9yjVCRhoz2ZGaPFzhg4kN+dhzxlioP9xhr3RNCbKVbTNJWiB0NH3VUfLNV33K6RkdM
         wT87Eed2R9ezzqEEoFHDSdybabEHE+zi9YnLsf2KACkbrYjTgXKmEdRP0AihHtAOxqSs
         icmQ==
X-Gm-Message-State: APjAAAVWm9LbQNZzRh86o0lAkTJ2LFRavVhCFQ3/Sa/HqWLn+hHg6NTL
        Ne6tp7q0QFcnwHQCxyBbTM5Yi/JY7JCHcqESIIZarZSO
X-Google-Smtp-Source: APXvYqzDrmQi77dAWBNc07ndDu3T5pa6iN0pcVHtAZNxLtfjwvQPS0Zb7sMkMpyK1B3ioBtGGZnPjQ/C8y0NssMQmSA=
X-Received: by 2002:aca:b641:: with SMTP id g62mr5885998oif.149.1557966122846;
 Wed, 15 May 2019 17:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190515192715.18000-1-vgoyal@redhat.com> <20190515192715.18000-13-vgoyal@redhat.com>
In-Reply-To: <20190515192715.18000-13-vgoyal@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 15 May 2019 17:21:51 -0700
Message-ID: <CAPcyv4i_-ri=w0jYJ4WjK4QD9E8pMzkGQNdMbt9H_nawDqYD3A@mail.gmail.com>
Subject: Re: [PATCH v2 12/30] dax: remove block device dependencies
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 15, 2019 at 12:28 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> From: Stefan Hajnoczi <stefanha@redhat.com>
>
> Although struct dax_device itself is not tied to a block device, some
> DAX code assumes there is a block device.  Make block devices optional
> by allowing bdev to be NULL in commonly used DAX APIs.
>
> When there is no block device:
>  * Skip the partition offset calculation in bdev_dax_pgoff()
>  * Skip the blkdev_issue_zeroout() optimization
>
> Note that more block device assumptions remain but I haven't reach those
> code paths yet.
>

Is there a generic object that non-block-based filesystems reference
for physical storage as a bdev stand-in? I assume "sector_t" is still
the common type for addressing filesystem capacity?

It just seems to me that we should stop pretending that the
filesystem-dax facility requires block devices and try to move this
functionality to generically use a dax device across all interfaces.
