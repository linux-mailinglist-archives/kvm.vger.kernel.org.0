Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152412F6DF1
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 23:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbhANWNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 17:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730666AbhANWN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 17:13:26 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B6BC0613C1
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 14:13:10 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y12so3908754pji.1
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 14:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C8h+j5fbJSEN0pJyExzvFI/MxCa+pEdm2TUh5tsiGUA=;
        b=uNU6S2j9Z7ETIRlQlv2eUjEMkA8U/qFKEvuUleM375unDtjtkDX8cMyHoohHqXnu3W
         woYXW0GCkFcdtlDOMiQz50569KgWKHvyTTEFwv7UOgS1c+xE2ir/5nHZsOSyZeRAH7Ku
         86dgto04m3LMpnK43rXHsPuD7bzDcqf2OZHjdW5xOKqQHgwAigATZabASQnnAyVfhklm
         dZ3f+Xe44pOeMBsC6ETbOrcwjksgZzoAzRZudnEme+wpGS+gD1BSXcQsj3SZ5pNd8coN
         DrbSGZsUTi7YPQIg3oQyrRYHBvkQRifNgo63roHlOl0oPOe/SSlAsyQsvaGP9kf+9NQM
         Y58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C8h+j5fbJSEN0pJyExzvFI/MxCa+pEdm2TUh5tsiGUA=;
        b=V/o93ZUkDdrWnPRMhrSls6uGefZQs4lEw5oY3GJONZaiYqLKCbKav1GWLDZY6b5npL
         5NQMuifofpOe/+vjFcDN+gEEiFWTPxK1ngtftp8fmG36Wh22cLhWS+5hBiZM2Wqk6R01
         CnC3TkQPlyn2pVzoMZXWwnlvQLtTyvgPGnZ0lKKYTxnupdMc1lIf4aMAWtvq1Ib0PhO6
         miZwOf845+vd5hIdUZtMpNY3EWmKvPBmtYIhIic0FDhIpWmmjHBKzYDQZ1dEYZAmVb+k
         Jkx2R65TNTXHnO5SUBpi818qq6MzlCdHVABAVY8SOgq0del33JjZHaMb7M5SkvHzvrU6
         DjjA==
X-Gm-Message-State: AOAM530I4zTPEoBC2+tF7SE9zXiAaVSspsXUmHatDy3jxKKcfJkeb/0o
        XRIwQj8VJoDwS0RoWbV/po/VkA==
X-Google-Smtp-Source: ABdhPJzF4jDEXIqIrZPuOIsgAL5RITqUyNw+o2KW3iUpVlpABpLpOS8lo5ggaR3l8+U1rmu3Jn2YCg==
X-Received: by 2002:a17:90a:5581:: with SMTP id c1mr7147041pji.86.1610662390345;
        Thu, 14 Jan 2021 14:13:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id d19sm5751219pjw.37.2021.01.14.14.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 14:13:09 -0800 (PST)
Date:   Thu, 14 Jan 2021 14:13:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Message-ID: <YADB72Bu9PGh+bFk@google.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
 <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
 <YACl4jtDc1IGcxiQ@google.com>
 <d2e5f090-b699-1f94-eb33-b7bb74f14364@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2e5f090-b699-1f94-eb33-b7bb74f14364@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021, Paolo Bonzini wrote:
> On 14/01/21 21:13, Sean Christopherson wrote:
> > On Wed, Jan 13, 2021, Paolo Bonzini wrote:
> > > On 12/01/21 23:28, Sean Christopherson wrote:
> > > > What's the biggest hurdle for doing this completely within the unit test
> > > > framework?  Is teaching the framework to migrate a unit test the biggest pain?
> > > 
> > > Yes, pretty much.  The shell script framework would show its limits.
> > > 
> > > That said, I've always treated run_tests.sh as a utility more than an
> > > integral part of kvm-unit-tests.  There's nothing that prevents a more
> > > capable framework from parsing unittests.cfg.
> > 
> > Heh, got anyone you can "volunteer" to create a new framework?  One-button
> > migration testing would be very nice to have.  I suspect I'm not the only
> > contributor that doesn't do migration testing as part of their standard workflow.
> 
> avocado-vt is the one I use for installation tests.  It can do a lot more,
> including migration, but it is a bit hard to set up.

Is avocado-vt the test stuff you were talking about at the KVM Forum BoF?
