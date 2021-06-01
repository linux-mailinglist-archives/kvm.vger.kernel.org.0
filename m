Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B572397330
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 14:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhFAM3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 08:29:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231219AbhFAM3Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 08:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622550454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lQvZyUoXVmIb3zfNjpz2vDPXvvVv3DHJGgPXj4NfCyk=;
        b=OePmFVothO6VTqbdsyk3t9Egv7wYpyZBC/vCx0u2zitJI84k6HAOqlW0A1uNU1wmWpSi6u
        I6MGOFVv475SQz4uyBKwjXQWu7T2bowofyfRBZYOG7TkYvqDygbkUkmpKqMgVerPndSIvx
        W1IzL1zjBZaN5mb5T5/ZLhGWMZ1gBds=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-M8qEEGtdOnCCuT_qzBAKFQ-1; Tue, 01 Jun 2021 08:27:33 -0400
X-MC-Unique: M8qEEGtdOnCCuT_qzBAKFQ-1
Received: by mail-ed1-f70.google.com with SMTP id j13-20020aa7de8d0000b029038fc8e57037so6290234edv.0
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 05:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lQvZyUoXVmIb3zfNjpz2vDPXvvVv3DHJGgPXj4NfCyk=;
        b=SUX3q9q++PBE2KZqHmX75H6PA9nbdgExASbnPxrfhVZCCann6WZ/2ixNWwu08e2VBW
         BD2oEShURPUgusNz07mGZFME32rmr4tAsTfcToZzEOh6fMSvX0G2ewuoBgl87CfE2T4p
         yJL9lWptJYvu26K+5OdbR16TSOlhlLYJxmlvmMHSZd8vDKvYgly7VOdAlNBHkc0vbpGH
         GhAkJ2AdbkmDJNe8eBXwn3wLQwME5AZM5q9uG8tJLuQSyoTt57fQNXaLby3G+np6fJ7z
         Uun7le2unoAZS97F4sb+q5FudW2pwVeBAIeOSGdVSZ/lVfDAaS8NnTCVKrnbPHDXcMJo
         jrSQ==
X-Gm-Message-State: AOAM532WtUl/2XHU9HJKSttaPr42b7bS/hF0shUgRqlQMvhaQru3qQ7m
        ZQPizIk5Gls7lUTCV0y7LHvoS5Z1DlBWS/5AaSCofNMwZ3L4vO4ZrX2gMFYT9ksigW2hwOfNukG
        ofA6bGccxC0rf
X-Received: by 2002:a05:6402:170e:: with SMTP id y14mr23743874edu.367.1622550452662;
        Tue, 01 Jun 2021 05:27:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiKHS2wqpO00I6qpAmAouTmxfS631vP+B8lrpX5GWqTUpwzxbzb820iR2grCzdAC1TdTDGlA==
X-Received: by 2002:a05:6402:170e:: with SMTP id y14mr23743859edu.367.1622550452504;
        Tue, 01 Jun 2021 05:27:32 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id e24sm439285ejb.52.2021.06.01.05.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 05:27:32 -0700 (PDT)
Date:   Tue, 1 Jun 2021 14:27:30 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v2 2/4] scripts/arch-run: don't use
 deprecated server/nowait options
Message-ID: <20210601122730.ssdxx7ut6e25e4b5@gator.home>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-3-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210525172628.2088-3-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 06:26:26PM +0100, Alex Bennée wrote:
> The very fact that QEMU drops the deprecation warning while running is
> enough to confuse the its-migration test into failing. The boolean
> options server and wait have accepted the long form options for a long
> time.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>
> ---
>  scripts/arch-run.bash | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

