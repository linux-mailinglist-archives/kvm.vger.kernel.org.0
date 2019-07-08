Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8562A58
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 22:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404920AbfGHU2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 16:28:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37603 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730271AbfGHU2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 16:28:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id z28so8362453ljn.4
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 13:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aP50fU9jWh1SVwYTLC+Bnr2NJDpeCgQBUG33TJZRv3c=;
        b=O9TVM7vPx877J6GvjeRwcyAevrgRrCuSS8pcoeJlEHDIViI420nOnFbTzd2KdqHImt
         LUIC0flvjlPO8E3m0D1RH+5iydfGexIVXmCQSpk1/gC9ovhgdt1bBeeCH4oKESBwzqeV
         2XeX4oxEZjXCAld8+vGogj5AhlRTWc2sU2VMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aP50fU9jWh1SVwYTLC+Bnr2NJDpeCgQBUG33TJZRv3c=;
        b=R77x21YbtisW9vubHYhw5U9+5g14Wwhx80eW9P1iZkejx7G6moK/g8lScCXmT6KxPH
         F0FH/fodJV9GFpKDeMHM/nHZSckFJ292khgkHFhZtskar1++qsdBOldN08VqMrCwiH9x
         tK5WL6dfcroKJwey10X95LJkA8LktKqzcjfnnblhF3In3dbuxSi24eNhxM8SDmekH9AW
         mY3N/zC/agYlp3BAET6llCIVsT0gV4kGLMeU2GCd6K3vHz+Dx1CR1W+Jk66ETMrdKTYE
         0WsS2iDo4wac8id6A/iIKzNKfEueY7yk5fvuTxdfxBZ2OaHqzYY63DTLq5AvzAWGTVZ3
         da0A==
X-Gm-Message-State: APjAAAXmV7ZpOQlkPOZR+7Mlj2tny8nwr8z/+aSKIwPK9IfxM0m9SaQL
        ncIrD/BYryfotkwNlZeu8OrLrQ==
X-Google-Smtp-Source: APXvYqyqusmub7bifQwEMHiihwOyK5Pb+umaZm2KbS0Q9R3gTIIIHnNVYU0MymObvFosL9+y+wrpiA==
X-Received: by 2002:a2e:b60f:: with SMTP id r15mr9591215ljn.172.1562617691526;
        Mon, 08 Jul 2019 13:28:11 -0700 (PDT)
Received: from luke-XPS-13 (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id l11sm2934729lfk.1.2019.07.08.13.28.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 13:28:10 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:28:08 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Documentation: virtual: Add toctree hooks
Message-ID: <20190708202808.GA8859@luke-XPS-13>
References: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
 <ef1edb15bd6a6ef87abf4fef7636cd9213450e3c.1562448500.git.lnowakow@eng.ucsd.edu>
 <20190708135404.3eeed68f@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708135404.3eeed68f@lwn.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 08, 2019 at 01:54:04PM -0600, Jonathan Corbet wrote:
> On Sat,  6 Jul 2019 14:38:13 -0700
> Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu> wrote:
> 
 
> At this point in the patch series, the above-mentioned RST files don't
> exist.  So if somebody tries to build the docs here, the build will fail.
> I suspect that it's pretty rare for people to use bisection with docs
> builds, but it's still proper practice to ensure that things work at every
> step in your series.  So the above entries should be added in the patches
> that convert the files.
>

Yes, agreed. It should be at the end of the series. 

> Also, vcpu-requests.txt is never touched in this patch series, which
> suggests that you didn't build the docs even at the end of it.
> 

In the staging tree I was doing work out of I saw a vcpu-requests.rst
file so thought I could add it "while I'm here". 

You're right. I should only add the files I am converting. 

> Thanks,
> 
> jon

Thanks again, 
- Luke
