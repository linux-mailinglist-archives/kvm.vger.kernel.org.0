Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AEB276F09
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 12:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgIXKwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 06:52:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726415AbgIXKwV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 06:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600944740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/LXVplYXii3i8VVDSoLkYAGmwaSBNh+u6rFR6DKMhFo=;
        b=jKD+3qae4iDTuYF3Iq8II4qsOiC8KqrKE72URBNsU/C1j7WK0a6Avy+jq051L77vcOzTcO
        Rj1vYnWxyhIwFvC2YRJfewnZr9/sjRAJgtxAGUh1n+zLDZtA8PtBMzFn4ko65eeyJyNB3Q
        VS3EcdUZIdoIVZJnrEPQ7XSR4k9+g6w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-d450kk1BMwy5UK-v-dr60Q-1; Thu, 24 Sep 2020 06:52:18 -0400
X-MC-Unique: d450kk1BMwy5UK-v-dr60Q-1
Received: by mail-wr1-f69.google.com with SMTP id h4so1089806wrb.4
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 03:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/LXVplYXii3i8VVDSoLkYAGmwaSBNh+u6rFR6DKMhFo=;
        b=lP4zXc4t+tNpnQ2GuNKCbxskp6jGQJqJooPKotvsbS4Tr4AkNe1p3qc9aLIOQVnngh
         BZomDdjC7F72+ykVLGCeEbWKJEPO+7z8KrAmSZ1alZo57ThNs+l9AJGM5Vofb8h8jG8/
         JafnhzcBv/85R1odMNGpXDrsTfa0iUl/4sfUX9iCqKYqFMZksAaxwL1anRPqy/QYImfQ
         Y5+a6Yn+4Mn3HzwIp8jxwh6mwjh7o0laq3NFvP7Bni79clxYRSJfsvwXTqZNBj5VhXZ2
         q4Dvslpvy4Ro7quIpXiY2O5yKfwr7h2sWei1IWxIsz4JRRAEzU1w28DOBcVITAFzlz5f
         MYKg==
X-Gm-Message-State: AOAM530ocqEkEJxc5WjoBPl2CzitM3fQR537hTwFsw13Lax6ZLvpq3mC
        kuYErqs5Fy2rmoA1zKTVsZ8w4EgZM//IwbpZRemfQZ12o0aZnXoWrsW6Fzs8UP+7SwOVeNwzb8j
        fEu9hTAzjhlra
X-Received: by 2002:a5d:5583:: with SMTP id i3mr4314112wrv.119.1600944737698;
        Thu, 24 Sep 2020 03:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRxLO0WGwijqqqAfAr8AjNUn1i5R4xgsLIh5aLXDytfnHloab3Yk6R6+Fx8DV4ANXkCLlWvA==
X-Received: by 2002:a5d:5583:: with SMTP id i3mr4314097wrv.119.1600944737511;
        Thu, 24 Sep 2020 03:52:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id a17sm3378566wra.24.2020.09.24.03.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 03:52:16 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] README: Reflect missing --getopt in
 configure
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
References: <20200924100613.71136-1-r.bolshakov@yadro.com>
 <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
 <20200924103054.GA69137@SPB-NB-133.local>
 <7e0b838b-2a6d-b370-e031-8d804c23b822@redhat.com>
 <20200924104836.GB69137@SPB-NB-133.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b515b803-daec-5a1f-9d65-07c2f209f763@redhat.com>
Date:   Thu, 24 Sep 2020 12:52:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924104836.GB69137@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 12:48, Roman Bolshakov wrote:
> Unfortunately it has no effect (and I wouldn't want to do that to avoid
> issues with other scripts/software that implicitly depend on native
> utilities):
> 
> $ brew link --force gnu-getopt
> Warning: Refusing to link macOS provided/shadowed software: gnu-getopt
> If you need to have gnu-getopt first in your PATH run:
>   echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc
> 
> So if it's possible I'd still prefer to add an option to specify
> --getopt in configure. I can resend a patch for that.

No, I'm not going to accept that.  It's just Apple's stupidity.  I have
applied your patch, rewriting the harness in another language would
probably be a good idea though.

Paolo

