Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039F11B0D66
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgDTNvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 09:51:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727046AbgDTNvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 09:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587390713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7gTi1IicJlsSKfDG5naKX5cqpPONHfHCE+Bv1EVj7p4=;
        b=Ic+Retk4v9dNbeRFVufz/gDmZHLd1kSWJ4tkvbv3PeQ2KePa8iF5bjpZqKzXocrNJDGbB0
        i0Db/t+RrHjfd/MyCEH2Gr0MxTUIIYjSXLyK6dMZ9C8mAePwwjxtfSioGRwTjDPMrfutyq
        JILbKUEGvpTarWE9dPETxzpJX7GyPvg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-Xbsm0hWmP1OvHpFBaL0aqg-1; Mon, 20 Apr 2020 09:51:51 -0400
X-MC-Unique: Xbsm0hWmP1OvHpFBaL0aqg-1
Received: by mail-qt1-f200.google.com with SMTP id u13so11028719qtk.5
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 06:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7gTi1IicJlsSKfDG5naKX5cqpPONHfHCE+Bv1EVj7p4=;
        b=pMcC/RrMjDhfNuNmeKAN1GO7Pc4/4gC8wIjRybrDgO3dVUlty6sOvHxjn/A0wcwrbD
         49oIw6lVsdvF3OwwmPnjLTLbj/IexQlHZVfNVCajObkb4ac8tQhGKgObCZ4C5+h51fMw
         EORFmIWNxzRom8ldMyNvfPR+V3HXXvXhTwYvCe0o/z3Q1twRFj7ZeWZFYfQoTOillyqi
         oNSdrl7ZRLPDhTrPDXwUI3XenAXv265xY8A7Hi5wk5DIjXQn9X6QgBGPjXPKBclwstcq
         fqJwt5BbPZvrsSU3hF950obqVM3Yo7466dA7SF4MMBkN66napr1X2z7TRGWF/UZ8pZ5J
         JXfw==
X-Gm-Message-State: AGi0PubPS94EBUN97tIQwcgP5DIPfSHRKLqNw/6TM3Ao1z5fLMjEhndp
        NZqhjzfSNuxxZHI1jM1Bl9UyR+7FP+G9r96lNofDLiQDMOQ8G3itbmNyhhL4Raon46A6cr0yD/z
        kzEygsAv41XIc
X-Received: by 2002:a05:620a:1009:: with SMTP id z9mr15818453qkj.270.1587390711068;
        Mon, 20 Apr 2020 06:51:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypIL/5HvAE8uGB2QeYJcMl1quKM2t1afKsHoOGNm7ioq9h6iVSe8lTD2IPGc1eogwV5ywc6E9A==
X-Received: by 2002:a05:620a:1009:: with SMTP id z9mr15818438qkj.270.1587390710884;
        Mon, 20 Apr 2020 06:51:50 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id y9sm606038qkb.41.2020.04.20.06.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 06:51:50 -0700 (PDT)
Date:   Mon, 20 Apr 2020 09:51:48 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/eventfd: remove unneeded conversion to bool
Message-ID: <20200420135148.GK287932@xz-x1>
References: <20200420123805.4494-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200420123805.4494-1-yanaijie@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 20, 2020 at 08:38:05PM +0800, Jason Yan wrote:
> The '==' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
> 
> virt/kvm/eventfd.c:724:38-43: WARNING: conversion to bool not needed
> here
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

