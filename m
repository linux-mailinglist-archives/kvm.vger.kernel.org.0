Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B30B5F31
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 10:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbfIRI2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 04:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfIRI2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 04:28:30 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EE69C057FA6
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 08:28:30 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id v13so2062899wrq.23
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 01:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5AiFkSR+jG9zbymZlmVuttvGFZdHdAkDLP8ZlJh9phk=;
        b=mfdquOpcRcJHHbuaWATQTQjOaXc/yVYrP/KFKJK8B4i/2cUaPqTohWdX0wJv/BlOrL
         PAYfq8w2G8wZant+JlkstzyNvR70EqeLdTdE40rNAAWYm15IhOnHYUPdOaZWEHWIQ+ys
         1HAgQTSs6szLXUC4nkw4re9J1QHPOIUswT4yyflz/uCP61UqPgN50OrzMU64laGn5ZsR
         VBhW06s4Nq/aQb2ut4BPcf0Iu4C2EkTpWp5Wt0mYfreDV5ZiR6Ws0noV/pkU9MO5IAX9
         fVa40iPbIK5P7zWoO0HUZmqmmnay8D7QKkUqx41o6jIR/oqoJ2Cb/R9Fw9IBW7zerSyh
         S0Gg==
X-Gm-Message-State: APjAAAXnIuhR7BnnMAwDrqV7GFiGAMOMtFCPCbno8mQ8lz1Ieff5MorU
        RFXwIciqJed2axRNc6HKdbjT0k6GXflWKupAVpkAvm0P65S9ARHvfCl+SJI3QEKp624jDK6+5kc
        NcdrHa8100ur9
X-Received: by 2002:a1c:4c12:: with SMTP id z18mr1740461wmf.45.1568795308929;
        Wed, 18 Sep 2019 01:28:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxyFjZ2wQiW9cu/cZKg0dWX+RfVfeje3y9q9jB5BgB6PWXxd8MWI1Sw6eqIsqzKzFph4xBAmA==
X-Received: by 2002:a1c:4c12:: with SMTP id z18mr1740437wmf.45.1568795308590;
        Wed, 18 Sep 2019 01:28:28 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id h17sm2864501wme.6.2019.09.18.01.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 01:28:28 -0700 (PDT)
Date:   Wed, 18 Sep 2019 10:28:25 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, libvir-list@redhat.com,
        kvm <kvm@vger.kernel.org>
Subject: Re: [libvirt] Call for volunteers: LWN.net articles about KVM Forum
 talks
Message-ID: <20190918082825.nnrjqvicqwjg3jq6@steredhat>
References: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 02:02:59PM +0100, Stefan Hajnoczi wrote:
> Hi,
> LWN.net is a popular open source news site that covers Linux and other
> open source communities (Python, GNOME, Debian, etc).  It has published
> a few KVM articles in the past too.
> 
> Let's raise awareness of QEMU, KVM, and libvirt by submitting articles covering
> KVM Forum.
> 
> I am looking for ~5 volunteers who are attending KVM Forum to write an article
> about a talk they find interesting.
> 
> Please pick a talk you'd like to cover and reply to this email thread.
> I will then send an email to LWN with a heads-up so they can let us know
> if they are interested in publishing a KVM Forum special.  I will not
> ask LWN.net for money.
> 
> KVM Forum schedule:
> https://events.linuxfoundation.org/events/kvm-forum-2019/program/schedule/
> 
> LWN.net guidelines:
> https://lwn.net/op/AuthorGuide.lwn
> "Our general guideline is for articles to be around 1500 words in
> length, though somewhat longer or shorter can work too. The best
> articles cover a fairly narrow topic completely, without any big
> omissions or any extra padding."
> 
> I volunteer to cover Michael Tsirkin's "VirtIO without the Virt -
> Towards Implementations in Hardware" talk.

I volunteer for "Libvirt: Never too Late to Learn New Tricks" by
Daniel Berrange.

Cheers,
Stefano

