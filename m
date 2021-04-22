Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12CA368483
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbhDVQNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:13:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236637AbhDVQNs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 12:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619107993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wrmcMXOaHKX1eup8mThBz/cZRGAf0vFNrgL5S7XFabQ=;
        b=SPDJOFyX0cpeegue/67Awin20C2aycKpPabmkipH/E+A8UOgCKNWkP4me3vA4iy80DDARx
        rc34O5PxL8Pl7ZNJND5Qh7s/VdCnTpcnVGFdx/gBQrR3L7hSnfBJHSOqMIPKV5lLlHs/Tu
        Ic57+lkYss6RFXCMec+jqO/yZhK5+Ys=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-AEfL0U5DMVe6GyIMnfmI4Q-1; Thu, 22 Apr 2021 12:12:35 -0400
X-MC-Unique: AEfL0U5DMVe6GyIMnfmI4Q-1
Received: by mail-wr1-f69.google.com with SMTP id 88-20020adf95610000b029010758d8d7e2so2439849wrs.19
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wrmcMXOaHKX1eup8mThBz/cZRGAf0vFNrgL5S7XFabQ=;
        b=luaWGwWzS3hXJRCo8RbwTfMsFj93CZFQBQ6y9QkncaL4qXZI4iLFMEHkDyR3cRUVDP
         EO4y5qUtucVrVnRLahk3zM9rr7GjGinngauOn+VrEkfh2Gvbf6gJfBvxEU5MAHpM9xgT
         7Oi4GwGZp3/7NLgz4phxmOj7qftfOOEsIh7R+QRuFHiwi0ZzPAEK9TKzs/XP4zpzng4H
         1RATJM6mRCzCMpr7n+xyudN7kIYlSCLT5pYuXkUlSFloyorYGOLnWCYwkUsqgRiLQhff
         TO+Al3Kz5Y09/tSd63bSnbccIwrKMg3Iv4+0+YRHPy5GoczQPC5Z85/+vr/H87OXb/cg
         iuqg==
X-Gm-Message-State: AOAM533prUV+4zDujY9ziN+PiZnXpGyFtwM4GARWbQDDz9W42obIJteV
        4AF68wdvmdl5f3aQ9hICBSWQbr9WfMVtKbDkAoVIZn6j7mobtSXP0ohUbdzj1zVGtE2nwFMnwzS
        lX/wyFNkF6nR7yhFQOaIN8ScE5P0C3BTDekTZzTMUi9MtsCFV9SWblIVMNH3uwMI=
X-Received: by 2002:a05:600c:365a:: with SMTP id y26mr4611330wmq.102.1619107954400;
        Thu, 22 Apr 2021 09:12:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUdHWEre7hz8fC/6YkaBBtpQzeudeoBNxTk1GjGPsOBLT7S1kv2ELvdCYalN6B5L/h2HiJHA==
X-Received: by 2002:a05:600c:365a:: with SMTP id y26mr4611314wmq.102.1619107954266;
        Thu, 22 Apr 2021 09:12:34 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id o1sm4682667wrw.95.2021.04.22.09.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 09:12:32 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:12:30 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 6/8] arm/arm64: setup: Consolidate
 memory layout assumptions
Message-ID: <20210422161230.t7wmnq3zsyxgchy2@gator>
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-7-drjones@redhat.com>
 <20210421064055.mdz3w4kgywyw5wiu@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421064055.mdz3w4kgywyw5wiu@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 08:40:55AM +0200, Andrew Jones wrote:
> On Tue, Apr 20, 2021 at 09:00:00PM +0200, Andrew Jones wrote:
> > +	assert(mem.end);
> >  	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
> 
> Eh, I promised Alex not to do this, but then didn't correct it quite
> right. This should be
> 
>   assert(!(mem.start & ~PHYS_MASK));
>   if ((mem.end - 1) & ~PHYS_MASK)
>      mem.end &= PHYS_MASK;

I've changed this to 

  assert(mem.end && !(mem.start & ~PHYS_MASK));
  mem.end &= PHYS_MASK;

for v3.

Thanks,
drew

