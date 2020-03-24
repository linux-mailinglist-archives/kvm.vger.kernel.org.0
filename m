Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824C51918C3
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCXST0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:19:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:53478 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727310AbgCXST0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585073964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bfKxrcAYL3qJAjPqhp2KXWsKra1TFVjk/RLo1JNsOVY=;
        b=UuZao6GNhoO8B0oAUoo93Uq2EYviRSKCB2BXNezcw9ERJsug44tnhIyH4FddyoWm3iJRJv
        ycb/wIhAyk5hkcqK1TR1tzKrVXUMuxFWv1XSj0WiKluigPF5+Yo7SXL4VyA9mxfJ3IwdCX
        lEgPFdjCtSKPuO7Mj1YFmOYeUDT0CoY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-L1yIOjN_NLa_1TFQyD5W6w-1; Tue, 24 Mar 2020 14:19:22 -0400
X-MC-Unique: L1yIOjN_NLa_1TFQyD5W6w-1
Received: by mail-wm1-f70.google.com with SMTP id n25so1552316wmi.5
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bfKxrcAYL3qJAjPqhp2KXWsKra1TFVjk/RLo1JNsOVY=;
        b=ZcodD9O0odHV5xLyx74JMXk01PEqNhZeXIx0IKVDilX/ai+mhaLeUmEyntTT0/PLpt
         GeL5c89yzBoT/EO3+bnakz8+o3FZ53Wmvrr9E/1VJPzVlhSHitjHUoFu6HPcyItaO3mU
         XUbJ/mnouA/Goie7COI63NRuC4rBZ/m1vxSovRBXGhaLVSmEmH+dVQSVgHLCotXrrRxp
         mbGn1ELGA1hNY/6PV++wxG73AzACgb87Ye29bxEBBQS+zV8r4rFAaJ2ULnDp1HOMfIXw
         KhhxCNo8grb5hViFZJsdL147YMi6inPugXyqxCefVMW92GCTDBEa8j/e7GKBRFheNwPL
         LY5Q==
X-Gm-Message-State: ANhLgQ24kdxAbySshgVV/fvpc+KQ2JcEqWfiyj9WnRiVrqqVk2n0PjUy
        Z8aYQYFiymYHRvyhQwIyxOhtP8S6CBveE3PeuR0lQ+J8I1P2qUfvfuCUjnwzJ7TyZ4nVCH+e3Jp
        S2xaVUyUsxDs3
X-Received: by 2002:adf:cf09:: with SMTP id o9mr37080579wrj.74.1585073961686;
        Tue, 24 Mar 2020 11:19:21 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtoyGu2Zn/sHDRK1B/QPFf7ailyYZQZxOfMhhUCMwv+32rQI+zwHFaIHeTUKFtQQbBMp9AAGQ==
X-Received: by 2002:adf:cf09:: with SMTP id o9mr37080540wrj.74.1585073961431;
        Tue, 24 Mar 2020 11:19:21 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id u5sm23315254wrp.81.2020.03.24.11.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:19:20 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:19:15 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v1 18/22] vfio: add support for flush iommu stage-1 cache
Message-ID: <20200324181915.GC127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-19-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-19-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:15AM -0700, Liu Yi L wrote:
> This patch adds flush_stage1_cache() definition in HostIOMUContextClass.
> And adds corresponding implementation in VFIO. This is to expose a way
> for vIOMMU to flush stage-1 cache in host side since guest owns stage-1
> translation structures in dual stage DMA translation configuration.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

