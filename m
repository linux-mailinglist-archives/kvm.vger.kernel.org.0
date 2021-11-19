Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC4145766D
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 19:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhKSSgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 13:36:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231841AbhKSSgF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 13:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637346783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+GQMwG10mbwdIIWMwu0ilfUEUoBg0jOybBvIrXEDjQ=;
        b=hANP8MGuaLOviZukTTmSdxdSRT9HNjIRf84lXZRDqKWSYJd73n6Qc5hqqxGvl5Mc6YtRJE
        O6Vc7IatXO9xxfMafYdE8dtSWDrJPVRLFFDpC3Dzyf0+FEu4uLlyhsxJt/zNlBdLALBfxs
        M70n7y1g7cbMtxBwUxg7no3wnijvfuQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-IoM9-hPuNpWTUoaqJeAgEA-1; Fri, 19 Nov 2021 13:33:02 -0500
X-MC-Unique: IoM9-hPuNpWTUoaqJeAgEA-1
Received: by mail-ed1-f69.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so9141889eds.23
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 10:33:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=B+GQMwG10mbwdIIWMwu0ilfUEUoBg0jOybBvIrXEDjQ=;
        b=vTgWIXfsy2X9oMZoWEQiAp7EHozLzFCVx3LXaDagu47Eir/l0HsfELUiv+9m+LLSWP
         jfJQjxX/frnz0KvSIuLBtC6ZIazydf1MLuCprwJkTkRwrsU5umVIeEIlri5pNWjb6ssw
         x7ODlaqWSWLP51ACx38tO8bf91SRofGOoYMW5CMwKiZuhECgsOid0r7i0iFc1EZLhHhr
         TC/VoRGK5Qxy/qg15ed6XM3zoA9k0YsGdjHD55MvsDUmljBEe9T0OzNWhSIjuQ17uy98
         iaDqo0gWB8xY1lKWeDJWGz1Sq89O5XozWMxFMARje+X4EKH/NpvfLwzCZnjiOha/5vkd
         t8gw==
X-Gm-Message-State: AOAM531lPb0L+idT2+iKSqpctNkpys1rkZHJWh6lyi4RmYytq6RJ2zR+
        SYvtYCIHrIF7rKGPJZXdxpeid/CF4ESdYClLyQyl8cr8mQNMaCxTfaME8e/B+GpFsuZ6V4NUzId
        s673ESALwRu13
X-Received: by 2002:a05:6402:4d5:: with SMTP id n21mr27235421edw.303.1637346780087;
        Fri, 19 Nov 2021 10:33:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEuO0iTCuF5ryZ5+13DQLvOPXu0iE6NgZszeF9V/f02IjK+pJ3+OHzfTepFE/huLwiPjmqwQ==
X-Received: by 2002:a05:6402:4d5:: with SMTP id n21mr27235398edw.303.1637346779971;
        Fri, 19 Nov 2021 10:32:59 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id sa3sm251805ejc.113.2021.11.19.10.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 10:32:59 -0800 (PST)
Date:   Fri, 19 Nov 2021 19:32:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v4 0/3] GIC ITS tests
Message-ID: <20211119183257.unj256xrobwbjvae@gator.home>
References: <20211119163710.974653-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211119163710.974653-1-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Please CC me on the full series. I'm not always able to keep up
on the lists. I see there's another series too that you've
posted. I'll look next week.

Thanks,
drew

On Fri, Nov 19, 2021 at 04:37:07PM +0000, Alex Bennée wrote:
> Hi,
> 
> changes since v3:
> 
>   - dropped the pending LPI test altogether
> 
> Alex Bennée (3):
>   arm64: remove invalid check from its-trigger test
>   arm64: enable its-migration tests for TCG
>   arch-run: do not process ERRATA when running under TCG
> 
>  scripts/arch-run.bash |  4 +++-
>  arm/gic.c             | 28 ++++++++--------------------
>  arm/unittests.cfg     |  3 ---
>  3 files changed, 11 insertions(+), 24 deletions(-)
> 
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

