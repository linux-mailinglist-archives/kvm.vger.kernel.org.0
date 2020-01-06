Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE921310D8
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgAFKut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:50:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59357 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgAFKus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:50:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578307842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qU0SboNEBDWBERvxqixCdqMTzHYQoyobKNvA/+6rjvk=;
        b=SHQAbBXjwM9JpzhLgaGwt7StvCGtb/Rm+1oaOxa4JXOo8dEXm/WRKCY5HYlRP2nnKxyVkz
        cZ4ZyYCx84zX8dGGM7c8604NmvN4mLbDn50ymsWLu8xfj6Lw61pXh2N21aRiA59eM5SE9i
        tUR8wkFDlWYundZcKHygvz0DP6R7Ft4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-UByREwiKOc6T-VUyRzg0zg-1; Mon, 06 Jan 2020 05:50:41 -0500
X-MC-Unique: UByREwiKOc6T-VUyRzg0zg-1
Received: by mail-qk1-f198.google.com with SMTP id m13so17277340qka.9
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 02:50:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qU0SboNEBDWBERvxqixCdqMTzHYQoyobKNvA/+6rjvk=;
        b=maH2/eKMkTaZJMqvr9sUGYLQUvE/A1ciecDOuAQux2OHctZpqhVZFdljAUzYQqvOif
         iucSUT3cYtPp4lJP0m3g42FfQbubj8unpo16ntDsHHiymwhyCeEuFk7hT8v5UEqP3rsS
         c0CjHAk1c+jOygc93BBF1EskWL9cVBUIIDc9lmhJ2vRttV9gmklNiA4voyG4r6WKEnNY
         i/j52RtLrrgcMjZnwjj3hyDyfjnwVlj3Y0BF1YF9bwnZyGgzLLDlj+uZtIBjGQSAv+Kp
         3iST5m312fnSRRHLPob+dCZvoBFo1NW9PFnfV0qxPPF+Vd5AFYKqm+RHG3Cji9NCBlc3
         m1vQ==
X-Gm-Message-State: APjAAAUyzk9qVodUvymR7hBkQGKeGleR5lz/0k2QtB/i0dZfySQXhUrw
        mt6e4e49H/apSWxy9o++z70RXsDMVAoZ+lih9scBierci2FAv+W/D87okUT50MBmkOiuIW3YmCs
        y3Qvglzb5hsOY
X-Received: by 2002:a37:65c7:: with SMTP id z190mr77575627qkb.261.1578307841388;
        Mon, 06 Jan 2020 02:50:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqwBMNWp3jpUCJz4gy7m1LfPpAYW3QX/zbzMI48HgZMdTtTpUk7nhqdKrFjR8fz3UtWCh133Iw==
X-Received: by 2002:a37:65c7:: with SMTP id z190mr77575606qkb.261.1578307841125;
        Mon, 06 Jan 2020 02:50:41 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id e2sm20313422qkb.112.2020.01.06.02.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 02:50:40 -0800 (PST)
Date:   Mon, 6 Jan 2020 05:50:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
Message-ID: <20200106054041-mutt-send-email-mst@kernel.org>
References: <c022e1d6-0d57-ae07-5e6b-8e40d3b01f4b@de.ibm.com>
 <20191218100926-mutt-send-email-mst@kernel.org>
 <2ffdbd95-e375-a627-55a1-6990b0a0e37a@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ffdbd95-e375-a627-55a1-6990b0a0e37a@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 04:59:02PM +0100, Christian Borntraeger wrote:
> On 18.12.19 16:10, Michael S. Tsirkin wrote:
> > On Wed, Dec 18, 2019 at 03:43:43PM +0100, Christian Borntraeger wrote:
> >> Michael,
> >>
> >> with 
> >> commit db7286b100b503ef80612884453bed53d74c9a16 (refs/bisect/skip-db7286b100b503ef80612884453bed53d74c9a16)
> >>     vhost: use batched version by default
> >> plus
> >> commit 6bd262d5eafcdf8cdfae491e2e748e4e434dcda6 (HEAD, refs/bisect/bad)
> >>     Revert "vhost/net: add an option to test new code"
> >> to make things compile (your next tree is not easily bisectable, can you fix that as well?).
> > 
> > I'll try.
> > 
> >>
> >> I get random crashes in my s390 KVM guests after reboot.
> >> Reverting both patches together with commit decd9b8 "vhost: use vhost_desc instead of vhost_log" to
> >> make it compile again) on top of linux-next-1218 makes the problem go away.
> >>
> >> Looks like the batched version is not yet ready for prime time. Can you drop these patches until
> >> we have fixed the issues?
> >>
> >> Christian
> >>
> > 
> > Will do, thanks for letting me know.
> 
> I have confirmed with the initial reporter (internal test team) that <driver name='qemu'/> 
> with a known to be broken linux next kernel also fixes the problem, so it is really the
> vhost changes.

OK I'm back and trying to make it more bisectable.

I pushed a new tag "batch-v2".
It's same code but with this bisect should get more information.


I suspect one of the following:

commit 1414d7ee3d10d2ec2bc4ee652d1d90ec91da1c79
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Mon Oct 7 06:11:18 2019 -0400

    vhost: batching fetches
    
    With this patch applied, new and old code perform identically.
    
    Lots of extra optimizations are now possible, e.g.
    we can fetch multiple heads with copy_from/to_user now.
    We can get rid of maintaining the log array.  Etc etc.
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

commit 50297a8480b439efc5f3f23088cb2d90b799acef
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Wed Dec 11 12:19:26 2019 -0500

    vhost: use batched version by default
    
    As testing shows no performance change, switch to that now.
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


and would like to know which.

Thanks!


