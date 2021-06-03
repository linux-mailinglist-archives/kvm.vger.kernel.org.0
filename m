Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AD039A09C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhFCMQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:16:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbhFCMP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 08:15:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622722455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h7KKMDASbghFb3fKVPA26WDfGRNRufLOOkWxirieT+A=;
        b=BbQXkmr4d/n7W4lC0Dzota7S6KhrUKHo0ORLBkhQXLbtcZbg+6xWYcGhCxNqmeuJu1txAi
        TEjSUc8xyWP2cN6/sPN+AZfV+h4QFNxNF5UH89ZXKRXY/wBpWB/EV+tbylx4o00vjB/TEh
        2BwsOUBCPOl01SWMDm5Du2pRw4QjctU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-VC8J5yksNLqKcWWGECX22A-1; Thu, 03 Jun 2021 08:14:13 -0400
X-MC-Unique: VC8J5yksNLqKcWWGECX22A-1
Received: by mail-ej1-f71.google.com with SMTP id h18-20020a1709063992b02903d59b32b039so1875587eje.12
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 05:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h7KKMDASbghFb3fKVPA26WDfGRNRufLOOkWxirieT+A=;
        b=N5dKymj+qvWL+VWZ4QSsRiFZm11JnLzvKH1Y95qhVJ6/p41/iZ6yJvk77EoDowKQ5c
         ps8w1TiWbWagv5IEiB0OuoPmVLUAxAsinDW5nvo4CTfyjjchI18i9VaExeqTJGXGXD4q
         i/X9NoH6v3zvqXdp/kiPotsYppTYw7S+Kkfu08HupylztB9Dg+T/E4oLlhfYQvCFalKb
         vHT1T8EwAhDTGKs9Yh82Tet6sz6rOtXYDIPIqW7AURYsgt7qYaQ26r1ph1UJkOsOdxgO
         WQdt5T0XJR4FILpJFKidiKv1k9ZL34Bb2xB65XuK17laytFXSpFqh3Vuu8Ifi4Xn6boq
         /yZQ==
X-Gm-Message-State: AOAM533/5SYZzIvm+GY6cWB4PLV5xvvmX/a99wjUSDW+QnlqWbLcl8yS
        x1nHhlS8MPANpeZe+z256qEcHPOpXi82KPJAd2I+Ujl1yhgcJN3fY/LHKTw294dZlIepFFzqndr
        YDUDCwL9UW6cn
X-Received: by 2002:aa7:d482:: with SMTP id b2mr26697636edr.45.1622722452466;
        Thu, 03 Jun 2021 05:14:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxA1xBICRSF57oS9q23u0rz34s1KwYHZ+9+yvEbkkzn9DEAfAF8YWtLGH7UkAi5mBuPd6zbSg==
X-Received: by 2002:aa7:d482:: with SMTP id b2mr26697618edr.45.1622722452283;
        Thu, 03 Jun 2021 05:14:12 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id dy19sm1662873edb.68.2021.06.03.05.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 05:14:09 -0700 (PDT)
Date:   Thu, 3 Jun 2021 14:14:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v3 1/5] KVM: arm64: selftests: get-reg-list: Introduce
 vcpu configs
Message-ID: <20210603121407.pb7cm3t6cfjwzana@gator.home>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-2-drjones@redhat.com>
 <YLgW7BDz6zAyU+Of@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLgW7BDz6zAyU+Of@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 04:40:28PM -0700, Ricardo Koller wrote:
> On Mon, May 31, 2021 at 12:33:40PM +0200, Andrew Jones wrote:
> > We already break register lists into sublists that get selected based
> > on vcpu config. However, since we only had two configs (vregs and sve),
> > we didn't structure the code very well to manage them. Restructure it
> > now to more cleanly handle register sublists that are dependent on the
> > vcpu config.
> > 
> > This patch has no intended functional change (except for the vcpu
> > config name now being prepended to all output).
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> Reviewed-by: Ricardo Koller <ricarkol@google.com>

Thanks

> I don't think it matters that much for this test, but ".capability = 0"
> is already taken:
> 
> #define KVM_CAP_IRQCHIP	  0
>

This is a good point, and I should have checked it before assuming I
could use zero for "no special capabilities". I'm tempted to leave this
as is for now though. If we ever need to consider KVM_CAP_IRQCHIP,
then we can cross that bridge later.

Thanks,
drew

