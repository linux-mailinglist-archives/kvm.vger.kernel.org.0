Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C034A5E83
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 15:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbiBAOop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 09:44:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232042AbiBAOon (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 09:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643726682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xPr60qxZCyURf1wWnO6jqTyKtFPYAeP8pg9MJVVWY5E=;
        b=i+HAYH5ch+qg91aKEEuUk3TLTK2yBB9IihnJX2d0FkUHD8bhxBumH9xSGRzF03LZZFqKxN
        YqHuw+q3a39u78G6D5l6d8bVIiFCcblGv0SkhCJFfqD+JsVIw7lev11LwW3uuzFdgVkshr
        Tcjfiow0UgA2q/9EZMES1P9NDVp1hM8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-hj8fa5_MPo6iNoFkXSatPA-1; Tue, 01 Feb 2022 09:44:41 -0500
X-MC-Unique: hj8fa5_MPo6iNoFkXSatPA-1
Received: by mail-ed1-f71.google.com with SMTP id a18-20020aa7d752000000b00403d18712beso8776497eds.17
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 06:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xPr60qxZCyURf1wWnO6jqTyKtFPYAeP8pg9MJVVWY5E=;
        b=jlVkyEasgB2OuX+05gccfHZ45l2Azkmwv1z6+9EWMczYCENBSqDKJQAx1IrWaq3pmD
         Y8CPnU3NgOoB4IHGV3CgNU8K7ZPFwlPPFuLG3ZjRqGAqQrdZZj2empPkqMEwOHU6W2ib
         myjg1HYhxpELlHJcQMC3ZaFKYupRkmaHXUmGDTp/Fjyhne5rqbNkerOrvXE7bTTWIMdC
         UARxTJKfs5etkFJngzGyIeslzhcqaCZUUTXtcmin7vijor/mt8hwPoTTDfAqisqp/3qc
         v2DhBcYRSzPgmXqP+qN3aNCP29scWPSp7W/ROZ+ZOe5KdkdXxc996C+y7eY7yP/3BOjZ
         3P9A==
X-Gm-Message-State: AOAM532GdJEU12Jb7JB3pYlYyF1BEdV3ciIYoAM0zM6Gcq8yU2pr8Cbw
        C6cvURzkQH+9AtbCqtoMXSI6MgSb2OElPR+owxHyKyjcaA1TT2yt3IJmqbimqGrL0lfp7dYX358
        QhqCRb7S3W1Ol
X-Received: by 2002:a17:906:7945:: with SMTP id l5mr21603466ejo.104.1643726680177;
        Tue, 01 Feb 2022 06:44:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynyvXIDdrE1MhRE3SomRdqiNaV91tp5hjxrkxBUNOFv2HU89Omp/4lqyWDEBDXFkSRHTwgNA==
X-Received: by 2002:a17:906:7945:: with SMTP id l5mr21603437ejo.104.1643726679954;
        Tue, 01 Feb 2022 06:44:39 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id m13sm14613223eja.160.2022.02.01.06.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 06:44:39 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:44:37 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20220201144437.fw5fv7xfxspf7a6s@gator>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
 <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home>
 <877dd4umy6.fsf@linaro.org>
 <20211119183059.jwrhb77jfjbv5rbz@gator.home>
 <87a6hlzq8t.fsf@linaro.org>
 <20211130143425.bh27yy47vpihllvs@gator.home>
 <87sft2yboq.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sft2yboq.fsf@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 01, 2022 at 01:10:13PM +0000, Alex Bennée wrote:
> 
> Gentle ping, I'm trying to clear this off my internal JIRA so let me
> know if you want me to do anything to help.
>

Sorry Alex! I've been juggling too many balls lately and completely
dropped this one. I'll rebase arm/queue now and run it through some
sanity tests. If all it good, I'll do the MR right away.

Thanks,
drew

