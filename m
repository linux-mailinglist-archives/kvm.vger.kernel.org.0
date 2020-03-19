Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BCF18B2BB
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 12:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgCSLyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 07:54:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:55405 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbgCSLyY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 07:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584618862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NgmFdXPOG5BK0FnreGKbBxPndGxBWswzYRCil+17m78=;
        b=JH9MbPIJJumLJY+23r6cgnTR1Fkwj9q40NnXZo/5RxLmfsiec2WNH7DMAfQ5Pqn+q8Ym0O
        OWlxqOxoHfzv+WLboPuQnb+2vlwWdroX1ukFl6fmpkaTAJFRwjlzcjlcLTyTRhGE3M8clx
        EKUPdI82KTZuPCaoSPQ1rgOD+G8Rfgs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-4xgUZqN-P4SdvjjdpM8eeg-1; Thu, 19 Mar 2020 07:54:21 -0400
X-MC-Unique: 4xgUZqN-P4SdvjjdpM8eeg-1
Received: by mail-wr1-f70.google.com with SMTP id q18so892426wrw.5
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 04:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NgmFdXPOG5BK0FnreGKbBxPndGxBWswzYRCil+17m78=;
        b=c6nOWysIOLV4MuzEEMLH6zkQpseKt0jDTWDTZfe2FVxWqQ42Gldo1N41FTYHz3X9+u
         P6z82lypA0qfykyZikD8n84TrRlyyQnZAHjTIz/00JeHuvtAwkT2EixxInAHxrl5ie6h
         QuEBL+meTeqODDHFHJ8NgbajKHUI0v9mv1lf97jhRgp9oWqRMUW27rlmqoGP3ZI2I9aM
         FTYHcyspHlXh52hk5cbSV4aGQpPMI9Wslpkhbv6IV8pdCISgIpF8X9ZjFu8gLs8JEYKp
         hH3CmP7nQ6/cObb29xDzFeaBHe+O/nE7boEyHocqwgHKeFydZEcU8yUx7rnMBydOYWuR
         VIiQ==
X-Gm-Message-State: ANhLgQ1kwmxrn/o4Pva+h6q1wdDnSJQi1AhFzBVrAb5wOYCnnXNs3QtK
        HgFpKkzCrTDm7Wq8rkgHmN6zHml5LhtwNNkoAbCD/6n11TCApzkN3u9owGBzQpdnL9TKjsaXC02
        mTT84oF6nPhaY
X-Received: by 2002:adf:9f48:: with SMTP id f8mr3802356wrg.199.1584618859837;
        Thu, 19 Mar 2020 04:54:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsu3nXFTlHZSaVLF6tppAjucUFLUwOcJMICRZCJpCgEsgJNvT5OyT1FK100J/5bltZ93l6MXA==
X-Received: by 2002:adf:9f48:: with SMTP id f8mr3802335wrg.199.1584618859599;
        Thu, 19 Mar 2020 04:54:19 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id 98sm3142089wrk.52.2020.03.19.04.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 04:54:19 -0700 (PDT)
Subject: Re: [PATCH 0/7] tools/kvm_stat: add logfile support
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com
References: <20200306114250.57585-1-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7f396df1-9589-6dd0-0adf-af4376aa8314@redhat.com>
Date:   Thu, 19 Mar 2020 12:54:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200306114250.57585-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/20 12:42, Stefan Raspl wrote:
> This patch series provides a couple of new options to make logging to
> files feasible.
> Specifically, we add command line switches to specify an arbitrary time
> interval for logging, and to toggle between a .csv and the previous
> file format. Furthermore, we allow logging to files, where we utilize a
> rotating set of 6 logfiles, each with its own header for easy post-
> processing, especially when using .csv format.
> Since specifying logfile size limits might be a non-trivial exercise,
> we're throwing in yet another command line option that allows to
> specify the minimum timeframe that should be covered by logs.
> Finally, there's a minimal systemd unit file to deploy kvm_stat-based
> logging in Linux distributions.
> Note that the decision to write our own logfiles rather than to log to
> e.g. systemd journal is a conscious one: It is effectively impossible to
> write csv records into the systemd journal, the header will either
> disappear after a while or has to be repeated from time to time, which
> defeats the purpose of having a .csv format that can be easily post-
> processed, etc.
> See individual patch description for further details.
> 
> 
> Stefan Raspl (7):
>   tools/kvm_stat: rework command line sequence and message texts
>   tools/kvm_stat: switch to argparse
>   tools/kvm_stat: add command line switch '-s' to set update interval
>   tools/kvm_stat: add command line switch '-c' to log in csv format
>   tools/kvm_stat: add rotating log support
>   tools/kvm_stat: add command line switch '-T'
>   tools/kvm_stat: add sample systemd unit file
> 
>  tools/kvm/kvm_stat/kvm_stat         | 434 +++++++++++++++++++++-------
>  tools/kvm/kvm_stat/kvm_stat.service |  15 +
>  tools/kvm/kvm_stat/kvm_stat.txt     |  59 ++--
>  3 files changed, 384 insertions(+), 124 deletions(-)
>  create mode 100644 tools/kvm/kvm_stat/kvm_stat.service
> 

I queued patches 1-4.  For the others, however, I would prefer to add
support for SIGHUP instead (to reopen the logfile), so that one can use
the usual logrotate services.

Paolo

