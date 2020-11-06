Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4142A9805
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 16:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgKFPEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 10:04:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727055AbgKFPEJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 10:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604675047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CzgmSukU+JJ0kZAYj3W3oD7+hdMHa/WgIF1zrVhCvus=;
        b=VLEhA+/6qu5P/NJ/Dnhl8GPF5bIao8MjV6XKeFOUBooatjq7wkqf+G6sqpN+Z9KvZk58H/
        C9zVs5qH4RaBxeufJezl1q/FRjR6ZEeo+RzqSahuJ94eqFGNYhQiV9Ijit6FlE2E2uIHwh
        0FJWVo5Biy5qjzCrvUGNph5HgTcOD8Y=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-61hDS0YkNFyoLcKqAerkhA-1; Fri, 06 Nov 2020 10:04:04 -0500
X-MC-Unique: 61hDS0YkNFyoLcKqAerkhA-1
Received: by mail-qk1-f199.google.com with SMTP id x5so894770qkn.2
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 07:04:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CzgmSukU+JJ0kZAYj3W3oD7+hdMHa/WgIF1zrVhCvus=;
        b=EZYFh30Kp3915QlUfIW3A+FguJvmkH7vhWl+KwYSYmg5goU3PuC7RPImW0rhOgZmrM
         Bh9RVCsCPjgUJVlnFdxxL/eJAMQBiby0fDSXFK3qSI2Te0ss5AoTwEh6OqVP8VM4GJHz
         AwriaM/dRDS4ZUYHlUHPNUNtA3X/CTswW+/iQZlO9FjOVgId+j0T0+b+SE2TiQwzI9cW
         Azmsi33hlTCh6jw4psm1E+kXvr44i/NSD9G4bTKumflj/PTTvyL6h10OM108qO8+2j4S
         4If4g9+KY0G6Siyoh9iCqF4whh7uHfLrxGuZsdL446j202BJze95qDNZPAK6lLXdF3Ie
         Q41g==
X-Gm-Message-State: AOAM530kbwb+7JbAWDVkZA59x6YrXYYHo4/100GUq0rsuoXvHdM8XWpL
        3o3mEiwH2sZ40UnDm9ZxFRUmyz4GvP2dG/8k7kcLRyIeYUsJ7b8aX9cpcoYkzo/jDJsX3rDga6F
        Ins0jbFM9zE/L
X-Received: by 2002:a37:99c2:: with SMTP id b185mr1722563qke.81.1604675043782;
        Fri, 06 Nov 2020 07:04:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYA8HjUTGFsF9FYbarx9dJ/KgkVCzzhLWdsVB8rhWPOZ7UHJju5a++qohgpKh78SN4ICf4DQ==
X-Received: by 2002:a37:99c2:: with SMTP id b185mr1722542qke.81.1604675043530;
        Fri, 06 Nov 2020 07:04:03 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id k11sm681742qtu.45.2020.11.06.07.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 07:04:02 -0800 (PST)
Date:   Fri, 6 Nov 2020 10:04:01 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 00/11] KVM: selftests: Cleanups
Message-ID: <20201106150401.GB138364@xz-x1>
References: <20201104212357.171559-1-drjones@redhat.com>
 <20201105185554.GD106309@xz-x1>
 <CANgfPd_97QGP+q8-_VAzhJxw_kdiHcFukAZ-dSp4cNrvKdNEpg@mail.gmail.com>
 <20201106094511.s4dj2a7n32dawt7m@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201106094511.s4dj2a7n32dawt7m@kamzik.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06, 2020 at 10:45:11AM +0100, Andrew Jones wrote:
> Yikes! Don't worry about KVM selftests then. Except for one more question?
> Can I translate your "looks good to me" into a r-b for the series? And,
> same question for Peter. I'll be respinning witht eh PTES_PER_PAGE change
> and can add your guys' r-b's if you want to give them.

Yes, please feel free to add with mine (if there's a repost).  Though I see
that Paolo has queued the series already, so maybe it's even easier to directly
work on top.

Thanks!

-- 
Peter Xu

